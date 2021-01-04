Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD78B2E96BE
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 15:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbhADOFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 09:05:52 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:1267 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbhADOFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 09:05:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1609769150; x=1641305150;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0zDGDP4zbRTEiuIH58w1HF3BEzPA/FKEOaOW5bGDSiM=;
  b=tFF/T+PZ9yfFEAnW9guwIZj41LcHLXtKJ4cb+aJM8rnBk+N/ZN1k/r5t
   cXnel+QrawzBp8Hp9CpDaoXqNgBnd0/A5ayTwObiSL2bi9YIiBq9An35p
   Cqe9dL1vWFOHb36aMSw8xgRST2H8WRa2NL12j1eJWACBZfaWbymvjAxui
   loVIJJvXQpevB2WVyogpia8c+Tsm/b91d+fGqnivwRtb+gQJzkI7v33om
   3drrxzDKS4iFfoSjq8AdqlC4t/J69m0zOWT76VwCz3YbM+ZLZq1c7CwQO
   xo0vL1A0oaB7/us94l5Rk4raHtQC6+Zp4WIPeLacjr70W/v+XcVZdA56U
   w==;
IronPort-SDR: /uXrcH3DdH30XPPk5FYE8CG36syy3qctEHcjznviMXnzILP8RsiF9jvKkWngDC2+W78SQNwVZw
 bLcGaZcQJKTVTVjpZJuGckh8F2MS/+mFR3d4/W4cAi+ZQqmJo6RLL6WZE0YkfV8epwf/8SFBu4
 gpfmKBHPz0jKGykd6uw3y3qr4Rix4DHwZ/WlSxmzEHzKq+eUMTMfc71ysv3/u1jbROkv9JvfEM
 YjS/3g04hQLGiRfQrqfdE444HtYTVHI5YJDVMClpoHwGKiPm2zBDqQDaCevOCN79yvMXNFYei3
 2/M=
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="39247610"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2021 07:04:34 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 4 Jan 2021 07:04:08 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 4 Jan 2021 07:04:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UyWo4DUjyvoi6OuAz7fa5SDPAliD7Y4y29CXjenIvz3sL6aCwxbEc+C/pIBHhzID5qJcuhFoiFfL0aNmtBsQTh7/T/rxxH/oJHFRWfW4fxGpiG3XTqrHSCB2k87msw1cl6ja8glpSwtEUkbsXwMuXnSXLe6NMrliW4OWY20SGXh/CGDsqUw4DQrYsDu0gzFnM54U8XwQYh+uUJps1LxgAjT9tMGTo3xXsI9jdtL/yKQaZn2J4ACVbG86ZAuocC3MPs3GhypMU/f4ZrodDoeBQTjbfSw2nL/ZvnMYt/qzPwclpt8xt/CrXksmt6iR4RA9fc/5DKYUqAgVPwXy6HB9zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0zDGDP4zbRTEiuIH58w1HF3BEzPA/FKEOaOW5bGDSiM=;
 b=kITlNHrFdL2YnlErlUlmsmak4IeXV+wa6xCsLzsVytuBq2H8GqoktPGLFwDPgCVaLZufGiy2ntLrqNgeeZzO6w5vpASbJNnXeXfBTt/O3znE3vYMM3gBPQtjYHUJIe0MWy+PtnLJ2+Y+SOs9pxqCSAxZ2fQbt8B0Uzb+pmUAzWp0FwJpC+knAc8OYV9K4IJzt2YlqB9SLbrQbe8TP68M+44kyY+rZrcHtUxZ8qIqZBn2Hh4y2JxEH00bMn+dnkgIHZ5C2rsMzWgSkUGQT0ygYmo3PlovhXkoLns3kW3sq2xijfk6CF/zfdcPUrfUNJnnyK7+EE4Yld79Gx+ferzvsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0zDGDP4zbRTEiuIH58w1HF3BEzPA/FKEOaOW5bGDSiM=;
 b=gFpsoIVb0ns5kOBMkCP5cXB5C8EEMZ69djm6nDRBFvTkYDPYgXI1qZc8zGiL02wkdtDwQHJrYfPA/AaoZN+41lnmWq6gb3h9shtpoBH1gM4mvp/HTYOxMGOWKIJ3tW0dASYhw9AGEkS2uoF4MIH5L9N/OcoKbpGhM/bpK5WyIZQ=
Received: from DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) by
 DM6PR11MB4625.namprd11.prod.outlook.com (2603:10b6:5:2a8::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3721.22; Mon, 4 Jan 2021 14:04:06 +0000
Received: from DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::b96e:6776:6971:80f4]) by DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::b96e:6776:6971:80f4%6]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 14:04:06 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <ckeepax@opensource.cirrus.com>, <Nicolas.Ferre@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v3] net: macb: Correct usage of MACB_CAPS_CLK_HW_CHG
 flag
Thread-Topic: [PATCH net v3] net: macb: Correct usage of MACB_CAPS_CLK_HW_CHG
 flag
Thread-Index: AQHW4qJ2dQunWG8NzkyqQ0iH/1Pcbw==
Date:   Mon, 4 Jan 2021 14:04:06 +0000
Message-ID: <8f36997b-2310-0579-173d-17f532a54d8d@microchip.com>
References: <20210104103802.13091-1-ckeepax@opensource.cirrus.com>
In-Reply-To: <20210104103802.13091-1-ckeepax@opensource.cirrus.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: opensource.cirrus.com; dkim=none (message not signed)
 header.d=none;opensource.cirrus.com; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [82.76.227.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aec348bd-622f-4474-abdb-08d8b0b999a6
x-ms-traffictypediagnostic: DM6PR11MB4625:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB46256E73FDC41D667ED551C987D20@DM6PR11MB4625.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3OfnRi3/pGAIR5i1fHq+84MPtiKehsvpofgotttjzeMhuBr6cVKfmjE0ycAreuOjJflRz4v2Wb8FH4kA+uL9bUc/Lpet53lHCxj/AoVrzp6IukfQO4cBDQEno0m8LV10nXFJ9GJHmMMvyW7R6NLzpOt09PXTNVHBKA6DiA1ucf3FRkFnCDGyBx9GaNFHaoOO4sKEpdilajGSz6TzPnd9hBZ6CHyzRYvtHYUV7J6iJcymWqF3z44uPTTUO1YnCMn1kl9J38rsKEQ6bfRQXvpCQ2BtMy4eN8Z/GLZyeiM0pMBUSGi7hc7sE349WuLyj0+eVKrotmVPoKZ6RufybSCnSwm0n7AArwDaFU4IXCUdJ4HdBiPMyBwhMhGiu6Yskt8STfzNxUvoys2Yv8ZvnpJ8cXTCvik0WRWBxqZE9GiF+NKBov23O0Io11zmjN1mwNcjzPJog109CqIuzk1CKqOo93m590taoyn+Zub4+sSn1UU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(376002)(396003)(366004)(2616005)(31686004)(36756003)(66946007)(76116006)(86362001)(6512007)(66446008)(110136005)(54906003)(66476007)(91956017)(64756008)(66556008)(6506007)(8936002)(478600001)(8676002)(53546011)(26005)(6486002)(4326008)(71200400001)(83380400001)(31696002)(186003)(5660300002)(316002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?U2l5SDNGNis2Yk5kdmhaSU1VbEhvd05Jc3dKbGpuMlZETEJWM3hoK05XMXRX?=
 =?utf-8?B?MTMwb3pIdzNjWmVnaDBRMDljb2NZd0pjQ1N5dllwVVZyUWVUQW1DaGtHM1ZJ?=
 =?utf-8?B?eThQWmVGYjh4UG5zYjU1SmpaY3NscVFUdFdIVW0wSHE2N3N0NWIxenhrS1N2?=
 =?utf-8?B?SzlyZmxHNU5KOXJETllxR0RDYU96T1FBTkpQSlAzLzRSVXlZZFI4UW9xWng4?=
 =?utf-8?B?Z1REMTF5UHBnWWh2UTllTXNIOWtxQzVnTldicmRDS0F4RmZVZ3ZEcytyNk5B?=
 =?utf-8?B?Z0VuSjBydERac2d5Y3ltRDhwTWhpbU5ldHlCTi9SS3F0VWd0NzRrYUxtbzc3?=
 =?utf-8?B?Vm5lYVZWQk5HMURZeWhwQjgvdUlxTjJWUXdMak9BdERISmtzNVc4cTNIUEpJ?=
 =?utf-8?B?NFpzd2lBdTJIZXFJcHRjczFFbGU1ZldHSmFYemwzUGwyWDNDNWxGZWZPZDVU?=
 =?utf-8?B?YmVGR1FiZ05qYjdQS2pEOCs5TlVmTktnMkdubjA2WUhveWxPWmNpSUVYUVlJ?=
 =?utf-8?B?YnlPenp2N29UTHBzZEtYSktlRzRPQzl5K2NpRG5DZDNlYytMVVk0amRjMzIr?=
 =?utf-8?B?ZkJLQ0R0NEpvSjk0MlJPTGxLUmNUZTRFQWZkQW14M0RvcS85d0pqNW13QVlE?=
 =?utf-8?B?d21oRDk2cHZvQ1Jqc0ZnNlFNY3ZMd1MwWGpVdjdUY1dHQ2hxeld5ODNVWGVR?=
 =?utf-8?B?cVl5TVFMNFl3V3gyY3plTzFYRTQrMytTZ0pkUHJMcmtidklyTFZNRDRtbmxz?=
 =?utf-8?B?aWFGWTd2TUJuUEhRdGFRQktRdXQzclNTcEIzNWljaEZjWFQrbGdGczA0YnVo?=
 =?utf-8?B?SHhhWkR6dzNmcTVPKzhpY1R5ZE5JVWtBRjFiR1Y5bEQyUmNjVzIyMjhBcndk?=
 =?utf-8?B?WnIzY0xnN09UT0M5bm5OVjJ4MUVza3hSNXBCcnB2UFFUbDdWdW1DZEpXamoy?=
 =?utf-8?B?SVRPY1NVZmhZV3JLQjY2MW9lb0ZtRno0dnU4Y21qTEFaaGVmcDBHM3FlYWxk?=
 =?utf-8?B?SUxlNnI1VUJtcnA1K2d1cmRHMUlxVThxY0l0MGhMdjRuVUhzSmllai91eTdq?=
 =?utf-8?B?ZForMjBSS0w2RGxzWDh2OTkwMlRabXRwRjBVamNvMEFCRFlIS3lrcFpCYTdV?=
 =?utf-8?B?V0ljSkdwN0gyREtjVlo4MVVOL2V1dDNQVnAyMFd2S1VVVTFURlA3aVQ4bHhV?=
 =?utf-8?B?cXY3ZDNJWEh3S3NreFlwTlJUVHAxM1VSV1JnQTBGYWJoV2l5MXgwaE43MlNJ?=
 =?utf-8?B?KzBxaHZScjlSeUhXMHdoeWFqOXRKczRJY3FpUFIzWGtpWVB5cFIvS3hVQ1VF?=
 =?utf-8?Q?WGDsPFFFa13HbGwSQNY/mZbrY72nenoo/O?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A759C6B04D18574CADAFE6F5A917F62C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aec348bd-622f-4474-abdb-08d8b0b999a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2021 14:04:06.4591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hTxSLSHGaZdJSeZlN+Da4Hqnoh1WaOHsJ/XYF4oyQxGv9BNiS6OG6hXHZPBEsalSgcvGrmq48M4Qxg/V0TZbk+abjem3kJBkXMvp1JNmEAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4625
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQ2hhcmxlcywNCg0KT24gMDQuMDEuMjAyMSAxMjozOCwgQ2hhcmxlcyBLZWVwYXggd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gQSBuZXcgZmxhZyBN
QUNCX0NBUFNfQ0xLX0hXX0NIRyB3YXMgYWRkZWQgYW5kIGFsbCBjYWxsZXJzIG9mDQo+IG1hY2Jf
c2V0X3R4X2NsayB3ZXJlIGdhdGVkIG9uIHRoZSBwcmVzZW5jZSBvZiB0aGlzIGZsYWcuDQo+IA0K
PiAtICAgaWYgKCFjbGspDQo+ICsgaWYgKCFicC0+dHhfY2xrIHx8ICEoYnAtPmNhcHMgJiBNQUNC
X0NBUFNfQ0xLX0hXX0NIRykpDQo+IA0KPiBIb3dldmVyIHRoZSBmbGFnIHdhcyBub3QgYWRkZWQg
dG8gYW55dGhpbmcgb3RoZXIgdGhhbiB0aGUgbmV3DQo+IHNhbWE3ZzVfZ2VtLCB0dXJuaW5nIHRo
YXQgZnVuY3Rpb24gY2FsbCBpbnRvIGEgbm8gb3AgZm9yIGFsbCBvdGhlcg0KPiBzeXN0ZW1zLiBU
aGlzIGJyZWFrcyB0aGUgbmV0d29ya2luZyBvbiBaeW5xLg0KPiANCj4gVGhlIGNvbW1pdCBtZXNz
YWdlIGFkZGluZyB0aGlzIHN0YXRlczogYSBuZXcgY2FwYWJpbGl0eSBzbyB0aGF0DQo+IG1hY2Jf
c2V0X3R4X2Nsb2NrKCkgdG8gbm90IGJlIGNhbGxlZCBmb3IgSVBzIGhhdmluZyB0aGlzDQo+IGNh
cGFiaWxpdHkNCj4gDQo+IFRoaXMgc3Ryb25nbHkgaW1wbGllcyB0aGF0IHByZXNlbnQgb2YgdGhl
IGZsYWcgd2FzIGludGVuZGVkIHRvIHNraXANCj4gdGhlIGZ1bmN0aW9uIG5vdCBhYnNlbmNlIG9m
IHRoZSBmbGFnLiBVcGRhdGUgdGhlIGlmIHN0YXRlbWVudCB0bw0KPiB0aGlzIGVmZmVjdCwgd2hp
Y2ggcmVwYWlycyB0aGUgZXhpc3RpbmcgdXNlcnMuDQoNClllcywgdGhlIHByZXNlbmNlIG9mIHRo
ZSBmbGFnIHNob3VsZCBpbnZvbHZlIHNraXBwaW5nIHRoZSBjYWxsaW5nIG9mDQpjbGtfc2V0X3Jh
dGUoKSBzaW5jZSB0aGUgSVAgbG9naWMgd291bGQgdGFrZSBjYXJlIG9mIHByb3BlciBjbG9jayBk
aXZpc2lvbg0KZGVwZW5kaW5nIG9uIHRoZSBsaW5rIHNwZWVkLiBJIHdyb25nbHkgY2hlcnJ5IHBp
Y2sgdGhpcyBvbmUgZnJvbSBpbnRlcm5hbA0KYnJhbmNoZXMuIFNvcnJ5IGZvciB0aGlzIGJyZWFr
YWdlLg0KDQo+IA0KPiBGaXhlczogZGFhZmExZDMzY2M5ICgibmV0OiBtYWNiOiBhZGQgY2FwYWJp
bGl0eSB0byBub3Qgc2V0IHRoZSBjbG9jayByYXRlIikNCj4gU3VnZ2VzdGVkLWJ5OiBBbmRyZXcg
THVubiA8YW5kcmV3QGx1bm4uY2g+DQo+IFNpZ25lZC1vZmYtYnk6IENoYXJsZXMgS2VlcGF4IDxj
a2VlcGF4QG9wZW5zb3VyY2UuY2lycnVzLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IENsYXVkaXUgQmV6
bmVhIDxjbGF1ZGl1LmJlem5lYUBtaWNyb2NoaXAuY29tPg0KDQo+IC0tLQ0KPiANCj4gQ2hhbmdl
cyBzaW5jZSB2MToNCj4gIC0gVXBkYXRlZCBmbGFnIHNlbWFudGljcyB0byBza2lwIGZ1bmN0aW9u
LCBhcyBhcHBlYXJzIHRvIGhhdmUgYmVlbg0KPiAgICBpbnRlbmRlZCBieSB0aGUgaW5pdGlhbCBj
b21taXQuDQo+IA0KPiBDaGFuZ2VzIHNpbmNlIHYyOg0KPiAgLSBBZGRpbmcgIm5ldCIgdG8gdGhl
IHN1YmplY3QgbGluZQ0KPiANCj4gVGhhbmtzLA0KPiBDaGFybGVzDQo+IA0KPiAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+IGluZGV4IGQ1ZDkxMDkxNmMyZTguLjgxNGE1YjEwMTQx
ZDEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWlu
LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiBA
QCAtNDY3LDcgKzQ2Nyw3IEBAIHN0YXRpYyB2b2lkIG1hY2Jfc2V0X3R4X2NsayhzdHJ1Y3QgbWFj
YiAqYnAsIGludCBzcGVlZCkNCj4gIHsNCj4gICAgICAgICBsb25nIGZlcnIsIHJhdGUsIHJhdGVf
cm91bmRlZDsNCj4gDQo+IC0gICAgICAgaWYgKCFicC0+dHhfY2xrIHx8ICEoYnAtPmNhcHMgJiBN
QUNCX0NBUFNfQ0xLX0hXX0NIRykpDQo+ICsgICAgICAgaWYgKCFicC0+dHhfY2xrIHx8IChicC0+
Y2FwcyAmIE1BQ0JfQ0FQU19DTEtfSFdfQ0hHKSkNCj4gICAgICAgICAgICAgICAgIHJldHVybjsN
Cj4gDQo+ICAgICAgICAgc3dpdGNoIChzcGVlZCkgew0KPiAtLQ0KPiAyLjExLjANCj4g
