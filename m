Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CDD30B4A8
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 02:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhBBB1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 20:27:21 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:46748 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbhBBB1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 20:27:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612229234; x=1643765234;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dWQc6PsrjFCWKjElFeqMzFn2W2AEliyxsRoxah/dzOw=;
  b=g07Hdb8O+zntfP4Ol4m3XHNFnj06ILfSMlK+KiLctJnrKh31dmx6u6k8
   EunBu6OhNdYArtwYmYElUSRzkeIBpeqLTL80818w2ZH2E5mEflcgAyaKo
   XWbHQcvIn7fgSVVQU4n1pgcvwq0MqJN666Oh4dUK5TWz63OOvzHmALHcy
   n37uwvpnVA4KlNijviOpIeCoZDXJL+y9edIwaouX0dz5ytSPtKV0f1cZ+
   BHz37sk+lxTnNEE+PceFMvGpBR/hTiJ/XQ3IrZ2WCKCiKTXT1VuMc4V8+
   df+UwgeuC8tteQTLbZ3tE+E2dBTet4OUDrUdPqkSszrUerhgK3Uh0Uic/
   Q==;
IronPort-SDR: h+x/rZUfEmNoByfqynLbzN48ztCJFG1xPygQuXcKwRDW1KELcQvk7ytzbNVOx+TZ56VNpqau84
 dGqISB0tLITB0anYjngKI9XQUBXnZhWWD9+QDY0v39BxK53AtEWhQCoBqrsuhVYx2XskP0PNkg
 rUBws4Bq8VDRATAYwAIVNCbOpUMucwO37Ul0CFMdicczp2edsKr0Sh3xqX8EVZOntaUdG0gu8X
 IpUgn7rTN4IUPtAV7stkVk1yX3NUoSTc0WWnSguJ7Q2pG2za7CnrfQ0BDXhrPukozPQxR8Y1b0
 D/M=
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="107602463"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2021 18:25:57 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 1 Feb 2021 18:25:56 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 1 Feb 2021 18:25:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7S++KD/5PjjupoGCtJ37fxJ/Er1fxbTQDCBWOtr4aSB4FwEAI9ZRjUBkp7S75Uo226ahoBviL8Bm2zmJYjroZbERd7X7U+JYljXuc4007kCQFkM2enHM5l8HULKkSVdGtqLmTMIkYTXWX2YtPoJtEefyXSSzSJpmtzmxI3O/tVvBSo1ZVUopn/yedgRlXzb4G+ZF8V7PHZITzu7QyknXDO92j5LT/mlDZ+VCVEVZr16eWBglZ7X1d3EfTAhbLQ6eXj2yws9TmwXblQK68bGMqclxdfcTTwTSwJorMJTcTppvVpu3tOlFGtmg1U9hY3kKinEczj9Vt4qdJxFwmALfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dWQc6PsrjFCWKjElFeqMzFn2W2AEliyxsRoxah/dzOw=;
 b=huFI39vAD9HLQrvxR7DlouAH5WTrqvjflDsE0Wijs/sm46lMCAUHOnEHrfcli+RWcz/2QC3lqy+yHI11CrlIZO9fGbvLJaBUBUSVartoECaC7n3x1X2d3WKQKUkGNPrEjxFJXFmEVKq5QTwNtylDVQs8Jvm3te7kPEJh9kSY3dkbhX2UzvLO30euHzpt9CU4s+6jIAXbv6R3jOMr8lPi8fTTB+eAWqW6YD4jM8MjiHzUzRxUALsxzn0imAkj1S3Njb+qXO9hQnB6I99xWL6R+faAR2naMo72iuo/5XQG7dvao9m4Hx1GIctAm4gwit46+BBgAe4zaXLvQ/UvFNZ3Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dWQc6PsrjFCWKjElFeqMzFn2W2AEliyxsRoxah/dzOw=;
 b=qJIZ+9+G2FrMtoDRP7MY5vihn0jp/8YizsuYt67CsE0FuwIudbvxm/KnrpRvAX7xsIfOuwHqpKY4e7WTVIk+jhs3N1NR4faR7nHTb6OuY7X658ohaWEP+6R4DU7FcB07htGB4MA1kHJZ7MF15lDArdYyP2HcuqDPa1IUqWroYw4=
Received: from BL0PR11MB3012.namprd11.prod.outlook.com (2603:10b6:208:79::14)
 by MN2PR11MB4495.namprd11.prod.outlook.com (2603:10b6:208:189::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.20; Tue, 2 Feb
 2021 01:25:52 +0000
Received: from BL0PR11MB3012.namprd11.prod.outlook.com
 ([fe80::3585:fa34:68dd:6ca6]) by BL0PR11MB3012.namprd11.prod.outlook.com
 ([fe80::3585:fa34:68dd:6ca6%5]) with mapi id 15.20.3805.024; Tue, 2 Feb 2021
 01:25:51 +0000
From:   <Woojung.Huh@microchip.com>
To:     <f.fainelli@gmail.com>,
        <Prasanna.VengateshanVaradharajan@microchip.com>, <andrew@lunn.ch>,
        <olteanv@gmail.com>, <netdev@vger.kernel.org>, <robh+dt@kernel.org>
CC:     <kuba@kernel.org>, <vivien.didelot@gmail.com>,
        <davem@davemloft.net>, <UNGLinuxDriver@microchip.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: RE: [PATCH net-next 0/8] net: dsa: microchip: DSA driver support for
 LAN937x switch
Thread-Topic: [PATCH net-next 0/8] net: dsa: microchip: DSA driver support for
 LAN937x switch
Thread-Index: AQHW9UEGd2dhNFT17EuXebnl5Hbz6ao9UycAgAbE0ZA=
Date:   Tue, 2 Feb 2021 01:25:51 +0000
Message-ID: <BL0PR11MB3012BB376C0A995CA307C11BE7B59@BL0PR11MB3012.namprd11.prod.outlook.com>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
 <bb729a8b-0ea1-e05d-f410-ed049e793d04@gmail.com>
In-Reply-To: <bb729a8b-0ea1-e05d-f410-ed049e793d04@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [69.119.82.37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a179ea1-234c-4fb4-072a-08d8c7197aa1
x-ms-traffictypediagnostic: MN2PR11MB4495:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB44957902E352A06FF9F535A6E7B59@MN2PR11MB4495.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BhFr64uDsQuu8ki8w8fpOCacH26zf4UM40qG+Ujwx9hU0aVLVEwcyXMD8EO2nN2jbEDksBMrAhV+odXQCGnkSLMy18Gxwi4I0e8xHDFHDlojCcvaj3A9tLvyirDJusJHEY637QLkQaIchZAeP9tayKV9iKYcafJYGo102GFR2buIocxxcb1QbfTm8mfyxeR3csuCPcyuHQ8fp9EvbOdWTpJHHWgqzSj+RrngAnhx26lXjgPk0dr7Cqa9QV/S9YFcZMMYARZheoaO7iF7TZBe+weQhVieQ/olzxMBT8OjiX17ER9jTCDzxisOtv/9RJbd+MzM8HQEp19xVfNqEMGCSWDhzKH8tz+vRFy4gnPNArQj8OCCEr/Id+w55A1+Bi865NsCJ848XhpP1uPd3J63W0aV1hexQCScNAU0/m1zpAV8wLAH7PWr10Mo8XrvJT1EBmSpMpe/ttpcl0qnlMP6MLzwDTBBiJEuTwrcWUd1i98JmvLq4rqIakucVjL8BctvId66/1ROMyP2K72Y+w8iAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3012.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(136003)(366004)(346002)(396003)(5660300002)(86362001)(2906002)(8936002)(66556008)(186003)(52536014)(33656002)(64756008)(6506007)(4326008)(26005)(66946007)(66446008)(76116006)(110136005)(7416002)(66476007)(83380400001)(478600001)(55016002)(71200400001)(8676002)(54906003)(316002)(7696005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?YTJiWFA5ZThuNERROTFFMDZNVjJyemROc1VsWWlaRk8yeGJONnd1QXJheVB5?=
 =?utf-8?B?ZlNTa1E0K0g4TU5yOVNQQ0F4VDhjMWJjRlhXM1kvUlhhc2dXaXZBbG1Td3NK?=
 =?utf-8?B?clBaMXErOGNOYWlZUjVtYUZOWGEvMXQwcmxKc0c1WkUxUFp4NkFQQk1wV2Yv?=
 =?utf-8?B?ZFVLQ0czSndML0hsM216TlRNR09BQVk5ZTVFWXQ3aW5EYlVRVDdNSlJ6VW1q?=
 =?utf-8?B?RHdNVTg2bFYwYUtoNkpUdEhmMitpdW1ubDR0L1hLS2hVZFBQZkdlUEMzY0Rz?=
 =?utf-8?B?TTZJMVFhVDZWbUkreDJWSk54b2daem5hd0hZN1ZEVkl6R0YvZXJ0Mk5jb3dF?=
 =?utf-8?B?dnRsSlNBT1RUSlRnWGFrTEZCUDl3QzlvWU5RVllNbURTbUowc05NUHgzVFRY?=
 =?utf-8?B?V3V5MnJpam5paDh6MUs2MExXK2lKeFFVdGpnYXpaOXg4eFhuVlpGMVJUNjhG?=
 =?utf-8?B?TkRvNmRVMXFaK0VuOGNvSVBMcTByaERJcFpHeWNGWGRGSWFBc2ZQVmNiSmY2?=
 =?utf-8?B?M3drTzl5R1YrSG13N0tEbUpGdTR2anhLblNTNGZ4WDJWcDFLSkVBaHZhcUVT?=
 =?utf-8?B?NXprcVIra0JpUHVqL3pQbm1MbFRyeVlJamcwOVQ0QjdJcXFZbWxIVVhxY1du?=
 =?utf-8?B?dTZoU3RNTEtvVm53ZzdWbGREdFc4eUlEZVFEeEtZOGJNTFUvRkxrQUdEWVdF?=
 =?utf-8?B?WEpFT2xrcTdRSjZGWHJFa1FwNC9ZSEVWV1dUOHNxYmVGVlVpSXlZdW51d3I0?=
 =?utf-8?B?TkJGM2tHVll0SUdpZFBPRkswYU1uc0Nwczl0eUtpbDJIRWdWdGdFVWI5WEMy?=
 =?utf-8?B?VUYzejVpV1BiemhhNDkwaU80UFZXUWJVeE1sVElrQ1krK2xtRGRsM29NaDU0?=
 =?utf-8?B?M0pYZEszMExtMVY2TCtrOGI5UnVnSFNXd3VHYThJQ0hFRnk5M1gwRkhKSk1I?=
 =?utf-8?B?d0VGeFVkSUdqL1dVN1VlWmFRN1lBOE52dk5RTmM3eVZHMUZKMkcvZlNqU0VJ?=
 =?utf-8?B?cVhhVzVQVGVlOTJ4bFFBY0xaQ3RLbDMxYWNqNTNWOGt6bTBxNnBUNnEzcjRo?=
 =?utf-8?B?Nmh1YUNURy9ZVFhBMndBUzIzSkFqek44QW1sQ1R1d0MxUnM3dmZPZGpTT3lB?=
 =?utf-8?B?a2IzblBJaUtBenpneEdKWUFGbmMyRDcrdTkwY0svei96TklFTGxtS09UZDZi?=
 =?utf-8?B?THpSZUxmTnk0SWN0Q2F4K1F2T0w5M1pPdnljbis0d0V5Rm96YnJBNEJmVlJw?=
 =?utf-8?B?aWJPV3lNa2g2bjhOWGhSaGxndkUxSTVDM3Uzam82WWJXeXJwd3RCSzhVZkla?=
 =?utf-8?B?aDFpQWZocGxIMHRNcGJXYTZNS2w4bHZjcm41ci9sclAxUUZVQi9DS3FWa2Vl?=
 =?utf-8?B?dTl3YVVneWRzTDJhZVBOdC9YdG04UkZ5K3pzekRpMWgyeUp0elhjWXVUSkp6?=
 =?utf-8?Q?9VcD8PsN?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3012.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a179ea1-234c-4fb4-072a-08d8c7197aa1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 01:25:51.6759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rzfBKYiCyVy+KbA9LiMhDInRAM7MxAtNUTJ50Vw2x3qlHNCeiHFDQhlfEMT3z8ViAWs6I6Jmo6KnQWQxLP5VV6P3OrQgybc2f23I8tYi/P8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4495
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRmxvcmlhbiwNCg0KV2lzaCB5b3UgYSBoYXBweSBhbmQgc2FmZSBuZXcgeWVhci4NCg0KVGhh
bmtzIGZvciB5b3VyIHRpbWUgdG8gcmV2aWV3IG5ldyBwYXRjaGVzLg0KID4gSXQgaXMgZ3JlYXQg
dG8gc2VlIGEgbmV3IHN3aXRjaCBmcm9tIE1pY3JvY2hpcCBiZWluZyBzdWJtaXR0ZWQgZm9yDQo+
IHJldmlldy4gT25lIHRoaW5nIHRoYXQgaGFzIGJvdGhlcmVkIG1lIGFzIGEgRFNBIG1haW50YWlu
ZXIgYmVmb3JlIHRob3VnaA0KPiBpcyB0aGF0IHdlIGhhdmUgc2VlbiBNaWNyb2NoaXAgY29udHJp
YnV0ZSBuZXcgRFNBIGRyaXZlcnMgd2hpY2ggYXJlDQo+IGFsd2F5cyB3ZWxjb21lLCBob3dldmVy
IHRoZSBtYWludGVuYW5jZSBhbmQgYnVnIGZpeGluZyBvZiB0aGVzZSBkcml2ZXJzDQo+IHdhcyBz
cG90dHksIHRodXMgbGVhZGluZyB0byBleHRlcm5hbCBjb250cmlidXRvcnMgdG8gdGFrZSBvbiB0
aGUgdGFza3MNCj4gb2YgZml4aW5nIGJ1Z3MuIERvIHlvdSBoYXZlIGEgc3Ryb25nZXIgY29tbWl0
bWVudCBub3cgdG8gc3RheSBpbnZvbHZlZA0KPiB3aXRoIHJldmlld2luZy9maXhpbmcgYnVncyBh
ZmZlY3RpbmcgTWljcm9jaGlwIERTQSBkcml2ZXJzIGFuZCB0byBhDQo+IGxhcmdlciBleHRlbnQg
dGhlIGZyYW1ld29yayBpdHNlbGY/DQpBZG1pdCB0aGF0IE1pY3JvY2hpcCdzIGFjdGl2aXRpZXMg
b24gY29tbXVuaXR5LCBlc3BlY2lhbGx5IG9uIERTQSBkcml2ZXJzLCANCndhcyBub3QgYWN0aXZl
IGZvciBhIHdoaWxlLiAgV2UgYXJlIGdvaW5nIHRvIGRvIG91ciBiZXN0IHRvIGdldCBpbnZvbHZl
ZCBtb3JlDQpvbiBjb21tdW5pdHkgaW5jbHVkaW5nIHJldmlld2luZyBhbmQgZnJhbWV3b3Jrcy4g
WW91IG1pZ2h0IGFscmVhZHkgc3RhcnQNCnNlZWluZyByZXZpZXcgYW5kIGNvbW1lbnRzIG9uIGNv
bW11bml0eSBmcm9tIE1pY3JvY2hpcCByZWNlbnRseS4NCiANCj4gQ291bGQgeW91IGFsc28gZmVl
ZCBiYWNrIHRvIHlvdXIgaGFyZHdhcmUgb3JnYW5pemF0aW9uIHRvIHNldHRsZSBvbiBhDQo+IHRh
ZyBmb3JtYXQgdGhhdCBpcyBub3QgYSBzbm93Zmxha2U/IEFsbW9zdCAqZXZlcnkqIHN3aXRjaCB5
b3UgaGF2ZSBoYXMgYQ0KPiBkaWZmZXJlbnQgdGFnZ2luZyBmb3JtYXQsIHRoaXMgaXMgYWJzdXJk
LiBBbGwgb3RoZXIgdmVuZG9ycyBpbiB0cmVlIGhhdmUNCj4gYmVlbiBhYmxlIHRvIHNldHRsZSBv
biBhdCBtb3N0IDIgb3IgMyBkaWZmZXJlbnQgdGFnZ2luZyBmb3JtYXRzIG92ZXINCj4gdGhlaXIg
c3dpdGNoaW5nIHByb2R1Y3QgbGlmZSBzcGFuIChmb3Igc29tZSB2ZW5kb3JzIHRoaXMgZGF0ZXMg
YmFjayAyMA0KPiB5ZWFycyBhZ28pLg0KVW5kZXJzdGFuZCB0aGlzIHBvaW50IHRvby4gQWN0dWFs
bHksIHRob3NlIHByb2R1Y3RzIGFyZSBkZXZlbG9wZWQgb3ZlciB0aW1lLg0KU29tZXRpbWUgaXQg
aXMgbm90IGF2b2lkYWJsZSB0byBhZGQgbmV3IHN0dWZmLg0KQnV0LCBZZXMsIGl0IHdvdWxkIGJl
IGJldHRlciB0byBkZXNpZ24gYWhlYWQgd2l0aCByZXNlcnZlZCBmaWVsZHMuDQoNClRoYW5rcyBh
Z2FpbiBvbiB5b3VyIHJldmlld3MgYW5kIGNvbW1lbnRzLCB3aWxsIGdlYXIgdXAgb24gRFNBIHdv
cmtzLg0KDQpCZXN0IFJlZ2FyZHMsDQpXb29qdW5nDQo=
