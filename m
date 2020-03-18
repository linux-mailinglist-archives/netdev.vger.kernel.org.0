Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1641F1894B3
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 04:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgCRD7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 23:59:06 -0400
Received: from mail-am6eur05on2076.outbound.protection.outlook.com ([40.107.22.76]:6153
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726250AbgCRD7G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 23:59:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kAjsP7FHGjHEORYu8T+JeN8ZtQZYwf+vDt94BMr1VhyI4ygRx0M6QrIvalmEOOK+Q9yydJ2okRuocLjpzu4kZw2EfNCm4Uo2bnZv80pfrRD73VJRBl6L67E7v6OgnshmMiqkcfwRR4FEQ6N1HltksW3DqZTDe2txzPZqWCQTUafkTL+ZMNsI2ywpvRHZC6KjwSnDmYRbgG1gFnJo7ZCALtBTlCOVJkEwHbW8FozvI5fRxtMzp8FSPatlMKw+k+YJto11W20vyW1d7tpknuyxUmh8JsSJP5xqeSRQUL+71rt2b8Y+BbPD8F/V0Ta0BnAmJ5VJLEsYot2QfAnZsuLq0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6iG57HeOsqrn9+8s8ynXdidOsUx6LxhG3der5CHYG0=;
 b=eKuwk+NWeu9ZDnmCmWkcSmpb7xgLZ8w0zPJgXfEtjlZnJiJ89fCeY5+mDQqJPonysUPfZlyi+iCMEt0IwQ0+GGnz6b38tJ2JDHNS/72Oys6aL81YfXKl0dN1icQdoopYjIKPw8MiMXLHIzF9vmU9d/pDgVy3ctFkFpKdic1kK1is8tFDWtWwMoWvKOqYEfZTWLLf0coofw6UgsGE6gjUVynFvbz9RZLV1qC/loeugPssS0baUklUH5UGyo+0Li+zYtnmHzG5EW4dXqDVlB+tIA1GzQQyHn686yd+ZBTnaQeto36u9SqE1wHzt+UhKk6cp6nHRJlFu02u+VMiwYlAow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6iG57HeOsqrn9+8s8ynXdidOsUx6LxhG3der5CHYG0=;
 b=eoIc2Fsm1+kV3agtDSPjgaGNxcaHvpzPwNwdI3QN3eRNfDwc3PES1WXmfVfBL0MVYgscYx0HvnUrZzR6CqIk8dBl7IQvWkqdTzMa17kzhv5SXj7urdnh2w1frjBQpGO906XBnuZ7GBxGPb0ciusJu3HuXayKyVFH/Wu18MFRUAs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4414.eurprd05.prod.outlook.com (52.133.12.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.18; Wed, 18 Mar 2020 03:59:01 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 03:59:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>,
        Paul Blakey <paulb@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb
 support
Thread-Topic: [PATCH net-next 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb
 support
Thread-Index: AQHVr0HWrJ3tUt3ylke6yfGwXQxlbqezP/qAgAD6fYCACo6eAICMWk4AgAMxNIA=
Date:   Wed, 18 Mar 2020 03:59:01 +0000
Message-ID: <94f07fd5a39e22ced54162d77b1089f46544030d.camel@mellanox.com>
References: <1575972525-20046-1-git-send-email-wenxu@ucloud.cn>
         <1575972525-20046-2-git-send-email-wenxu@ucloud.cn>
         <140d29e0-712a-31b0-e7b0-e4f8af29d4a8@mellanox.com>
         <a96ffa33-e680-d92c-3c5c-f86b7b9e12bb@ucloud.cn>
         <62c3d7ec655b0209d2f5d573070e484ac561033c.camel@mellanox.com>
         <02ad5abe-8a1c-8e39-3c8e-e78c3186ef79@ucloud.cn>
In-Reply-To: <02ad5abe-8a1c-8e39-3c8e-e78c3186ef79@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cfc8f190-5a15-465a-b8aa-08d7caf0b1ab
x-ms-traffictypediagnostic: VI1PR05MB4414:|VI1PR05MB4414:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4414318AD38B6C83409C314EBEF70@VI1PR05MB4414.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 03468CBA43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(199004)(76116006)(91956017)(81166006)(81156014)(66556008)(86362001)(66946007)(53546011)(186003)(66446008)(110136005)(64756008)(66476007)(8676002)(6512007)(2616005)(8936002)(4001150100001)(71200400001)(36756003)(966005)(5660300002)(4326008)(26005)(478600001)(316002)(6636002)(2906002)(6506007)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4414;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HK8AY3c7p1KMT/CLopxe446VBEFNZ+0egmN6w5kyTwe/5AsBJPvzlAG5G5BY6JSLlSgFp7F0lojqmKGWxt1lIHG811iFgjXA0vb85zrqD1+Dkc4idCg+Nn0kt0Q1cbs1pRuVU7+HCQJMGDsQJeN7C+BgZEYDXutJtVRwhH7FWZwmTSw7TwrW+a8Tw7gZBMjoKVc27kpk7I2HMNOB5BsWLw99CcEeeokzQd9Jq4Xgdov/CEuhZKhuEaL1SqDGMVwK1+YAnFH0puAi+mzrmM5b4gp9w8YmgbEhTFrpg6ru+rDDDPQwKXz+dXDf48v4ctmvNgNjwcYbarv95I+m+z2KSsiaKQZRH6EijjSiH1EK639C4ZaOO2oX+qSBnI07eI4ymUkVzE8HZ9gD79XY/AXd92k0DbyskLStefjfPnlb/JJQpWQ26rcWQSKLuYb3kbJUmELC+C5J5COATXmrEurksCjjd06ePA3q3N7bTxKVipuDM6NVH1rhj5MFXH+KON8sNaRLpDat3+7FirQZJ6X4XQ==
x-ms-exchange-antispam-messagedata: X0rDlBgIMqUo5xEUEZJPc4CF/Etj3nHx1flbjewQV4AyWlNPNQ5WQLJz2MbP2YfE7e/58eWU4JOxJTfH5jeQk0E/Ors9BeCermBVnqmMEbsEbNQRykSvf9HQHTnTh/jqtlDmo4fCADmlW7qbOwOMpg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9CE7A1BBFA46842B2B2F6B3D5D458D3@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfc8f190-5a15-465a-b8aa-08d7caf0b1ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2020 03:59:01.6468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tBCOj1iDO6wC2fdkfDDNXB3THThwPWNxQpXRMQanQ7TR0aUh58hrQ8NvDChGkzSq1mV9hXJEtVGyUYxDraYc0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4414
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTAzLTE2IGF0IDExOjE0ICswODAwLCB3ZW54dSB3cm90ZToNCj4gT24gMTIv
MTgvMjAxOSAzOjU0IEFNLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4gPiBPbiBXZWQsIDIwMTkt
MTItMTEgYXQgMTA6NDEgKzA4MDAsIHdlbnh1IHdyb3RlOg0KPiA+ID4gT24gMTIvMTAvMjAxOSA3
OjQ0IFBNLCBQYXVsIEJsYWtleSB3cm90ZToNCj4gPiA+ID4gT24gMTIvMTAvMjAxOSAxMjowOCBQ
TSwgd2VueHVAdWNsb3VkLmNuIHdyb3RlOg0KPiA+ID4gPiA+IEZyb206IHdlbnh1IDx3ZW54dUB1
Y2xvdWQuY24+DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gQWRkIG1seDVlX3JlcF9pbmRyX3NldHVw
X2Z0X2NiIHRvIHN1cHBvcnQgaW5kciBibG9jayBzZXR1cA0KPiA+ID4gPiA+IGluIEZUIG1vZGUu
DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gU2lnbmVkLW9mZi1ieTogd2VueHUgPHdlbnh1QHVjbG91
ZC5jbj4NCj4gPiA+ID4gPiAtLS0NCj4gPiBbLi4uXQ0KPiA+IA0KPiA+ID4gPiArY2MgU2FlZWQN
Cj4gPiA+ID4gDQo+ID4gPiA+IA0KPiA+ID4gPiBUaGlzIGxvb2tzIGdvb2QgdG8gbWUsIGJ1dCBp
dCBzaG91bGQgYmUgb24gdG9wIG9mIGEgcGF0Y2ggdGhhdA0KPiA+ID4gPiB3aWxsIA0KPiA+ID4g
PiBhY3R1YWwgYWxsb3dzIHRoZSBpbmRpcmVjdCBCSU5EIGlmIHRoZSBuZnQNCj4gPiA+ID4gDQo+
ID4gPiA+IHRhYmxlIGRldmljZSBpcyBhIHR1bm5lbCBkZXZpY2UuIElzIHRoYXQgdXBzdHJlYW0/
IElmIHNvIHdoaWNoDQo+ID4gPiA+IHBhdGNoPw0KPiA+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+
IEN1cnJlbnRseSAoNS41LjAtcmMxKyksIG5mdF9yZWdpc3Rlcl9mbG93dGFibGVfbmV0X2hvb2tz
IGNhbGxzIA0KPiA+ID4gPiBuZl9mbG93X3RhYmxlX29mZmxvYWRfc2V0dXAgd2hpY2ggd2lsbCBz
ZWUNCj4gPiA+ID4gDQo+ID4gPiA+IHRoYXQgdGhlIHR1bm5lbCBkZXZpY2UgZG9lc24ndCBoYXZl
IG5kb19zZXR1cF90YyBhbmQgcmV0dXJuIA0KPiA+ID4gPiAtRU9QTk9UU1VQUE9SVEVELg0KPiA+
ID4gVGhlIHJlbGF0ZWQgcGF0Y2ggIGh0dHA6Ly9wYXRjaHdvcmsub3psYWJzLm9yZy9wYXRjaC8x
MjA2OTM1Lw0KPiA+ID4gDQo+ID4gPiBpcyB3YWl0aW5nIGZvciB1cHN0cmVhbQ0KPiA+ID4gDQo+
ID4gVGhlIG5ldGZpbHRlciBwYXRjaCBpcyBzdGlsbCB1bmRlci1yZXZpZXcsIG9uY2UgYWNjZXB0
ZWQgaSB3aWxsDQo+ID4gYXBwbHkNCj4gPiB0aGlzIHNlcmllcy4NCj4gPiANCj4gPiBUaGFua3Ms
DQo+ID4gU2FlZWQuDQo+ID4gDQo+IEhpIFNhZWVkLA0KPiANCj4gDQo+IFNvcnJ5IGZvciBzbyBs
b25nIHRpbWUgdG8gdXBkYXRlLiBUaGUgbmV0ZmlsdGVyIHBhdGNoIGlzIGFscmVhZHkNCj4gYWNj
ZXB0ZWQuICBUaGlzIHNlcmllcyBpcyBhbHNvDQo+IA0KPiBub3Qgb3V0IG9mIGRhdGUgYW5kIGNh
biBhcHBseSB0byBuZXQtbmV4dC4gIElmIHlvdSBmZWVsIG9rICBwbGVhc2UNCj4gYXBwbHkgaXQg
dGhhbmtzLg0KPiANCj4gDQo+IFRoZSBuZXRmaWx0ZXIgcGF0Y2g6DQo+IA0KPiBodHRwOi8vcGF0
Y2h3b3JrLm96bGFicy5vcmcvcGF0Y2gvMTI0MjgxNS8NCj4gDQo+IEJSDQo+IA0KPiB3ZW54dQ0K
PiANCg0KQXBwbGllZCB0byBuZXQtbmV4dC1tbHg1LCAgZG9pbmcgc29tZSBidWlsZCB0ZXN0aW5n
IG5vdywgYW5kIHdpbGwgbWFrZQ0KdGhpcyBydW4gaW4gcmVncmVzc2lvbiBmb3IgYSBjb3VwbGUg
b2YgZGF5cyB1bnRpbCBteSBuZXh0IHB1bGwgcmVxdWVzdA0KdG8gbmV0LW5leHQuDQoNClRoYW5r
cywNCnNhZWVkLg0K
