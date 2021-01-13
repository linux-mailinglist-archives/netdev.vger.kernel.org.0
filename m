Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471932F41DA
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 03:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbhAMCg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 21:36:26 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:29481 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbhAMCgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 21:36:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610505384; x=1642041384;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qI+1oODAeKenPYUwMmz8slBfxpHJ8i98gNrAC5jiL7M=;
  b=M3m1uf+kHgbNDGNIrkwrVXjBzlu40kG854tpMM36hbXvRZsTupIiJfEP
   q6EZqQf55ffcpgAxvi2aTFRYlmKovQo9Njz2O91bBY4UAtd3ZRH0ocyhq
   BX/rlc3KXCbmskR2za06MzlmAEQ7Aqi7lxjuYRbne/tRcAiZ4BOQP+RNI
   i2kaYWiDhhZ9rpz3rSuXy8Sssym1MlVp8sNZQNekcGYXpmcGzVbMol/FG
   yZAcYEOibWaFmZsxdLNDthAQhCk2PBSesM0QvdtlOU2zzqp0NhmfuXFTH
   ZlzeYBJvzqGlxoJZDy8zx0MvcmYiYik9N17oqOUU40nYHX9SpS3XTv04H
   g==;
IronPort-SDR: R+OYjExcKX/jDYBebJAMV6piOudr0sHMHgrjAnoGllZ+oeivbESbnVVXm7SnPr5DKI6kY4MU1u
 afq5BL/455N8sxvquudTmHynuDwgP2ynIoTXF59ynT26m3s8ZPbwYRKw7dzyU0WfOHVp+SBZZo
 Yfpw0q5z1vQA87fvrQth2Xpkbg8/BGi92CCkvyXfA0s1b6cynYhCuJBSq14+TCRWScENWgYxFm
 oQ4eR8rNeAHM6XGqPxhSmaM8iyeGmDV2IRi25zF4Z77OdUJTDDdbQ7FqQpGV1DploIeVT8chon
 WSU=
X-IronPort-AV: E=Sophos;i="5.79,343,1602518400"; 
   d="scan'208";a="157290251"
Received: from mail-bn8nam11lp2173.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.173])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jan 2021 10:35:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZygFT5KTV7lgoMLDCexH3KhNy5fcZFM5oRZeDe6wkA6ClZf2Wtjq9H/FcW7BJMDEcwDmChcSgGQoSzqnGbfh1A7poi3Xv+VU2snFhKjWFvL6EZ+l8VG2ypxvKrK1vIxmRDPakeMlhH7cXn3Mzl0edVyuwKq0Z+gsl2bDtENaToFTRh0diQC6XCIZ9e5kuUakv+WLq0JtkfOcvB729Klrq/HkF9jKx6ArCtERrYEt/nrmh5XJdJR+g/6Nlgr44pdZ/Rx7svQIZAJVUBD2h1jwd/Co79ff7ZO0qdQBF1aH2p3EVJnll3j3q7tJubWdNPNwbvoVQ3nvNBGAWc3Dh+MZnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qI+1oODAeKenPYUwMmz8slBfxpHJ8i98gNrAC5jiL7M=;
 b=iG/UNe0xDbzaGp67LAJzfTicvyY/gvK8AWMY2GZJ8tJ2TvNZuzkl4kagO5u6IGgn2ZhJfVj4jxgE7BZ4TSIUdW+MgjVzBcn4v0Q8nvl16leaiL5/DOItq/K1ktf8C0TOyQec30u+al1eSRVt84V8lEa0sXYD7GF6QMGjK4rLr1c4i2cFKMFQ5HD2Ftb9MqJmHVF9HAf7nnt8Eb+ecDTR5SuB/DLQXBzh0h0aWrfPOqwOuGHoEuZldOgEwbcZt7/uIECwYxKhQlyQtFxTudajA3BV9yEc2OW4yDShtu+5fYQzSHXHZRcMK2LuBoZxZCabnHVOsG2pIBqGKvXpZvv+dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qI+1oODAeKenPYUwMmz8slBfxpHJ8i98gNrAC5jiL7M=;
 b=sx8nPXgRkB5sXFRcSmLROKxzujQmBZkTc6doqEXVwcGo6Tx7DzIbQ4vFHIN5GWad8l2ZN5MxKegoEpgqwPofXXZ97gm5dIBp8yHIAVY+HJAzsGM1kqZafR6SnNDYI1Cvj9+nRoPwIpyN5gmxsljEEQnf1itLdgHGelgko9CtESY=
Received: from BY5PR04MB6724.namprd04.prod.outlook.com (2603:10b6:a03:219::15)
 by BY5PR04MB6311.namprd04.prod.outlook.com (2603:10b6:a03:1f2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 13 Jan
 2021 02:35:16 +0000
Received: from BY5PR04MB6724.namprd04.prod.outlook.com
 ([fe80::ec3e:7abd:37a1:eb8b]) by BY5PR04MB6724.namprd04.prod.outlook.com
 ([fe80::ec3e:7abd:37a1:eb8b%8]) with mapi id 15.20.3763.009; Wed, 13 Jan 2021
 02:35:16 +0000
From:   Atish Patra <Atish.Patra@wdc.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net v2] net: macb: Add default usrio config to default gem
 config
Thread-Topic: [PATCH net v2] net: macb: Add default usrio config to default
 gem config
Thread-Index: AQHW6ITmmSVXcwgPHEW5ofpL1bz14Kok0b4AgAAGrAA=
Date:   Wed, 13 Jan 2021 02:35:16 +0000
Message-ID: <c7fb5e664bd4ef0751390deeb0cfec18093c2f6b.camel@wdc.com>
References: <20210112014728.3788473-1-atish.patra@wdc.com>
         <20210112181124.11af8020@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210112181124.11af8020@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [99.13.229.45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0eb698b2-f1fa-49da-117e-08d8b76bdce4
x-ms-traffictypediagnostic: BY5PR04MB6311:
x-microsoft-antispam-prvs: <BY5PR04MB6311F689FC81FC4B58EB0E2CFAA90@BY5PR04MB6311.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:181;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FA34bJGXlBc58/oPsY7PE7LofIakOCFMrhH5BHBkZQTJyCTnWg9NpCEQVD7PUb4m4jtZWsa3VX/+X3oqzq1ZrMiHe4sI4ff7SoNyMMexkVcMx3WiLOuV3U5zCKqGsWmLA9CMbWQF5VwPCIfd4OSFeVuia0RP71gcOYDmEgPgbjahJrLjShGun9GHiIXVT1YWf6+tYYWgp6z3IWcuUSQjG5cQ6PIHslfdD2xrM4Wb2rLEcagP9NePLKO7XSFpCrEzMyUnWO15o+iTJJkciYBoDw8lzx5rkBWG2C+lepCcMMRg5K38kIXTfTbbh4hMKNvzLugSAaKQV9xj/vy4X/RnJH0TjVdHd9y4SLhLIDoH+bDdUETQQGSm/RvhMZman0720KTL5kWhKpBzC3T7tYN5bw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6724.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(6512007)(478600001)(54906003)(86362001)(316002)(4326008)(6486002)(186003)(66476007)(66946007)(2906002)(64756008)(8936002)(2616005)(66556008)(8676002)(66446008)(6506007)(6916009)(36756003)(76116006)(5660300002)(71200400001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ckVEazlUZWY2aG03anFFbUEzSlpDMGE2UFhLbXlhcnBqRlB0L0w4V2xHVXl6?=
 =?utf-8?B?MG5mdUFOWTg3bmpHcU50eEFTN2k1RUpmbW9GZis1TlozZExtelI1ZUhIcC9E?=
 =?utf-8?B?cjJjRGZvVGplRmZ2TVZtcTJ0bjdKdmpuaWJkc2x5Z05SaEQrRTFXTE9haW1a?=
 =?utf-8?B?YWtPK0ZvSWM1dmd3V2ZYaHFvMS8rZkoxTGRweXoxMG1ScmtvdVN5Wi9KbGdz?=
 =?utf-8?B?MUdQWjhKVTl3QUJ6WVJtYkhxTUN1VHNCYlpJT0pPaFQwS3pDdVptak9SYk84?=
 =?utf-8?B?UkcvZHlPd3BVaEZzSVVhNElQcTYwWTBNUEg4cWpGSDJydUttTU1IalhnRW5V?=
 =?utf-8?B?V0toZlJna1g1VUVQcHFlQnlPV2ZrMmtKZ0k4V1dqSEcraVE5QzFLaW9QVjdo?=
 =?utf-8?B?L3A1c1RuTFRrN0dzN1BjYlVibmtERmthQk9IOXR1c2k2aVJIb01lWno3bk5K?=
 =?utf-8?B?MXhUMS84SGxodys5VmlDYkl2U2hBWnpSb29oaXpUak9Hbkk4eGxYUlVFd0Na?=
 =?utf-8?B?VGhZSGgzZnlGMUEyeVk3cWZRK3VaSnI0VEJoR0g1SVlhbUhkcmVyV1FJZXNI?=
 =?utf-8?B?NWtqcmV2OVZ6c0FmcGY3YVlBd3BFRWxLVXNWVU9IKzZseFZvTjZMQ2VPbWxM?=
 =?utf-8?B?VnVsaEFudFhCczVGQzdtSGViODVLbUYrbThTWHQwTkdESUlQVDFCbUIwd0Ew?=
 =?utf-8?B?VWNGRjl0MTU5b21ySVJLVkV6SzlUaW0vMTVvSWtzN2ppV0NYd0pxNVFQbWFZ?=
 =?utf-8?B?OGdKKzlBZXVLcjlIMHlSYUtwTTRkMytRU0w5SStsQ1RZbkZWK2xqclpaSUNn?=
 =?utf-8?B?QU1JRVllWnQzNHBFdXQ5Tzl3YkQ3dGZyRk5acHNZYnBRQ3BzSW9qQmx6MG1R?=
 =?utf-8?B?MTNlbHBZR3hmMXNSaDhobG12U2U3UmVjYlF2L2JtMlV0OHNubWowRW9KVDVo?=
 =?utf-8?B?VFMrcXFQdFI2emJHUFZLTXJPbG5XcW5wSHo2Q0t1TlBkbzJIZzQwWFovaEhY?=
 =?utf-8?B?QUZXTEd6SllRcWNTb1NVejlXMUFVd0RUcUJlNnB4RkxBcVR0U3NuK3ZZKzNy?=
 =?utf-8?B?a0JvQjhsbVVRRTdQUVVWYlR3MmNuU01hMkZJVnI5K3dRYk1DN3Vhbkx1MDE5?=
 =?utf-8?B?TlZ5NWtjQU93OHVnY2RpUW4xbW16VXlnd3UydnpPOFprMlFuU3EySHh4WXNv?=
 =?utf-8?B?RVFTZFc4VStUVXNzVXNjVWhtV0MxeWNVSGNPanV4eHpmdUkyQVBld3RNNkdQ?=
 =?utf-8?B?T3RxUWZpYldNT2pEdVN1bmI4NnFBcmYzdnFuZnpTcXJ4TDQ0WmFmckN3eU1O?=
 =?utf-8?Q?33p0/PGaS5eC6iTRy7s8ZAEJnF3ItgbyXL?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <2FB7F55DFE88654EA27AB77C3294619F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6724.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eb698b2-f1fa-49da-117e-08d8b76bdce4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2021 02:35:16.7615
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fTaQKVe1NBB5M59QRkmsNSeYzyPYaxxAjWRY1JRSQBY5u9yn07F4pROAK3QZfiVR8dh5Rar+BunBwzgACZwDIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6311
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTAxLTEyIGF0IDE4OjExIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gTW9uLCAxMSBKYW4gMjAyMSAxNzo0NzoyOCAtMDgwMCBBdGlzaCBQYXRyYSB3cm90ZToN
Cj4gPiBUaGVyZSBpcyBubyB1c3JpbyBjb25maWcgZGVmaW5lZCBmb3IgZGVmYXVsdCBnZW0gY29u
ZmlnIGxlYWRpbmcgdG8NCj4gPiBhIGtlcm5lbCBwYW5pYyBkZXZpY2VzIHRoYXQgZG9uJ3QgZGVm
aW5lIGEgZGF0YS4gVGhpcyBpc3N1ZSBjYW4gYmUNCj4gPiByZXByZG91Y2VkIHdpdGggbWljcm9j
aGlwIHBvbGFyIGZpcmUgc29jIHdoZXJlIGNvbXBhdGlibGUgc3RyaW5nDQo+ID4gaXMgZGVmaW5l
ZCBhcyAiY2RucyxtYWNiIi4NCj4gPiANCj4gPiBGaXhlczogZWRhYzYzODYxZGI3ICgibmV0OiBt
YWNiOiBBZGQgZGVmYXVsdCB1c3JpbyBjb25maWcgdG8NCj4gPiBkZWZhdWx0IGdlbSBjb25maWci
KQ0KPiA+IFNpZ25lZC1vZmYtYnk6IEF0aXNoIFBhdHJhIDxhdGlzaC5wYXRyYUB3ZGMuY29tPg0K
PiA+IC0tLQ0KPiA+IENoYW5nZXMgZnJvbSB2MS0+djI6DQo+ID4gMS4gRml4ZWQgdGhhdCBmaXhl
cyB0YWcuDQo+IA0KPiBTdGlsbCBuZWVkcyBhIGxpdHRsZSBiaXQgb2Ygd29yazoNCj4gDQo+IEZp
eGVzIHRhZzogRml4ZXM6IGVkYWM2Mzg2MWRiNyAoIm5ldDogbWFjYjogQWRkIGRlZmF1bHQgdXNy
aW8gY29uZmlnDQo+IHRvIGRlZmF1bHQgZ2VtIGNvbmZpZyIpDQoNCkkgYW0gc28gc29ycnkgYWJv
dXQgdGhpcy4gSSBtYW5hZ2VkIHNjcmV3IHVwIG15IHNjcmlwdCB0byBhZGQgRml4ZXMgdGFnDQp0
d2ljZSBpbiBhIHJvdyA6KC4NCg0KPiBIYXMgdGhlc2UgcHJvYmxlbShzKToNCj4gwqDCoMKgwqDC
oMKgwqDCoC0gU3ViamVjdCBkb2VzIG5vdCBtYXRjaCB0YXJnZXQgY29tbWl0IHN1YmplY3QNCj4g
wqDCoMKgwqDCoMKgwqDCoMKgIEp1c3QgdXNlDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgZ2l0IGxvZyAtMSAtLWZvcm1hdD0nRml4ZXM6ICVoICgiJXMiKScNCj4gDQo+IA0KPiBQ
bGVhc2UgbWFrZSBzdXJlIHRvIGtlZXAgTmljJ3MgQWNrIHdoZW4gcmVwb3N0aW5nLg0KDQpBYnNv
bHV0ZWx5LiBBcG9sb2dpZXMgYWdhaW4gZm9yIHRoZSBub2lzZSBmb3IgdGhpcyBzbWFsbCBmaXgu
DQoNCi0tIA0KUmVnYXJkcywNCkF0aXNoDQo=
