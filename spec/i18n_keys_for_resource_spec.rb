# typed: false
# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/public/i18n_keys_for_resource'

RSpec.describe ResourceRegistry::I18nKeysForResource do
  subject { described_class.new(resource) }

  let(:resource) do
    ResourceRegistry::Resource.new(
      repository_raw: 'TestDomain::Repositories::TestResource',
      schema: SchemaRegistry::Schema.new(
        name: 'TestResource',
        namespace: 'TestNamespace',
        properties: []
      ),
      verbs: {}
    )
  end

  describe '#resource_name_key' do
    it 'returns the correct translation key' do
      expect(subject.resource_name_key).to eq('test_domain.resources.test_resource.name')
    end
  end

  describe '#field_name_key' do
    it 'returns the correct translation key' do
      expect(subject.field_name_key(:field)).to eq(
        'test_domain.resources.test_resource.fields.field.name'
      )
    end
  end

  describe '#enum_value_name_key' do
    it 'returns the correct translation key' do
      expect(subject.enum_value_name_key(:field, :value)).to eq(
        'test_domain.resources.test_resource.fields.field.enum.value.name'
      )
    end
  end

  describe 'Resources translations configuration' do
    let(:resources) do
      Rails
        .configuration
        .resource_registry
        .fetch_with_capabilities(ResourceRegistry::Capabilities::Reports)
        .map { |resource| [resource.schema, resource.translation] }
    end

    it 'has no missing translations' do
      expect do
        resources.each do |schema, translation|
          schema.properties.each do |property|
            I18n.with_locale('en') { I18n.t!(translation.field_name_key(property.name.to_sym)) }
          end
        end
      end.not_to raise_error(I18n::MissingTranslationData)
    end
  end
end
