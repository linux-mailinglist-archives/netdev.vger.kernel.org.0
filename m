Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61D758E864
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 10:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbiHJIGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 04:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiHJIFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 04:05:55 -0400
Received: from de-smtp-delivery-113.mimecast.com (de-smtp-delivery-113.mimecast.com [194.104.109.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5911143330
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 01:05:50 -0700 (PDT)
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com
 (mail-zr0che01lp2112.outbound.protection.outlook.com [104.47.22.112]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-25-bzocriJ2MOiIM2noYf2mcQ-1; Wed, 10 Aug 2022 10:05:47 +0200
X-MC-Unique: bzocriJ2MOiIM2noYf2mcQ-1
Received: from ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3b::9) by
 GVAP278MB0070.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:23::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.15; Wed, 10 Aug 2022 08:05:45 +0000
Received: from ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM
 ([fe80::cd78:5df6:612c:455f]) by ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM
 ([fe80::cd78:5df6:612c:455f%2]) with mapi id 15.20.5525.011; Wed, 10 Aug 2022
 08:05:45 +0000
From:   Marcel Ziswiler <marcel.ziswiler@toradex.com>
To:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "embed3d@gmail.com" <embed3d@gmail.com>,
        "qiangqing.zhang@nxp.com" <qiangqing.zhang@nxp.com>
CC:     "philipp.rossak@formulastudent.de" <philipp.rossak@formulastudent.de>,
        "guoniu.zhou@nxp.com" <guoniu.zhou@nxp.com>,
        "aisheng.dong@nxp.com" <aisheng.dong@nxp.com>,
        "abel.vesa@nxp.com" <abel.vesa@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: Question: Ethernet Phy issues on Colibri IMX8X (imx8qxp) - kernel
 5.19
Thread-Topic: Question: Ethernet Phy issues on Colibri IMX8X (imx8qxp) -
 kernel 5.19
Thread-Index: AQHYrI/+0vnMKpTjW0iEfU3dAn0M5w==
Date:   Wed, 10 Aug 2022 08:05:45 +0000
Message-ID: <7d541e1dfa1e93abf901f96c60be54b01c78371c.camel@toradex.com>
References: <90d979b7-7457-34b0-5142-fe288c4206d8@gmail.com>
In-Reply-To: <90d979b7-7457-34b0-5142-fe288c4206d8@gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f0314f3-fbda-4fa4-adf3-08da7aa720d4
x-ms-traffictypediagnostic: GVAP278MB0070:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: BQ4l5D2Zuw0VExsVR7AfSpb/a60dfNiobaFDhkF/fM4cjbDiYP57lKgRQbWHPGDfqlD4+uTnh4o4rhegxCNmarXU861ZU896AuByAuJXDmzlpV3SiVBxs9yKHmzUDkFnemBCFNo866CfJ6xyQGwliHlyKKNzN2gp0d8NgmeFsoGSR3I8h7ZQtRSozp7E1wtCI8GZVCrnvFno78MJDubqo1jKRfEZHetduhcr/Wq51pC78KAWFTarXHKbSypbCb7je7n2ZwCN8XyuZISzd2T4wY6la+OpY4zodAIt3k5zRRQJ8/HTL/ffHhA4qinlNAdpMFSD13FBi7oW7Q+lApe+TpI7NBSDs6G2JsN4nOgBlG7m0ThQVq5H6mPGzgVtDlGHgapWcbasmsl8AeRm8v9ymqqzxMkXbaKXjGoEyzXh0FpB01zvH79zeiGKHN/owFQy0X6tQRCXf0/l3tQ8k6CbmAR4HL3332KsaMRBOxSvoOD3PQqZ1sgQcGeWhWbxHJcYJvYmR3YDDxdupB7pRc0TgJoSf9KTPs4s+y9cHtQ8FczYGFZzkqAzOgql7gh+hYNj4wy7g4FFv8kOv8jbdP7E7Jd6+kr68Pxeau0F0CHqWu/NSHXYmVPHORIEy4Ov7ayOJtBaMcG5vxG7+dUSr9kLNW1CcyybO43Yzl/CPF1mpB2dBG5YfjkQR8edjr69YmYYjdID8NqDdRPnDTcy5Xg3dN7GlA6ArOnsiVoYtpwPK3M9cD1UXIkAQr6t04PWthaqqel35McsUb3wddwDvsHvkBJbPvsgfPLoTwx7pnpIBn8gqJDhuIoZ7aLgpWo+hcjnHmEvF71dyQMMwkHctTP0yZ69eBWnt2KORaWyK4v5p+c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(366004)(39850400004)(376002)(41300700001)(6506007)(2906002)(2616005)(6512007)(26005)(316002)(38070700005)(86362001)(83380400001)(8936002)(4326008)(76116006)(122000001)(966005)(66556008)(66946007)(5660300002)(8676002)(38100700002)(66446008)(54906003)(6486002)(186003)(64756008)(71200400001)(478600001)(36756003)(110136005)(44832011)(66476007)(32563001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MmdPeHY5K2V3K2VMSkRhZDRKdlk2Z1pvdG9TRndyVlJ2akZvWXVNZGs0eU1t?=
 =?utf-8?B?MjdCSkppSTJVZFZFeU9xcERKdWpub1lkVU05ZDhub25JSzliemU5RzZtZVhF?=
 =?utf-8?B?a0xxT1Y0MlhseWFJK0JlS1VWb01NQ2luYU1pRUVIb1d0ZFJEdWxRVlVERHJ0?=
 =?utf-8?B?amdTTlErNTVkb3FmdkZYcmUxSnczbjk2cEc0eXJUMjJheEFEY2N0cW9td3o3?=
 =?utf-8?B?aW1MTWVGMHhLekVETXhLNHBqQXY1eXdaaEVFK29IZkFIQmVsbG96WTZPeHY0?=
 =?utf-8?B?YlF5Rm5ZOEI2TjB4UVBxNFpWamZObGh3OTdaanRJZWI5bTZRTml4Ym5lR3ZT?=
 =?utf-8?B?TC8xZEl0eTV1VHRPZWdoOEx3blBsdVlMTUJWTWlvb0ppRkpSZTdGSHlvNTFP?=
 =?utf-8?B?QS9nTncxVDE3V1lXbEJHdEh0elJLQXpwSVlRdjdHWXlBMktNaU1ES3VER1J0?=
 =?utf-8?B?dW9ZVmhQZXdqZWlFeGZZTC9PTmFUYzBvNzR0VDRBMm9sREJqQW1FNXNpV3Vj?=
 =?utf-8?B?dkxVaUhNZ0VnTjRpZmZsMFhpYzMyWmZjRGR6NHgvczhFOU16TFA5OW0zNzlo?=
 =?utf-8?B?Z05VZkh4M2hzRkZsbTRhVFhuOTM5MFJoZnMzckJ6UXRhZ25rUXhSb3VCTCtI?=
 =?utf-8?B?OFZlM1JaaG12RHUwUW4rVE1FMmxLUWV6b0s2SzE5OEEzYTcxeVNhVWtvZEJl?=
 =?utf-8?B?aWw4eXNnVHo0MTdDUTcwR2h1WmxLNWhiRzNWcG9rSFlYNGljRmtCN3h4eE50?=
 =?utf-8?B?VURPVUFWZVQyclhWT2hiS0xBTXVOT3c5TmhzVHl1NndFNy91c3drd2k0NFBi?=
 =?utf-8?B?MnNkNkEyV1Vxd2dUNTBpVHJFMUM4U2ZTcWlaeXJWZXJTUTBVcytIenBmZ082?=
 =?utf-8?B?bkVENkZYYkhzSndhbjRBQjdWd1hJdFZrSGdFYTFDOWVHNXpicGwwWUZCLzV4?=
 =?utf-8?B?UzRoK0h1OU9wLy9GY0k1Tzh4R3lBL1lnTG9xVklMUnJzMG94Z1lOcWJFUy9E?=
 =?utf-8?B?Q3FyNDhtRmF5RWZJTFRBa01IbDQ0WDd0UmU1NkF4emVsaVJaaXBRU3lWeVky?=
 =?utf-8?B?bGxoUUdHNkF0eGVnVTVxaUxybVpDYVo1RHJqMWhZNlk3Uis3ZzdhaDlHM3Bs?=
 =?utf-8?B?NThrSTYvL2JQRjZOZWs0RFVHMnJuYkNuSW9aallZV05oSy8yODVNV1RjbzBv?=
 =?utf-8?B?dWF2dVFlZ0VWWk5QZWNSUUs5SVJIdmFwd3E4cTl2TFNhQmo0ekJGazJJZkx5?=
 =?utf-8?B?SWQ1ZHFjaFRMbzBrWnNVcEdDT2xScmN5cXNYVkdWUXhmVDlqblA4V01TRThN?=
 =?utf-8?B?ZG96bEducTV1SUR3TG1NRjR3cXorTDJmVkJoUGdpSU1EbzcwL3BVZ0dPYm8w?=
 =?utf-8?B?d3lSL2xFeE00R2xLMHJOREpDZnFGNm4vSTFSdUVrOFcwamg3bmRLYmdGcUo0?=
 =?utf-8?B?SlZuTSs1V1BDYkEyQkZOb09MelJ2cklGZlNDOUM1R2ZwLzRwSTVCN2RhRVVB?=
 =?utf-8?B?VmpQQlhGK3cvMTFjM2ozVDl1VjJEdU0ybzBQM09yTDhTaDJiczNhWk9jT1Rq?=
 =?utf-8?B?SCtZWXRtYnhMeFJ0aGM5eG8veW1CVXd2YXVKNTUxRnpZUVNTWlJoWG9iaFVn?=
 =?utf-8?B?U3hhTjVnV2llSFpDT2lBMVRZYXJhRVVXWDhnaW8vN2NNaGtNRjJ0Q1JUMzBC?=
 =?utf-8?B?dUVhVWFQVjBYaUc4WlQ1bXVyYlMrM0ZxWnlVdU5qM1c2aGdsblVCSUUwcUJQ?=
 =?utf-8?B?ZlRsNU4zV0RHNmxTeGNHU1d4MGp0bDBkdkd1dlhWdHRmQ2RyN29NdkhIQmk4?=
 =?utf-8?B?K3pERXFVQXh3cVdEQU1yWDdvZTdDeG1TYjBoOWNLZkRDcUpZNnB3bU0rRldW?=
 =?utf-8?B?OVVJVDR6akJVWmdzbTFoWjhja3o5bVZiRTZ5QUtpSkJMVWNVUUgzWUhHVHQr?=
 =?utf-8?B?YVgxRmtiaXBtS2tYaWRhb0JHd3NKdVR2MVVpWWxXTzZJV25HZ0VvdGgxbk5C?=
 =?utf-8?B?MlhuaXQrR3lxOE8rK3RQUFdaemxKSHY2cUhIdDR6ZmFrbkQxb3k1cFYzTkg4?=
 =?utf-8?B?ejNKZG5SaEdKKzBNNlJiTk1tR2I4ZG5wdkZSWVphRTZlcjlqdzg4S2tZaU9J?=
 =?utf-8?B?em1GQmg2R1FGaERlaDVqMzlvcVpKQmU5Z3JBcHJpQmI5aVNCZ3h5cmlabmhB?=
 =?utf-8?Q?JNz0Tf4Wrz4KpYb4wfHATRE=3D?=
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f0314f3-fbda-4fa4-adf3-08da7aa720d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2022 08:05:45.4970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h6A0PTL/jswRQR/QhFcweB9i1+aNztk8D7/ACcOHyEFLx06S69Bqnv6zzBKuTYEdTwHvrxhACXqs4BD2n1uG1m0zeYROiI/eXNQwimG4K7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVAP278MB0070
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <5FD422D70DE94B41839A1DB6AA788AA8@CHEP278.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U2FsaSBQaGlsaXBwDQoNCk9uIFdlZCwgMjAyMi0wOC0xMCBhdCAwMDo1NSArMDIwMCwgUGhpbGlw
cCBSb3NzYWsgd3JvdGU6DQo+IEhpLA0KPiANCj4gSSBjdXJyZW50bHkgaGF2ZSBhIHByb2plY3Qg
d2l0aCBhIFRvcmFkZXggQ29saWJyaSBJTVg4WCBTT00gYm9hcmQgd2hpdGggDQo+IGFuIG9uYm9h
cmQgTWljcmVsIEtTWjgwNDFOTCBFdGhlcm5ldCBQSFkuDQo+IA0KPiBUaGUgaGFyZHdhcmUgaXMg
ZGVzY3JpYmVkIGluIHRoZSBkZXZpY3RyZWUgcHJvcGVybHkgc28gSSBleHBlY3RlZCB0aGF0IA0K
PiB0aGUgb25ib2FyZCBFdGhlcm5ldCB3aXRoIHRoZSBwaHkgaXMgd29ya2luZy4NCj4gDQo+IEN1
cnJlbnRseSBJJ20gbm90IGFibGUgdG8gZ2V0IHRoZSBsaW5rIHVwLg0KPiANCj4gSSBhbHJlYWR5
IGNvbXBhcmVkIGl0IHRvIHRoZSBCU1Aga2VybmVsLCBidXQgSSBkaWRuJ3QgZm91bmQgYW55dGhp
bmcgDQo+IGhlbHBmdWwuIFRoZSBCU1Aga2VybmVsIGlzIHdvcmtpbmcuDQo+IA0KPiBEbyB5b3Ug
a25vdyBpZiB0aGVyZSBpcyBzb21ldGhpbmcgaW4gdGhlIGtlcm5lbCBtaXNzaW5nIGFuZCBnb3Qg
aXQgcnVubmluZz8NCg0KWWVzLCB5b3UgbWF5IGp1c3QgcmV2ZXJ0IHRoZSBmb2xsb3dpbmcgY29t
bWl0IGJhYmZhYTk1NTZkNyAoImNsazogaW14OiBzY3U6IGFkZCBtb3JlIHNjdSBjbG9ja3MiKQ0K
DQpBbHRlcm5hdGl2ZWx5LCBqdXN0IGNvbW1lbnRpbmcgb3V0IHRoZSBmb2xsb3dpbmcgc2luZ2xl
IGxpbmUgYWxzbyBoZWxwczoNCg0KaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4
L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0L3RyZWUvZHJpdmVycy9jbGsvaW14L2Nsay1p
bXg4cXhwLmM/aD12NS4xOSNuMTcyDQoNCkkganVzdCBmb3VuZCB0aGlzIG91dCBhYm91dCB0d28g
d2Vla3MgYWdvIGJlZm9yZSBJIHdlbnQgdG8gdmFjYXRpb24gYW5kIHNpbmNlIGhhdmUgdG8gZmlu
ZCBvdXQgd2l0aCBOWFAgd2hhdA0KZXhhY3RseSB0aGUgaWRlYSBvZiB0aGlzIGNsb2NraW5nL1ND
Rlcgc3R1ZmYgaXMgcmVsYXRlZCB0byBvdXIgaGFyZHdhcmUuDQoNCkBOWFA6IElmIGFueSBvZiB5
b3UgZ3V5cyBjb3VsZCBzaGVkIHNvbWUgbGlnaHQgdGhhdCB3b3VsZCBiZSBtdWNoIGFwcHJlY2lh
dGVkLiBUaGFua3MhDQoNCj4gVGhhbmtzLA0KPiBQaGlsaXBwDQoNCkNoZWVycw0KDQpNYXJjZWwN
Cg==

