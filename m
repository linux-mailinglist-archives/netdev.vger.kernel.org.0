Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B932F4F57F9
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 10:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242447AbiDFIVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 04:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354785AbiDFIUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 04:20:07 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120058.outbound.protection.outlook.com [40.107.12.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BD03D8981;
        Tue,  5 Apr 2022 22:53:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWUVmCkzAv5AppfhquhfCIGYODRX4wMfNayWjlgZSQM3Inu6kUqHm2FPFPATrXUVxrKZ0DJKAUPThW116h+DgSt5m3mfq/xqKy8abREpydvyv3kMlMdGKaM/ECqv1g+jB0SFVlH4rERkOLBr5TS4QrsY61/HOrceMehqwOMIafl9faZsJQVN6z0tvkpaJHfQ53mT7SfHlsR5BCD9oUe8twdBtQHLsIKjfrOe5GwI1EjLgtrr6o9P9It/5McxAtoLoj+WzhUpCM31n7/d+c16wdVBXZuE2YIAyO6HxQtQYVzHCIXcdCpYwqKN2VQLJLaI4LPDwygUy+b7fRba4eKzDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WnZz3KnX2t0NTMgeVsoLIXr2Knv2KaDbuVGTTU4Zwm4=;
 b=hwrf/9QctZFOyRwWTGk9vcvs16R0mG5EGKopoZ7xQlNewF+BCGYutSx35P9y/2Jsl5zclPAinUtT8EhE/1vwl2juQgvV1nt2VnNOn+POeHbA/fMd/H/lfoblcYc9allsgN5l9TjtMLvuFNe+IG+UFb1UixDX2SDb1ULT41Aw+MCUeXpk3zWI/9oU8gEQKhTmH7XYMZct1zMriNbng/bNoloz8pByotj6K3ac9u1vNcEKTeRysRSEG8wBEeWx8TLf3mqfxQGX1ZZikcEPNzXxR+1x2xcSTm8Q0ixqCUgoYP4l5XivaaLb26FXOleqHoLhhy2j5VMJ2Dm3zj4ZeE3ymA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB3011.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 05:53:46 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::59c:ae33:63c1:cb1c]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::59c:ae33:63c1:cb1c%7]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 05:53:46 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] sungem: Prepare cleanup of powerpc's asm/prom.h
Thread-Topic: [PATCH net-next] sungem: Prepare cleanup of powerpc's asm/prom.h
Thread-Index: AQHYRnrdmIDrva6DkkmRu6Wgc/GcSKzhyLiAgACfrIA=
Date:   Wed, 6 Apr 2022 05:53:46 +0000
Message-ID: <f43aa220-dcef-bc4b-ebb5-74268581e3e6@csgroup.eu>
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
x-ms-office365-filtering-correlation-id: f81f718c-85cd-411d-bbbb-08da1791d079
x-ms-traffictypediagnostic: MR1P264MB3011:EE_
x-microsoft-antispam-prvs: <MR1P264MB3011A193C3DF32D3DFB30636EDE79@MR1P264MB3011.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fOA0kjVSXDlFkh1bVx2sUWtQBEB4Vc/DBe5K+/JMMLMstdzJlb66i79/YdBQDy07xaM513HZyXOKqJcC2i9GwC3zL4RcBX/7CWqZ5lQ8d4GnRXS8THBPKs9j03687Ss39X6uA4csXE/gbgosq6ROabz/BCWgVmvmWJGI62jjKaKLrn2DnBOvrQu9eoo6IuV2JhL+Ge7yLU6gnfySzH+dZB+36/rdYqpPCEkTCpNEKofROyW0UzxphwSjHkaq1LqvUJLCnqf41xO5bP3oiQyzd3OGM1vlPpT80NoAUsC8xyNASJgctHFPAz9mILBxhP8UGQtMLBERuXgMNGcVLuqudXl7btLu7NaJ1fCR3ETVuFrHp30AH6+isRI1pU9CbCrvvccUzZn4Gi7Q42i77yCRPiSMt4+Paf2ET2DTO4R6zUWiZv8juucYH/PtWpOEbhosW4ELHHMNFeHRPrjw80lTVBTwmQ5/yRopROTcVZGT9559/cjh09kZ0f0DeaH5kOk5vqg31Khytz14Kxhm+wCxDIdHOf85GYzfHMY55oi9IPPrYEyNYGrF/7jh/Bk7U+o2bcRxvZP9gWv8yKhJRQMfe37XikSLdNk3CVVfVN82GTvlrCekwm8GSaQS3Wp2ByTz4sod7u7U5c+LUxGN7f3YmZCI2ki6tFBtB5mwjbvWodYw6Qvb0Mc4XAU7j4vMnlhKR0Oi+Dr9BsY+RwGXThk5Z72qK7cNnjm5A52CFQjFMuNUTq4JC8N/7BKDULHgee3Zgj3Kc7MgHKDOwLWvjWNX1ncAkSZVEo3Bgvzkx8CObCFOYGRGfQqMaFS7uZbzXvgBLzGFJcyF32gsEzus6RmfL0+a5dmwgSslJhoV0MJiobM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(91956017)(8676002)(31696002)(8936002)(5660300002)(66946007)(66476007)(66556008)(6506007)(64756008)(66446008)(76116006)(316002)(6512007)(86362001)(83380400001)(4326008)(4744005)(6916009)(122000001)(6486002)(71200400001)(31686004)(966005)(36756003)(54906003)(508600001)(26005)(2906002)(66574015)(38100700002)(186003)(2616005)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YnlaL1FTQTJKbE5ZTXVDZW9jb0FpR2NIb2hOblljOEYwYUZreW45OFZWdnBC?=
 =?utf-8?B?ZzgycktKa2xlVGtIMkROVy9ld1F5ZmkweDdSZnR4RG05RDdHWlRrZGJJMkt5?=
 =?utf-8?B?T3FJT0l5cUpHZnIyTUs2V2pxR00xQ0k4NlAvNno3cVEzMTBVa3I5cE1WaGl5?=
 =?utf-8?B?WHgrWlIzSWc4aVdJbktLVXYvazkzL1B0V0pXb25iOC9keEVMU0U0dzRaSW42?=
 =?utf-8?B?M2MvMnUxWFhmRExaZ0xlSUFQdXgzOVliOUpGcS9YcHVjTkpXMkxLcFdSNHpH?=
 =?utf-8?B?alFYc21saitnM0x2QS9HVmRIRVRQTmNmS25HRjUwUE9wMXBwS3o5bi8vaDJw?=
 =?utf-8?B?SDN5emkwSjFtR0pwZXpVNmcrUDNpdExVY3FvU3VFd0d4TVprYVZnVDFiZ3dj?=
 =?utf-8?B?RndzRjBSMVlRUjJtL20xcUozVHg2QndxRzl1bzZMR3c5Z3hWVkIxTFphRlhJ?=
 =?utf-8?B?ZnBrbUthdjErMjh0ZE04YmlxRGZUNWxCdVRxZkhMQkFLSllBV3JackZkdUZJ?=
 =?utf-8?B?cVZVSGlnQ1NvZVlHaE9STk5obENaYm9yS3VNQTB6RUk2ZVMyb2FGcS9IVG5W?=
 =?utf-8?B?c2J1TDFOVzhPSlVPdFA1YzRuQXJvd3IwOUxQLzREVFVXa0JYWkFhU3IvcVJv?=
 =?utf-8?B?MVhBbStMUVgvVmNFeldhV1l1aTVoZjExUXRycTZDOFhmMWZHS1JqNVR6UmJ4?=
 =?utf-8?B?VjZMWUMyZGl2dE9obGhmd0pBZ3JDWGE2bVllQUNTOE9xa2VyK1lUOVkzQURQ?=
 =?utf-8?B?WEZxYUM4T2xDV1dwUnM4REdCdVI0UWhueTQxeER0UzVieXMxL2dzTHplSWM0?=
 =?utf-8?B?Z1pxM1B1QlczZWRPZHdWL25ocWkxMVErREJYQU9BM2hyU01oQm9CU0QzV3hD?=
 =?utf-8?B?cnhMM0hiNU9ZQ25vOC9qL3UxRnZkUWlDQ2RVRitoMERWN1MrRGptT0RydWNw?=
 =?utf-8?B?Sk9lNjRwNFl6UmVSZFlPbytuRUMxKzVCUnFQOWFqbjAxKzdKVks3V3V2SDM3?=
 =?utf-8?B?WCsrVm5TK3MvWmRnTlV1VXhyQWlKbkNmMUhtc3FkOXR4RzQyZlZ6YUJvaFdX?=
 =?utf-8?B?emNPMEFWM2U3WExDTGV4K0hjbXNaQ3JUaTlkRGpFTnU1bm9TQ1RIcmdWTks1?=
 =?utf-8?B?MitXR3RXYlhOcEFuT3h1Um5PNk01YUUxQVQwQWhNbGM0YTR3dDlhTmdNSlZu?=
 =?utf-8?B?MXhYK3RpbDFlVll3RW53Wi9PQjQ5UURWNEt1VlIrbDhVR3UxZnJhOFQvN3ls?=
 =?utf-8?B?ZnlEQzBXR2oxb1pTeWtnZjFCMC9idlVsZmRIT3RPRU02V3VjSGxydHBBR29K?=
 =?utf-8?B?MjMzVmpHR1cwdDh5UnNSVWhHdnRuajNMZ3puT3dHeDh0UXcvZUwzL0wwTmsx?=
 =?utf-8?B?MUZYUU9iNVpvclJqU0NYRkd0U0crcGpQMjNaY0gxR3ZpQzl1enlld2tLUjVP?=
 =?utf-8?B?WCt3U0tiN3JNRmtsNlpwdDVzRzU2bWo3M1h6Q3d4ajlLN3VVdUhocE5JcGh5?=
 =?utf-8?B?L1dpcGJOc1RhQ0svb1pkeHNjdE0xNWJQQ09qc2h2aTFKczBTT082ZSt3WVdO?=
 =?utf-8?B?Mm9Qb0FIT0Y3Ym0xaGU4L1owY1BRLzQxZWdkS1Z4Y05yWjVNKzcwY0VZcWhU?=
 =?utf-8?B?YU5lN2VDMmtacGhIVDBNOW5rejYxd1dvS3hwQVN4TExDdUVMblUwbGp6S2th?=
 =?utf-8?B?dkJ6MXRnTkJneHpSdzA0RTVzcnR4QWZQdXFMZHRxOUtEYjh2ODlxNzU5ZXVU?=
 =?utf-8?B?ZVFUVmR5K2Juc2ZxSkIrSk5hYytFR2FqQlVQeWREWlRVSzB1R3hFRXdZcWdo?=
 =?utf-8?B?RjVVa1hhOGR3RDVtZ3kxZCtaeGFtVVNaZ2xRZUx4TDhqR3FRNXY1RkZhTkV3?=
 =?utf-8?B?UDFOUStOM2EwemYweU9KdzJMb0xRSXN1TmdCYWY1cnZVWVdjL2JGWUhjR1Y1?=
 =?utf-8?B?Yy9SbWVvUjVUclJPMVZWdlh4Z1Ywc1dlNVRvZ2ZqcEsxWm9CUVo4NzI4L0pN?=
 =?utf-8?B?WkV1WHRiSHBMcnBoSzlzbFp4SGFpNk9VVlFVQm5saUg4NXRjS1ozQlNnb2xi?=
 =?utf-8?B?bE8rSGZ3c21LM0d5SERKQzMrR0lkMUdhWHRXOUcvS1U4U3NBOHkveG5mdndo?=
 =?utf-8?B?UjhnNDhBMmRPNE9oaFpBN1NXZmFBOUVoR05iZ2lzSXlIalZkT2ZxL1p3a2pw?=
 =?utf-8?B?eXBHZDVoUWRBTVdUUUtlbWJ1clpGUDVjRlV3djRrVTJsdVMxR1lvYlhIRXVo?=
 =?utf-8?B?Q1MwVWp2a3VoZFZaNExYS3JnbitnUUpjQjJLME1YcmtkK08yeWR0eERKZjZo?=
 =?utf-8?B?bDJtMU15MXFEcHdtSHRHdzZFL3lQb2YrY2R2VmUwMld6c3JlN29vbkdFeXJ5?=
 =?utf-8?Q?/uytqCTAlH8WGwU0M50yAZYRgs3lFIYvoZyd6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4E86430A174BD4CBE88B4D955F7149D@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f81f718c-85cd-411d-bbbb-08da1791d079
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 05:53:46.1056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K0zWQ2luO1hWC78EwwTVr/xrAPmvGT8zaMrrAjJ3XBgQi7gWVBRf/53wsPFpqe/jrcI1ek1qpWiQz0WpLuUgIUHK+FP5HycuVk0GzCd9mO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB3011
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
Cj4gQ291bGQgeW91IHJlc2VuZCB0aGUgbmV0LW5leHQgcGF0Y2hlcyB5b3UgaGFkPw0KDQpTdXJl
IEkgY2FuIGJ1dCwNCg0KPiANCj4gVGhleSBnb3QgZHJvcHBlZCBmcm9tIHBhdGNod29yayBkdWUg
dG8gbmV0LW5leHQgYmVpbmcgY2xvc2VkIGR1cmluZw0KPiB0aGUgbWVyZ2Ugd2luZG93Lg0KDQpo
dHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3QvbmV0ZGV2YnBmL2xpc3QvP3Nlcmll
cz0mc3VibWl0dGVyPTE5MjM2MyZzdGF0ZT0qJnE9JmFyY2hpdmU9JmRlbGVnYXRlPQ0KDQpBcyBm
YXIgYXMgSSBjYW4gc2VlIHRoZXkgYXJlIGluIHBhdGNod29yayBhbmQgdHdvIG9mIHRoZW0gaGF2
ZSBiZWVuIA0KYWNjZXB0ZWQsIGFuZCB0aGlzIG9uZSBpcyB0YWdnZWQgYXMgJ2RlZmVycmVkJywg
c28gZG8gSSBoYXZlIHRvIHJlc2VuZCBpdCA/DQoNClRoYW5rcw0KQ2hyaXN0b3BoZQ==
