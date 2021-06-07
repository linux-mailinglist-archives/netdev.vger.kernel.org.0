Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A3E39D419
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 06:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhFGEjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 00:39:23 -0400
Received: from us-smtp-delivery-115.mimecast.com ([216.205.24.115]:35994 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229498AbhFGEjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 00:39:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1623040651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n2dYKh8+ZK0VaFs6WzEMc8KcnQhI/W0QiIB+A4KCpp0=;
        b=F4bLRibWA19mDPsA2jrkG+U+7765tdcFqoteTTomC9Aeun9QCbOkS6bBjTDdne9HGwZCmM
        Hr4DlNLaqHrMkujtIc2oW5m9kpwvBQ/a7cZmX9gEu9rROzbqf2e+ERMbEblap9mxR0ydmp
        gfukPnD/K7grgU3HuiD4MG/zVGpFBUc=
Received: from NAM10-BN7-obe.outbound.protection.outlook.com
 (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-FBUgKMMgPpW7V9hWb0sHrw-1; Mon, 07 Jun 2021 00:37:29 -0400
X-MC-Unique: FBUgKMMgPpW7V9hWb0sHrw-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by MWHPR19MB0125.namprd19.prod.outlook.com (2603:10b6:301:6a::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.29; Mon, 7 Jun
 2021 04:37:25 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4195.029; Mon, 7 Jun 2021
 04:37:24 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Thomas Mohren <tmohren@maxlinear.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>
Subject: Re: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Topic: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Index: AQHXWVyDhUpan91jNkyIQ1KYwvXYZKsEQVYAgACCzgCAAOiAgIACTkGA
Date:   Mon, 7 Jun 2021 04:37:24 +0000
Message-ID: <9ecb75b8-c4d8-1769-58f4-1082b8f53e05@maxlinear.com>
References: <20210604161250.49749-1-lxu@maxlinear.com>
 <20210604194428.2276092-1-martin.blumenstingl@googlemail.com>
 <b01a8ac2-b77e-32aa-7c9b-57de4f2d3a95@maxlinear.com>
 <YLuzX5EYfGNaosHT@lunn.ch>
In-Reply-To: <YLuzX5EYfGNaosHT@lunn.ch>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
x-originating-ip: [138.75.37.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 072a11a7-0b5d-4ff4-9de4-08d9296df2a6
x-ms-traffictypediagnostic: MWHPR19MB0125:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR19MB0125AEF4CAA1CC40AAA560BBBD389@MWHPR19MB0125.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: wSrzWl4B7fZVaKf//dOHs03vX4xT0H8rN/6qha+HkMdn6liR/MlLJqkSwSDKJG74Il4xo3gwzcZQGfBrxKk6XHL1VYrlBGiiwmQrKjhaBS+Mv3/vQGoCVLpGgMEWMOmPtJjukKrsONoJtqUDHxB94u7YayOvCeuZWhU7XsyIYSYJppG9gLrxSQd4ilFeV381HKs2rVic/vXuUdonLvPnea3az51VvmbHAmX9/TrHn4kx+uyOzheoeYp/Vt9d7rYsxnEsuPoaYjSk2ENH+6G2g0MNfArWgESd7SsvkeJKcCl8TB4XFkYV4xzF7QmDwNAe479C5IxlwkyNN9nlg1uzM1QT0+Q6ebt4LYrS/2ddQQmGuxO6wLD0Id2KwbFdSVQAadiDnj+wY4DGc4MF+eVI1eEmtwTCdmXkZJtIpkpXZ+AsUVkxN0Ajk7uFXf0OpvgPkhlIO34vAAn3V35HLjQ8Z1hqBpdKazJofNG/CLbF+1Ra+rDTYDIbusP2U+A7BvBSQEuCSzxO725P7oV6StKTpFtJVNEk+B6coElRG7u5HSvtEYecEbCs2MnkO9gSSiZIgLPnv9E0VgvI9jYVxE6nUvohMINH5qGFDQHkukafPh/UAGHREyFIqGmVHAwiL2mCqlD/RVXM/CthWYqJUiLIN9xfWnfxhlNasndQh+s4TR9Y0fIPKiVaGqSFzygbLzAC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(376002)(366004)(136003)(396003)(36756003)(86362001)(66446008)(31686004)(71200400001)(76116006)(91956017)(66946007)(66556008)(66476007)(6486002)(6916009)(64756008)(478600001)(2906002)(83380400001)(186003)(316002)(122000001)(38100700002)(2616005)(6506007)(8936002)(54906003)(26005)(8676002)(5660300002)(6512007)(4326008)(31696002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata: =?utf-8?B?cENNTitvY0xDek1xbU5IdE9Ha1FrMmJtWWRrQkNKNmxYb1ZiejBHa3J0eG54?=
 =?utf-8?B?UWRlSGZFTjAyWUNMdUk5R2s2cnZ5NEQ0T09yb01sMGhSZmpvdTcwNm5mcUFC?=
 =?utf-8?B?d0ZMQk5qcU43akgrVkN4YThJZmkvYXY0R0tFS1BOdFNzeitPb1JwTTBVYzRW?=
 =?utf-8?B?TWR3NFlWS1h5akg2aUV6QjJxa2hKMUpCdDlXUWNxUXNwRDhRK3dLWWdaQkVx?=
 =?utf-8?B?UlZjWitzU21lRGhOSlJ3eUNnaHp2UE5IRm5MZXA2THRDOFl4UXhDZjRKYUVo?=
 =?utf-8?B?SEozaEx5MjVvTUR5N2IrUDJEMXNxNEpkNjJmeldZYllxMThVMUpUOHVmTDB0?=
 =?utf-8?B?KzRMTDdHSEtBc1ZqamxSVmFXeEdRKzZFVlIyZWhCR2hhZTlpS1J5akpKU2tQ?=
 =?utf-8?B?UXFJRTFzNytPaERDVjVlSnpwL0lOVXlJZ0grMlpXRU9UMGJraWM2dnFvMzAw?=
 =?utf-8?B?RHlyd2lFNENrVTNwaEJjUllBb3FnbFpHQ3FDLzNBTWI4UEJvR1dyRFY2QVkw?=
 =?utf-8?B?VUExNlNNUzJqdVlJdHBSSWVjd3I4b2FtM1FxU0IxRXR4RnJWYzl2dTg0Y2xY?=
 =?utf-8?B?NmZkUkErc1laUVpMUkR0UXVuR2xUNzh3WVQ1KzB4aVYzeCtLZHZhM2h4RUpJ?=
 =?utf-8?B?ZGhNMmRnY3JESmd2ckV3QmhaTWlRd1oxcUxDTlZnN0h2MDV2UXVWRjc1cDdO?=
 =?utf-8?B?RGlHUm9sV3NVcGRzMmkxZmhNdDUwd0xLbWhyR29kZURCcWxhdjBBTVFvQjh0?=
 =?utf-8?B?TWIvWU5VSmloaU5VSkJTSlBmR3FSdGRyUDhqNWwyWU1TQVpSTlVhUmlSUzNs?=
 =?utf-8?B?dzhQOUlMZm1sYmtpT2hiVXhKOEJhM0hiV1Z5YTI0UkZOWHA1V3V1TkhRL0Vj?=
 =?utf-8?B?TUNBZ2pURWZMcXVjeGwrM1AzTFZFS0t0MjhJN3hNbUZqSTJMSTcvSEt6NzZU?=
 =?utf-8?B?aHhBbGFoRVZENWpiRER3Wmh4N2Q5aDFFTHhnSEg1NlE3SytnRW1Oc0pBTFdN?=
 =?utf-8?B?R3BaaEFHTGJIWEZzZmwxUmt0U1hoWmhURFYyK2pOQWdFMnI4bDlmVDFUWEN4?=
 =?utf-8?B?T280L0tObUpOYWNaMFNVMDh5bjRNWm5tMW9WaS84cEV5QkFXLzBubnRlclF1?=
 =?utf-8?B?Vk5qSU5rTkM5YmkzWFlyLzVaaEJ0ZHBCNStJWnlKbEY0VytOSC9WRC93N01s?=
 =?utf-8?B?Z1M1Zk1WTkNIMzJVeEh4M2lEb1ZMa1FhL0xldm9TUzFQNGpvZjluRGgwWTR5?=
 =?utf-8?B?ajNzY0FuNkUwOG5SdG1JRDF5eUZ0U29RYVB5QWFtMTQxS1hiOHNWQTFQemJI?=
 =?utf-8?B?OU5TbWEyNDhFMWpYNWlWM2FlODRjSUtiZ25TN21CYUFTNUdLbUZHTjh0aHBC?=
 =?utf-8?B?RnZEcm4rVW5rbUo1d2ttRHZnNm9vdllNTEhEeEZNbFpjMW52Q1FGTjQwWnQ0?=
 =?utf-8?B?YnVlaDZNQkZ0ZWc5M1VJaHM2ais3ejdxRkZCUEFHUFo4MjVGN21jRmJzeWtM?=
 =?utf-8?B?blNmb1E2KzdCWnRwb1kySjJTNjRYSkpmdmFBbitzOGpqUG5GMjJMMEp5OWZZ?=
 =?utf-8?B?anduR3RLd2NseGtodTU0NXlxOEhDaW9CSnRqQVRHSWt1UUNWeGdPbFM5dnpJ?=
 =?utf-8?B?SmQxOG1adFBGclVtamttSU4wNG9udkVlVzU4U0ZhZTFtRG05V2NKRDczN1Yw?=
 =?utf-8?B?bWRYRytCYy9BQnV0SlJFMDNXYmtpVUZHM3ZaV2RlbWdUemVXT2RDNXFIejVi?=
 =?utf-8?Q?4ORmSyCx1l/7IVrAjE=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 072a11a7-0b5d-4ff4-9de4-08d9296df2a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2021 04:37:24.4558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7jsclU1e2HkDWnfJalq8fTxQ+q6PfpOjY7KDpBc77LloQSi1YPbS0CEWy05sQoqB9l7d6Lq9ebFMy+7MjMN/jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR19MB0125
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <31FD87AF9CDD714996022E251BC78F87@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi82LzIwMjEgMToyNCBhbSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IFRoaXMgZW1haWwgd2Fz
IHNlbnQgZnJvbSBvdXRzaWRlIG9mIE1heExpbmVhci4NCj4NCj4NCj4gT24gU2F0LCBKdW4gMDUs
IDIwMjEgYXQgMDM6MzI6MzlBTSArMDAwMCwgTGlhbmcgWHUgd3JvdGU6DQo+PiBPbiA1LzYvMjAy
MSAzOjQ0IGFtLCBNYXJ0aW4gQmx1bWVuc3RpbmdsIHdyb3RlOg0KPj4+IFRoaXMgZW1haWwgd2Fz
IHNlbnQgZnJvbSBvdXRzaWRlIG9mIE1heExpbmVhci4NCj4+Pg0KPj4+DQo+Pj4gSGVsbG8sDQo+
Pj4NCj4+Pj4gQWRkIGRyaXZlciB0byBzdXBwb3J0IHRoZSBNYXhsaW5lYXIgR1BZMTE1LCBHUFky
MTEsIEdQWTIxMiwgR1BZMjE1LA0KPj4+PiBHUFkyNDEsIEdQWTI0NSBQSFlzLg0KPj4+IHRvIG1l
IHRoaXMgc2VlbXMgbGlrZSBhbiBldm9sdXRpb24gb2YgdGhlIExhbnRpcSBYV0FZIFBIWXMgZm9y
IHdoaWNoDQo+Pj4gd2UgYWxyZWFkeSBoYXZlIGEgZHJpdmVyOiBpbnRlbC14d2F5LmMuDQo+Pj4g
SW50ZWwgdG9vayBvdmVyIExhbnRpcSBzb21lIHllYXJzIGFnbyBhbmQgbGFzdCB5ZWFyIE1heExp
bmVhciB0aGVuDQo+Pj4gdG9vayBvdmVyIHdoYXQgd2FzIGZvcm1lcmx5IExhbnRpcSBmcm9tIElu
dGVsLg0KPj4+DQo+Pj4gICBGcm9tIHdoYXQgSSBjYW4gdGVsbCByaWdodCBhd2F5OiB0aGUgaW50
ZXJydXB0IGhhbmRsaW5nIHN0aWxsIHNlZW1zDQo+Pj4gdG8gYmUgdGhlIHNhbWUuIEFsc28gdGhl
IEdQSFkgZmlybXdhcmUgdmVyc2lvbiByZWdpc3RlciBhbHNvIHdhcyB0aGVyZQ0KPj4+IG9uIG9s
ZGVyIFNvQ3MgKHdpdGggdHdvIG9yIG1vcmUgR1BIWXMgZW1iZWRkZWQgaW50byB0aGUgU29DKS4g
U0dNSUkNCj4+PiBzdXBwb3J0IGlzIG5ldy4gQW5kIEkgYW0gbm90IHN1cmUgYWJvdXQgV2FrZS1v
bi1MQU4uDQo+Pj4NCj4+PiBIYXZlIHlvdSBjb25zaWRlcmVkIGFkZGluZyBzdXBwb3J0IGZvciB0
aGVzZSBuZXcgUEhZcyB0byBpbnRlbC14d2F5LmM/DQo+IFRoZSBXT0wgaW50ZXJydXB0cyBhcmUg
dGhlIHNhbWUsIHdoaWNoIGNvdWxkIGltcGx5IFdvTCBjb25maWd1cmF0aW9uDQo+IGlzIHRoZSBz
YW1lPyBJZiBpdCBpcyB0aGUgc2FtZSwgaXQgd291bGQgYmUgZ29vZCB0byBhbHNvIGFkZCBXb0wg
dG8NCj4gaW50ZWwteHdheS5jLg0KPg0KPiBXaGF0IHRoaXMgbmV3IGRyaXZlciBkb2VzIG5vdCB5
ZXQgZG8gaXMgTEVEcy4gSXQgd291bGQgYmUgaW50ZXJlc3RpbmcNCj4gdG8gc2VlIGlmIHRoZSBM
RUQgY29udHJvbCBpcyB0aGUgc2FtZS4gSG9wZWZ1bGx5LCBvbmUgZGF5LCBnZW5lcmljIExFRA0K
PiBzdXBwb3J0IHdpbGwgZ2V0IGFkZGVkLiBJZiB0aGlzIFBIWSBhbmQgaW50ZWwteHdheS5jIGhh
cyB0aGUgc2FtZSBMRUQNCj4gY29kZSwgd2Ugd2lsbCB3YW50IHRvIHNoYXJlIGl0Lg0KPg0KPj4g
VGhleSBhcmUgYmFzZWQgb24gZGlmZmVyZW50IElQIGFuZCBoYXZlIG1hbnkgZGlmZmVyZW5jZXMu
DQo+IFBsZWFzZSBjb3VsZCB5b3UgbGlzdCB0aGUgZGlmZmVyZW5jZXM/IElzIHRoZSBkYXRhc2hl
ZXQgYXZhaWxhYmxlPyAgSQ0KPiBmb3VuZCBhIGRhdGFzaGVldCBmb3IgdGhlIFhXQVksIHNvIGl0
IHdvdWxkIGJlIG5pY2UgdG8gYmUgYWJsZSB0bw0KPiBjb21wYXJlIHRoZW0uDQo+DQo+PiBUaGUg
WFdBWSBQSFlzIGFyZSBnb2luZyB0byBFb0wgKG9yIG1heWJlIGFscmVhZHkgRW9MKS4NCj4gVGhh
dCBkb2VzIG5vdCBtYXR0ZXIuIFRoZXkgYXJlIGdvaW5nIHRvIGJlIGluIHVzZSBmb3IgdGhlIG5l
eHQgNSB5ZWFycw0KPiBvciBtb3JlLCB1bnRpbCBhbGwgdGhlIHByb2R1Y3RzIHVzaW5nIHRoZW0g
aGF2ZSBkaWVkIG9yIGJlZW4NCj4gcmVwbGFjZWQuIExpbnV4IHN1cHBvcnRzIGhhcmR3YXJlIHRo
YXQgaXMgaW4gdXNlLCBub3QganVzdCB3aGF0DQo+IHZlbmRvcnMgc2VsbCB0b2RheS4NCj4NCj4+
IEl0IGNyZWF0ZXMgZGlmZmljdWx0eSBmb3IgdGhlIHRlc3QgY292ZXJhZ2UgdG8gcHV0IHRvZ2V0
aGVyLg0KPiBUaGF0IGFsc28gZG9lcyBub3QgcmVhbGx5IG1hdHRlci4gSWYgc29tZWJvZHkgaGFz
IGJvdGgsIGRvZXMgdGhlIHdvcmsNCj4gdG8gbWVyZ2UgdGhlIGRyaXZlcnMgYW5kIG92ZXJhbGwg
d2UgaGF2ZSBsZXNzIGNvZGUgYW5kIG1vcmUgZmVhdHVyZXMsDQo+IHRoZSBwYXRjaCB3aWxsIGJl
IGFjY2VwdGVkLg0KPg0KPg0KPiAgICAgICAgICBBbmRyZXcNCj4NCj4NClRoZSBkYXRhc2hlZXQg
b2YgR1BZMnh4IGFyZSBvbmx5IGF2YWlsYWJsZSB1bmRlciBOREEgY3VycmVudGx5LCBzaW5jZSB3
ZSANCmhhdmUNCg0KdG8gcHJvdGVjdCBvdXIgSVAgZm9yIHRoZSBuZXcgZGV2aWNlcy4NCg0KSSBk
byBub3Qga25vdyBtdWNoIGFib3V0IFhXQVkgZmVhdHVyZSBzZXQsIGJ1dCBJIGd1ZXNzIHRoZSBk
aWZmZXJlbmNlIHNob3VsZA0KDQpiZSAyLjVHIHN1cHBvcnQsIEM0NSByZWdpc3RlciBzZXQsIFBU
UCBvZmZsb2FkLCBNQUNzZWMgb2ZmbG9hZCwgZXRjLg0KDQpQcm9ibGVtIG9mIG1lcmdpbmcgdGhl
IGJvdGggZHJpdmVycyB3b3VsZCBiZSB0aGUgdmVyaWZpY2F0aW9uIG9mIHRoZSBvbGQgDQpkZXZp
Y2VzDQoNCmZvciB3aGljaCBJIGRvIG5vdCBoYXZlIGEgdGVzdCBlbnZpcm9ubWVudC4gSSBjYW4n
dCBkZWxpdmVyIGNvZGUgd2l0aG91dCANCnRlc3RpbmcsDQoNCmFuZCBpdCB3aWxsIGJlIGJpZyBw
cm9ibGVtIGZvciBtZSBpZiBpdCBicmVha3MgZnVuY3Rpb24gb2YgZXhpc3RpbmcgDQp1c2VyL2N1
c3RvbWVyLg0KDQpXZSB3aWxsIGNoZWNrIGZvciBvcHRpb25zIGFuZCBuZWVkIGFwcHJvdmFsIGZy
b20gY29tcGFueSwgYnV0IHRoaXMgd2lsbCANCm5vdCBiZQ0KDQpwb3NzaWJsZSBzaG9ydCB0ZXJt
IHdpdGhpbiB0aGlzIG1lcmdlIHdpbmRvdy4NCg0KRm9yIG5vdywgY2FuIEkgdXBzdHJlYW0gdGhp
cyBuZXcgZHJpdmVyIGZpcnN0LCBhbmQgbWVyZ2UgdGhlIG9sZCBkcml2ZXIgDQppbnRvIG5ldyBv
bmUgbGF0ZXI/DQoNCldlIHdpbGwgZW5oYW5jZSB0aGUgbmV3IGRyaXZlciBzdGVwIGJ5IHN0ZXAg
d2l0aCBkaWZmZXJlbnQgZmVhdHVyZXMsIGJ1dCANCmN1cnJlbnRseQ0KDQp3ZSB3b3VsZCBsaWtl
IHRvIG1ha2UgdGhlIGZpcnN0IHZlcnNpb24gYXZhaWxhYmxlIGFuZCB3b3JraW5nIGZvciBvdXIg
DQpjdXN0b21lcnMuDQoNCg0KVGhhbmtzICYgUmVnYXJkcywNCg0KWHUgTGlhbmcNCg0K

