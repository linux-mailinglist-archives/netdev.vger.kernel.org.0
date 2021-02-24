Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219C1323594
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 03:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhBXCN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 21:13:57 -0500
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:56036
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229961AbhBXCNz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 21:13:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iF0CznVCpJJCwWWiEekFMO3YpsjqMIenTm5SpSKLsz2aJC5AlJJwcmBI6zIBTa5QemcrvG9O/Gjf1KywzU2djgnhaRIMwSuF2Rr6dqFB4AnNvDK1tfTLXLbLiN9tEJ6pIJZo7gMa8Z/JnDLiRkzG4qfW7uXUVCKjfgRWsxix64VaRRJAzpzqNnNmpDRqX5kk1VtKnrYEmOlWbMERTXbALyv4NdLleufM4TTmKm4tZAQbwSMRz0CiAJEMclGHQf9TNK/N4MdLSc6M/Oo1urYPd/+F1MAARufVHB0B6f4h1gfRswSfMQCA8L9W4TtmifqVdbef2p3sE2Iy0tOcGb4COw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/yxdWPdM9NjoIZYbY/wPTO1OiSFGTbqqAYGac8wqzrA=;
 b=c/MRsvHmx/mzKJTjudzqcrbo95osvy2ekDmKY3cba7IljNLCx3vvS3/sEz9uYDu6ENYbFsIlyyXETI4RN7xu0W86p7qybTcty/+mEXjGC0VLnMuB2BGuyZTr4it8mAuhUkLJdmC8iN2oty5WlBI2XYpSGQnlXyn1PXFCQ0au0OUgSmOICUQYqq1Mt9ioFG9H922I20ogrXUPMX6Aq8ffcGzcOai93xI/0E9HkXHTm2XINRVXZzfZrKjkmJtYFdCePBchICKJXEPTJhpSLYAR1F63uuoqT40LDuULeblKdGNbZxqPhv4blZMtbHFEwUhUicCFgB+bB89IoOZK+wZK8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/yxdWPdM9NjoIZYbY/wPTO1OiSFGTbqqAYGac8wqzrA=;
 b=JNJfG0K3Ia5zfzQaJDL+4NlznRdlviZfUqaTOirORV9DawJIa5T1IbdImHmfJscbuoFFcj4+6gToCqkGvvy3kEWoE3gPNJelKj2OgC3kPAn9BVlJ/6awt3nRq2q9aKsvO6UUrT1y24xwp0iMhaPf6uLE2cHM4uJUuNj93f5Nh5Y=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7900.eurprd04.prod.outlook.com (2603:10a6:10:1e8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Wed, 24 Feb
 2021 02:13:05 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Wed, 24 Feb 2021
 02:13:05 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V1 net-next 0/3] net: stmmac: implement clocks
Thread-Topic: [PATCH V1 net-next 0/3] net: stmmac: implement clocks
Thread-Index: AQHXCdFekWFqiRqYw0qX+7Ua7CCmtKpl8tSAgACRjMCAAAgFgIAAA1yA
Date:   Wed, 24 Feb 2021 02:13:05 +0000
Message-ID: <DB8PR04MB6795663DB5336C8BDB16A159E69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
        <20210223084503.34ae93f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DB8PR04MB6795925488C63791C2BD588EE69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210223175441.2a1b86f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210223175441.2a1b86f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 32fc5068-6570-484e-583f-08d8d869b8f2
x-ms-traffictypediagnostic: DBBPR04MB7900:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB79008B00D3A9D5115569B0F2E69F9@DBBPR04MB7900.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4zIYa52OXjuMMWn11J2dEM3dtlJGYeFLYF+ZKzmxu6R468y36jy0p/px8r9d8FIxuH64f9Eq2IbOeoXSvSEg0cPMaY4jCmMzJtgOQs56k+N9NEGtGC+RIKuOd4cXVP/7eB921qXxtYPEWnDJ+V+iwpNWqKljnXWbDroWkUvBjN/lwy7tcmxrLSDXxfGUSAMOMGhNPghJpy2IYkA/hDmyLDR63BntMiZUZ2g8tz1At3FIM1QNMtH6c/WTNsgQCvyQ0X68WPn/z/I+q+7i3hRhfVvnXG1w0imQtT8UWt1APOAE1cQj4O639OJ5/cJ1Xssk4pznTT/VCmiNgD0FXQeRZ85CGoIevQ29MSd18IFlDvsgRP5D2AvfePApo2pAE7e/vnBrQlgyHl1sDriVC4HTHVwzLAPEd+9XabGgn+c+MEVIbvtgfanQ/Hhs2L2gWwJlZ8gi7fYB/4n/heMhXvbtC5Gk4mEe36lsFXDYpnx6TuBILv1LmQnJqrl79G+hkzYgxDbD6JmDi4nnb7nkyKRzIA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(66476007)(64756008)(7696005)(76116006)(9686003)(186003)(54906003)(66556008)(478600001)(26005)(4326008)(5660300002)(2906002)(52536014)(66446008)(8676002)(66946007)(55016002)(53546011)(86362001)(6506007)(6916009)(8936002)(83380400001)(316002)(33656002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?a1IwTFJOVENmdUduYXlhNGVWZzd2S3ZRK3FQSlRZeW9EdVBBUm1HRXdGRkl5?=
 =?gb2312?B?QXQwbFRyWWI1ckZ4Nk95L28rSXJSeXpHMzFyak9wUUloUXpiSXhZN2k0NG5P?=
 =?gb2312?B?K0NkeC9mb0VxRlBIZWhWKzlyYm5UMTR3RTI5VzB1QWtGaE1sN1JwenVLeWhv?=
 =?gb2312?B?RlBaZGFGT0RDbi8wR3NsMnN3YzcxWXpVT2UxSnFXSTV5M1g5ZkV3WDk2ZGUr?=
 =?gb2312?B?YlQrZGcyNUJrcVF5alN0cmhxSkwycWJLb1VMY05ibGpVb3RnUHBvSXFQcnR5?=
 =?gb2312?B?WHRXTVdJdnRjU1VXS1NHcU15MWFWMndlR25xQzdGa0U5UHJLWkdoNTdYY3dW?=
 =?gb2312?B?MDZ4a2d2cjdIK2N3K3lTcFN3S05TeFU4SG5jTXQ4a1h2N1RJY1hTSThCUDF5?=
 =?gb2312?B?d2UxM2czQVJRTXVXTWFQUVFlRlR5Z0M5TUNOUU1PL1grVHZFWmllcmdMcFdQ?=
 =?gb2312?B?VXZ3NjJKWC9ZMlpyMVY5dFo0RFdyNmJBVCs1ZTNQZWxDTzlROGtJZ0xWRjlP?=
 =?gb2312?B?dldZelNBaFlBYUVwOEJvOGhtcDR0WkV4azQ1TkJaeWVTMTlCTmlRUjV1RUlo?=
 =?gb2312?B?NFFGemFRVVhiLzJtQ0U4MXo4MlZ5Zndmekx1RlpYYnFaL3pxZngxOVpzNTgx?=
 =?gb2312?B?enFGbVVyeDdhQXhOTjV5TVdmYUJSdzBnaWFsbFQ5M1FMcDdOMitoOXhiZHQw?=
 =?gb2312?B?cytrNVFUOHBKbW5yU2tITWxuZEYzVVFUMzYvRmNoQXBvdGp5NzlmbUI1c24x?=
 =?gb2312?B?NUIxWWs5Z3IvWlVxaU1scUoyMWw4QXhsNGVpQ1hDVm13VFFzTUxuT0FicXkz?=
 =?gb2312?B?QmFVQ3M1cWJJTlIxczcrYUtPSnB0SDdRM3VBaTQwazgyNnM2aTlscWs4YjFW?=
 =?gb2312?B?K0hyWUxYaDVyaE5uRm90RktMdGFBOURjUHhKMUJwbWMzYjRLOFpMeTZsc0tH?=
 =?gb2312?B?MlRUZmN4Y0RhMm1mck95anJ6MHNsYVByRTNzd2kxWEZIVmx0TCthWjErSThs?=
 =?gb2312?B?WFBTYkpsQS92LzU1R0k1VGswaGhTNE1HaDZod2FySGlicXk3WUMzY1B1cWk3?=
 =?gb2312?B?NXQ3VTlFNkxyTU1IRndMUXJOK1FTVWhiV3dFdU5xLy9HTXFRdnlONGFLV1Jq?=
 =?gb2312?B?K2srRGx4SFA5RmVSeDF2ME1CeEVGcDNmWVJiT1JXLzFMYWtxZi9VT0ZwWTFV?=
 =?gb2312?B?VVE2dXE4c09hZHFIR1d5RTZiMlpnVWVZR1lySjVwc2lYNm9hM0FRZzlKSmRx?=
 =?gb2312?B?S3hJbVVnN1pZQ3lxc01Td0JKa2dzOVduUzE4eUsxVXV2RVA1THVpR0s2WDYy?=
 =?gb2312?B?MFZjaTlNV3RYQy9sNjZPczl0NDFVWjNRajV1Y0lwUnZEaUc5T3ZaYi9mR3Bl?=
 =?gb2312?B?NENvUlYwdHFFVEI4V1NzZDdQQmM3aGc5Q09FMTR3WmdxS2NCYXllOGFVK1BQ?=
 =?gb2312?B?SEcwUytZc3BKS212aGZxZ1JIbWVjU29EUHlhTk11YUF1NjJOeFRwN21JL0lL?=
 =?gb2312?B?aktBOTJiUGZuWUxsQlErNEVNaVBBK01tVEVXQ2RyRFJhMVZQSFFTMDhQdVU5?=
 =?gb2312?B?WDZpMUFxc0JSSHRCU0ZQZGdaczd6TFR1SUZoRzVYNlpRdG1laGFpOFZrVVFm?=
 =?gb2312?B?bXZnZlRQTGtXSUdFSlBPcWFHQmZxWXUwV3Jxem41VElVZjJFTmhCUExab1h5?=
 =?gb2312?B?bldFbzZvWlZ0NVBKTTEvVWpMWUFldEhHYzNnNXhqRWlzL3BTU1FHQkRQeXZs?=
 =?gb2312?Q?s5nzgfONZs12PH3S0vieMlE/WOo7VtXJCH38dJ4?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32fc5068-6570-484e-583f-08d8d869b8f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2021 02:13:05.8393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VHrsdu2u68BNOdnPHVcROqJki2euFaqP1uxvcb2VZreRWPWeOH6WRZZRTRC/J+9eLgTj+z4g1CKHrzQED2IEcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7900
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpha3ViIEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IDIwMjHE6jLUwjI0yNUgOTo1NQ0KPiBUbzogSm9ha2lt
IFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IHBlcHBlLmNhdmFsbGFyb0Bz
dC5jb207IGFsZXhhbmRyZS50b3JndWVAc3QuY29tOw0KPiBqb2FicmV1QHN5bm9wc3lzLmNvbTsg
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gZGwtbGludXgt
aW14IDxsaW51eC1pbXhAbnhwLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBWMSBuZXQtbmV4
dCAwLzNdIG5ldDogc3RtbWFjOiBpbXBsZW1lbnQgY2xvY2tzDQo+IA0KPiBPbiBXZWQsIDI0IEZl
YiAyMDIxIDAxOjQ1OjQwICswMDAwIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPiA+IEknbSBub3Qg
YW4gZXhwZXJ0IG9uIHRoaXMgc3R1ZmYsIGJ1dCBpcyB0aGVyZSBhIHJlYXNvbiB5b3UncmUgbm90
DQo+ID4gPiBpbnRlZ3JhdGluZyB0aGlzIGZ1bmN0aW9uYWxpdHkgd2l0aCB0aGUgcG93ZXIgbWFu
YWdlbWVudCBzdWJzeXN0ZW0/DQo+ID4NCj4gPiBEbyB5b3UgbWVhbiB0aGF0IGltcGxlbWVudCBy
dW50aW1lIHBvd2VyIG1hbmFnZW1lbnQgZm9yIGRyaXZlcj8gSWYNCj4gPiB5ZXMsIEkgdGhpbmsg
dGhhdCBpcyBhbm90aGVyIGZlYXR1cmUsIHdlIGNhbiBzdXBwb3J0IGxhdGVyLg0KPiANCj4gUnVu
dGltZSBpcyBhIHN0cm9uZyB3b3JkLCBJSVVDIHlvdSBjYW4ganVzdCBpbXBsZW1lbnQgdGhlIFBN
IGNhbGxiYWNrcywgYW5kDQo+IGFsd2F5cyByZXN1bWUgaW4gLm9wZW4gYW5kIGFsd2F5cyBzdXNw
ZW5kIGluIC5jbG9zZS4gUHJldHR5IG11Y2ggd2hhdCB5b3UNCj4gaGF2ZSBhbHJlYWR5Lg0KPiAN
Cj4gPiA+IEkgZG9uJ3QgdGhpbmsgaXQnZCBjaGFuZ2UgdGhlIGZ1bmN0aW9uYWxpdHksIGJ1dCBp
dCdkIGZlZWwgbW9yZQ0KPiA+ID4gaWRpb21hdGljIHRvIGZpdCBpbiB0aGUgc3RhbmRhcmQgTGlu
dXggZnJhbWV3b3JrLg0KPiA+DQo+ID4gWWVzLCB0aGVyZSBpcyBubyBmdW5jdGlvbmFsaXR5IGNo
YW5nZSwgdGhpcyBwYXRjaCBzZXQganVzdCBhZGRzIGNsb2Nrcw0KPiBtYW5hZ2VtZW50Lg0KPiA+
IEluIHRoZSBkcml2ZXIgbm93LCB3ZSBtYW5hZ2UgY2xvY2tzIGF0IHR3byBwb2ludCBzaWRlOg0K
PiA+IDEuIGVuYWJsZSBjbG9ja3Mgd2hlbiBwcm9iZSBkcml2ZXIsIGRpc2FibGUgY2xvY2tzIHdo
ZW4gcmVtb3ZlIGRyaXZlci4NCj4gPiAyLiBkaXNhYmxlIGNsb2NrcyB3aGVuIHN5c3RlbSBzdXNw
ZW5kLCBlbmFibGUgY2xvY2tzIHdoZW4gc3lzdGVtIHJlc3VtZQ0KPiBiYWNrLg0KPiA+DQo+ID4g
VGhpcyBzaG91bGQgbm90IGJlIGVub3VnaCwgc3VjaCBhcywgZXZlbiB3ZSBjbG9zZSB0aGUgTklD
LCB0aGUgY2xvY2tzIHN0aWxsDQo+IGVuYWJsZWQuIFNvIHRoaXMgcGF0Y2ggaW1wcm92ZSBiZWxv
dzoNCj4gPiBLZWVwIGNsb2NrcyBkaXNhYmxlZCBhZnRlciBkcml2ZXIgcHJvYmUsIGVuYWJsZSBj
bG9ja3Mgd2hlbiBOSUMgdXAsIGFuZCB0aGVuDQo+IGRpc2FibGUgY2xvY2tzIHdoZW4gTklDIGRv
d24uDQo+ID4gVGhlIGFpbSBpcyB0byBlbmFibGUgY2xvY2tzIHdoZW4gaXQgbmVlZHMsIG90aGVy
cyBrZWVwIGNsb2NrcyBkaXNhYmxlZC4NCj4gDQo+IFVuZGVyc3Rvb2QuIFBsZWFzZSBkb3VibGUg
Y2hlY2sgZXRodG9vbCBjYWxsYmFja3Mgd29yayBmaW5lLiBQZW9wbGUgb2Z0ZW4NCj4gZm9yZ2V0
IGFib3V0IHRob3NlIHdoZW4gZGlzYWJsaW5nIGNsb2NrcyBpbiAuY2xvc2UuDQoNCkhpIEpha3Vi
LA0KDQpJZiBOSUMgaXMgb3BlbiB0aGVuIGNsb2NrcyBhcmUgYWx3YXlzIGVuYWJsZWQsIHNvIGFs
bCBldGh0b29sIGNhbGxiYWNrcyBzaG91bGQgYmUgb2theS4NCg0KQ291bGQgeW91IHBvaW50IG1l
IHdoaWNoIGV0aHRvb2wgY2FsbGJhY2tzIGNvdWxkIGJlIGludm9rZWQgd2hlbiBOSUMgaXMgY2xv
c2VkPyBJJ20gbm90IHZlcnkgZmFtaWxpYXIgd2l0aCBldGh0b29sIHVzZSBjYXNlLiBUaGFua3Mu
DQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0K
