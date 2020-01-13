Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07F8B139324
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 15:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbgAMOHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 09:07:52 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:37718 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726074AbgAMOHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 09:07:52 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E19EA4069F;
        Mon, 13 Jan 2020 14:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578924471; bh=zsOc4rVx8WEuuSsqeg8bHLctdcMZOz9AdQLk0z9FNCg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=bwgQLgIXqrv8dhI9PRpl27ZQ36UPbrV6ntxxfLSVPvrXZsjQHe2tfIkn6aq0uVf+h
         4gQAcz6Wy8cRuoQ41LuV0fNCfuycTyrUMZfNT+DLbSu1Vk5H0Zah03TJnvc5pP17b7
         aMORUoRrJGrIzVgCJyO9k0ZFEgglbFudzrAaj2lj5CnRnBYt2kr6aNPJ+ecleIzf/H
         Isu3ywyCBbwoCXf6GtPjvxzBV8COZvGFmCA+TQGrmGseqNKJMPKdSHu7eLZoDbG7aF
         FMHNVQd0JdE1O+dLKawGNCrwQXKhFGLHqbBTFmMQmBENIm2Q1w9Ev8yIShGptgcm8H
         T+rmy3e8jkxwA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 739AFA0083;
        Mon, 13 Jan 2020 14:07:50 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 13 Jan 2020 06:07:50 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 13 Jan 2020 06:07:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OYGQ7jm+YcNHNjioG9LFtlyrjrcVAXpqp9go4Ab/Ss82gcu/ieY0CUCs4bMJuWQW9fTFH+IK3jPBFAuGGnU5DDffP5uEpr+qmykc98ZDf6QjBn6v80PrAl14UQmyjf0Jru2eGqgPCz7XPeKahBiIAevRORO+NCDjUtXUNhXBHLUXJccxzwTvmrX84fM8qWda20pFkxQHKUnDPfWkGF/9RksCHJ41iSCHHMGYj9UzEEasjT8t91P1QwoB6O/6es/6h+LHmWOuHeW9BhfiIxVYJ70RCn6Khb4IFwO1E1jynxWfo/HXw5m7AWgIGeyusJSyTD7P9hOln7NdSboxpp/RNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsOc4rVx8WEuuSsqeg8bHLctdcMZOz9AdQLk0z9FNCg=;
 b=nFdEK9q/AYsEsnFPbXb3Yg/7mCIBMAn8QrPXD6D4FUzmlMH+xgHbg7jZWCyp2bar9O7J9qWLMARKZAHZZXOXssoD2jvGuVJJl6i2vwIDSMGMm3xxC3ZjL/Qlew81OS9bHxGYysthJLGcGMGN05frMWnT8KPebnYG/xvSwIP4qS4RThY7vXuFGR78FuxN484BxahFNuy/liKkF7N43xatqdURZVdKt9Zv90/V7BjQvVn+DQwqqY312l7O3VUlYguyK4PEqidkS1lCEI/wURDegY+O14AbWlXNATuIc1D6Mu28TpjL9jDDbrlh8S0FXYqmZuoU86hfxTq7wUQ1TRXKnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsOc4rVx8WEuuSsqeg8bHLctdcMZOz9AdQLk0z9FNCg=;
 b=B0X8BE8u7nE8+38H0gG7LnrefQqtu2Yls1ijW4Ank7nhFC0USBpfMchUsls8OOZD9mkOuqsPa3OVt7NUI9KbzGJgRe73QI3g/MDm6zlj4+cxmjIEbnNyOfEkVPHSJ9dUTDCHOhAwfFfMSFyxvFDqPzHJ9gw2IWLObp9x02B+LYc=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3363.namprd12.prod.outlook.com (20.178.212.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Mon, 13 Jan 2020 14:07:48 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 14:07:48 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
CC:     netdev <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
Thread-Topic: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
Thread-Index: AQHVyhMHPh1TkUf6pU+JUVzLFdFzk6fomoeAgAADWNA=
Date:   Mon, 13 Jan 2020 14:07:48 +0000
Message-ID: <BN8PR12MB3266363BD930BEC46E9680E2D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <4953fc69a26bee930bccdeb612f1ce740a4294df.1578921062.git.Jose.Abreu@synopsys.com>
 <CAHp75VeOefY_BK7MitFtdb7enrh5TOOwZ8kDJfVxvW28gejUbg@mail.gmail.com>
In-Reply-To: <CAHp75VeOefY_BK7MitFtdb7enrh5TOOwZ8kDJfVxvW28gejUbg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ec35d1e-2169-4bd0-e35c-08d79831f852
x-ms-traffictypediagnostic: BN8PR12MB3363:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB336389401FD643FA4B3FD224D3350@BN8PR12MB3363.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(366004)(39860400002)(376002)(136003)(189003)(199004)(8676002)(81156014)(55016002)(71200400001)(9686003)(86362001)(4326008)(2906002)(81166006)(66446008)(54906003)(76116006)(7696005)(6916009)(6506007)(33656002)(66476007)(66946007)(66556008)(478600001)(64756008)(26005)(52536014)(316002)(186003)(8936002)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3363;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YJMKt3AjRKFwv6a1QJb0fWrTNszv3rZLVMLUMCIhhD59Nj4sPrY/ScXLwIoxzc+vgzDG/JVcM8TQPkk0K290SeHmtv/Ah1vXa5ij/B/ymRiZwq5Hy5IHpb4vtbT7L7y75X7QaRMaQSz3rMDp6eNAxxonaGiJxlH1kUfik18/cxoRWQ0HenXS7MBbeOYzQDxxcuqTRG0aj5h/S0l8Yinp8TG6OF7dIRxRYQm/K8LhCYkUdwRbOg8KFWm36va7s7z/oRNHZ3uqtmlaMDtmFkgJl5S4rbjefoTeFYzKPu8JPo0ytw1j9LLUsEByfwjqQ4fnJwPXsxsCHCDbtjQkQFC1LKlKtq/8bfa4j7dhE8UHCX8SET9J2QcwB/L16P53NULMQUgruruezBvkPLpNYMU/XPYki9RavkO92H4A4ihX29tj7FlLE5gXucAbsEk34UKt
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec35d1e-2169-4bd0-e35c-08d79831f852
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 14:07:48.2166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xAuAN9WO662QzjbFpXJMyeUHjaG0m/6yeHexuTjJNwKtbTSH2UYkkG/xHHm+Z0Jka+G7ypqYC9Yuq4FGvhNiiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3363
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQW5keSBTaGV2Y2hlbmtvIDxhbmR5LnNoZXZjaGVua29AZ21haWwuY29tPg0KRGF0ZTog
SmFuLzEzLzIwMjAsIDEzOjQyOjQ3IChVVEMrMDA6MDApDQoNCj4gPiArI2RlZmluZSBTWU5PUFNZ
U19YUEhZX0lEICAgICAgICAgICAgICAgMHg3OTk2Y2VkMA0KPiA+ICsjZGVmaW5lIFNZTk9QU1lT
X1hQSFlfTUFTSyAgICAgICAgICAgICAweGZmZmZmZmZmDQo+IA0KPiBHRU5NQVNLKCkgPw0KPiAo
SXQgc2VlbXMgYml0cy5oIGlzIG1pc3NlZCBpbiB0aGUgaGVhZGVycyBibG9jaykNCg0KVGhpcyBp
cyBvbiBwdXJwb3NlLCBpdCdzIGFuIElEIGFuZCB0aGUgbWFzayBpcyBtb3JlIGNsZWFybHkgcmVh
ZCB0aGlzIA0Kd2F5IChpbiBteSBvcGluaW9uKS4NCg0KPiANCj4gPiArI2RlZmluZSBEV19VU1hH
TUlJXzI1MDAgICAgICAgICAgICAgICAgICAgICAgICAoQklUKDUpKQ0KPiA+ICsjZGVmaW5lIERX
X1VTWEdNSUlfMTAwMCAgICAgICAgICAgICAgICAgICAgICAgIChCSVQoNikpDQo+ID4gKyNkZWZp
bmUgRFdfVVNYR01JSV8xMDAgICAgICAgICAgICAgICAgIChCSVQoMTMpKQ0KPiA+ICsjZGVmaW5l
IERXX1VTWEdNSUlfMTAgICAgICAgICAgICAgICAgICAoMCkNCj4gDQo+IFVzZWxlc3MgcGFyZW50
aGVzZXMuDQoNCkp1c3QgY29kaW5nIHN0eWxlLCB0byBrZWVwIGl0IGFsaWduZWQgd2l0aCB0aGUg
b3RoZXIgc3BlZWRzLCB5b3UgY2FuIA0KY2FsbCBpdCBPQ0QgOikNCg0KPiA+ICtzdGF0aWMgaW50
IGR3X3BvbGxfcmVzZXQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldiwgaW50IGRldikNCj4gPiAr
ew0KPiA+ICsgICAgICAgLyogUG9sbCB1bnRpbCB0aGUgcmVzZXQgYml0IGNsZWFycyAoNTBtcyBw
ZXIgcmV0cnkgPT0gMC42IHNlYykgKi8NCj4gPiArICAgICAgIHVuc2lnbmVkIGludCByZXRyaWVz
ID0gMTI7DQo+ID4gKyAgICAgICBpbnQgcmV0Ow0KPiA+ICsNCj4gPiArICAgICAgIGRvIHsNCj4g
DQo+ID4gKyAgICAgICAgICAgICAgIG1zbGVlcCg1MCk7DQo+IA0KPiBJdCdzIGEgYml0IHVudXN1
YWwgdG8gaGF2ZSB0aW1lb3V0IGxvb3AgdG8gYmUgc3RhcnRlZCB3aXRoIHNsZWVwLg0KPiBJbWFn
aW5lIHRoZSBjYXNlIHdoZW4gYmV0d2VlbiB3cml0aW5nIGEgcmVzZXQgYml0IGFuZCBhY3R1YWwg
Y2hlY2tpbmcNCj4gdGhlIHNjaGVkdWxpbmcgaGFwcGVucyBhbmQgcmVzZXQgaGFzIGJlZW4gZG9u
ZSBZb3UgYWRkIGhlcmUNCj4gdW5uZWNlc3NhcnkgNTAgbXMgb2Ygd2FpdGluZy4NCg0KSW50ZW5k
ZWQgYWxzby4gQWN0dWFsbHksIHVuY29uZGl0aW9uYWwgc2xlZXAgYWxsb3dzIHRvIHNhZmVseSB3
YWl0IGZvciANCnJlc2V0IGFuZCBub3QgdHJ5IHRvIHBvbGwgdGhlIGJpdCBpbiB0aGUgbWlkZGxl
IG9mIHJlc2V0IHdoZXJlIHRoZSBGU00gDQptYXkgbm90IGJlIG9wZXJhdGlvbmFsIGFuZCByZWFk
cyBtYXkgbm90IHJldHVybiBjb3JyZWN0bHkuIFRoaXMgaXMgYWxzbyANCm5lZWRlZCBiZWNhdXNl
IGluIHNvbWUgY29uZmlndXJhdGlvbnMgdGhlIFhQQ1MgZG9lcyBub3QgYWxsb3cgcmVhZHMgaW4g
DQp0aGUgbWlkZGxlIG9mIGEgcmVzZXQuDQoNCj4gPiArc3RhdGljIGludCBfX2R3X3NvZnRfcmVz
ZXQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldiwgaW50IGRldiwgaW50IHJlZykNCj4gPiArew0K
PiA+ICsgICAgICAgaW50IHZhbDsNCj4gDQo+IHZhbD8hIFBlcmhhcHMgcmV0IGlzIGJldHRlciBu
YW1lPw0KPiBBcHBsaWNhYmxlIHRvIHRoZSByZXN0IG9mIGZ1bmN0aW9ucy4NCg0KVGhpcyBpcyB0
aGUgbW9zdCBjb21tb25seSB1c2VkIHBhdHRlcm4gaW4gbmV0L3BoeSBzdWJzeXN0ZW0uDQoNCj4g
PiArI2RlZmluZSBkd193YXJuKF9fcGh5LCBfX2FyZ3MuLi4pIFwNCj4gDQo+IGR3X3dhcm4oKSAt
PiBkd193YXJuX2lmX3BoeV9saW5rKCkNCg0KSG1tLCB0aGlzIHdpbGwgcHJvYmFibHkgbWFrZSB0
aGUgd2FybnMgbGluZXMgcGFzcyB0aGUgODAgY2hhcnMgYW5kIEkgDQpkb24ndCBsaWtlIHRvIGJy
ZWFrIGxpbmVzIDopDQoNCj4gPiArc3RhdGljIGludCBkd19hbmVnX2RvbmUoc3RydWN0IHBoeV9k
ZXZpY2UgKnBoeWRldikNCj4gPiArew0KPiA+ICsgICAgICAgaW50IHZhbDsNCj4gPiArDQo+ID4g
KyAgICAgICB2YWwgPSBwaHlfcmVhZF9tbWQocGh5ZGV2LCBNRElPX01NRF9BTiwgTURJT19TVEFU
MSk7DQo+ID4gKyAgICAgICBpZiAodmFsIDwgMCkNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJu
IHZhbDsNCj4gPiArDQo+ID4gKyAgICAgICBpZiAodmFsICYgTURJT19BTl9TVEFUMV9DT01QTEVU
RSkgew0KPiA+ICsgICAgICAgICAgICAgICB2YWwgPSBwaHlfcmVhZF9tbWQocGh5ZGV2LCBNRElP
X01NRF9BTiwgRFdfU1JfQU5fTFBfQUJMMSk7DQo+ID4gKyAgICAgICAgICAgICAgIGlmICh2YWwg
PCAwKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiB2YWw7DQo+ID4gKw0KPiA+
ICsgICAgICAgICAgICAgICAvKiBDaGVjayBpZiBBbmVnIG91dGNvbWUgaXMgdmFsaWQgKi8NCj4g
PiArICAgICAgICAgICAgICAgaWYgKCEodmFsICYgMHgxKSkNCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgICBnb3RvIGZhdWx0Ow0KPiA+ICsNCj4gDQo+ID4gKyAgICAgICAgICAgICAgIHJldHVy
biAxOw0KPiANCj4gMT8hIFdoYXQgZG9lcyBpdCBtZWFuPw0KDQpKdXN0IGxpa2UgcGh5X2FuZWdf
ZG9uZSgpOg0KCSIqIERlc2NyaXB0aW9uOiBSZXR1cm4gdGhlIGF1dG8tbmVnb3RpYXRpb24gc3Rh
dHVzIGZyb20gdGhpcyBAcGh5ZGV2DQoJICogUmV0dXJucyA+IDAgb24gc3VjY2VzcyBvciA8IDAg
b24gZXJyb3IuIDAgbWVhbnMgdGhhdCANCmF1dG8tbmVnb3RpYXRpb24NCgkgKiBpcyBzdGlsbCBw
ZW5kaW5nLiINCg0KSSdsbCBhZGQgcmVtYWluaW5nIGNoYW5nZXMgaW4gb2ZmaWNpYWwgdmVyc2lv
bi4gVGhhbmtzIGZvciB0aGUgcmV2aWV3IQ0KDQotLS0NClRoYW5rcywNCkpvc2UgTWlndWVsIEFi
cmV1DQo=
