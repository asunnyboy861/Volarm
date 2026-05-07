# Pricing Configuration

## Monetization Model: Freemium + One-Time Purchase (IAP)

## Free Version
- **Price**: Free (No charge)
- **Alarm Limit**: 3 alarms
- **Independent Volume Control**: ✅ Included (core feature must be free)
- **Built-in Sounds**: 5 sounds
- **Basic Snooze**: ✅ Included

## Pro Upgrade — One-Time Purchase

### Lifetime Purchase
- **Reference Name**: Volarm Pro
- **Product ID**: `com.zzoutuo.Volarm.pro`
- **Price**: $4.99 one-time
- **Display Name**: Volarm Pro
- **Description**: Unlock unlimited alarms and premium features
- **Localization**: English (US)

### Pro Features Included
- Unlimited alarms
- Gradual volume (gentle wake-up)
- Custom sound import
- Alarm groups
- Volume presets (Quiet/Medium/Loud/Max)
- Widgets & Dynamic Island
- Siri & Shortcuts
- iCloud sync

## App Store Connect Pricing
- **Price Tier**: Free (base app)
- **IAP Tier**: Tier 5 = $4.99 (one-time non-consumable)

## Policy Pages Required
- Support Page: ✅ (Must include restore purchases info)
- Privacy Policy: ✅
- Terms of Use: ❌ (Not needed for one-time purchase apps — only required for subscription apps)

## Apple IAP Compliance Checklist
- [ ] Restore purchases functionality implemented
- [ ] No dark patterns in paywall
- [ ] Pricing clearly stated
- [ ] Free features clearly distinguished from Pro features
- [ ] No subscription — one-time purchase only

## Why Not Subscription?
1. Volarm is a single-function tool — users won't pay monthly for volume control
2. Subscription fatigue is the #1 complaint about alarm apps on App Store
3. All competitors use subscriptions — one-time purchase is a massive differentiator
4. No ongoing server/API costs — no need for recurring revenue
5. "No Subscription" is a top App Store search term and marketing advantage

## Revenue Projection
| Scenario | Monthly Downloads | Free→Pro Conversion | Monthly Revenue | Annual Revenue |
|----------|-------------------|---------------------|-----------------|----------------|
| Conservative | 5,000 | 8% | $1,996 | $23,952 |
| Moderate | 20,000 | 10% | $9,980 | $119,760 |
| Optimistic | 50,000 | 12% | $29,940 | $359,280 |
