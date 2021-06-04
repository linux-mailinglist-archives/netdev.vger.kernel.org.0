Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460E639B939
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 14:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhFDMxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 08:53:54 -0400
Received: from us-smtp-delivery-115.mimecast.com ([170.10.133.115]:58783 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229718AbhFDMxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 08:53:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1622811127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=19ZY/xxcU1gatRAXQka+MY4dJ8vmH8e/wriireMZ7dk=;
        b=v2+i8Gagg9fFEOd0C6TgC1Zw861OnXPtRidmBSPTQ/QZUoMYjO4mOHgYHouhwaZdZHViSu
        6yH0CeAIzfmdv8RLAtGjk8VimSdiHWjlltJg/QYkjv/8xM5Etczu2OzFknYzibz2nVp9dk
        X2+V4jOjllt5j67fe9KgyzXmM/BpNzE=
Received: from NAM04-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam08lp2175.outbound.protection.outlook.com [104.47.73.175])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-tKRthYaJPHWEVCUdz0JOdQ-1; Fri, 04 Jun 2021 08:52:05 -0400
X-MC-Unique: tKRthYaJPHWEVCUdz0JOdQ-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by CO1PR19MB5016.namprd19.prod.outlook.com (2603:10b6:303:d6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Fri, 4 Jun
 2021 12:52:02 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 12:52:02 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH v2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Topic: [PATCH v2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Index: AQHXWEr5aRzQQmYLZUuI1qUONcx6wKsDxf8AgAAKPYA=
Date:   Fri, 4 Jun 2021 12:52:02 +0000
Message-ID: <797fe98f-ab65-8633-dadc-beed56d251d0@maxlinear.com>
References: <20210603073438.33967-1-lxu@maxlinear.com>
 <YLoZWho/5a60wqPu@lunn.ch>
In-Reply-To: <YLoZWho/5a60wqPu@lunn.ch>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
x-originating-ip: [27.104.174.186]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 575c6507-a3f2-424e-14fc-08d927578ca8
x-ms-traffictypediagnostic: CO1PR19MB5016:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR19MB5016A8302CB821825D387706BD3B9@CO1PR19MB5016.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 16Z9KCg79AFXoDMTHQ4FVcEhdI6Xz4xVjuY2iqZpv25Zu0WwtlNJWnVsE7S14btdcpLhoQN3jLaatJ3irG4jQ/ByOoaw8NhT7hJE831KBgRWBws6wrCqpj4dxmt+zSg3qBpARVMwGc5SNXf1VgCEt30++dmQt6tif1zWn1l3aal0dTGCcuaaBNRSuG2RIYuiVy9Os3T+N5PNjgW3vi+hRtcLbH2SKkS+FJ7kC8DgF+X/nXc5c8wC6uc+6mJPxxW2I5pFqaL9VSY48BuOCkGDmfv72kAAE4ixPoCtTGIBZhiBNVcbQXbENCbrJM2dLeyPKPduyrZLG7HLpmyF7ZgZOco+VTfg7LRTIaG1wSOir5fiW/lYB1jVlf0pj3WxszKUxRfUOd7FjsVMQqvzpM64aHvV9y1/dZOlapoDfZfVOf+50bWNh0IcW/w2oVNse3qxg5XCpD/Sg5HSlj2VkovNctB+ly8S2+KQBVDwq9NxRbiG55PZX4vjXBFirFOZFekp+CG57cQJ4nEZgrai4Lvdm/fX/qNv8L0vvSlqI9EqFfUJxezXPkpV1jRo18kLoT7UdJN5ev8/YZS6ROFgbOWgi/qf5dkHDfosqjJs4J74ZSJxk7/BSAFXkTxIjCHvT8qo8DatBRwLukzZJNiNZrAoyLcvHoGxN2mX5Ngi8SbRA2fkz36l5Vk1qfmTZS+3R9+C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(346002)(39850400004)(376002)(6916009)(31696002)(4744005)(8936002)(8676002)(6486002)(66446008)(64756008)(6512007)(5660300002)(66476007)(66946007)(76116006)(66556008)(91956017)(36756003)(71200400001)(26005)(478600001)(38100700002)(316002)(122000001)(4326008)(107886003)(6506007)(2906002)(186003)(31686004)(54906003)(86362001)(2616005)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata: =?utf-8?B?U1RkazhsMkw5dGU3REUvUFFGVGhGU29BOTh6SkkwTXZlMFRvSHhFRjMyN1Ar?=
 =?utf-8?B?MjJvY0Rqa1RrVmxiaWx6elNnTjV4cUppRUtmMHFUdlJlT2lWL2JWdFB0K1dx?=
 =?utf-8?B?Q0c2Sm9kMkZiZzc3dm13SkhzK3JJRjFvaVRiaE1YRFRaM2lBc0tnVUo0aTVC?=
 =?utf-8?B?b3NsQmd3QTRPUTlna1lQeEdiS2lhL3dnZENjZkZYbUFLSEhjWEg3RDE1WlZD?=
 =?utf-8?B?MTNLaHhOS3J6YXVLZGRFRVZGV2hhR3hTa2NXNjY1Q3MyN1F6dnNQVkg4aVQw?=
 =?utf-8?B?dHhJN0V2MWt1bzh6Y1dPVkxyTDlFVGdCZ25nbGUzZzIzcW83cTUrcXd2dnZs?=
 =?utf-8?B?dXV2eGdVSVZCaFJ5UjBzejlCY1NNTVY5SUpDTnliRmpHN0FNMVBJMWNRa29j?=
 =?utf-8?B?NVRhQ3F6Y1A3VWdSSTlzRm53MlcwUko4dmFiNUxFMVhWYlA4dVhqeTRLQjB3?=
 =?utf-8?B?c1BzM016Sk5tR1VDY1VNb2ozTzU1OG9aYTJzSmV5ODZHbSs4WGNQMkRRdi8y?=
 =?utf-8?B?a25vM25PM1BYVEFLSDhtK0tYaE45a1dDQlBGYWJya0JsM0p0cTNyby9LMk5S?=
 =?utf-8?B?akxwRWhONVFmaVdHektDZmJDdTBYVXRXV0lLZzRXb1RLSVNWc0hsdXJJemVC?=
 =?utf-8?B?UWFFQUhiNVB1VTBqTzhIVGtYTEdEa25zSnk1azZZYTAvZUFJTkJSYVd0S0RN?=
 =?utf-8?B?WVhVZnNSY1djS0RRV0V1bWpCcjdxLy96K2VtOUFVa3JEOHVYbXhDZVRlNTM3?=
 =?utf-8?B?Vk1KR1lXejlPRjNxMDREb2U0blUzdWRLc0tLWlJkNVJPWTgydmgzU0d0MWNm?=
 =?utf-8?B?cEtsbVBWL2g1dXdEZnJ3SVg3MDZYN3NlblpVTHd1N1Zib0hnVTdOOHNUZGxX?=
 =?utf-8?B?cHhoYmVwR0ViZFNqMXN4b3FJVW1iRjZ3K0J5bUZ3ZHBXS2kxQ3h6QVRSQVN0?=
 =?utf-8?B?enFwaWJTaWViakZSSXR4RmZBVENIbEJ5M2pWRVJjOVRmV2xOWjdzdFlGNDdD?=
 =?utf-8?B?N2lkbU1ZTTYydDlpaEhlbDBPd0dKTythbnRJQlFyaGRSQXk5N3l5R3loci9n?=
 =?utf-8?B?ZzRZWjR4VFpyeEpoTmdZWEpwNmdKb0FQQUlKOXNubnNzUkhmNVVEUDdGalVM?=
 =?utf-8?B?bE5OaExzczd2SEVyREpvekd1amN6V0I2Y05vdWtJQXMrN3V0R0FOVWZIQ3lK?=
 =?utf-8?B?QkFueE5jbXoyR3FuMXptZGZHN0ZueDBDZ0FTMUFSTnpKYWllNEdoVm5mdDZr?=
 =?utf-8?B?VWJwU0xaUk8vN2E4a1dQTXMzaGE2eEF5K21leWM4SmtZN1FtSHA5MkxxSUcv?=
 =?utf-8?B?K2x2YnJSaS9VRUh0NmJPUDB2RzBPSkhUbHJlOUJYK1lsWUQ0SWxrMUcxZjc5?=
 =?utf-8?B?a3JxWTZ5eHZZVFFNSVRYYjAyZ3ZPN1NBWXpNL0svTlFjcytBOElBNE0yd0Ux?=
 =?utf-8?B?UG5OWDRTZEd2dnpzVTZPc08xZi8xR2d4WUtiVnNHTlZNN1ZZQkp2VkxyQnM2?=
 =?utf-8?B?d2lmbGJaaU82ZnZlbCtqbGlKaDVpd2hwc29hblJ6VVdZQXZqTWtKdGJMZEF3?=
 =?utf-8?B?bWVVZzhEWlE1bGRVcVg3Rytwblc2dkhTRmJHZis3K21MWGsrNUJkcEZ2Y3RN?=
 =?utf-8?B?NW5vRC9YOEMzQnJsSFFrSGhGNktNQlFNMWhNYTF4QkxjNnJrTzRxYXZ2WjhM?=
 =?utf-8?B?T0llQ2dBY3k0WUM3Wkd3UnBNVWh1M1k5WVBGNlNIZmpUaFYwZnY4citwYUJT?=
 =?utf-8?Q?R4ocpFoibmaEfoTnlY4R5W0onRRNI//ixy2l641?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 575c6507-a3f2-424e-14fc-08d927578ca8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 12:52:02.4030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sAV9ZuZA8U0lkEjUYfgwiGJNaVIqEJpOUpIW66QVDnWK4ylLh7OwVHXWyY22EceCOJnYJFaHqNuUxb8f37k2RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR19MB5016
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <0D275A454BDD6943921D7FC5C2908E0D@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNC82LzIwMjEgODoxNSBwbSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IFRoaXMgZW1haWwgd2Fz
IHNlbnQgZnJvbSBvdXRzaWRlIG9mIE1heExpbmVhci4NCj4NCj4NCj4+ICtjb25maWcgTVhMX0dQ
SFkNCj4+ICsgICAgIHRyaXN0YXRlICJNYXhsaW5lYXIgUEhZcyINCj4+ICsgICAgIGhlbHANCj4+
ICsgICAgICAgU3VwcG9ydCBmb3IgdGhlIE1heGxpbmVhciBHUFkxMTUsIEdQWTIxMSwgR1BZMjEy
LCBHUFkyMTUsDQo+PiArICAgICAgIEdQWTI0MSwgR1BZMjQ1IFBIWXMuDQo+IERvIHRoZXNlIFBI
WXMgaGF2ZSB1bmlxdWUgSURzIGluIHJlZ2lzdGVyIDIgYW5kIDM/IFdoYXQgaXMgdGhlIGZvcm1h
dA0KPiBvZiB0aGVzZSBJRHM/DQo+DQo+IFRoZSBPVUkgaXMgZml4ZWQuIEJ1dCBvZnRlbiB0aGUg
cmVzdCBpcyBzcGxpdCBpbnRvIHR3by4gVGhlIGhpZ2hlcg0KPiBwYXJ0IGluZGljYXRlcyB0aGUg
cHJvZHVjdCwgYW5kIHRoZSBsb3dlciBwYXJ0IGlzIHRoZSByZXZpc2lvbi4gV2UNCj4gdGhlbiBo
YXZlIGEgc3RydWN0IHBoeV9kcml2ZXIgZm9yIGVhY2ggcHJvZHVjdCwgYW5kIHRoZSBtYXNrIGlz
IHVzZWQNCj4gdG8gbWF0Y2ggb24gYWxsIHRoZSByZXZpc2lvbnMgb2YgdGhlIHByb2R1Y3QuDQo+
DQo+ICAgICAgIEFuZHJldw0KPg0KUmVnaXN0ZXIgMiwgUmVnaXN0ZXIgMyBiaXQgMTB+MTUgLSBP
VUkNCg0KUmVnaXN0ZXIgMyBiaXQgNH45IC0gcHJvZHVjdCBudW1iZXINCg0KUmVnaXN0ZXIgMyBi
aXQgMH4zIC0gcmV2aXNpb24gbnVtYmVyDQoNClRoZXNlIFBIWXMgaGF2ZSBzYW1lIElEIGluIHJl
Z2lzdGVyIDIgYW5kIDMuDQoNCg0K

