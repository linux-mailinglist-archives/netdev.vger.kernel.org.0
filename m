Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E574D31ED7E
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhBRRmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:42:08 -0500
Received: from mail-eopbgr1410101.outbound.protection.outlook.com ([40.107.141.101]:38208
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233223AbhBRQPE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 11:15:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SoRcYgaGOD1VHgAL2EYItLOsPE2K4gCvZn5nwv1LGX70ol49J6dEZ1OR6pd52raORfsO48gSC1iGc4mkF12GzJuNSP+birc95xlgZ/6T8XdJCJlQbR9+4+/UYJL3OJxP2ODS3jIG0OJ9VWLQ3ym+G/aLpgLDwUyws2YkKrOEKJNNW9kxQULeH3qzolUauzHyVXobQxtiqa68WtmVdBiJo7keq81AO5ObAWTt9fwaWmbPgT7fzIP535FTAfDPYjAcpSCh4ROGBhRgJLH7kOHwK0F8TxX642dgLa0YYm+7kQEyvOon615eAv8Nlc7fu4R+NNH4ZExwgVM1dInw7DA0Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwVnaT+4zU+LkJVF8xph8egtE/8BvQhjj341vYRR8R0=;
 b=aKjNCFiOoG/YN577TbvoiG8YodshoN3cTzqBkjlZklh4F/eMLeokov+cUB2eiEGMYUK/O1BV8IKEWskXgpFwhjotCC15zcQrMDfVSyvAf9bgFmt6hCKS/HxDorYaotimqQhmgA6fIE0DNEm/JbTrCKivpnNhSofT1RbO7LE09PBriNUyx4hlD/8qw2xTK12vNE4vm8gnvimvdOFX/VHkq9l524sUEKuV89apoi/pzzfj/lIwX/0Sn9qM59zuaZJJvkYt+6jz8RYCcvvRUSUFN2ZXK156C+joWDxeFEX+/ui1jQZI9nuQN1cJjTfdbvNj7wTzqhYyDcNfGyhSUGVhpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwVnaT+4zU+LkJVF8xph8egtE/8BvQhjj341vYRR8R0=;
 b=Db9aE24qIqm9NIzclGWMncvXWPXNATqjsifAI2neQwyWYLE8SpSHfZGGFySTChQtBcqi30foKCJIAcqyqeOg/gXkyxL7gsj2Q6feti8m6Bb9rojSSpQoBHD+FE7T7+51w3vrAZ22S2SQZTGQgJ2nj7ybiRWNWmJNE7aUOyAUqa4=
Received: from OSBPR01MB4773.jpnprd01.prod.outlook.com (2603:1096:604:7a::23)
 by OSYPR01MB5512.jpnprd01.prod.outlook.com (2603:1096:604:91::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28; Thu, 18 Feb
 2021 16:14:13 +0000
Received: from OSBPR01MB4773.jpnprd01.prod.outlook.com
 ([fe80::1971:336c:e4c0:8c5]) by OSBPR01MB4773.jpnprd01.prod.outlook.com
 ([fe80::1971:336c:e4c0:8c5%3]) with mapi id 15.20.3846.038; Thu, 18 Feb 2021
 16:14:13 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Arnd Bergmann <arnd@kernel.org>
CC:     Derek Kiernan <derek.kiernan@xilinx.com>,
        Dragan Cvetic <dragan.cvetic@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        gregkh <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [PATCH net-next] misc: Add Renesas Synchronization Management
 Unit (SMU) support
Thread-Topic: [PATCH net-next] misc: Add Renesas Synchronization Management
 Unit (SMU) support
Thread-Index: AQHXACKOoFb+ofRp20OhBYk2S05d7KpS86SAgADGlHCAAIcoAIAAassggABEPICABhmmwIAAPsuAgAAOzaCAATLmgIAAD7eQgABNoACAAGKO8IAAfRmAgABR13A=
Date:   Thu, 18 Feb 2021 16:14:13 +0000
Message-ID: <OSBPR01MB4773548EE94463B9A595BBE2BA859@OSBPR01MB4773.jpnprd01.prod.outlook.com>
References: <1613012611-8489-1-git-send-email-min.li.xe@renesas.com>
 <CAK8P3a3YhAGEfrvmi4YhhnG_3uWZuQi0ChS=0Cu9c4XCf5oGdw@mail.gmail.com>
 <OSBPR01MB47732017A97D5C911C4528F0BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2KDO4HutsXNJzjmRJTvW1QW4Kt8H7U53_QqpmgvZtd3A@mail.gmail.com>
 <OSBPR01MB4773B22EA094A362DD807F83BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a3k5dAF=X3_NrYAAp5gPJ_uvF3XfmC4rKz0oGTrGRriCw@mail.gmail.com>
 <OSBPR01MB47732AFC03DA8A0DDF626706BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2TeeLfsTNkZPnC3YowdOS=bFM5yYj58crP6F5U9Y_r-Q@mail.gmail.com>
 <OSBPR01MB47739CBDE12E1F3A19649772BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2fRgDJZv-vzy_X6Y5t3daaVdCiXtMwkmXUyG0EQZ0a6Q@mail.gmail.com>
 <OSBPR01MB477394546AE3BC1F186FC0E9BA869@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a32jF+iCH5Sk82LaozyPJ0n=f92MRdseZwN9aOtf4DwKQ@mail.gmail.com>
 <OSBPR01MB47737A11F8BFCC856C4A62DCBA859@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a3LrkAE9MuMkwMpJ6_5ZYM3m_S-0v7V7qrpY6JaAzHUTQ@mail.gmail.com>
In-Reply-To: <CAK8P3a3LrkAE9MuMkwMpJ6_5ZYM3m_S-0v7V7qrpY6JaAzHUTQ@mail.gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [72.140.114.230]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fe1bdfaf-53a3-4f87-2073-08d8d4283bab
x-ms-traffictypediagnostic: OSYPR01MB5512:
x-microsoft-antispam-prvs: <OSYPR01MB5512743C40C18E9A50A41958BA859@OSYPR01MB5512.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vu6XZLTwHhvlBxBZrEeSCDS4oaspQGT7HNShPsFdE2RmW3U1eiQS14UhhptGhDbxfCexH6CL1GGfWrvAoZNdTDS/e389X3nh6iJ6qklMRzvRHBmPJTtcDz4WycfkYUYkgzj0RGMHr1BapACfNscggoU75PERDIZKorOiBHhLUuV0Xil0WMhuDaGLv+wmbfSNuymCUm074jRcqPbLl7p2CiZ41gVg1W5y8MIfvdi9iQWmL+IcUtuD1SKt260WIt0b2CidKQ5WffcKw494e4RCLON6C7mt+C1eZijygDUuXriggMFF7NYYXcOQP1Q8X3VtLCKd83hr/yuI3gnPN8ISTzKWBVIMilbHULZG9EmtWg4NlEUgB0VBtac8iVq8zqJsBVweJsLWrpWhrTqcZKmeVXAMle9GlbItNw2FE6w//kZootNpfl63hdCYE50s5CgEDetUi9ciAPWnWsDhkKlYqSItrNVuDs/bKUxx12QP8BgGbiyeGYfmKp0644s8jMEapTs3GYS9pIG6cPuixVNIkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB4773.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(83380400001)(86362001)(26005)(186003)(33656002)(8676002)(2906002)(478600001)(9686003)(54906003)(55016002)(316002)(5660300002)(76116006)(66556008)(4326008)(8936002)(66476007)(52536014)(66946007)(7696005)(6916009)(71200400001)(66446008)(53546011)(64756008)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?S2pra0c2Y1VmV0pRUmJRR28yTlloRC9PeGVaS2E0NGtBS3JpWENtWHh4SnAy?=
 =?utf-8?B?TzRZbXdtVDdvMUdta2tTM2tMZ0lORGxtUVhjcisyREVGbXVnQ1ZTblFyNndL?=
 =?utf-8?B?Mk1JdzkwUStpbThHQTRTTzA1c2lKNmtIUlFEUjNwOHJ3bnJRWVFUMHJsWVVs?=
 =?utf-8?B?aERHR2FyM2xxeDRQQmZaWkNuUmM1OHhmd2JrQzAvcmRXR0JWQ05YS0xwVWNP?=
 =?utf-8?B?RDdHT2Zvclc1bW9telhuR2pPWFI4T2dRU3ppVVR3cS9hU3p0WG93QlN3NW56?=
 =?utf-8?B?a1FzKzVteENKNFJ3S3NSZ2ZrK1dldzJHZEhxYm83QlRndEdsejFFUHArd21u?=
 =?utf-8?B?MU0vUi9iSXhXN2hkeEl4VUROeEgxMDVxZ0o0MGVvN3RmRjNJY1ViWUJjMFoy?=
 =?utf-8?B?ekowb0VLSlVzYjRvR2RmTzdhWlRlQ0xPdlJHYytPMnJGaHp4U3gzdEpFSzJy?=
 =?utf-8?B?ZTdGbmFFWWhTSWZQamRNZkFTakVxT3AydE9MeUR1aVprSVhTOHJvVzJJOXlR?=
 =?utf-8?B?QkN3aWJHYUhiS0ZGMFpLOWJnQ2ZaZS9VdURvTWwvVkdETk9iNGF2bzR6bk1x?=
 =?utf-8?B?SFlsdEhXSFp5blRTRENTVjVOcGo3Q3lZcWJLUTl5MXlhenB4YU0zdnloTHJz?=
 =?utf-8?B?bVE3OHVHcnBEMEwrQmRiUjJLbTNCVGNaQ3RsYjd0RTNKRFpERFhYelJUaUgy?=
 =?utf-8?B?RWpzeUFzcWJveklFeWtlckxSLy9xVzRyNVZ5UU5lMFJicGxETVVrN0NyaTdE?=
 =?utf-8?B?K1hWZ1VqcUo0RUQ3QUgwanN0dlBCSEljK28wall6NEV1MlVoZktPb2FwVXhG?=
 =?utf-8?B?THdBMFVFQVFmcW9yN0htYjJiT0RrbEcxUkdlOGtsOWRSaGFZdktRSGo0ODlK?=
 =?utf-8?B?bkxRODIwTDhCREpGRHlNbTAvWlZ6NXJPNWswR3BubTFBZDg3dFFsZXg4ak1V?=
 =?utf-8?B?ME1ZOEUxL3JaNUczQi9nVXJ4ZlB6ak9kOXhLSkgxU0JSeGtkTGhLKzFVelMw?=
 =?utf-8?B?SGlyNmljZWs5UFg5clB3czRxbG1obTRkWjFhRGtIQlhMMFdrNm1oZVVTMHp5?=
 =?utf-8?B?bXVOTUtnUlpsYzMxUml5Y09raTN5SE9HK2JCUnJ0NW5RODI3QTV0Q3o1Smxy?=
 =?utf-8?B?R0pseFcvdDZvUmlVQ0NVSTBDNEorSDJwSXNPTnRIejRuMjRLTURmcTl1dUkw?=
 =?utf-8?B?VlVjaDBtdWF1RDMzazZjNDJQa0VuSmVyZHhnR3lXYnBEc285V2dsZHJ6dDdW?=
 =?utf-8?B?SGZlbWkxV25qT2V1bUtsTkgwc2Z1NmxCNVB0dXZLdkpyeDVUd1FoMTJMZmtH?=
 =?utf-8?B?VFdWaWtuVjRqaWgzWU9qMW54eFphTGdYNjNPaEdabTF0Tm51SURQL1dRWGJF?=
 =?utf-8?B?MkZoV1JPWXNxU2ZCS0hrc2Q2NThseTYxdWRoK05IOFU0RENCcGZLR1VISisy?=
 =?utf-8?B?aDVGOWdqcTY0K0pwbWJWNHZBdjlvVEVRTU9vWHp5aTVnWXV4c1Z5UUtubFlZ?=
 =?utf-8?B?L0dnUkh3eVNjL29NbDE0NU9TU0tLMFpWZ0UyWTE2Y0FNOTM1anpSV3A3a25v?=
 =?utf-8?B?Y1lQYkxaYloyNC91R2paKzJtS0cxWTlMZDRkb0Y2bXZkZ0djMmlnRUtxOFlS?=
 =?utf-8?B?TFJ6RlVsQWFUazdNaUU1SmljRUVJWFFOdUJ1VWVRVGhVeVNkQm9JamhVaXRS?=
 =?utf-8?B?Rys0WW9oWlJ1YkhDK2lDNFlpV1luQmNjZG54ajZIZWw5dWJGUWtvNDlKSUh4?=
 =?utf-8?Q?Oqr0tMjOm3SB2gAK/kq6FdDhS+2oVYZIoqoAqt6?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB4773.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe1bdfaf-53a3-4f87-2073-08d8d4283bab
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2021 16:14:13.6377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AwxerOxrnZ0ibgC/euxa1ZZUGMPKdZz2yOdmVB+SB7/L9iMwmyqEACQJcNoBaIMrGoPkG2+3KMTUd++R0kLtig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSYPR01MB5512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQXJuZCBCZXJnbWFubiA8
YXJuZEBrZXJuZWwub3JnPg0KPiBTZW50OiBGZWJydWFyeSAxOCwgMjAyMSA1OjUxIEFNDQo+IFRv
OiBNaW4gTGkgPG1pbi5saS54ZUByZW5lc2FzLmNvbT4NCj4gQ2M6IERlcmVrIEtpZXJuYW4gPGRl
cmVrLmtpZXJuYW5AeGlsaW54LmNvbT47IERyYWdhbiBDdmV0aWMNCj4gPGRyYWdhbi5jdmV0aWNA
eGlsaW54LmNvbT47IEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+OyBncmVna2gNCj4gPGdy
ZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsg
TmV0d29ya2luZw0KPiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IFJpY2hhcmQgQ29jaHJhbiA8
cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0
XSBtaXNjOiBBZGQgUmVuZXNhcyBTeW5jaHJvbml6YXRpb24NCj4gTWFuYWdlbWVudCBVbml0IChT
TVUpIHN1cHBvcnQNCj4gDQo+IE9uIFRodSwgRmViIDE4LCAyMDIxIGF0IDQ6MjggQU0gTWluIExp
IDxtaW4ubGkueGVAcmVuZXNhcy5jb20+IHdyb3RlOg0KPiA+ID4gSWYgdGhlIGRyaXZlciBjYW4g
dXNlIHRoZSBzYW1lIGFsZ29yaXRobSB0aGF0IGlzIGluIHlvdXIgdXNlciBzcGFjZQ0KPiA+ID4g
c29mdHdhcmUgdG9kYXksIHRoYXQgd291bGQgc2VlbSB0byBiZSBhIG5pY2VyIHdheSB0byBoYW5k
bGUgaXQgdGhhbg0KPiA+ID4gcmVxdWlyaW5nIGEgc2VwYXJhdGUgYXBwbGljYXRpb24uDQo+ID4g
Pg0KPiA+DQo+ID4gSGkgQXJuZA0KPiA+DQo+ID4NCj4gPiBXaGF0IGlzIHRoZSBkZXZpY2UgZHJp
dmVyIHRoYXQgeW91IGFyZSByZWZlcnJpbmcgaGVyZT8NCj4gPg0KPiA+IEluIHN1bW1hcnkgb2Yg
eW91ciByZXZpZXdzLCBhcmUgeW91IHN1Z2dlc3RpbmcgbWUgdG8gZGlzY2FyZCB0aGlzDQo+ID4g
Y2hhbmdlIGFuZCBnbyBiYWNrIHRvIFBUUCBzdWJzeXN0ZW0gdG8gZmluZCBhIGJldHRlciBwbGFj
ZSBmb3IgdGhpbmdzDQo+ID4gdGhhdCBJIHdhbm5hIGRvIGhlcmU/DQo+IA0KPiBZZXMsIEkgbWVh
biBkb2luZyBpdCBhbGwgaW4gdGhlIFBUUCBkcml2ZXIuDQo+IA0KPiAgICAgICAgIEFybmQNCg0K
SGkgQXJuZA0KDQpUaGUgQVBJcyBJIGFtIGFkZGluZyBoZXJlIGlzIGZvciBvdXIgZGV2ZWxvcG1l
bnQgb2YgYXNzaXN0ZWQgcGFydGlhbCB0aW1pbmcgc3VwcG9ydCAoQVBUUyksDQp3aGljaCBpcyBh
IEdsb2JhbCBOYXZpZ2F0aW9uIFNhdGVsbGl0ZSBTeXN0ZW0gKEdOU1MpIGJhY2tlZCBieSBQcmVj
aXNpb24gVGltZSBQcm90b2NvbCAoUFRQKS4NClNvIGl0IGlzIG5vdCBwYXJ0IG9mIFBUUCBidXQg
dGhleSBjYW4gd29yayB0b2dldGhlciBmb3IgbmV0d29yayB0aW1pbmcgc29sdXRpb24uDQoNCldo
YXQgSSBhbSB0cnlpbmcgdG8gc2F5IGlzIHRoZSB0aGluZ3MgdGhhdCBJIGFtIGFkZGluZyBoZXJl
IGRvZXNuJ3QgcmVhbGx5IGJlbG9uZyB0byB0aGUgUFRQIHdvcmxkLg0KRm9yIGV4YW1wbGUsIHRp
bWV4LT5mcmVxIGlzIGRpZmZlcmVudCBmcm9tIHRoZSBmZm8gdGhhdCBJIGFtIHJlYWRpbmcgZnJv
bSB0aGlzIGRyaXZlciBzaW5jZSB0aGUgRFBMTCBpcw0KV29ya2luZyBpbiBkaWZmZXJlbnQgbW9k
ZS4gRm9yIFBUUCwgRFBMTCBpcyB3b3JraW5nIGluIERDTyBtb2RlLiBJbiBEQ08gbW9kZSwgdGhl
IERQTEwgDQpjb250cm9sIGxvb3AgaXMgb3BlbmVkIGFuZCB0aGUgRENPIGNhbiBiZSBjb250cm9s
bGVkIGJ5IGEgUFRQIGNsb2NrIHJlY292ZXJ5IHNlcnZvIHJ1bm5pbmcgb24gYW4gDQpleHRlcm5h
bCBwcm9jZXNzb3IgdG8gc3ludGhlc2l6ZSBQVFAgY2xvY2tzLiBPbiB0aGUgb3RoZXIgaGFuZCBm
b3IgR05TUyB0aW1pbmcsIHRoZSBmZm8gSSBhbSByZWFkaW5nIGhlcmUgaXMgd2hlbiBEUExMIGlz
DQppbiBsb2NrZWQgbW9kZS4gSW4gTG9ja2VkIHRoZSBsb25nLXRlcm0gb3V0cHV0IGZyZXF1ZW5j
eSBhY2N1cmFjeSBpcyB0aGUgc2FtZSBhcyB0aGUgbG9uZy10ZXJtDQpmcmVxdWVuY3kgYWNjdXJh
Y3kgb2YgdGhlIHNlbGVjdGVkIGlucHV0IHJlZmVyZW5jZS4NCg0KRm9yIG91ciBHTlNTIEFQVFMg
ZGV2ZWxvcG1lbnQsIHdlIGhhdmUgMiBEUExMIGNoYW5uZWxzLCBvbmUgY2hhbm5lbCBpcyBsb2Nr
ZWQgdG8gR05TUyBhbmQgYW5vdGhlciBjaGFubmVsIGlzIFBUUCBjaGFubmVsLg0KSWYgR05TUyBj
aGFubmVsIGlzIGxvY2tlZCwgd2UgdXNlIEdOU1MncyBjaGFubmVsIHRvIHN1cHBvcnQgbmV0d29y
ayB0aW1pbmcuIE90aGVyd2lzZSwgd2Ugc3dpdGNoIHRvIFBUUCBjaGFubmVsLiANCg0KVG8gdGhp
bmsgYWJvdXQgaXQsIG91ciBkZXZpY2UgaXMgcmVhbGx5IGFuIG11bHRpIGZ1bmN0aW9uYWwgZGV2
aWNlIChNRkQpLCB3aGljaCBpcyB3aHkgSSBhbSBzdWJtaXR0aW5nIGFub3RoZXIgcmV2aWV3IGZv
ciBvdXIgTUZEIGRyaXZlcg0Kb24gdGhlIHNpZGUuIFdlIGhhdmUgb3VyIFBUUCBkcml2ZXIgYW5k
IHdlIGhhdmUgdGhpcyBmb3IgR05TUyBBUFRTIGFuZCBvdGhlciBtaXNjIGZ1bmN0aW9ucy4gDQoN
ClNvIGNhbiB5b3UgdGFrZSBhIGxvb2sgYXQgdGhpcyBhZ2FpbiBhbmQgc2VlIGlmIGl0IG1ha2Vz
IHNlbnNlIHRvIGtlZXAgdGhpcyBjaGFuZ2Ugc2ltcGx5IGJlY2F1c2UgdGhlIGNoYW5nZSBpcyBu
b3QgcGFydCBvZiBQVFAgc3Vic3lzdGVtLg0KVGhleSBzb3VuZCBsaWtlIHRoZXkgYXJlIHJlbGF0
ZWQuIEJ1dCB3aGVuIGl0IGNvbWVzIHRvIHRlY2huaWNhbGl0eSwgdGhlcmUgaXMgcmVhbGx5IG5v
IHBsYWNlIGluIFBUUCB0byBob2xkIHN0dWZmIHRoYXQgSSBhbSBkb2luZyBoZXJlLg0KDQpUaGFu
a3MNCg0KTWluDQo=
