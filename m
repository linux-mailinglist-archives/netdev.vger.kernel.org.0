Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF92E6B983A
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 15:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjCNOon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 10:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjCNOoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 10:44:37 -0400
X-Greylist: delayed 18369 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Mar 2023 07:43:15 PDT
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.133.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E170DA54CB
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 07:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1678804994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S0jyx4/mx+fG6mXEn0+FW19xji6q7dFTqdOV0azMqsA=;
        b=Rz0It18zjLOQ49n/JL0uyUeofkHGJ3IMBnsfwfP4o8muhALhAI/OAFvchPz3JxxRGp9QsS
        ZLC8X4NWZWy2qkztOXUUhaDtO5dghhNrOcRLLvcDVGsCNw0nTK1zbIUvDemKcK/yPqd9Cu
        ifc6SImxLTDpeN2NlKmA3hXxwj3NViDTd3em5Acas7DSDvMieer8t4ppXJ+hxsXuJ8gyL+
        YJHaLh7bj7ILgycD90H+K2d68tJYLPm8dyFe7GQUcthOYcl9Nal+8k3ZEXD2wBi/pcSfwH
        22677ynqPq0rhRAL5hejZzL4wsot7KjchacNDi4j70OTYtLob4k1uAEfowmDlA==
Received: from NAM04-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam04lp2047.outbound.protection.outlook.com [104.47.74.47]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-RcgcNNa2OZ2BeAQvoWloAg-2; Tue, 14 Mar 2023 10:43:13 -0400
X-MC-Unique: RcgcNNa2OZ2BeAQvoWloAg-2
Received: from PH7PR19MB5613.namprd19.prod.outlook.com (2603:10b6:510:136::5)
 by DS7PR19MB4470.namprd19.prod.outlook.com (2603:10b6:5:2d0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Mar
 2023 14:43:09 +0000
Received: from PH7PR19MB5613.namprd19.prod.outlook.com
 ([fe80::75b8:239d:a9cf:9839]) by PH7PR19MB5613.namprd19.prod.outlook.com
 ([fe80::75b8:239d:a9cf:9839%2]) with mapi id 15.20.6086.024; Tue, 14 Mar 2023
 14:43:09 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>,
        Rahul Tanwar <rtanwar@maxlinear.com>,
        "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH net-next v4] net: phy: mxl-gpy: enhance delay time
 required by loopback disable function
Thread-Topic: [PATCH net-next v4] net: phy: mxl-gpy: enhance delay time
 required by loopback disable function
Thread-Index: AQHZVliJUvK3ehimmkKPqfhPbGFpD676S1CAgAAD6gCAAAqqAA==
Date:   Tue, 14 Mar 2023 14:43:08 +0000
Message-ID: <4219e4e0-dc44-1c23-8ae2-05cafee54bc6@maxlinear.com>
References: <20230314093648.44510-1-lxu@maxlinear.com>
 <67a3a8f3-5bee-4379-890a-6c8e8be391a8@lunn.ch>
 <1e78d2e117fbb8e409f54a00694dc324@walle.cc>
In-Reply-To: <1e78d2e117fbb8e409f54a00694dc324@walle.cc>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR19MB5613:EE_|DS7PR19MB4470:EE_
x-ms-office365-filtering-correlation-id: 63dba2c8-9382-4365-ce7d-08db249a6dd9
x-ld-processed: dac28005-13e0-41b8-8280-7663835f2b1d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: mgsYUP1qzpaZfLBJbAfck6nrCfDVFg5hywjosBlVQFI8wE2PW321l73dDUR5QmTuTNDqFy4SY9XgFOtJ4h2nTl4HFTmuSf6f3w5RNxoeNXE0LoYfGSEbATTQF4ae+QOkgTRwCSeZctxI8pU3id6bZLjyr6ldTkUdH0jyRpRNBs9NiMpwbdOanP0PUd0qnAlSe32+heh9eEJKaDHM5STrueMKKGRzdYvz3u++71E3VJpDRL29ArxbdT40AOdVWBzsYEEKuOLisPNiqIuTm40nuhLNm0Hu2cNA6+QoapUEJbYA96UJKXpBftGYUD+UZzkIPUnwtbE5TWlikQl8qMEKGgGZunbZJ/oI99P2PhyZ/usDLXRoy/Z1+COF9bOf5rlehjKi2HjpDP4lKJbL/61dt9D6sGB8rW35jx5DmqGjgdB2hHeZ9tgaNaXR9mpIK4dGDGWIDeWmrHhimIYPhyjMBzz9Ii2h9nhB4sQQVSezVPJcp6pF7RMZtnZn7Fa91qBRefiOujXBUO++7COFtlu3u3JSvWk4V9l1/kKHFzAiuMKq4H2XWY07nNq+FQsjCSEU8WDAldbjG3ZFhSDp7QeVfxSjg6c9bsfzN1jUGl/Ca1ie71ppfLsNmXhFMz+ApIs9+CifENF39czUBlate4JnUONCqqZlMBKdEU/JHdJLnF8hR+2wKSGvvyOHMkATf2SPQS6d/t2bPzesg6NngZJFo5jNUkmbXttFkgXLZmePRLomNO0KXXRVA+PBSO1841PEwvCZ57PGud5MHMk0L17TUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR19MB5613.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(346002)(396003)(39850400004)(136003)(451199018)(5660300002)(2906002)(8936002)(41300700001)(66446008)(110136005)(83380400001)(4326008)(31686004)(91956017)(7416002)(64756008)(66476007)(8676002)(38100700002)(186003)(66556008)(478600001)(54906003)(71200400001)(6506007)(26005)(6512007)(31696002)(6486002)(36756003)(53546011)(2616005)(86362001)(66946007)(316002)(76116006)(38070700005)(122000001)(45980500001)(43740500002);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NHZlNUVuZ1g4ZVhpNS9IZUdSUFJjNExYb2UxRU9yNkp1WWorcnVjKyt2RkFQ?=
 =?utf-8?B?VlN0SDNSYW9kdzdpN0JMbHU5bFBhN0g1RXNGQ2RjcVJycWNaMUF5L3c1ZlY5?=
 =?utf-8?B?MlhNZitUVjlMckVocEY4K1YzVk9RbTVhMGNkUDVCdHp0VVdrZUhsOWtnZWlO?=
 =?utf-8?B?NlJLcHhzbkpRQWFhTVBNakJON2Nud1ZYT252UTJ2VVh1MmlJSk1kTlhmc1kv?=
 =?utf-8?B?WGZHM2R6QkFJZnBJd0RGU2Y1a3dnbnpib09Yd1czQytUZEpzK0RGTkhTdG15?=
 =?utf-8?B?bWRkdWdOSUZEVk13a0RiMlRUUXdwbGJMb1poZ1ZJelFPZGxLUEJIeWRmZFZY?=
 =?utf-8?B?TnBkZzVZWVhjRk5zRnA2MUV1WWsxZkdHN05hZFo1UHFQZDJCM2ZQZkVCb2hi?=
 =?utf-8?B?T2EzMDNuRVdrK3kxUWd6ZTQ4NGsySmR2MkFoQ3c4Ni9MQU9NaFc1V3M1NGcx?=
 =?utf-8?B?Q2w5dmI0d1RvNzZlYUtXSVRQb3UxRGM5T3k4Rks1ckpLVDIrWWJMYmhXWnVx?=
 =?utf-8?B?Z3k5Y2xmTWRGcE1oTm9NbU04cVpWRllQQlFtSWhqZFJJWnFmcmoxNyt5WVhT?=
 =?utf-8?B?TXNtUVVzQmhlaEVSYWlwaXRQcmNTK21VejJJeGllcXB1MWZGemtFNDZOcS9n?=
 =?utf-8?B?QzlsalI2K0RCb0UrUUl4NUtDSU1McWtLM1NJS0gwdmdWZWs2cnFnUkNaemVL?=
 =?utf-8?B?VDRWUi9XcTB6cU1JWlgxVnovSEFnZnB3ZkV2V2ZoNkVQRFpkZitDNFdDa1M1?=
 =?utf-8?B?dVVOZ1lzNG85Vyt6bU5pazIwNXViNmNmSDN0U2poOUpRVnVRTjBHYmM5b0M0?=
 =?utf-8?B?MGZuVXdHSitsN3ZQb3RSTGt5ZnNIUlNCdDlmWFFhNmZSSUN6MElNQ0tBMlA3?=
 =?utf-8?B?RytzTnBWOTJzZ1E4UE9mN2R4V2tjNXBzK2IwVDFtbk5lQnNSdm5CWGpNQmxM?=
 =?utf-8?B?WVdXUHhQenFxNVZTUWxvNHhvU1ZGdmZlYmV2enpHdndTT1VJSnYvdHl2aVAz?=
 =?utf-8?B?QWRYM3Q5ZGFCRW94RXNSeG9zb0U0K3pPd3RUeWRjN21VUkwxMXRxVEpOcU0z?=
 =?utf-8?B?dUlWOVA5bmh0VEpYTEdIVk9WSlIrR2Ywek5ybktBbVh2OHdTc1djdkJvdlB0?=
 =?utf-8?B?V25CR0UxeFlibHdCcEh6K1gzcS9tVlVyczAxZlRxM0tjV213azhxL28wSkp2?=
 =?utf-8?B?OHdZSHZ1S3VIcC9zMElqVzUxNkljK25PL1hCSWNLZjFaV1JLMjNOa3RCM3Uz?=
 =?utf-8?B?TWhEWDR4dTJuTkpwYVZLeS9QL1JuanYrano5N1VibjJQYXVXejJGM2t0Yi9P?=
 =?utf-8?B?RWJqYVJQWTY3STllMEtYT1g3bjllZFd5Z0tPWS92Z2djZ2d4MklHUUpKWVRT?=
 =?utf-8?B?d2owa2FBSVltM21JSkVSZXhuOW1UOUJMNnEzbnFENG1XYkVlek9WQzM3c3gv?=
 =?utf-8?B?eFNIdlY0Tjc4SUROcnJPNGxHTGpxWEduQkhQSlVjNS9IWTR0YzF3c3J4bkFL?=
 =?utf-8?B?NlpIS1Q5SVMyT0RLejBxSXR2aDRTWTB6aFAxU0Z0RVc1UTRHeG5mSVdlNXI4?=
 =?utf-8?B?cC93eTlXWXY5OU52emlZVUhMOTdlUkFlWDYrV0dkblRYVDhMcndnc2RDaEo0?=
 =?utf-8?B?bHIvYVhQRnNwdXIzVEVJcGI2QU9pdENiU08vSURWRDQ4R0lENDFycmdrT3NV?=
 =?utf-8?B?N2V3cCt6cmRFb011UVozSCt5QTlXY0pkS3l3VThRRk5ycDBnc3F0MzVXdndj?=
 =?utf-8?B?eEtnSkNYcFZVV1Fxb2JidU9xTUFhaTRzOFpJSzBpRzlhQkI2UWYxeUF6NUlK?=
 =?utf-8?B?U3dQZXc3NkM0K0JHVVJINkRhOGdueUM5UWxlVmdPNWdyWkJOamxhQWEwZ2NB?=
 =?utf-8?B?QUdZalZYRVlMMUxRaXAyWUFDT0tPMVFmWVhzY1Y5RnBpN0UxSHJvQWs3c1F3?=
 =?utf-8?B?N2VyUFZBamF2YjkxckVoVEVSenlLcDBTcVJwV0xVUzBISXNQNm96SWFFUFU3?=
 =?utf-8?B?ZmN5U2h1RGJqNDlQcys1SlNmN1FWRlZnTURVYjBhV0VORU1sbGhOVEIrTm1M?=
 =?utf-8?B?OVBLc1hvd3cza1N0azBHS05wTUV6L0M1UW1MRjdkV1Y4c2huUDVoRWtvalFU?=
 =?utf-8?Q?Cd48=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR19MB5613.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63dba2c8-9382-4365-ce7d-08db249a6dd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 14:43:08.9142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gNdHZ9gB01AueLgpgh0r+/WIG9xo0vXMKd+vVyJwURVmXn6IJzIsLi2ETyb6d/xT1EMK5+kkqj666BBvjvjSOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR19MB4470
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <9110E84AA4578D40AAD0C856ECC27A69@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTQvMy8yMDIzIDEwOjA0IHBtLCBNaWNoYWVsIFdhbGxlIHdyb3RlOg0KPiBUaGlzIGVtYWls
IHdhcyBzZW50IGZyb20gb3V0c2lkZSBvZiBNYXhMaW5lYXIuDQo+DQo+DQo+IEFtIDIwMjMtMDMt
MTQgMTQ6NTAsIHNjaHJpZWIgQW5kcmV3IEx1bm46DQo+Pj4gK8KgwqDCoCAvKiBJdCB0YWtlcyAz
IHNlY29uZHMgdG8gZnVsbHkgc3dpdGNoIG91dCBvZiBsb29wYmFjayBtb2RlIGJlZm9yZQ0KPj4+
ICvCoMKgwqDCoCAqIGl0IGNhbiBzYWZlbHkgcmUtZW50ZXIgbG9vcGJhY2sgbW9kZS4gUmVjb3Jk
IHRoZSB0aW1lIHdoZW4NCj4+PiArwqDCoMKgwqAgKiBsb29wYmFjayBpcyBkaXNhYmxlZC4gQ2hl
Y2sgYW5kIHdhaXQgaWYgbmVjZXNzYXJ5IGJlZm9yZSANCj4+PiBsb29wYmFjaw0KPj4+ICvCoMKg
wqDCoCAqIGlzIGVuYWJsZWQuDQo+Pj4gK8KgwqDCoMKgICovDQo+Pg0KPj4gSXMgdGhlcmUgYXJl
IHJlc3RyaWN0aW9uIGFib3V0IGVudGVyaW5nIGxvb3BiYWNrIG1vZGUgd2l0aGluIHRoZSBmaXJz
dA0KPj4gMyBzZWNvbmRzIGFmdGVyIHBvd2VyIG9uPw0KPj4NCj4+PiArwqDCoMKgIGJvb2wgbGJf
ZGlzX2NoazsNCj4+PiArwqDCoMKgIHU2NCBsYl9kaXNfdG87DQo+Pj4gwqB9Ow0KPj4+DQo+Pj4g
wqBzdGF0aWMgY29uc3Qgc3RydWN0IHsNCj4+PiBAQCAtNzY5LDE4ICs3NzcsMzQgQEAgc3RhdGlj
IHZvaWQgZ3B5X2dldF93b2woc3RydWN0IHBoeV9kZXZpY2UNCj4+PiAqcGh5ZGV2LA0KPj4+DQo+
Pj4gwqBzdGF0aWMgaW50IGdweV9sb29wYmFjayhzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2LCBi
b29sIGVuYWJsZSkNCj4+PiDCoHsNCj4+PiArwqDCoMKgIHN0cnVjdCBncHlfcHJpdiAqcHJpdiA9
IHBoeWRldi0+cHJpdjsNCj4+PiArwqDCoMKgIHUxNiBzZXQgPSAwOw0KPj4+IMKgwqDCoMKgIGlu
dCByZXQ7DQo+Pj4NCj4+PiAtwqDCoMKgIHJldCA9IHBoeV9tb2RpZnkocGh5ZGV2LCBNSUlfQk1D
UiwgQk1DUl9MT09QQkFDSywNCj4+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBlbmFibGUgPyBCTUNSX0xPT1BCQUNLIDogMCk7DQo+Pj4gLcKgwqDCoCBpZiAoIXJl
dCkgew0KPj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qIEl0IHRha2VzIHNvbWUgdGltZSBm
b3IgUEhZIGRldmljZSB0byBzd2l0Y2gNCj4+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICog
aW50by9vdXQtb2YgbG9vcGJhY2sgbW9kZS4NCj4+PiArwqDCoMKgIGlmIChlbmFibGUpIHsNCj4+
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKiB3YWl0IHVudGlsIDMgc2Vjb25kcyBmcm9tIGxh
c3QgZGlzYWJsZSAqLw0KPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChwcml2LT5sYl9k
aXNfY2hrICYmIA0KPj4+IHRpbWVfaXNfYWZ0ZXJfamlmZmllczY0KHByaXYtPmxiX2Rpc190bykp
DQo+Pj4gKyBtc2xlZXAoamlmZmllczY0X3RvX21zZWNzKHByaXYtPmxiX2Rpc190byAtIGdldF9q
aWZmaWVzXzY0KCkpKTsNCj4+PiArDQo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcHJpdi0+
bGJfZGlzX2NoayA9IGZhbHNlOw0KPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNldCA9IEJN
Q1JfTE9PUEJBQ0s7DQo+Pg0KPj4gTWF5YmUgdGhpcyBjYW4gYmUgc2ltcGxpZmllZCBieSBzZXR0
aW5nIHByaXYtPmxiX2Rpc190byA9DQo+PiBnZXRfamlmZmllc182NCgpICsgSFogKiAzIGluIF9w
cm9iZSgpLiBUaGVuIHlvdSBkb24ndCBuZWVkDQo+PiBwcml2LT5sYl9kaXNfY2hrLg0KPg0KPiBG
aXJzdCwgSSB3b25kZXIgaWYgdGhpcyBpcyB3b3J0aCB0aGUgZWZmb3J0IGFuZCBjb2RlIGNvbXBs
aWNhdGlvbnMuDQo+IHBoeV9sb29wYmFjaygpIHNlZW0gdG8gYmUgdXNlZCB2ZXJ5IHNlbGRvbS4g
QW55d2F5Lg0KPg0KPiBDYW4ndCB3ZSBqdXN0IHNhdmUgdGhlIGppZmZpZXMgb24gbGFzdCBlbmFi
bGUgYXMga2luZCBvZiBhIHRpbWVzdGFtcC4NCj4gSWYgaXQncyAwIHlvdSBrbm93IGl0IHdhc24n
dCBjYWxsZWQgeWV0IGFuZCBpZiBpdCdzIHNldCwgeW91IGhhdmUgdG8gYXQNCj4gbGVhc3Qgd2Fp
dCBmb3IgdW50aWwgaXQgaXMgYWZ0ZXIgImppZmZpZXMgKyBIWiozIi4NCj4NCj4gQWxzbyBpc24n
dCB0aGF0IHJhY3kgcmlnaHQgbm93PyAicHJpdi0+bGJfZGlzX3RvIC0gZ2V0X2ppZmZpZXNfNjQo
KSkiDQo+IGNhbg0KPiBnZXQgbmVnYXRpdmUsIG5vPw0KPg0KWWVzLCB0aGlzIGlzIGEgYnVnLiBJ
IHdpbGwgZml4Lg0KDQpBbHNvIHVzZSBqaWZmaWVzIG9ubHkuDQoNClRoZXJlIGlzIG5vIHJlc3Ry
aWN0aW9uIHRvIGVudGVyIGxvb3BiYWNrIG1vZGUgZm9yIGZpcnN0IDMgc2Vjb25kcy4NCg0KPiAt
bWljaGFlbA0KPg0KDQo=

