Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B272D64B7
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 19:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404148AbgLJSSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 13:18:16 -0500
Received: from mail-eopbgr60042.outbound.protection.outlook.com ([40.107.6.42]:45429
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403837AbgLJSSM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 13:18:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQMzW8acptK92vQ799oI8zHlSZyZWO1W2RM26rUk0FfCfPJr2nYSCN8V7bEAP3qCcR+ZM6Btl4MrVgmqtHPhhf7U1wbZbGlsqXPUjZeVr8DH1+WvkgExDQN9WC0m5conE5n90WpCGNkGOxOvoqauNUPNA6J2F6GoxTu5iSstNOlXydw1mKabQarrRwS0uo4bkTqLdOcUZCm7S0L3B+zBl8XE77BCYk/wVDvSnrFgB4TzCroTQKeS7fnnsQiKI0cQ/sC9uCCxonSEXOBgR9J7+cC8Sl8lFck60XWwpOKNSzMhSIC42QpLs9VoYh5xNniPA6KfflgzpmHLVpP8m2OcNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCxCdGZnHQYZ1osj0jBr1b8U8pP4ENDfyjrf6dXZjwc=;
 b=O/Ko0iwcVub9X+L5W9H3Nkcp+jFQ4FoSc36cB1g7GIdE3o9xP0qBFPdhjkA74qXpx/2C9lLEg68t389NHh1wW+RdD0kQO8Z4I2XI8LDWAVlCRb97uQfFVpXpqAbm74mpW+jaBh9PqHBFdpUCImUMxSeXpTHTDwiFKDm1E4ERuK68sI+6pJBV/47br2yTNWm6k/zRj6/CDwvg+Ydhl3TH/u4LGWQQEIFIzAB4tgMSZZyLWFTFP20AeWg4zyDwFHg5jx9kNnhjfUME4JFdRz/OX6U39RuHiU5zt87j/heYgP+0TA4cOE+jK7tyEUIAMCujxQ6+3Bn7IA4NKDSnG3QJkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=siemens.onmicrosoft.com; s=selector1-siemens-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCxCdGZnHQYZ1osj0jBr1b8U8pP4ENDfyjrf6dXZjwc=;
 b=CzdzZuwDboCpV2ibkZLiBx5cCCVCaNo27EdGlQRhj7R0b/0dpzyog4dNk0ZePIPBbO8UkbGRBqB2b5KmWbDR//jfFzWJ9s6sbNKPV9chdUnVTbXn0QGqjquroI7mMBTaA7/8XozOD80Mv+sMUyXi4Z+G3vVGBbxyQOIpKI9418s=
Received: from AM6PR10MB2438.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:52::11)
 by AM7PR10MB3496.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:13f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 18:17:25 +0000
Received: from AM6PR10MB2438.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::7c1c:5b4e:ad40:b4bd]) by AM6PR10MB2438.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::7c1c:5b4e:ad40:b4bd%6]) with mapi id 15.20.3654.015; Thu, 10 Dec 2020
 18:17:24 +0000
From:   "Geva, Erez" <erez.geva.ext@siemens.com>
To:     kernel test robot <lkp@intel.com>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Arnd Bergmann <arnd@arndb.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Sudler, Simon" <simon.sudler@siemens.com>,
        "Meisinger, Andreas" <andreas.meisinger@siemens.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "henning.schild@siemens.com" <henning.schild@siemens.com>
Subject: Re: [PATCH 1/3] Add TX sending hardware timestamp.
Thread-Topic: [PATCH 1/3] Add TX sending hardware timestamp.
Thread-Index: AQHWzjjS+JtwwiLyJkKEw3ObDmZ1g6nvp7+AgACdOQCAAB/egA==
Date:   Thu, 10 Dec 2020 18:17:23 +0000
Message-ID: <AM6PR10MB2438372B8E1E528A359A64E9ABCB0@AM6PR10MB2438.EURPRD10.PROD.OUTLOOK.COM>
References: <20201209143707.13503-2-erez.geva.ext@siemens.com>
 <202012101050.lTUKkbvy-lkp@intel.com>
 <VI1PR10MB244664932EF569D492539DB8ABCB0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To: <VI1PR10MB244664932EF569D492539DB8ABCB0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-GB, en-DE, he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Enabled=true;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SetDate=2020-12-10T18:17:21Z;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Method=Standard;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Name=restricted-default;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SiteId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ActionId=edac9743-7858-4bc8-bfa6-868eef5c53cf;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ContentBits=0
document_confidentiality: Restricted
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=siemens.com;
x-originating-ip: [165.225.26.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 390151a9-a279-4692-0b9a-08d89d37d7f5
x-ms-traffictypediagnostic: AM7PR10MB3496:
x-ld-processed: 38ae3bcd-9579-4fd4-adda-b42e1495d55a,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR10MB3496D1F470AEE4DF87612D3EABCB0@AM7PR10MB3496.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G6KE0FZ+4OJ5JlHAhtmvRtkE3cu6KVqMKl2B/qwPhCYLBAGjenWu7XyaioeJrqTKYIrRRkG0SezevbWgGgNRwe/p63YqTAVPcEMpxhmZKvnn13VN+67sa1lOPrtO9nBtzi2zEpA3kd/vO11l5uy7oL4pPI44eHESebG7/fmdeNuWnV3lEKv+zgkGyAThaBzh85WTec2MFKm9xWIVpNbsGUNQs1rUvxUCEuR2F+jjFcN2v/3JjhedcD9o5Ea0TBKH7oMgphdLZBHx5TAbpph3Aq0imaOwh1GoqrVJNPvk2yZMFrV6s5tEoQM2FNnCnjs/Eh0w4SIMSd8n/qz0/G8c/321X+HzSM8wM4bjJLlxuymieJQ4SJyA/Ew9mnU+eTrs8XMV+mk2G8wWrPiCpWNukz+lcUJsL4M9Q7gK6NctaH1fV49EKF4kRWBK35/n0HAi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR10MB2438.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(8676002)(55016002)(7416002)(6506007)(7696005)(9686003)(55236004)(2906002)(76116006)(66946007)(66446008)(316002)(66476007)(966005)(26005)(64756008)(5660300002)(186003)(86362001)(71200400001)(33656002)(4326008)(8936002)(54906003)(66556008)(53546011)(110136005)(52536014)(478600001)(107886003)(83380400001)(2004002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UXpaeVo1T1lmcW1wczVKOHg2OU5YWnlvVmVFTk1xb1hMZDBNRDdPVU5oZTZ0?=
 =?utf-8?B?U0V0Z0ZUc21PWmwxYmVDbW1NRHc5bHMvWGx2bXZ6YlQvQ0tpMVIwSlo4Wkhx?=
 =?utf-8?B?aWVWUGtBUkR3NTl3bHQzTGVXTXFNeTI1Yk4relRkeWVoNU9ZYVZFZEJ6N3Zp?=
 =?utf-8?B?M3hHUHRmakVtb0JvQXJ3RUdjdDBhQm9HakdlRFhBREhld3JTY3pmN2ZzZ0tX?=
 =?utf-8?B?TkZOellra1hUTUlVL3J5b2U5cVl2UUQyVmlIdW1kTVRaeDJyVm1pUSs0d3FV?=
 =?utf-8?B?Wkt0UUxwOU5wT0NuZThUaDB1VUx0Q2ZZTVp3Mk1NT3M1TmJJZ3ZsaExvbEQr?=
 =?utf-8?B?YWRkekg0MzEyeXN6T0UrM2NhTDVYUm5FQjFJWDBlN1pkT1dmNmZhSm16cnhh?=
 =?utf-8?B?ZHRvaUQ3cWZGaHdYVTFjbGViOGc0cWhRRS9vcFo2MkxWRFU1MDZIQ1JFZlNq?=
 =?utf-8?B?ZzlMb2p3NmhHdDl6WmgxUzZYSXgvc3kzb25QdUkxMys3b3gvejJkRGQ4Tm9j?=
 =?utf-8?B?YjB0MGpyMzRUZFZWYUs3K3Q1dWliUXQzZlZhdS9vZjY5c3RJQ3VteENpS1Mv?=
 =?utf-8?B?L1R4bVNTSmhXamZ6MEU1MTUrT3VZY2pOeTZkQ05Qc3BsSDB3dkV5UHFxZnhJ?=
 =?utf-8?B?OFNhVTk0c01TSCt0T0hUNTVoMFNqdExaN2tZMlRWZyt4ZUZEN2ZseEVnQ0pO?=
 =?utf-8?B?ZzdvS3poQy83bU5WVnB0bGVtQ3RrTW5RNWlkWEFITU9EU1JscXlobC92VERw?=
 =?utf-8?B?ZkJMakRlbEFVZC9UWjB4QU5iOS8zeFNONzRsZEJiaDY2OTByRXJGYklKcFJX?=
 =?utf-8?B?bXBLYTFTRXVVKzNhR2h0S1JwSzlqVkcvZ0dOSWVYVDhtdkVXRXg4eXZTVUZm?=
 =?utf-8?B?Y2Q4SFBEajZDamZkNldYbGNiMVoyU3JUNTFrVXMwUG4yaHRDY2FuNXZaWVk1?=
 =?utf-8?B?Tmtta1FFbU16MFlJN2gvc1RNRVFXYnJmNmR2RzJFaHIzb3JBY0hoNDZScjRV?=
 =?utf-8?B?ZUJ0QkpOcmU5NG1tVEN3NVdqTGs1T1AzWXJLOXZrd0pqM1hMVHY0UlZWZU1x?=
 =?utf-8?B?TEpVREFuNVBHeFJ3QWpFOHhRVW0wazVteE5pNEEycXowNTlna2pJbzZBNFNZ?=
 =?utf-8?B?VEtRQWdZVG5SV3JhQ3RFNkJpcFErWllob1cvY1ZIR1RhekxZMmdzQ3R4M05z?=
 =?utf-8?B?bmYzdVdmZSsyMGgzR2g3czQwS1FlYW5iM0JVT2Q1cjZ1V05mQ2VkVGovN2ts?=
 =?utf-8?B?QkVmdzN2L1IzWFZoUmRjaytXZkFmNklhdGdEUVZZdytuMkJ1SVJydExRMGZx?=
 =?utf-8?Q?3X7yqpA69pXcY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <195A145459202E44BAC0355BA153A5E4@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR10MB2438.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 390151a9-a279-4692-0b9a-08d89d37d7f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2020 18:17:24.2899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: St4sk+3twgL4G1sDPC77ttW26jvTzx5cogTQFXaoo+p/Or1w5/0yYciRH2dlmmhfDtmRA/ZXjZvJAolRyTJ4Didnplkk4uSeuRcWVfEYVIk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR10MB3496
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxMC8xMi8yMDIwIDEzOjMzLCBHZXZhLCBFcmV6IChleHQpIChESSBQQSBDSSBSJkQgMykg
d3JvdGU6DQo+IA0KPiBPbiAxMC8xMi8yMDIwIDA0OjExLCBrZXJuZWwgdGVzdCByb2JvdCB3cm90
ZToNCj4+IEhpIEVyZXosDQo+Pg0KPj4gVGhhbmsgeW91IGZvciB0aGUgcGF0Y2ghIFlldCBzb21l
dGhpbmcgdG8gaW1wcm92ZToNCj4+DQo+IFRoYW5rcyBmb3IgdGhlIHJvYm90LA0KPiBhcyB3ZSBy
YXJlbHkgdXNlIGNsYW5nIGZvciBrZXJuZWwuIEl0IGlzIHZlcnkgaGVscGZ1bC4NCj4gDQo+PiBb
YXV0byBidWlsZCB0ZXN0IEVSUk9SIG9uIGI2NTA1NDU5Nzg3MmNlM2FlZmJjNmE2NjYzODVlYWJk
ZjllMjg4ZGFdDQo+Pg0KPj4gdXJsOiAgICBodHRwczovL2dpdGh1Yi5jb20vMGRheS1jaS9saW51
eC9jb21taXRzL0VyZXotR2V2YS9BZGQtc2VuZGluZy1UWC1oYXJkd2FyZS10aW1lc3RhbXAtZm9y
LVRDLUVURi1RZGlzYy8yMDIwMTIxMC0wMDA1MjENCj4gSSBjYW4gbm90IGZpbmQgdGhpcyBjb21t
aXQNCj4gDQo+PiBiYXNlOiAgICBiNjUwNTQ1OTc4NzJjZTNhZWZiYzZhNjY2Mzg1ZWFiZGY5ZTI4
OGRhDQo+PiBjb25maWc6IG1pcHMtcmFuZGNvbmZpZy1yMDI2LTIwMjAxMjA5IChhdHRhY2hlZCBh
cyAuY29uZmlnKQ0KPj4gY29tcGlsZXI6IGNsYW5nIHZlcnNpb24gMTIuMC4wIChodHRwczovL2dp
dGh1Yi5jb20vbGx2bS9sbHZtLXByb2plY3QgMTk2ODgwNGFjNzI2ZTc2NzRkNWRlMjJiYzIyMDRi
NDU4NTdkYTM0NCkNCj4gSG93ZXZlciB0aGUgY2xhbmcgaW4NCj4gaHR0cHM6Ly9kb3dubG9hZC4w
MS5vcmcvMGRheS1jaS9jcm9zcy1wYWNrYWdlL2NsYW5nLWxhdGVzdC9jbGFuZy50YXIueHogIGlz
IHZlcnNpb24gMTENCj4gDQo+PiByZXByb2R1Y2UgKHRoaXMgaXMgYSBXPTEgYnVpbGQpOg0KPj4g
ICAgICAgICAgIHdnZXQgaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2ludGVsL2xr
cC10ZXN0cy9tYXN0ZXIvc2Jpbi9tYWtlLmNyb3NzIC1PIH4vYmluL21ha2UuY3Jvc3MNCj4gWW91
ciBtYWtlIGNyb3NzIHNjcmlwdCB0cmllcyB0byBkb3dubG9hZCB0aGUgY2xhbmcgZXZlcnkgdGlt
ZS4NCj4gUGxlYXNlIHNlcGFyYXRlIHRoZSBkb3dubG9hZCAod2hpY2ggaXMgfjQwMCBNQiBhbmQg
MiBHQiBhZnRlciBvcGVuKSBmcm9tIHRoZSBjb21waWxhdGlvbi4NCj4gDQo+IFBsZWFzZSB1c2Ug
IndnZXQiIGZvbGxvdyB5b3VyIG93biBpbnN0cnVjdGlvbnMgaW4gdGhpcyBlbWFpbC4NCj4gDQo+
PiAgICAgICAgICAgY2htb2QgK3ggfi9iaW4vbWFrZS5jcm9zcw0KPj4gICAgICAgICAgICMgaW5z
dGFsbCBtaXBzIGNyb3NzIGNvbXBpbGluZyB0b29sIGZvciBjbGFuZyBidWlsZA0KPj4gICAgICAg
ICAgICMgYXB0LWdldCBpbnN0YWxsIGJpbnV0aWxzLW1pcHMtbGludXgtZ251DQo+PiAgICAgICAg
ICAgIyBodHRwczovL2dpdGh1Yi5jb20vMGRheS1jaS9saW51eC9jb21taXQvOGE4ZjYzNGJjNzRk
YjE2ZGM1NTFjZmNmM2I2M2MxMTgzZjk4ZWFhYw0KPj4gICAgICAgICAgIGdpdCByZW1vdGUgYWRk
IGxpbnV4LXJldmlldyBodHRwczovL2dpdGh1Yi5jb20vMGRheS1jaS9saW51eA0KPj4gICAgICAg
ICAgIGdpdCBmZXRjaCAtLW5vLXRhZ3MgbGludXgtcmV2aWV3IEVyZXotR2V2YS9BZGQtc2VuZGlu
Zy1UWC1oYXJkd2FyZS10aW1lc3RhbXAtZm9yLVRDLUVURi1RZGlzYy8yMDIwMTIxMC0wMDA1MjEN
Cj4gVGhpcyBicmFuY2ggaXMgYWJzZW50DQo+IA0KPj4gICAgICAgICAgIGdpdCBjaGVja291dCA4
YThmNjM0YmM3NGRiMTZkYzU1MWNmY2YzYjYzYzExODNmOThlYWFjDQo+IFRoaXMgY29tbWl0IGFz
IHdlbGwNCj4gDQo+PiAgICAgICAgICAgIyBzYXZlIHRoZSBhdHRhY2hlZCAuY29uZmlnIHRvIGxp
bnV4IGJ1aWxkIHRyZWUNCj4+ICAgICAgICAgICBDT01QSUxFUl9JTlNUQUxMX1BBVEg9JEhPTUUv
MGRheSBDT01QSUxFUj1jbGFuZyBtYWtlLmNyb3NzIEFSQ0g9bWlwcw0KPj4NCj4gSSB1c2UgRGVi
aWFuIDEwLjcuDQo+IEkgdXN1YWxseSBjb21waWxlIHdpdGggR0NDLiBJIGhhdmUgbm90IHNlZSBh
bnkgZXJyb3JzLg0KPiANCj4gV2hlbiBJIHVzZSBjbGFuZyAxMSBmcm9tIGRvd25sb2FkLjAxLm9y
ZyBJIGdldCBhIGNyYXNoIHJpZ2h0IGF3YXkuDQo+IFBsZWFzZSBhZGQgYSBwcm9wZXIgaW5zdHJ1
Y3Rpb25zIGhvdyB0byB1c2UgY2xhbmcgb24gRGViaWFuIG9yIHByb3ZpZGUNCj4gYSBEb2NrZXIg
Y29udGFpbmVyIHdpdGggdXBkYXRlZCBjbGFuZyBmb3IgdGVzdGluZy4NCj4gDQo+PiBJZiB5b3Ug
Zml4IHRoZSBpc3N1ZSwga2luZGx5IGFkZCBmb2xsb3dpbmcgdGFnIGFzIGFwcHJvcHJpYXRlDQo+
PiBSZXBvcnRlZC1ieToga2VybmVsIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+DQo+Pg0KPj4g
QWxsIGVycm9ycyAobmV3IG9uZXMgcHJlZml4ZWQgYnkgPj4pOg0KPj4NCj4+Pj4gbmV0L2NvcmUv
c29jay5jOjIzODM6NzogZXJyb3I6IHVzZSBvZiB1bmRlY2xhcmVkIGlkZW50aWZpZXIgJ1NDTV9I
V19UWFRJTUUnOyBkaWQgeW91IG1lYW4gJ1NPQ0tfSFdfVFhUSU1FJz8NCj4+ICAgICAgICAgICAg
ICBjYXNlIFNDTV9IV19UWFRJTUU6DQo+PiAgICAgICAgICAgICAgICAgICBefn5+fn5+fn5+fn5+
DQo+PiAgICAgICAgICAgICAgICAgICBTT0NLX0hXX1RYVElNRQ0KPj4gICAgICBpbmNsdWRlL25l
dC9zb2NrLmg6ODYyOjI6IG5vdGU6ICdTT0NLX0hXX1RYVElNRScgZGVjbGFyZWQgaGVyZQ0KPj4g
ICAgICAgICAgICAgIFNPQ0tfSFdfVFhUSU1FLA0KPj4gICAgICAgICAgICAgIF4NCj4+ICAgICAg
MSBlcnJvciBnZW5lcmF0ZWQuDQo+Pg0KPj4gdmltICsyMzgzIG5ldC9jb3JlL3NvY2suYw0KPj4N
Cj4+ICAgICAyMzUxCQ0KPj4gICAgIDIzNTIJaW50IF9fc29ja19jbXNnX3NlbmQoc3RydWN0IHNv
Y2sgKnNrLCBzdHJ1Y3QgbXNnaGRyICptc2csIHN0cnVjdCBjbXNnaGRyICpjbXNnLA0KPj4gICAg
IDIzNTMJCQkgICAgIHN0cnVjdCBzb2NrY21fY29va2llICpzb2NrYykNCj4+ICAgICAyMzU0CXsN
Cj4+ICAgICAyMzU1CQl1MzIgdHNmbGFnczsNCj4+ICAgICAyMzU2CQ0KPj4gICAgIDIzNTcJCXN3
aXRjaCAoY21zZy0+Y21zZ190eXBlKSB7DQo+PiAgICAgMjM1OAkJY2FzZSBTT19NQVJLOg0KPj4g
ICAgIDIzNTkJCQlpZiAoIW5zX2NhcGFibGUoc29ja19uZXQoc2spLT51c2VyX25zLCBDQVBfTkVU
X0FETUlOKSkNCj4+ICAgICAyMzYwCQkJCXJldHVybiAtRVBFUk07DQo+PiAgICAgMjM2MQkJCWlm
IChjbXNnLT5jbXNnX2xlbiAhPSBDTVNHX0xFTihzaXplb2YodTMyKSkpDQo+PiAgICAgMjM2MgkJ
CQlyZXR1cm4gLUVJTlZBTDsNCj4+ICAgICAyMzYzCQkJc29ja2MtPm1hcmsgPSAqKHUzMiAqKUNN
U0dfREFUQShjbXNnKTsNCj4+ICAgICAyMzY0CQkJYnJlYWs7DQo+PiAgICAgMjM2NQkJY2FzZSBT
T19USU1FU1RBTVBJTkdfT0xEOg0KPj4gICAgIDIzNjYJCQlpZiAoY21zZy0+Y21zZ19sZW4gIT0g
Q01TR19MRU4oc2l6ZW9mKHUzMikpKQ0KPj4gICAgIDIzNjcJCQkJcmV0dXJuIC1FSU5WQUw7DQo+
PiAgICAgMjM2OAkNCj4+ICAgICAyMzY5CQkJdHNmbGFncyA9ICoodTMyICopQ01TR19EQVRBKGNt
c2cpOw0KPj4gICAgIDIzNzAJCQlpZiAodHNmbGFncyAmIH5TT0ZfVElNRVNUQU1QSU5HX1RYX1JF
Q09SRF9NQVNLKQ0KPj4gICAgIDIzNzEJCQkJcmV0dXJuIC1FSU5WQUw7DQo+PiAgICAgMjM3MgkN
Cj4+ICAgICAyMzczCQkJc29ja2MtPnRzZmxhZ3MgJj0gflNPRl9USU1FU1RBTVBJTkdfVFhfUkVD
T1JEX01BU0s7DQo+PiAgICAgMjM3NAkJCXNvY2tjLT50c2ZsYWdzIHw9IHRzZmxhZ3M7DQo+PiAg
ICAgMjM3NQkJCWJyZWFrOw0KPj4gICAgIDIzNzYJCWNhc2UgU0NNX1RYVElNRToNCj4+ICAgICAy
Mzc3CQkJaWYgKCFzb2NrX2ZsYWcoc2ssIFNPQ0tfVFhUSU1FKSkNCj4+ICAgICAyMzc4CQkJCXJl
dHVybiAtRUlOVkFMOw0KPj4gICAgIDIzNzkJCQlpZiAoY21zZy0+Y21zZ19sZW4gIT0gQ01TR19M
RU4oc2l6ZW9mKHU2NCkpKQ0KPj4gICAgIDIzODAJCQkJcmV0dXJuIC1FSU5WQUw7DQo+PiAgICAg
MjM4MQkJCXNvY2tjLT50cmFuc21pdF90aW1lID0gZ2V0X3VuYWxpZ25lZCgodTY0ICopQ01TR19E
QVRBKGNtc2cpKTsNCj4+ICAgICAyMzgyCQkJYnJlYWs7DQo+Pj4gMjM4MwkJY2FzZSBTQ01fSFdf
VFhUSU1FOg0KPj4gICAgIDIzODQJCQlpZiAoIXNvY2tfZmxhZyhzaywgU09DS19IV19UWFRJTUUp
KQ0KPj4gICAgIDIzODUJCQkJcmV0dXJuIC1FSU5WQUw7DQo+PiAgICAgMjM4NgkJCWlmIChjbXNn
LT5jbXNnX2xlbiAhPSBDTVNHX0xFTihzaXplb2YodTY0KSkpDQo+PiAgICAgMjM4NwkJCQlyZXR1
cm4gLUVJTlZBTDsNCj4+ICAgICAyMzg4CQkJc29ja2MtPnRyYW5zbWl0X2h3X3RpbWUgPSBnZXRf
dW5hbGlnbmVkKCh1NjQgKilDTVNHX0RBVEEoY21zZykpOw0KPj4gICAgIDIzODkJCQlicmVhazsN
Cj4+ICAgICAyMzkwCQkvKiBTQ01fUklHSFRTIGFuZCBTQ01fQ1JFREVOVElBTFMgYXJlIHNlbWFu
dGljYWxseSBpbiBTT0xfVU5JWC4gKi8NCj4+ICAgICAyMzkxCQljYXNlIFNDTV9SSUdIVFM6DQo+
PiAgICAgMjM5MgkJY2FzZSBTQ01fQ1JFREVOVElBTFM6DQo+PiAgICAgMjM5MwkJCWJyZWFrOw0K
Pj4gICAgIDIzOTQJCWRlZmF1bHQ6DQo+PiAgICAgMjM5NQkJCXJldHVybiAtRUlOVkFMOw0KPj4g
ICAgIDIzOTYJCX0NCj4+ICAgICAyMzk3CQlyZXR1cm4gMDsNCj4+ICAgICAyMzk4CX0NCj4+ICAg
ICAyMzk5CUVYUE9SVF9TWU1CT0woX19zb2NrX2Ntc2dfc2VuZCk7DQo+PiAgICAgMjQwMAkNCj4+
DQo+PiAtLS0NCj4+IDAtREFZIENJIEtlcm5lbCBUZXN0IFNlcnZpY2UsIEludGVsIENvcnBvcmF0
aW9uDQo+PiBodHRwczovL2xpc3RzLjAxLm9yZy9oeXBlcmtpdHR5L2xpc3Qva2J1aWxkLWFsbEBs
aXN0cy4wMS5vcmcNCj4+DQo+IA0KPiBQbGVhc2UgaW1wcm92ZSB0aGUgcm9ib3QsIHNvIHdlIGNh
biBjb21wbHkgYW5kIHByb3Blcmx5IHN1cHBvcnQgY2xhbmcgY29tcGlsYXRpb24uDQo+IA0KPiBU
aGFua3MNCj4gICAgIEVyZXoNCj4gDQoNClVwZGF0ZSwNCg0KSSB1c2UgdGhlIHNhbWUgLmNvbmZp
ZyBmcm9tIHRoZSBJbnRlbCByb2JvdCB0ZXN0Lg0KDQpJIHdhcyB0cnlpbmcgdG8gY29tcGlsZSB2
NS4xMC1yYzYgd2l0aCBHQ0MgY3Jvc3MgY29tcGlsZXIgZm9yIG1pcHMuDQoNCiMgYXB0LWdldCBp
bnN0YWxsIC10IHNpZCBnY2MtbWlwcy1saW51eC1nbnUNCg0Ka2VybmVsLXRlc3QgKCh2NS4xMC1y
YzYpKSQgL3Vzci9iaW4vbWlwcy1saW51eC1nbnUtZ2NjIC0tdmVyc2lvbg0KbWlwcy1saW51eC1n
bnUtZ2NjIChEZWJpYW4gMTAuMi4wLTE3KSAxMC4yLjANCkNvcHlyaWdodCAoQykgMjAyMCBGcmVl
IFNvZnR3YXJlIEZvdW5kYXRpb24sIEluYy4NClRoaXMgaXMgZnJlZSBzb2Z0d2FyZTsgc2VlIHRo
ZSBzb3VyY2UgZm9yIGNvcHlpbmcgY29uZGl0aW9ucy4gIFRoZXJlIGlzIE5PDQp3YXJyYW50eTsg
bm90IGV2ZW4gZm9yIE1FUkNIQU5UQUJJTElUWSBvciBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIg
UFVSUE9TRS4NCg0Ka2VybmVsLXRlc3QgKCh2NS4xMC1yYzYpKSQgY3AgLi4vaW50ZWxfcm9ib3Qu
Y29uZmlnIC5jb25maWcNCmtlcm5lbC10ZXN0ICgodjUuMTAtcmM2KSkkIG1ha2UgQVJDSD1taXBz
IENST1NTX0NPTVBJTEU9L3Vzci9iaW4vbWlwcy1saW51eC1nbnUtIG9sZGRlZmNvbmZpZw0KLi4u
DQoNCmtlcm5lbC10ZXN0ICgodjUuMTAtcmM2KSkkIG1ha2UgQVJDSD1taXBzIENST1NTX0NPTVBJ
TEU9L3Vzci9iaW4vbWlwcy1saW51eC1nbnUtIGFsbA0KLi4uDQogIENDICAgICAgaW5pdC9tYWlu
Lm8NCntzdGFuZGFyZCBpbnB1dH06IEFzc2VtYmxlciBtZXNzYWdlczoNCntzdGFuZGFyZCBpbnB1
dH06OTEwMzogRXJyb3I6IGZvdW5kICcoJywgZXhwZWN0ZWQ6ICcpJw0Ke3N0YW5kYXJkIGlucHV0
fTo5MTAzOiBFcnJvcjogZm91bmQgJygnLCBleHBlY3RlZDogJyknDQp7c3RhbmRhcmQgaW5wdXR9
OjkxMDM6IEVycm9yOiBub24tY29uc3RhbnQgZXhwcmVzc2lvbiBpbiAiLmlmIiBzdGF0ZW1lbnQN
CntzdGFuZGFyZCBpbnB1dH06OTEwMzogRXJyb3I6IGp1bmsgYXQgZW5kIG9mIGxpbmUsIGZpcnN0
IHVucmVjb2duaXplZCBjaGFyYWN0ZXIgaXMgYCgnDQptYWtlWzFdOiAqKiogW3NjcmlwdHMvTWFr
ZWZpbGUuYnVpbGQ6MjgzOiBpbml0L21haW4ub10gRXJyb3IgMQ0KbWFrZTogKioqIFtNYWtlZmls
ZToxNzk3OiBpbml0XSBFcnJvciAyDQoNCkVyZXoNCg==
