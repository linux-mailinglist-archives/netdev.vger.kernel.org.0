Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCA33CFA83
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238766AbhGTMos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:44:48 -0400
Received: from us-smtp-delivery-115.mimecast.com ([170.10.133.115]:34954 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238658AbhGTMjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 08:39:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1626787213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h9WDZJfN4xUnogNfA4wzKgD74HJPzq8HZ5HNV0tlAZ8=;
        b=vA6FiPNU+BpjyOY+FPYD3p3NfI5iXC5fbQ+nNZjh33QoKFzMDkAdNXsYcVcz6GanmF8QxF
        hiACuXwC7MZayaPkvZTbUvgKMh67W8/GWF/PlQHiMJ14EtWAH3C43BLxvZ8qRzH1FANAB5
        R9VjJhrRFheyzf+arKtjcoQ1eAOYWiQ=
Received: from NAM04-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam08lp2172.outbound.protection.outlook.com [104.47.73.172])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-Ow-aITzAPkWTpGR-3LIFSg-1; Tue, 20 Jul 2021 09:18:07 -0400
X-MC-Unique: Ow-aITzAPkWTpGR-3LIFSg-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by CO1PR19MB5015.namprd19.prod.outlook.com (2603:10b6:303:f0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 13:18:02 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 13:18:02 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>,
        "mohammad.athari.ismail@intel.com" <mohammad.athari.ismail@intel.com>
Subject: Re: [PATCH v6 2/2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Topic: [PATCH v6 2/2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Index: AQHXfF93E9dlj6gxN0ii5bTKpxVpI6tKxfkAgABxygCAAJ50gIAABF6A
Date:   Tue, 20 Jul 2021 13:18:02 +0000
Message-ID: <15f9a29b-d34f-e55c-033f-48076eb1cb0f@maxlinear.com>
References: <20210719053212.11244-1-lxu@maxlinear.com>
 <20210719053212.11244-2-lxu@maxlinear.com> <YPXlAFZCU3T+ua93@lunn.ch>
 <c21ac03c-28dc-1bb1-642a-ba309e39c08b@maxlinear.com>
 <YPbJX34DG5gYFkEq@lunn.ch>
In-Reply-To: <YPbJX34DG5gYFkEq@lunn.ch>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36bac248-96f1-42f3-6688-08d94b80cd56
x-ms-traffictypediagnostic: CO1PR19MB5015:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR19MB50157DE718B7948BBC2159E2BDE29@CO1PR19MB5015.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ibhDJIFh5BYc05VHkwv69ZGe02gf3/FoDkLNIqlDK3S1FkCx+CpIuDvl2W5ikqQ1hWnQa51SVdK/1DeUsLv4lybSMCnqFSBacaK9jSScR/bvbnxE45ahl1L8SArS7zh/n4IKmBt8bxrr2hyOPX230VEH+sCU1t/kfRaFmOY5QQ0caelJZt8bsXTrCHdW7Q1YRUf5Af1efl881MnhTX5y2Le8VTBNHdVkj0Aar8nPyuY5Jt2WgXwbiDPuSRv/4yerPKDXAZ8D8RPFSWFUXpVdPZpcTsV++kf6z1dOcGiFzaooX+DuAflPcCIbChiGnQvqINOg/vEcnDTaTASogyJ4cJGR+0QrCdUBYwJIvrOsr6xJmYBHYycvMtZs9O3xHtQaVefDtqW9CRjRRsYXu/6TcIi4aW8u8pKHRhVEnoq/usR+kpZsNUrTkUj3utq2k5+2IlMgFNZkSE4rt32lA1GyAQI1nvy6adt6smaBCiwDv9jPSbh6qRH3CG/GICJd1tCoKzCLYbQVS6TtVj9yur6SaXr/BAKlqJl2ePfuQI4KvmHfQmLMVmITNqFTy5GZLDX1Cv9ESmfaWI5WAtFvDIovhMrcLrnREGTUF+BLXH+h/j2kGy2GA6Y0VNNswgwW4dtYNhK0F4Ipo8Z+cijR17blyi+3gt+CCJ/ofukuE/+L4ekHPolV/pFFt3cywGEX6CPqWswOqd3bHL6L+o3B5mjPJHTTnuoSVzhqSf++F1IftBXbPtZVyB1iuriqnmse4gLERc+aNopl6uGuhkXJdMWLJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(136003)(376002)(366004)(346002)(54906003)(122000001)(2616005)(38100700002)(71200400001)(8676002)(6486002)(86362001)(31686004)(6506007)(2906002)(31696002)(8936002)(5660300002)(186003)(478600001)(4744005)(316002)(6916009)(36756003)(6512007)(66446008)(66946007)(53546011)(4326008)(66556008)(66476007)(64756008)(76116006)(91956017)(26005)(38070700004)(45980500001)(43740500002);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlJFM1RiK0JvNEtyTnVYcVZwRWViV1FFWnJ1Zzc3MlllQkZvUEY2dThQZkhF?=
 =?utf-8?B?c0dGUjFNSDE5bWpoMnFTVGxIbE44blRseTY3Tzl5Z0JWNTFkU1JWWWpBVzdK?=
 =?utf-8?B?NlpPV3pmS3g3dFJxVUJWbzg2RWJoNWNkdThCVFN5RkxtM0pFc3FaL285Y25v?=
 =?utf-8?B?R2h4Mmhqd1FGWGhJUnNnTE9GMjNMaHI5cUpmdEgydUI0VXJHeGxiZGRJTmZJ?=
 =?utf-8?B?OWUxL3gxdFgveHM1NE5yWVE0WDlkVXB5c0pZNWZEajBQTGpLSUNlcXpXL3BX?=
 =?utf-8?B?SEwxWmtVMXVISUY2UnpyNGpTM1EvMnB5ZmEwbWxWdGRSWlBLRDVoc2QrRmlB?=
 =?utf-8?B?TWlQa0R3SGJIdkpRV1FSMHhJRmtuc0FScHJQZURmV3FJRWo4TVhRMy9SSUEw?=
 =?utf-8?B?TnN2eXcwb3B2bnpMWmVDNFhtZjZWcGZocCsxRnZqM0xmL3VYVkw2WnZBbzlS?=
 =?utf-8?B?K0tRRzhjNHhFd050YlRhY2NscjNabEhnN0Rvai8vYUZhU1lBU3crVU5Hd0ZB?=
 =?utf-8?B?OFJ2TmpHakNFejNBQitkU2V5bkduQ1ZDWjNBOHZ0eFYyaFhwMkgyOGNxeCs3?=
 =?utf-8?B?cjcwczFobFJsVVBzb2dYTm45TWkxQytIaFB1S2I3SDNEVmdVSTA4NmhMaDJr?=
 =?utf-8?B?TU4yL0tJb25TWmUxektSWXQ2d09NT3NMMHFIZWVEcVJBekxOWVNlY2M4bU55?=
 =?utf-8?B?Q0FmR1JaU0NrMVRHdFJMNGYzVnBXSmRGV0xwNTc2U29POGEwWFZGc0wwdmJV?=
 =?utf-8?B?R0NzVTEyZU1ZV1ZGV1JJd2hQL0NLYko2UzU5ZTJhQ1VEZG03ZG4zejFjTkQv?=
 =?utf-8?B?WmYyNGtoUlNxbjhoRDJkdWp6eUFkL1RDbTZVUGtwZm1Gb1lhU1B3dkk5bUpE?=
 =?utf-8?B?azl1eTRWOEhKZWRDcC9weUgyTUszbUlEV2R0dU5vMVNnWmgyRVRWdnFhYmNm?=
 =?utf-8?B?dml2Y21uelFybk5BMTZ1Y2YyNmxLQVNxb0cyZGRLRHBGdDdyaW8zT09Kd3k2?=
 =?utf-8?B?YVFxcHRNaXBtaU1BWlR1eThnc1VkNXduWFh0ZkVvVGJPbnBWV0MrUm9DVWsy?=
 =?utf-8?B?Nk84WDkvUkZST2VmbXFLaW45UTBCZmZhckoxZElvTytyRjk1YlNwUjZpQkc5?=
 =?utf-8?B?TG5xTE1TUVhDbElLaDA0RHlOUjg1bnZES1g1K0k2Tnk2NTFKWXVQcmF2bXVZ?=
 =?utf-8?B?SVlzdVV6Znl2RWs5YjR4b1dndzMveGZwbENkMG4xNHlZUVJ4M3JkZmx5OGVa?=
 =?utf-8?B?cER4c1AxVy9ORDl5S0JPTkNucjFXZWFWcDY5eXJTMWZMYUgyQUV5OWpycXFU?=
 =?utf-8?B?RWFNU00wRkIvb1BRWER1eURTRlJMbStkZXNTbGxjTC9KOVB6TWZzNVVZU09O?=
 =?utf-8?B?eVBkeHQ0S0k1ejBxQUFtbnZ0ekZ0TXBIdjdrbkNBT3FGazBGckVyOHAyTytR?=
 =?utf-8?B?NXQ5SWlRNXlhQSswN3JsZEw0L09hWVJZSEJPYTFSSUxoODU1U1hLVnZpd0hX?=
 =?utf-8?B?S1RYTHphSjVNZkVSeUYvNDEyb2NBWi9iWTQyYXUyeHAxZjZMZEhCUy9jbEVv?=
 =?utf-8?B?enRMZitreVFNZFIwTlBjQVp5TElyL0E3UTVubDJoRVJEbEs5eTNaVSs2UU1N?=
 =?utf-8?B?ZnhPMWlrV1NYQ291aGhkR052S3pvb1JsalczZFRaUCtBdHUwM1F0Y01kbDJp?=
 =?utf-8?B?V1p4RkREMFBkYzBmdkxVRFM5M2VOMEVBdllEY1FNRXVLbm9NVXFNYWhNL0lR?=
 =?utf-8?Q?XSK+Yeu6uBdBfL8QbU=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36bac248-96f1-42f3-6688-08d94b80cd56
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2021 13:18:02.1275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rQBvoyaxtqj1NHapT+H5ohiRw1kEwzhbG6TVJ7ltD1E89ISjeJroNGO8mqi4SJwOwLsTIfOU675nPL/JbYpjjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR19MB5015
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <FA045FDF02963045B65C1435ADAB6DE6@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAvNy8yMDIxIDk6MDIgcG0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPiBUaGlzIGVtYWlsIHdh
cyBzZW50IGZyb20gb3V0c2lkZSBvZiBNYXhMaW5lYXIuDQo+DQo+DQo+IE9uIFR1ZSwgSnVsIDIw
LCAyMDIxIGF0IDAzOjM1OjE3QU0gKzAwMDAsIExpYW5nIFh1IHdyb3RlOg0KPj4gT24gMjAvNy8y
MDIxIDQ6NDggYW0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPj4+IFRoaXMgZW1haWwgd2FzIHNlbnQg
ZnJvbSBvdXRzaWRlIG9mIE1heExpbmVhci4NCj4+Pg0KPj4+DQo+Pj4+ICsvKiBQSFkgSUQgKi8N
Cj4+Pj4gKyNkZWZpbmUgUEhZX0lEX0dQWXgxNUJfTUFTSyAgMHhGRkZGRkZGQw0KPj4+PiArI2Rl
ZmluZSBQSFlfSURfR1BZMjF4Ql9NQVNLICAweEZGRkZGRkY5DQo+Pj4gVGhhdCBpcyBhbiBvZGQg
bWFzay4gSXMgdGhhdCByZWFsbHkgY29ycmVjdD8NCj4+Pg0KPj4+ICAgICAgICBBbmRyZXcNCj4+
Pg0KPj4gSGkgQW5kcmV3LA0KPj4NCj4+DQo+PiBZZXMsIHRoaXMgaXMgY29ycmVjdCBhbmQgaGFz
IGJlZW4gdGVzdGVkLg0KPj4NCj4+IEl0J3Mgc3BlY2lhbCBiZWNhdXNlIG9mIGEgUEhZIElEIHNj
aGVtZSBjaGFuZ2UgZHVyaW5nIG1hbnVmYWN0dXJpbmcuDQo+IE8uSy4gSXQgaXMganVzdCBhIHJl
YWxseSBvZGQgbWFzay4gQW5kIHB1dHRpbmcgdGhlIHJldmlzaW9uIGluIHRoZQ0KPiBtaWRkbGUs
IG5vdCBhdCB0aGUgZW5kPyBBbmQgbm9uZSBvZiB0aGUgSURzIGhhdmUgYml0IDAgc2V0LiBJdCBq
dXN0DQo+IGFsbCBhZGRzIHVwIHRvIGl0IGxvb2tpbmcgd3JvbmcuIFNvIGkgaGFkIHRvIGFzay4N
Cj4NCj4gICAgICBBbmRyZXcNCj4NClVuZGVyc3Rvb2QuIEhlcmUgYXJlIHRoZSByZXZpc2lvbnMg
YWxyZWFkeSBpbiB0aGUgbWFya2V0IChzaGlwcGVkKToNCg0KMS4gR1BZMjExQiAtIDY3QzlERTA4
LCA2N0M5REUwQQ0KDQoyLiBHUFkyMTJCIC0gNjdDOURFMDksIDY3QzlERTBCDQoNCg0K

