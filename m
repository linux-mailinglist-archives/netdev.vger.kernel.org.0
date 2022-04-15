Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C986502706
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 10:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351456AbiDOIsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 04:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351557AbiDOIrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 04:47:39 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90048.outbound.protection.outlook.com [40.107.9.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6960D1838E;
        Fri, 15 Apr 2022 01:45:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZ2NGPfVcV2NHcSkXNrGfUprSMMRZLt/GhktBEzhvGm3p9Ne97DGqIxqRTjGELrhS35yFaDIhjp2EAHyBZ2vV4D8Ry6NJL/td+KH6e5TeeqHyitx8biTTgCRDk6LRAdE5D9kzLzzJtC7rI0/TA/h8GoX8y+4RRsPUwJoiNgzZTd28bz1GwEME3F/aOcsAhT7sZ2R7Xl9eYed2HH811Il+YURWp7fyOaOEItrqWc6VdoiNku0pgvfPAe9PXInbsXdovBVcQuebakpKfGchNAIgglRR1oM66/4OIynY7zwKxax3b4OPpOoiW1dA+Vl+zCv6Thv6kBLkzun9j75vmw9/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SLne5as6MQWE29/ugkuF8rWCrKBvaCJkw12GcvA/hB4=;
 b=Dh0std2nCC163feEAMturaJJ+t7EuBRfqp96bBZuuwvMCI7pX/PgZsGrv7TxboqnYKOjCWrClglq/QFmS+oDyNKYwduBE1+CLV7F4yGHBkR2sL7kddoozIKqfRV1dAWgEDZQQfmQ6N0k3so5Eg3QSb3zBs3JtXor8fwGQPHfhORMMyXAyrvezHG4+tOHD5pgQ4aCRIO6xqB9L9IXRbmL2lW2kDD7cPEpAhWSBc9gJ48QgXY2lkvhNp1udO5ryv0ZMBq6NyxCDi2WnqFjAxKVjWifoI/cp0eLI9uuhHWSc55wvAEGEY/ygqM/v7bQ4dkSGBebVugGNrMnvgoyowERQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB3979.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:25a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.19; Fri, 15 Apr
 2022 08:45:09 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::59c:ae33:63c1:cb1c]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::59c:ae33:63c1:cb1c%8]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 08:45:09 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] sungem: Prepare cleanup of powerpc's asm/prom.h
Thread-Topic: [PATCH net-next] sungem: Prepare cleanup of powerpc's asm/prom.h
Thread-Index: AQHYRnrdmIDrva6DkkmRu6Wgc/GcSKzhyLiAgA70igA=
Date:   Fri, 15 Apr 2022 08:45:09 +0000
Message-ID: <5b0e7dd2-793e-35e8-f0db-e77efd46bc94@csgroup.eu>
References: <fa778bf9c0a23df8a9e6fe2e2b20d936bd0a89af.1648833433.git.christophe.leroy@csgroup.eu>
 <20220405132215.75f0d5ec@kernel.org>
In-Reply-To: <20220405132215.75f0d5ec@kernel.org>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d41cba32-0997-4861-1f2f-08da1ebc3f77
x-ms-traffictypediagnostic: PR0P264MB3979:EE_
x-microsoft-antispam-prvs: <PR0P264MB3979DB28550AF428D05EDB07EDEE9@PR0P264MB3979.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TuUPf+eYJuBwEvhkVbsbrF557GzfJzw1JbDVTSN6F2RIvtOI9evsIrm4cM1IU/fx5VvILG7gi06XGBMNVKc/8d8CYwghfPMC24NrV3I/wGmpJR0co0FyUNIi9/THV71COlI1GL7z+VnzZBJ2sK+Vi3oL6GLoDwqt5aMpAHLxDLXn7XYso8T8FNq9w1zKeTKuryaN+6l55yGbqu7P4yoYAXN5si/B32QeRiBU7gqZS9wC0X6AVoEmeLR29gzVGfLg4jABSBDFP8xLphGWsHCZe7KVwWGKkbA/SeUi7RLE6Wj1x+sQC9jznHCpSpWGKVoI43idTLzY4Ig3bHibQLapUOlPhw5VnbEYjQxs8eGKsJIWNmdFRAk+u0hySChRxqTZYhLPfawkrpVwpNqI158skW42dYo/oLiKKOv6sLzvSlUUR3/vU7XoFN7spEnziP63lhIYD4diQjjX6d1bnBkp6n0fZXNu4VbjOypAMwNwGN9VwG3dlrjgRcVuDPjJlxa5snXkTRnJmPzOdioz7bUUopqkkH48EVDH+VKxVDMiSr9fXyM+StnSnq5z7libC6cN5E9vchsFmJJPw+5sNKNvhQ1y4R/eVGeaKHYfAfjvftKn+6CZl0pJ8q9G52UXMhUWGlJNHJ8ZZeTYg53ZzGx5WkGx1BLyNYjGyxj01CEWP0mIT21YmJLqKEMsK8q9hVf/FSjzEzBDUYd6DbaYcqaPpPKkiOChmfrkZ4Y8n0AboG4JNJwuH12NvCyLjLRjJw4n+3d6XqUgdQwDhAaZDHuCqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(36756003)(38070700005)(38100700002)(31696002)(91956017)(6512007)(8676002)(8936002)(64756008)(66574015)(44832011)(76116006)(122000001)(86362001)(54906003)(26005)(186003)(66556008)(83380400001)(66446008)(4744005)(6916009)(66946007)(31686004)(66476007)(5660300002)(2906002)(2616005)(6486002)(508600001)(6506007)(4326008)(71200400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aEk4NDJaaGxpQ2VYWHBqeWxoaXU1azJQb2V4UkZNN01OL0RucjVaMWszenhS?=
 =?utf-8?B?ZWdoenBHN3kwY2ljd0RKRi83dm1EVDJxNlI1T216ckdoc0xsazA4dktUd0tv?=
 =?utf-8?B?dEhRdUdXZ2hIdExwaU84ditSSjNWeHN3SG1rdkliTmV1S1JKTmJKOE41dW9J?=
 =?utf-8?B?OUU1Nnh3WkVIUFIxOWNWcGp2MjVMQ2t5bFl6RG1QRUV3TDVFQy9sL1B4MVBC?=
 =?utf-8?B?Q1Q2YVcvUDc1YXpibGJ6dHNzSWU5YTNGL0xpUk1ndUdmU2dVV1I3QjNHaHA3?=
 =?utf-8?B?REZoWVRUZHVBemFUaXdKMXZXL1MwcnZuNXJCY3RxUjNZNVFlMzlaT2VxRmkv?=
 =?utf-8?B?TUtZQnZhTXI3Snl3SWN0eDNPZzAwZG1qbkhyVlhRZzFRaE01VWFoNHZMKy9B?=
 =?utf-8?B?WTQ3N0pyR3ZHbzhpSUU4bHdTOVhsRVFQazJ5cDVLK2NocmwzK21LYzNPUDZx?=
 =?utf-8?B?KzQ4TWFrdVo0em1lYjQvNEM3N0xhUVBPRzIvV2J2TTdrenVRU0RJbllySlhD?=
 =?utf-8?B?UWhBWG5wcENpdlRKZEU1emxIdTV6S3k3S1lWZDZZSnJTb04zaGRyMDI1UGFY?=
 =?utf-8?B?dWw3dkFGcWRGMWRVMm9JZDluTjdCWHRncEhGOGdDb05wRFVkU1YvVUpKdlZ2?=
 =?utf-8?B?akFFZnFaQWp0WWxXMDBGRkcyZmJLVzF6a2FkeWpOZElzTERPQXdhY3NXcTBV?=
 =?utf-8?B?V1NGZWlwNmhnSE5zZzBYYit3djNtaWhjTkEwRk0wcVNycmpJTFhLSlgvcFo1?=
 =?utf-8?B?TXU5Y0IrZ2pqdVRJZGpIb0d2OThYUnUrZzBpSDI0dzBFY3hpMGRqZ1pYWko2?=
 =?utf-8?B?S2pDQ3VSUkFVT2tnbVRoNllzeGNKWUcyTFdjNFhMZWVvYzYycXA0TW5LaGhL?=
 =?utf-8?B?cFJoamZJV2VsdnhCZ2lEb2tFMDhRa0w1VlVGMzlzc01FTklUcVpVdWNNM1Nv?=
 =?utf-8?B?NEFOb1hoOEpoQ0k1NllSRnFsczZlY0NWUzZIbEJIb254VXVDajNCa2lLT2la?=
 =?utf-8?B?cWNrR3RZWHg3NjB2Z2JYYnUwNndaZmhBaUtkTFdFU1ptWjQ2UENFOWtKQjNK?=
 =?utf-8?B?RTBHS3NmcjZvTGpuY2NCSlU5ODh6MGRORkJaaFEvaWIwbUdRRTRlODJIc3Jw?=
 =?utf-8?B?TURWWXVlNTFQT21yQWY5NnU2Q0ZESUtRalAzUXJBSllmdFJSY0RlRmMyenhY?=
 =?utf-8?B?NS8vdU1HZGpLYWp4emRWNFdkTmRtR2RVMytQWC82OFpQcG5UNHNhZjExY0lP?=
 =?utf-8?B?UUhPRlNBbHRlMkhaZ3dXcHBTMURFWnJENC9KQVY0Z1pzS0pwWjB6M3hOdEJz?=
 =?utf-8?B?SC93TFJ2ekhEZTdDdXRrR2t5MTlrQmJrbFBGZWxJSklUWW1lNnY4NHl5dk55?=
 =?utf-8?B?Q0d3TzBMbVBZUmZxRHdnK3MzRXJ4c0hFSjJYNzZja28rTmZiY28vQnBOZlRY?=
 =?utf-8?B?WE9vbGdpYUNUZGEvdG9nOEUvWUo1eEJQdW44M2NUZ1FhaUw1L2l6cy9YZUc2?=
 =?utf-8?B?VzdldVU0Nk5OYWowbTk1dnhDMTNHS1U0dmpDZW8yMC96TWZZNDdJWHkxQlY4?=
 =?utf-8?B?NzI2elAzdDNOcXI0R2JKU3VjalNYN21mRlpKZkM4U2pDdWlvNzkwdUtNWnlT?=
 =?utf-8?B?QmhYd3FGNE5jdTdiK2NUWXZici84algrdlQ1akNDN2UzN1VoWjJtR285VFRu?=
 =?utf-8?B?NzdpZStZRy9tNkJRZWorU21qa1dCOExUWWNwem5UbTYrbEVMd3kxZElBYWlS?=
 =?utf-8?B?R3JRbVNZRENUa3N1Y2YySGpYcFdTZ3U0V1JXMlhsUm0rdUlSa3lEbEZEUjNP?=
 =?utf-8?B?anhMMm1HaGVUamp0cUhnUVNJZWdEaDZqVDdCVE4vbFAyaHRWMW1pTER6UGhV?=
 =?utf-8?B?ZTBZRzlaV0NFNjMrNnZiR29WbHJ1UkQybzRieFJUQ1F1aW9TUnBYNExzd1dv?=
 =?utf-8?B?S3lJcnFoc0dKTGxlT1VZRjRkMVU0Znl2THNnTEVDRlRHVmJJT1N3NFk5Mnlu?=
 =?utf-8?B?dXdTdDJ2WTdBMndnRCs4TGh6YXNYY3UzQmJVZ3I3cktJVi9NdEJuU05lQWVF?=
 =?utf-8?B?SU1QbUNtQlZYbS9OSHRVM1kvYlFhNkczUWZXNTBUYjVmWEFSQ09xYnNOZXZ4?=
 =?utf-8?B?QVlndkdqKzF2VHJUbS9Uc3FtQU1EdHJLOHZBTERndTZkTnZuUDBlKzF1ZHRZ?=
 =?utf-8?B?bE44bE9xKzlRRzRMU1hYbmRSak56OHd3MDRBVmZKOUl6VWp3bmlFNFBpeWh0?=
 =?utf-8?B?Zm5ITU5sWHlGdCtSQm5Na3dFQ3VmU2ZhenpucTNYZ3VJNXc5YXVETXlsWWd3?=
 =?utf-8?B?OUZNNExacTVjcmVSejdrWjJLWWVsTGFjMzdoQXdxSGs5WldaL3RqYXpEbDB6?=
 =?utf-8?Q?ru37ky+kBesPGGw9Xr0ii5x7KfFO6dc1PYOgA?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A2BF163D79932E49981E6718AF7983FF@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d41cba32-0997-4861-1f2f-08da1ebc3f77
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 08:45:09.3009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yd726VM8D88f6w5d9ZLD9rBDjNWmOQbQB5x4s6nvvo2r+pGuScPzgjl3ja50FbWzGYdqVCC/KDhehNt32BMgXsQ+vspm7cYxdX0QaYYdP5w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB3979
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDA1LzA0LzIwMjIgw6AgMjI6MjIsIEpha3ViIEtpY2luc2tpIGEgw6ljcml0wqA6DQo+
IE9uIFNhdCwgIDIgQXByIDIwMjIgMTI6MTc6MTMgKzAyMDAgQ2hyaXN0b3BoZSBMZXJveSB3cm90
ZToNCj4+IHBvd2VycGMncyBhc20vcHJvbS5oIGJyaW5ncyBzb21lIGhlYWRlcnMgdGhhdCBpdCBk
b2Vzbid0DQo+PiBuZWVkIGl0c2VsZi4NCj4+DQo+PiBJbiBvcmRlciB0byBjbGVhbiBpdCB1cCwg
Zmlyc3QgYWRkIG1pc3NpbmcgaGVhZGVycyBpbg0KPj4gdXNlcnMgb2YgYXNtL3Byb20uaA0KPiAN
Cj4gQ291bGQgeW91IHJlc2VuZCB0aGUgbmV0LW5leHQgcGF0Y2hlcyB5b3UgaGFkPw0KPiANCj4g
VGhleSBnb3QgZHJvcHBlZCBmcm9tIHBhdGNod29yayBkdWUgdG8gbmV0LW5leHQgYmVpbmcgY2xv
c2VkIGR1cmluZw0KPiB0aGUgbWVyZ2Ugd2luZG93Lg0KDQpPaywgSSBzZW50IHYyLCB3aXRoIGEg
Yml0IG1vcmUgZGV0YWlsZWQgZGVzY3JpcHRpb24uDQoNClRoYW5rcw0KQ2hyaXN0b3BoZQ==
