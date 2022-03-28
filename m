Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B46E4E9C1F
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 18:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241169AbiC1QVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 12:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238330AbiC1QVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 12:21:15 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90040.outbound.protection.outlook.com [40.107.9.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6CD2AC42;
        Mon, 28 Mar 2022 09:19:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bgpWXRnPMJ7WYKHkygV1peWgbf+eMJ+abf8jIPIMyos1361+ihnBZznKwE9xYgLGTBvonGD5TFdzXe86ST4q1OzFTH7i1sEI4m0u38JwMfrT4RgZyhrJpHTiDppC80Crw7UOm9dePPA9VYt5Ov1odhmCKz2Vazh2EShtg2n8BH1oGMpneaHW45ctgLyi5GjdCi88Yv45AGwKGMpyOyUFAlWNVqRJ1v3ldGhCbKkJdo0f0JFtHI5GKNhpE/C25bCOgSiiwjARG67zgcYwF3lkYPlppf6gzMsbIsOEtWTzvsgq2SL2sdP2asbQaB2zJmXJWWuIgCkGQeg2DIsyHX9clw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u2ryxQPQJlgRaYUszmb8zDyzKrmk9XXwxoLsSND837c=;
 b=fkuOseAA8HcqtbwHlqKlZnTQuMboxmas4ySQC6+zvzdqScWt+F7I9sxVW2XDVZlWZqLnGlHIaXhJTbIjjtxA+IiZ70g9oXRgCcxPnX5qTEJ7ppZBi84HpaFhgdTI/VBW2tJMCI/oVXlcOyWOnTWRcrMfnIPt9vwsr1KnHDJdogKrHYodvVWq3nTVGo54zpHDN1SRz5gS1dpuCBWhUC4Zc299bDF21huI2DIZjvWtqoIPeU0XGzI1zcKli+1a8N1Chll3izFQHyLDNOGTkrOlr237pL0NOgMqB/OvUlclRkM35/qeE6Sq5q1jUZaXQEQNLEqrMSQeGRWQ6Eddb/8Zag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR1P264MB2174.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1b2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Mon, 28 Mar
 2022 16:19:30 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::cd2f:d05d:9aa3:400d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::cd2f:d05d:9aa3:400d%6]) with mapi id 15.20.5102.022; Mon, 28 Mar 2022
 16:19:30 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Paolo Abeni <pabeni@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "cake@lists.bufferbloat.net" <cake@lists.bufferbloat.net>
Subject: Re: [PATCH net-next] sch_cake: Take into account guideline
 DEF/DGSIC/36 from French Administration
Thread-Topic: [PATCH net-next] sch_cake: Take into account guideline
 DEF/DGSIC/36 from French Administration
Thread-Index: AQHYQpvjppMlrKiyBU2guUha863gGqzU8AAAgAAJ+gA=
Date:   Mon, 28 Mar 2022 16:19:30 +0000
Message-ID: <079a3b29-fec7-97c9-19d9-0bd9a17e63f1@csgroup.eu>
References: <356a242a964fabbdf876a18c7640eb6ead6d0e6b.1648468695.git.christophe.leroy@csgroup.eu>
 <87bkxq5bgt.fsf@toke.dk>
In-Reply-To: <87bkxq5bgt.fsf@toke.dk>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e32c28b0-d78d-4ee3-f82d-08da10d6bcf7
x-ms-traffictypediagnostic: PR1P264MB2174:EE_
x-microsoft-antispam-prvs: <PR1P264MB217439A659BDE2711311494BED1D9@PR1P264MB2174.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h1huRjCUyTByAS+ZPKdaVxMH7owC/amjVaMJFo/2bUx/o4gHiMcceUpvn+VMyhN3JRPO+ndvvJgRo7nTUENLKNrZ3G2efVridVJYqUFIDfbiQkhRGDo/EJ312SdUFiEdVvTl5wuzieWawXmbZYVKLAJyeuMt7I6ywlr9s0CVRUxjsqWyptEi68drBEjwQjXV17QCHMeoTDwltgo+qQZS0PjOMw4jKGx6MDqZnO25jUXovb+e9PsfttDMqa8tH358XuBP6BrG5RMwXHiXZnumrC/u7jMQ12DYfpitnfS2gOhmBLp83SVqfIEDzbeo1ElvaGy7d4GEEQes4E6no2uFk7gVpgwfGtC7oFZICJVTDZjLJ9HpRxEvDjqXGbHdDKMqU1MWwh9cLRxJuJnaePZPkiy91ImUlquXCw7jvnBoKs8QWepecwKqRpNdkb/Sbw5vQHp30/+QlrybIMmU6ZRxDGMi2hpv+nMwhx1ks2NCqzVhCAk3Wmjiu1Mr3/pog8ZS6M3hnnHPi5haKPa0hnNR6nCayVoAjp0e5CKR083Dl5Dn2ES7RkhZSEv/trCJXUclShx2epKBgJKatCBPNk8W9iT2XycEH6aTCygChBuCpHuo1WxXgQcpBLjASW78Iegt5GsAScOgORqbDE2ZFrwL1N6EGTKeznR1+FPoqNtT62XT/qyz6IohdLblLx8Mmp3gLE0s8qWoAH/YW3Nd/usnOJKs4DhDIznwgh8TgveMH0jhluUrdWaUCYiPj6loO1jtzI29jDGgtmaXAtFZv/yCqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(122000001)(38100700002)(83380400001)(186003)(76116006)(26005)(66574015)(38070700005)(508600001)(4326008)(91956017)(110136005)(6506007)(2616005)(66476007)(54906003)(6486002)(66446008)(66946007)(8676002)(8936002)(5660300002)(31696002)(64756008)(66556008)(36756003)(86362001)(71200400001)(7416002)(316002)(6512007)(15650500001)(2906002)(31686004)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWxDdGNPYlJ4bEVEbThwZDQrUUlLMjcxdStzTkNqdm1aYTZkM0V3U3ZyeXlD?=
 =?utf-8?B?aXo1N25wSG5JSFFNSlcvNGZ2WEhxaVAyOGp6QlZveXNvd1dtSkE5RWFZalJn?=
 =?utf-8?B?NlVQTkdEcHhlakZtL3l1dDMvcy9NK0llLzdMWjNZc0VrWS9tNk9FL0NWc3dO?=
 =?utf-8?B?KzlHK2tTbVdWUVY2YVV0MU8zTGl5ajBucEVtVFB6T2IvZTRXa3FxTktUL2to?=
 =?utf-8?B?cVd2N0lqVlNNT3BXZE5DeUQyVEhaMU1mSWxsSGtOMnB4QkZqeVBpWEpYdFU4?=
 =?utf-8?B?L1ZSbXZwSDFHR3c3YjhvVEYzNzF6NGIrc2U2RXI4d01tRXY3c3ZxckhUb0d2?=
 =?utf-8?B?TU1INlUwUFBydVNlZzVzMm9rcUZPWWN6SmUzNklhVWtWOVB3WU5MOVR0eTI1?=
 =?utf-8?B?Z21yU0hpVHkwa2RGUzR3L0k0MjdJbWpiU0kvSWd3U1pMNFBzU2FnRjBwZ253?=
 =?utf-8?B?TGhsdDhXTCtjNTFLVGxYd2hkeE43MHhDN2F4dGMzZzN0Q1RtV0ZEQkpHQWxs?=
 =?utf-8?B?d3lpbXh4d2ZZK2FsOFBnSEFuUENRVG53V05GZE15SytSQmYwc0wwUjZRU000?=
 =?utf-8?B?R3YvV09HQ25EbEdFajRhWnpITzRLSEV0RWkzVHBYWjd1R08vRTJ0Zjluc1Zq?=
 =?utf-8?B?cVpMQVZqSkltSzF0MnFwcUxFMUFjNGZEeE1PNGw2TzZ3ekpRcHVneEZQVUJ6?=
 =?utf-8?B?UzF3enVGWFpXMjBqRUt6WWgwbHl1L0tkdk5FZTlMS04rK3VLVWtVTHRIRXJq?=
 =?utf-8?B?dXdaeDdIVFFUWStGdTMrYnYwdlRGMmJVNnRSc2hRUGRjMVpFSGpZOVlGZnZn?=
 =?utf-8?B?QXZSTFhWaFI4U0EvbzQyLytUcVowSU1pbVdTd2Rtc0QrQ1FkSXdDL0FOSG1x?=
 =?utf-8?B?SGFKOUsvWlk3ODl3U3BrNTljNFA4alUwL2U3Wm0zSWxhRlJHeEF4amYzWjFB?=
 =?utf-8?B?VGlJMWlSRUR5dzVneVdxT0x3aDA2WmNsNW43Zm95VXFqRitNbms1Sm5leDFO?=
 =?utf-8?B?UXpER1ZYOWtRTThYbXhScGZGeFVrbUxtUTEvaVNOaGxZdEx0b1ZUVVJYVjdW?=
 =?utf-8?B?K2wrN3Y4cTdOd0diMjlndzNCcnZVc2VESjc1eS9aS1JEMDBmWTRCVjVwUGVj?=
 =?utf-8?B?MWR0ckNCT3BQZFR0Wi9McHJudlJaM1R0QXpiUndGeDNiYTJmK0RjM2hseXM0?=
 =?utf-8?B?Z3NUQkpwYUhTdHdIUEJPOEgrOUd1cnczZ1Rzcy9SOHMyWFlrdm5vTVVERjhD?=
 =?utf-8?B?MmVBcENQTHplZzdkWGwxWVFXVGVpaExKZVN0SmI5SFpheGFWUnZTSHBGcDhO?=
 =?utf-8?B?SC9YcTFuRWsvaWhZakFoeVEzSW45MDhkaUYxaWMxbXlXekFCbVBXVmw1Y21a?=
 =?utf-8?B?dTQ2V0NzNE5yeHAzQVB1bXpaQ3hKRUx1WmdsdnNuc2tBanhDazd3a3kwOG1m?=
 =?utf-8?B?U01KdXduL05BV1kyMk8vTERPbTlZLzlJUzdGQ29JQnRtVUIwWGxQdERPMjN1?=
 =?utf-8?B?R2pYZTFVdTA5NStmbFNrN3JWYzMzRHdHZFhCVXRVNDExUU1NUUV1NU12MGNi?=
 =?utf-8?B?SC8vaUhFdU8veFZFZGdlcDFkWTZyTWlFeEpKOU5BQi91ZG5FZEx3SVNKVGtu?=
 =?utf-8?B?YVA2MzFNL3o1ejBRSkozcTlBVDcxdi9SVWwxYWplVGsxTCtQVy85bVkzTDE3?=
 =?utf-8?B?S1FlNjRLVGhaWVM0MTE0Rzdkd09rTitNb1lkTnBhVzhlZHlQODYwcVJ4Q3lL?=
 =?utf-8?B?Q2RqdkNvRmEvTDdhdVZiNVY2TDVtUDluR0NRWkdxVzhtb1BMUkFYQm1XV3ZH?=
 =?utf-8?B?aVVZeUhhbklKb2hzcEkwYUpjZVQwdFRyVGJrejI4RlpMY3dBYlE1QlhJYWxT?=
 =?utf-8?B?OHdyKzR1YWVlQkgxMVRhaEl4MHhCNDRma1hwU3RtbmRlZGF4S202bFZvcWVs?=
 =?utf-8?B?amQ4cVROWnM0WmhRT2JBVDBnemZsUTdpRkU3akpGNzdFeGw3ZWNWbVlPRFlL?=
 =?utf-8?B?UTdyL2tWVW5XTTJvOUhWNWwwRGpBUVQxb0d0aEQwUFJxN0xWYW9ORFVUaDJl?=
 =?utf-8?B?cWJ1QTQ1aFV4SVRPeEZvdTE3aHd6NEN1eCtBT3k2ZnZmL25zME4zejQ0VWVT?=
 =?utf-8?B?WkRuKy9CaFhNMndTKy9NZG9icmNFckhVOGkvOUhidUNhYjFPcXlWU0tybjA4?=
 =?utf-8?B?aTZ3ZXU3dkJjMGJMaENyaCtDRFRUeVBWSnE3WGhPVXo3NW1EMHdocERpTng1?=
 =?utf-8?B?NExVMDdXNHlySlNZdno4b1I2SldtcTdxaEk0MFVyYTk1YkdLS2VYOTIyeWZn?=
 =?utf-8?B?cExmVlkyL2VTOW8vMEVzTVBYZU1URnpwWE5nNzVpMlovQkdISHltRzFqbnB6?=
 =?utf-8?Q?+rl2ExaG9nUutt5gZFEGJDLQy/NFdvBZBsDDT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <55228DAC19408041BC6FFE2994CAC488@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e32c28b0-d78d-4ee3-f82d-08da10d6bcf7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2022 16:19:30.5135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tYv38GIH/0D5mp4g8WSz82xzhPrxBvXxjGADjrPnTlAmiIP8olCuQt1OgdbTMfUS6ZpbzOqRZ9coYXq+JzUv7fHNWzNoHXys5Y7KZ5GACtY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB2174
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDI4LzAzLzIwMjIgw6AgMTc6NDMsIFRva2UgSMO4aWxhbmQtSsO4cmdlbnNlbiBhIMOp
Y3JpdMKgOg0KPiBDaHJpc3RvcGhlIExlcm95IDxjaHJpc3RvcGhlLmxlcm95QGNzZ3JvdXAuZXU+
IHdyaXRlczoNCj4gDQo+PiBGcmVuY2ggQWRtaW5pc3RyYXRpb24gaGFzIHdyaXR0ZW4gYSBndWlk
ZWxpbmUgdGhhdCBkZWZpbmVzIGFkZGl0aW9uYWwNCj4+IERTQ1AgdmFsdWVzIGZvciB1c2UgaW4g
aXRzIG5ldHdvcmtzLg0KPiANCj4gSHVoLCB0aGF0J3MgaW50ZXJlc3RpbmchDQo+IA0KPj4gQWRk
IG5ldyBDQUtFIGRpZmZzZXJ2IHRhYmxlcyB0byB0YWtlIHRob3NlIG5ldyB2YWx1ZXMgaW50byBh
Y2NvdW50DQo+PiBhbmQgYWRkIENPTkZJR19ORVRfU0NIX0NBS0VfREdTSUMgdG8gc2VsZWN0IHRo
b3NlIHRhYmxlcyBpbnN0ZWFkIG9mDQo+PiB0aGUgZGVmYXVsdCBvbmVzLg0KPiANCj4gLi4uaG93
ZXZlciBJIGRvbid0IHRoaW5rIHdlIHNob3VsZCBiZSBpbmNsdWRpbmcgc29tZXRoaW5nIHRoaXMN
Cj4gc3BlY2lhbC1wdXJwb3NlIGludG8gdGhlIHFkaXNjIGtlcm5lbCBjb2RlLCBhbmQgY2VydGFp
bmx5IHdlIHNob3VsZG4ndA0KPiBoYXZlIGEgY29uZmlnIG9wdGlvbiB0aGF0IGNoYW5nZXMgdGhl
IG1lYW5pbmcgb2YgdGhlIGV4aXN0aW5nIGRpZmZzZXJ2DQo+IGtleXdvcmRzIQ0KDQpCeSB0aGUg
d2F5IGl0IGRvZXNuJ3QgcmVhbGx5IGNoYW5nZSBtZWFuaW5nLiBKdXN0IGVuaGFuY2VzIGl0IGlu
ZGVlZC4gDQpCZWNhdXNlIHRoZXkgYXJlIG5vdCBjaGFuZ2luZyB0aGUgbWVhbmluZyBvZiBleGlz
dGluZyBEU0NQIGNvZGVzLCBqdXN0IA0KYWRkaW5nIG5ldyBvbmVzLg0KDQo+IA0KPiBSYXRoZXIs
IHRoaXMgaXMgc29tZXRoaW5nIHRoYXQgaXMgYmVzdCBzcGVjaWZpZWQgZnJvbSB1c2Vyc3BhY2U7
IGFuZCBpbg0KPiBmYWN0IENha2UgYWxyZWFkeSBoYXMgbm8gbGVzcyB0aGFuIHR3byBkaWZmZXJl
bnQgd2F5cyB0byBkbyB0aGlzOiB0aGUNCj4gJ2Z3bWFyaycgb3B0aW9uLCBhbmQgc2V0dGluZyB0
aGUgc2tiLT5wcmlvcml0eSBmaWVsZC4gSGF2ZSB5b3UgdHJpZWQNCj4gdXNpbmcgdGhvc2U/DQoN
Ck5vIEkgaGF2ZSBub3QuIEluIGZhY3QgSSdtIGp1c3QgZGlzY292ZXJpbmcgdGhlIHN1YmplY3Qg
YWZ0ZXIgc29tZSANCnBlb3BsZSB0b2xkIG1lICJ3ZSBhcmUgY29udHJhY3R1YWxseSByZXF1aXJl
ZCB0byBhcHBseSB0aGlzIGd1aWRlbGluZSwgDQpwbGVhc2UgbWFrZSBzdXJlIExpbnV4IGtlcm5l
bCBzdXBwb3J0cyBpdCIuDQoNCkknbGwgZ2l2ZSAnZndtYXJrJyBhbmQvb3Igc2tiLT5wcmlvcml0
eSBhIHRyeS4gSXMgdGhlcmUgYW55IA0KRG9jdW1lbnRhdGlvbiBvbiB0aGF0IHNvbWV3aGVyZSA/
DQoNClRoYW5rcw0KQ2hyaXN0b3BoZQ==
