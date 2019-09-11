Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4912EAF8A4
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 11:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfIKJPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 05:15:14 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:55890 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725616AbfIKJPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 05:15:13 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E79CEC2B5D;
        Wed, 11 Sep 2019 09:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568193313; bh=Z6H6Q3qCuQBuJvyVPzZfoBxJUg83zGwNuDnH9LUNepw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=AaktmoImg36jo/ix9RKsFlV/ZCTiKz71dDQoTNYa4mHQTwpGCHfbqUvZr7HSP+uav
         2JB3tsXIwGR5/6qpwUBsdJqx3Zff2RLiW9eMCNQMmyQQhXSqfUOR97jpejOl16hQ31
         +VhLgz0D9HJ1lkhf98tyfGWDg+ZLCDMxLSagxE+ne1sBdMWmoNGGae7ZQ1uxc90K1G
         io0/YwIgs5+a6M7lLMNj3MtL8/6x9DH5++QVFX+LZPj35VvyXj3094nQfJYvUA7A9F
         LaalGvPTuH40zHcAn5DaJpHSuatLabHwlkQbo2EINk9lxnXUhhyPIAghPThkCQf+J5
         PGFi2qzTGkd7g==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 64B75A005A;
        Wed, 11 Sep 2019 09:15:12 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 11 Sep 2019 02:15:11 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 11 Sep 2019 02:15:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7UVuD0qlQGRqFj+ozg6lVVgokoR61h05ZnJVIzi57HLoyWUWQ7YT0we+Do5x3yKhjBK3vZbXwk/gqLdaVNMDOYuecOxLm0xHSR98+hhvkvSiy6340epwGpc+RoyEID9Wrbp4PBsdgMIzgghRkCjoWdZxINEgrljgK2R8iSslbgzpfY+ITL9ZAyMhj9/bKZBtaXA5EXJCN3UMd3mdj5+vrEb7lSIaq3ecCebLKPi1km6jApcjOMPhPB8f3igrmO3Mg4P5QK4HRcJGEbWwqh/zaX+9gv69ZfKcHykFcOgeLt1SqK5U5jRwXq/MLCHG7e0Iku8jC6NzgJsdd5MpQJhFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z6H6Q3qCuQBuJvyVPzZfoBxJUg83zGwNuDnH9LUNepw=;
 b=MRyfgoy0O0xxGtPMNCnL6himI/f9jd4oZOQZ3o3w/658Dc3nSXxwW/OMeBpMo7g/55iQle0asAahCDpmn9qFJTT9yXojusd6DiTNCWBdfB2puhYJ9H/IYpvG1+cDUbRtKyMkFkr4buusSGhQ5Won3dVZ3S+8g2gf0dC72rJJfhHER5YOd2ajDXU5JZpgoF3aRJDTIm1XH6awOnxE4o1qlaoQJjBQfkQKaCjUsVFECfdOa9e/Oo3ElHADymcdc2S2CawQkdVZUdusWm36AZ+pYH213T3R40Y9V5lDj/EJrFhINrxtJWCZ4Q7z8icR6VI1WWOdw0W6at74Hpf2amQhaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z6H6Q3qCuQBuJvyVPzZfoBxJUg83zGwNuDnH9LUNepw=;
 b=NXxr1m0J7CfujwWJPVhlLNChF3lr6Qx4Ioj207cqLzp2Hlg9Dj35rp3ufR1xjjovj0qitH4fG4QrWE5IwBUq4gDhE+7ttDTfysRNd4dfwjkQngaJDvWWyneUWrqoZnu7S+toDBFRkTlOSTD/hChzQr0wdcXTO1ppR1OluXxoxGI=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3012.namprd12.prod.outlook.com (20.178.209.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Wed, 11 Sep 2019 09:15:10 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2263.015; Wed, 11 Sep 2019
 09:15:10 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Jon Hunter" <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH net-next v2 2/2] net: stmmac: Support enhanced addressing
 mode for DWMAC 4.10
Thread-Topic: [PATCH net-next v2 2/2] net: stmmac: Support enhanced addressing
 mode for DWMAC 4.10
Thread-Index: AQHVZyLugLltb0ZW10+a6Fka6Re0xKcjgeswgAA1IoCAAN9LkIAAr46AgADsSGA=
Date:   Wed, 11 Sep 2019 09:15:10 +0000
Message-ID: <BN8PR12MB3266FC9B7C984F875A920D3ED3B10@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20190909152546.383-1-thierry.reding@gmail.com>
 <20190909152546.383-2-thierry.reding@gmail.com>
 <BN8PR12MB3266AAC6FF4819EC25CB087BD3B70@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190909191329.GB23804@mithrandir>
 <BN8PR12MB3266F021DFC2C61CDEC83418D3B60@BN8PR12MB3266.namprd12.prod.outlook.com>
 <c8d419d3-6cf6-e260-a2e2-6a339c6c321b@gmail.com>
In-Reply-To: <c8d419d3-6cf6-e260-a2e2-6a339c6c321b@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [148.69.85.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43e6016a-59a8-4fa1-280b-08d736988c19
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3012;
x-ms-traffictypediagnostic: BN8PR12MB3012:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3012B6B255516CC3F85A708ED3B10@BN8PR12MB3012.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(366004)(39860400002)(376002)(136003)(189003)(199004)(2906002)(476003)(14454004)(5660300002)(256004)(76176011)(14444005)(71190400001)(71200400001)(110136005)(8676002)(7696005)(229853002)(54906003)(486006)(6116002)(316002)(3846002)(478600001)(55016002)(6506007)(186003)(9686003)(8936002)(6246003)(74316002)(53546011)(6436002)(7736002)(4326008)(81156014)(81166006)(66946007)(52536014)(305945005)(76116006)(25786009)(99286004)(102836004)(26005)(446003)(11346002)(53936002)(33656002)(66476007)(66556008)(64756008)(66066001)(66446008)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3012;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: U8oPdDGs+orqN9GgC6WbLCZlvKtbAkuhiLs3OEU2WTqMu2OKwIRqq8StWjFUZob38PTO5uIBOJG8ZGj92r8rprXUkKO2XuOsoPLdJVd02i8/7kpcNHLHC/lAJY6bR3z9EDP/rwFo+CYR5eKvgUAYqkOWy8Z9/BzEEeUfJEkkzYE2wNo8qvkLM1zTLdZskuA04oLi014bEJYkrx5dhaKxoYqMj5pe7xS9e+wD7rGfuGVQerDNIiP6KpE93uDXC314kaACpBSyyxoSPWDQoqZRf4J9zC7lKJVhsmWRUYQ8yjYNOvFbJ8ByvySgZ9A2rYlHthTmlmsippvnucu2b6Ck2J3BD4qy/BtfFu1m7ixAHvDy9Gd+zED32UckDljCvg/uAnE5XkKQUAc5gOcIvPVKf29PVIq/p39IzD9a/stcqbM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 43e6016a-59a8-4fa1-280b-08d736988c19
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 09:15:10.7743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Aj4CT+b37hEgNKzzupD3egUTk1/CrbFIidS+3MRbWACEOdc3RblY1AbHsMgkYl7hTPk+Vl7bnXutthvfFkflQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3012
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+DQpEYXRlOiBTZXAv
MTAvMjAxOSwgMjA6MDE6MDEgKFVUQyswMDowMCkNCg0KPiBPbiA5LzEwLzE5IDE6MzUgQU0sIEpv
c2UgQWJyZXUgd3JvdGU6DQo+ID4gRnJvbTogVGhpZXJyeSBSZWRpbmcgPHRoaWVycnkucmVkaW5n
QGdtYWlsLmNvbT4NCj4gPiBEYXRlOiBTZXAvMDkvMjAxOSwgMjA6MTM6MjkgKFVUQyswMDowMCkN
Cj4gPiANCj4gPj4gT24gTW9uLCBTZXAgMDksIDIwMTkgYXQgMDQ6MDU6NTJQTSArMDAwMCwgSm9z
ZSBBYnJldSB3cm90ZToNCj4gPj4+IEZyb206IFRoaWVycnkgUmVkaW5nIDx0aGllcnJ5LnJlZGlu
Z0BnbWFpbC5jb20+DQo+ID4+PiBEYXRlOiBTZXAvMDkvMjAxOSwgMTY6MjU6NDYgKFVUQyswMDow
MCkNCj4gPj4+DQo+ID4+Pj4gQEAgLTc5LDYgKzc5LDEwIEBAIHN0YXRpYyB2b2lkIGR3bWFjNF9k
bWFfaW5pdF9yeF9jaGFuKHZvaWQgX19pb21lbSAqaW9hZGRyLA0KPiA+Pj4+ICAJdmFsdWUgPSB2
YWx1ZSB8IChyeHBibCA8PCBETUFfQlVTX01PREVfUlBCTF9TSElGVCk7DQo+ID4+Pj4gIAl3cml0
ZWwodmFsdWUsIGlvYWRkciArIERNQV9DSEFOX1JYX0NPTlRST0woY2hhbikpOw0KPiA+Pj4+ICAN
Cj4gPj4+PiArCWlmIChkbWFfY2ZnLT5lYW1lKQ0KPiA+Pj4NCj4gPj4+IFRoZXJlIGlzIG5vIG5l
ZWQgZm9yIHRoaXMgY2hlY2suIElmIEVBTUUgaXMgbm90IGVuYWJsZWQgdGhlbiB1cHBlciAzMiAN
Cj4gPj4+IGJpdHMgd2lsbCBiZSB6ZXJvLg0KPiA+Pg0KPiA+PiBUaGUgaWRlYSBoZXJlIHdhcyB0
byBwb3RlbnRpYWxseSBndWFyZCBhZ2FpbnN0IHRoaXMgcmVnaXN0ZXIgbm90IGJlaW5nDQo+ID4+
IGF2YWlsYWJsZSBvbiBzb21lIHJldmlzaW9ucy4gSGF2aW5nIHRoZSBjaGVjayBoZXJlIHdvdWxk
IGF2b2lkIGFjY2VzcyB0bw0KPiA+PiB0aGUgcmVnaXN0ZXIgaWYgdGhlIGRldmljZSBkb2Vzbid0
IHN1cHBvcnQgZW5oYW5jZWQgYWRkcmVzc2luZy4NCj4gPiANCj4gPiBJIHNlZSB5b3VyIHBvaW50
IGJ1dCBJIGRvbid0IHRoaW5rIHRoZXJlIHdpbGwgYmUgYW55IHByb2JsZW1zIHVubGVzcyB5b3Ug
DQo+ID4gaGF2ZSBzb21lIHN0cmFuZ2Ugc3lzdGVtIHRoYXQgZG9lc24ndCBoYW5kbGUgdGhlIHdy
aXRlIGFjY2Vzc2VzIHRvIA0KPiA+IHVuaW1wbGVtZW50ZWQgZmVhdHVyZXMgcHJvcGVybHkgLi4u
DQo+IA0KPiBJcyBub3QgaXQgdGhlbiBqdXN0IHNhZmVyIHRvIG5vdCBkbyB0aGUgd3JpdGUgdG8g
YSByZWdpc3RlciB0aGF0IHlvdSBkbw0KPiBub3Qga25vdyBob3cgdGhlIGltcGxlbWVudGF0aW9u
IGlzIGdvaW5nIHRvIHJlc3BvbmQgdG8gd2l0aCBvbmUgb2YgYQ0KPiB0YXJnZXQgYWJvcnQsIHRp
bWVvdXQsIGRlY29kaW5nIGVycm9yLCBqdXN0IGRlYWQgbG9jaz8NCg0KSSBkb24ndCB0aGluayBh
bnkgb2YgdGhlc2Ugd2lsbCBldmVyIGhhcHBlbi4gTm90aWNlIHRoYXQgdGhpcyBpcyBhbHJlYWR5
IA0KYmVlbiBkb25lIGZvciBhIGxvbmcgdGltZSBpbiBzb21lIHJlZ2lzdGVycyB0aGF0IG1heSBu
b3QgZXhpc3QgaW4gc29tZSANCnJhbmRvbSBIVyBjb25maWcgYW5kIHRoZXJlIGlzIGFsc28gdGhl
IHBvaW50IHRoYXQgdGhpcyBpcyBhIHdyaXRlIA0Kb3BlcmF0aW9uIHNvIFNsYXZlIEVycm9yIHdv
dWxkIG9ubHkgZ2V0IHRyaWdnZXJlZCBpZiB3ZSBkaWQgYSByZWFkLg0KDQo+IEFsc28sIHdvdWxk
IGl0IG1ha2Ugc2Vuc2UgdG8gY29uc2lkZXIgYWRkaW5nIGFuICNpZmRlZg0KPiBDT05GSUdfUEhZ
U19BRERSX1RfNjRCSVQgcGx1cyB0aGUgY29uZGl0aW9uYWwgY2hlY2sgc28gdGhhdCB5b3UgY2Fu
IGJlDQo+IHNsaWdodGx5IG1vcmUgb3B0aW1hbCBpbiB0aGUgaG90LXBhdGggaGVyZT8NCg0KV2Vs
bCwgdGhpcyBpcyBub3QgaG90LXBhdGguIEl0J3Mgb25seSBkb25lIGluIEhXIG9wZW4gc2VxdWVu
Y2UuIFRoZSANCmhvdC1wYXRoIHdvdWxkIGJlIHNldF97cngvdHh9X3RhaWxfcHRyKCkgYnV0IHRo
YXQncyAzMiBiaXRzIG9ubHkuIA0KDQotLS0NClRoYW5rcywNCkpvc2UgTWlndWVsIEFicmV1DQo=
