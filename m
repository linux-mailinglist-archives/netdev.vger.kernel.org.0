Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CC939A32E
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 16:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhFCOb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 10:31:26 -0400
Received: from mail-mw2nam10on2085.outbound.protection.outlook.com ([40.107.94.85]:23905
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231460AbhFCObZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 10:31:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUqXUPSKRUqAYx0F2SB/SXVFhGN/uSvVfukuaURHgdQhPueGiQd0SVQjJJM+cEJPym86l0br+a7A8wmrdBm+WivjcCkkeprVjkitwpL28sesdro5Gi7PzdZP9553qs+2U6lmCFZBnmprhaEf/97iL1aWCSwkAS9Z1P5NiUwh3g/FZXR6FNyPAKNCUkk86vWl3QARjSgDSGO3Wc0uTJQccz2HwMFnEdueoSfzNPHZeG8+oBgObr4I3Me9GDkHLmhibpOxTpHgz+XpB6tCJbyEXoCoJrS2c1rsb2IhU8H0D6Eld0UFo7W0EI8vvsLQHnGrTkJScmfjN9oXTBZbFoDTNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2r8aJAhNQsYG2oj4X+ekCggYUR/4GHTlaRTOi2PHtko=;
 b=TXEAbq1yyNl7H1+zYo3pZqW0OEyFmiCzi3LCCm6uwk63NDuWTRxRN1zmo7pO0NzcyLdTR6qGa346LpNetWbYBOzEs0OyVhQRueUK7/54mB4ZygB8YNssC/uW4AGz8LpbrV5a6uT2Didw5UnlHR1P6OJzagqRiXeFlpySE3tjfhc54cdA+lLB/TxJMOIOQ9dzxr0WJw0sZlFTtLCQ/71FQRmZeE8AFMKtPOD3csyFhptxtQMlT5XPLlNEaw7dxSg92rkMB39Mlyjioulzu4C7Z82fgKcu8bItjA+3BHnCMMfa01Y4SuxabbhmhhS6FKb/vX/K7eqR4wwG52yzLABYmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2r8aJAhNQsYG2oj4X+ekCggYUR/4GHTlaRTOi2PHtko=;
 b=DKbBTlO3q6BVcUv7m2BcPyXYTcXqPreHXDb7n41jhaoByrd6ygX+B/aH8DsmDghJO+pIHKV7u1qCEilEjdAwezCjnNf5XwWdTijaz1IXno0Jl6GEOAznLBQ2lhaIPe6GZbW2Ms6aFLXv+AhE0H1HKMxzbveBvDpDHggTsBoQWoA=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by PH0PR10MB4517.namprd10.prod.outlook.com (2603:10b6:510:36::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Thu, 3 Jun
 2021 14:29:39 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::5021:f762:e76f:d567]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::5021:f762:e76f:d567%7]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 14:29:39 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: /sys/class/net/eth0/name_assign_type -> EINVAL
Thread-Topic: /sys/class/net/eth0/name_assign_type -> EINVAL
Thread-Index: AQHXWHltyt+qV8FxG0GezI/QpvQ5e6sCQzAAgAAR6ICAAAO4AA==
Date:   Thu, 3 Jun 2021 14:29:38 +0000
Message-ID: <92a72e7b3f54d694a69b9286fadedf1e375640df.camel@infinera.com>
References: <1b61b068cd72677cf5f0c80b82092dcb1684fa9d.camel@infinera.com>
         <5922a590219f3940a7ce94901b8d916daee31d3a.camel@infinera.com>
         <YLjkMw/TUYmuckzv@lunn.ch>
In-Reply-To: <YLjkMw/TUYmuckzv@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.0 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e19cacb8-f82a-42de-2819-08d9269c0520
x-ms-traffictypediagnostic: PH0PR10MB4517:
x-microsoft-antispam-prvs: <PH0PR10MB45172DB814E25C37F40D7B6AF43C9@PH0PR10MB4517.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5MfSQxySvGlJZAt9AMDnydAU7vy2IVe4jafeQnHXWVzxZ46DKeaYy+JAI9FAhSz271M04ElH3tAKJb9TEdkAA3u8VyxCYeMvcd1MXVTJ6m3WRIOVlW7hq1K5ES8ir/9EmE9ay94bm5utGFyjk4cfdLbHxCwmgbwaiRj8sOI/PfiVvLo7ZUr1B94V45fVbUvLE36G+mtZnv0nkTdfMQbQ1DiBF3+BHfBwrKD/Jjnws/KCdkwrxOmV0JYKndu53tvm9KvBn3dyKJy6XRXUjVBmQyYqoZKgR3dF5F+Q1WniK+2kOGiQTvDi0uuHBhP4FMOw1sPLMxpn9Xcl+Rck3Ej+0FPY02F5uDA0XEeYPisGfd0CpFKBhq1GOeF1i63E4oXxO0koFScMldp9fg1f7IwHbTAnGbgC6S9bMkCTptI3AsQxdI45VeFcTzdPlyaKrXNuO5703kD8t+ZqXnJTCb9/W9S986rbCwf5HH6wbcbfdk840imvl6OFMGAiDskf7htA2iADLmimTGB9j1MftIuV/JUontGoBajJDwtVtjBH27GcJVvkTxovoiFXqerpTAg6DbPoYY0+RRm4YTm3ovYgIoCeGwd/eR3rV+yE0kPyPXA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(346002)(366004)(136003)(376002)(76116006)(66476007)(66946007)(66446008)(64756008)(66556008)(91956017)(86362001)(2616005)(5660300002)(4744005)(4326008)(6486002)(6512007)(8676002)(2906002)(36756003)(478600001)(8936002)(6916009)(71200400001)(38100700002)(122000001)(316002)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MmhwQ01KQWNCeS9XempYRDlRR1pvWVZ3NCtKQmxTVjU2UzlrUWU4RXFNTHZY?=
 =?utf-8?B?WDVWdFF1aU5scFh3cFhEVTVrVUU0Q3JrOE8wZ3BuWDlBcEhxVE90azErZmpq?=
 =?utf-8?B?V1M2V3R2WDlPYmNUSFBCcVVoWit3eW43a20valFyeVdwbW5JM0xaWW9OUFNy?=
 =?utf-8?B?RGVaS2NEOXl1b3JHSnFvSlpoeVB5M3N3NTRyVmU0NU5HTkg3QWd0WG1rTjF0?=
 =?utf-8?B?WE1rQlVRYVVOMCtPWDI4TGw1SHFQSGMrZjFGV1F2YytnRlBhV3BRRyt6NXRS?=
 =?utf-8?B?cjFhd3VtaHFIUlVoVXhaSnpHeDc0bjdXTFZESmZuSCtZVVFHeVg3U3R4TzFQ?=
 =?utf-8?B?eG9GcHAvUFRxTFhYZEphek4zbVhYaDh5U2cwZGFjUWY3V3JadTFyYXd5Qmc2?=
 =?utf-8?B?c1FYOFV5MGxGYTZ3NWRRcHUwSFhyL0JaOENxRWkxL00wR2JGOFNQK3RJR2Jh?=
 =?utf-8?B?YzlEelg2UzRjcEdxdHVGUEJ0RWpwYnY3ZmtrR3FRWkJsK3BmTmJQeXhPemc0?=
 =?utf-8?B?OGx0Z1ZNNzhwaFBDeU0rOWljbTdrQ1gyNjZiK2pSTnZxUitHRllCcDBFU3B5?=
 =?utf-8?B?akVYMWVJcmxLbEU4ei81NFpUdG0zcTNicUxvYjFUOE5IdUpwd3ZCZy81N0sz?=
 =?utf-8?B?Z21RaFJyK2cvdE1taGlpNjlKYWU1QTdIdm9KS1g0N2ozK1hQby9HSWt6SGJG?=
 =?utf-8?B?TldnZGs2QU0rVlpxL3U1eHVNNTgycHVXbzBEaU02R1d5aU1CTFdRWDM3OXJF?=
 =?utf-8?B?SVZvRTNJd2RENElkUjV4RHl2NmhNckNENFRmWGUrWU0vVEl3eTRJK1h5UnZu?=
 =?utf-8?B?RUQ4K29GMU1hQWxGaERMaGdnc04ycEp5RGhvZFVOcm9IUlh3STdHSWZJQ1JY?=
 =?utf-8?B?VllBSmlDT0oyRjVHRlFnaWFuYnZKdzMyWTdkTitJV29XQXZLSTZBd1JhNkRW?=
 =?utf-8?B?YWhYMUZ1MG01ZkJoQmxvMUV0QytOQXZXdlNVUUNtM2hSRnU3c292NDg2YXcy?=
 =?utf-8?B?Sm53ZE5zaEd2dFl2ZG9MdlFqQ2VBQ0IwZjVTd2wyOW54NGpmdDhIcEcxZVd1?=
 =?utf-8?B?MGdQOHZBRDcxaVFxQ3lRbE0zd1RhYTllZWY1UkU1SE51N3JpU3NIRXV2Vkkx?=
 =?utf-8?B?N1ZFc3FjNFNzUjNOV1haRy95R2JSNzNjZS9WYnRkTWN6U2dGUUs4OUlGOFpP?=
 =?utf-8?B?R0JWa1VTcG1DQTdYek11NVlENnFUb3VrQzVIU0pwcjY2dERlYm15K2Evdmkx?=
 =?utf-8?B?c1RYL0lVem4zWEMrL2dqR2lnUktRQ0NwbEgrYXZzQVpPYkdZYlpJOXpLYjhT?=
 =?utf-8?B?emJoQWRZaktZNUVwK1BXOGNudUwxYTZNM3J3ZG1Cbi95WVBYbWtSN2hTc0tj?=
 =?utf-8?B?cXhaK3NXT3RQbHJMVENxa1NNY0RqU0hNOWF6Qm51OXMrMXh5N1JFcENGbElJ?=
 =?utf-8?B?RlBJMkdQd0dDNFE0TDN2K2FsU0U0aDRkU0wzcG1lekV5eCtKSWlRbThUN3NL?=
 =?utf-8?B?cEx4QkxUeGpuVUViM2U1WE5CSWVGOVBaSlc1RnBOTllsYU1SMTFaU1dzM1FT?=
 =?utf-8?B?M2UrOCt4c29Xdi8wU004YnM4M1BTdkZwSFZkV3dWQmNxMWhqVUZJYzRleGtR?=
 =?utf-8?B?TFFRYlhNRkhsb3QrRkJXMnZIS0JnVGNwekFHdlIyODhRVEZsWGV4K2wzSmlv?=
 =?utf-8?B?QjRLRkVwYnBhL2hQLzR0VlJnSXRYbGxMRXhiME9qalZyZ1lxY1RnK1FxcUdQ?=
 =?utf-8?B?TTMwMHkxUEJSbzdmSzhOSURjNFdDRW5CNzUwbktSbWdCemg3NTlVVnZXWDRi?=
 =?utf-8?B?Y3BoTVg3OHUxMVZ3bjBFQT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B3C47A3465DE6B4390BC22898D05B167@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e19cacb8-f82a-42de-2819-08d9269c0520
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 14:29:38.8968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O16zSa3sPI4d3zQfD62SsR5kfMT8GxTlwODTMWFuPlAXQMVHQPVBo1TGZDZJ/trQwPa3TGRdFtREp4ziXtax3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4517
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTA2LTAzIGF0IDE2OjE2ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
T24gVGh1LCBKdW4gMDMsIDIwMjEgYXQgMDE6MTI6MTZQTSArMDAwMCwgSm9ha2ltIFRqZXJubHVu
ZCB3cm90ZToNCj4gPiBTZWVtcyBsaWtlIG9sZCBldGggaW50ZXJmYWNlIG5hbWVzIGNhbm5vdCBy
ZWFkIG5hbWVfYXNzaWduX3R5cGU6DQo+ID4gY2F0IC9zeXMvY2xhc3MvbmV0L2V0aDAvbmFtZV9h
c3NpZ25fdHlwZQ0KPiA+IGNhdDogL3N5cy9jbGFzcy9uZXQvZXRoMC9uYW1lX2Fzc2lnbl90eXBl
OiBJbnZhbGlkIGFyZ3VtZW50DQo+IA0KPiBIYXZlIHlvdSBkb25lIGEgZ2l0IGJpc2VjdCB0byBm
aWd1cmUgb3V0IHdoaWNoIGNoYW5nZSBicm9rZSBpdD8NCj4gDQo+IFRoZSA1LjEwIGtlcm5lbCBv
biBteSBEZWJpYW4gZGVza3RvcCBoYXMgdGhpcyBpc3N1ZS4gU28gaXQgaXMgb2xkZXINCj4gdGhh
biB0aGF0Lg0KPiANCj4gwqDCoMKgwqDCoEFuZHJldw0KDQpObywgSSBoYXZlIG5vdCB1c2VkIHN5
c3RlbWQgYmVmb3JlLCBhbHNvIG9uIDUuMTAubGF0ZXN0LCBJIGFtIHNldHRpbmcgdXAgYSBuZXcg
RlcgQGhvbWUgYW5kIGRlY2lkZWQgdG8gdHJ5IG91dCBzeXN0ZW1kLg0KDQogSm9ja2UNCg==
