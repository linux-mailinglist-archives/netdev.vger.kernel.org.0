Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E516A23440E
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 12:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732431AbgGaKZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 06:25:23 -0400
Received: from esa12.fujitsucc.c3s2.iphmx.com ([216.71.156.125]:46854 "EHLO
        esa12.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731998AbgGaKZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 06:25:23 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Jul 2020 06:25:21 EDT
IronPort-SDR: kGHGB7q+pWJffu9f9p5j5QM5gxqzIZKvbtrDq72w5AG1Q1l/TdimRtJ/RNSqMhwlWleM97gW7y
 KOix8jP8wda8HDMSKvm2AloP4s3oucvlYBjKE/uECx+omFpi37x0Y23GB7KEp5YSKQHgAvmkdJ
 YfpkwG7EV4aFx/ntGfD7z8AMhgBc2GXIYNCGj6vrovD1CjAaydTyDpaBNIcAsFsejDOWwNpQSy
 Zfao1Bjd1MZviWLFbwHUdc1cpnysoM0N4gJZEalRaiXdhrpX59zadH7pbLwFcqcNx6eLnavN0p
 ico=
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="16261950"
X-IronPort-AV: E=Sophos;i="5.75,418,1589209200"; 
   d="scan'208";a="16261950"
Received: from mail-ty1jpn01lp2054.outbound.protection.outlook.com (HELO JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.54])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 19:18:12 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDPogCgwswc0mNknaYXIxR/Uy+9mVMROQfgQ2+sfcEb4zxa9MxpBUYnGAUwun25XH2rOqTHazlRC83F8hPILLXOpc/EJwRDS+SluZErwZqOQuvAeG4Ks3qMbDJETD1dBaJ+3cnHsWL3D5q4V+UV1vrUstE1wupeM0ITU5KuJS7y74DkEqeUkG8qB0YDad1DCMXP1+hVVOAMCktqFDtP1nb0P/Gg3gMd3EICcnZAyfhlzaVvsJpuMQsxWq2ju0bGFLLx1JUUYosjZ1NcfRGNiZDMbqqYd1ByL70HHGEpH4iR3+/lfl5kmKVTeiKXT7dGi9eWr24CiQ6jhIugEvY0Yjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/w4FR3QlyrbiYQMboSh//DaSJKCmP1TQXzmdNmpREM=;
 b=jF+Q3/k6l4cOgi2q/eHJ4Q8nA+32M1jBhwNgo+HDF0+w6B/9U2NkiSq1xeyPHq4xKnZhdNeO/9zY+OtI1vG1vVovHZ2EANlxMHEW6sak0PAcaLW/zt4XI6bjlBAq661Gioryik56WtZvBxn6IjLU8nquX9xEQrSa57XVOjTUkRJJ3t9NGI+5l00RzclhOkvvdOjtjXRzCwMCQj0uAjRLG+vEgbyHT5FYiS/VCYDl4e4X35WKpLzAr2hbEdM3KvSpezqXP7ODCmyGde3vdH2rEWRGWxvZka6SLk4mV8Q0lfkTAkQOs72PPOWPBALW4VGKBFFmtCqkQu2XRDrRe1ss0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/w4FR3QlyrbiYQMboSh//DaSJKCmP1TQXzmdNmpREM=;
 b=IbLMiNHcobzmpsLZdjCOuqyAe/enUYW4jZWDuknjD8VrJ9SYackIARhE0P/cC6zh2kEd7ySXTBEyM6E+tBACaU0c4NhbFpcaMTr5Wz3WQ/O+HxxsekHfyHH1xUdXeAPblRqa8b+NrOOeKCxNNEtAYyawJdfJqOYzVR82mT47FNQ=
Received: from OSAPR01MB3844.jpnprd01.prod.outlook.com (2603:1096:604:5d::13)
 by OSBPR01MB1574.jpnprd01.prod.outlook.com (2603:1096:603:1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.25; Fri, 31 Jul
 2020 10:18:09 +0000
Received: from OSAPR01MB3844.jpnprd01.prod.outlook.com
 ([fe80::18a7:bf65:8605:633e]) by OSAPR01MB3844.jpnprd01.prod.outlook.com
 ([fe80::18a7:bf65:8605:633e%5]) with mapi id 15.20.3216.034; Fri, 31 Jul 2020
 10:18:09 +0000
From:   "ashiduka@fujitsu.com" <ashiduka@fujitsu.com>
To:     'Sergei Shtylyov' <sergei.shtylyov@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v2] ravb: Fixed the problem that rmmod can not be done
Thread-Topic: [PATCH v2] ravb: Fixed the problem that rmmod can not be done
Thread-Index: AQHWZliVF0gqbKeTM0q7YOFUctSlU6kgSWOAgAEpsHA=
Date:   Fri, 31 Jul 2020 10:18:09 +0000
Message-ID: <OSAPR01MB3844C77766155CAB10BE296CDF4E0@OSAPR01MB3844.jpnprd01.prod.outlook.com>
References: <20200730035649.5940-1-ashiduka@fujitsu.com>
 <20200730100151.7490-1-ashiduka@fujitsu.com>
 <ce81e95d-b3b0-7f1c-8f97-8bdcb23d5a8e@gmail.com>
In-Reply-To: <ce81e95d-b3b0-7f1c-8f97-8bdcb23d5a8e@gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-securitypolicycheck: OK by SHieldMailChecker v2.6.2
x-shieldmailcheckerpolicyversion: FJ-ISEC-20181130-VDI-enc
x-shieldmailcheckermailid: 2bfacab4fb124f7caba5735e9933bd29
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fujitsu.com;
x-originating-ip: [118.155.224.176]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d510940-56b8-4100-4447-08d8353b065c
x-ms-traffictypediagnostic: OSBPR01MB1574:
x-microsoft-antispam-prvs: <OSBPR01MB15749D9D5045A69EBCA9B9C1DF4E0@OSBPR01MB1574.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hju5dk3YqcFugEvU3pQvOZe/chq/cCdJUwV9SkD0t+nqnVeDQkcO9+p17A7CgyJECsyVhoDxLqVxRQd/K87Q4VBlr6got4OG51d2N8rF6t28/BJCPLGwImfYrcviV25JDK92EGuox7St+zO5kbiUw0Couaoigv/CvJecKk+PYYe+Bm9ZVnb0c5RyUz2ZbUI1KdhPM+HTYDhX1TzXWcHNAg9tULjVsr8ORumvboFLt+9brWuXTD1WdWBSCHp3uppBfyAZx24NUC7mWiq3Wv4710q/yn+nASpc1CSMF/H7f5U7ntLw5o5jhBxASOWh4edz9pgvEWs2Q9LqfavXnM71arZ0qWxOBrcmjvxG67BOwkUWvGtl1z+OSzH5YpzusLQU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB3844.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(366004)(376002)(396003)(39860400002)(9686003)(55016002)(83380400001)(8936002)(54906003)(2906002)(6916009)(5660300002)(316002)(86362001)(71200400001)(76116006)(26005)(64756008)(66556008)(66476007)(85182001)(33656002)(8676002)(66946007)(6506007)(53546011)(7696005)(478600001)(66446008)(52536014)(4326008)(186003)(777600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: FRCI4/oMLSmqdLctG8sjjEs99HtakPwmDqhaAy5r/eBtYvlm/3Vztwnt9J5kIu17Sg+dum8Ix+XP0xGp4zTIT+VAy7OCu9Ef2aY2XyAF5j5pemWm60dAldgNoIovbdq3EKBnmYAOWswrKFh1Z51e6I7Kl9RuED2tKGFQBkzNS0ViJgsK9FdSrFiSekoy2zln1Mbx53j4BXWmEeOBv7FcKPECKK/ypNJvt1Pr1xTr5//wsBrXF9plrwmh8gU22SojG8A/eNRdgZPWXTmFhypjn6ts0j49/URRIBRdSdPiquep0i9V9MwYIHwX77m2RTseGADM8vEzJPhloRvFiXYfG0cySLwxdz0nNT+mIvIi58CC97yiePAk2tPjWShxDxkPs5PWP4N7Vg4jV86ibGh6omtP814uhGKu9CR0QhhaN7KhS14hqOmRV9jC/yM/RqxTj4WFzNt0ncCESdZvQrnpcpmgzYmBo39KRJYyoPqH01s3ON9uZ2+a/ac4gUZ6g0fS
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB3844.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d510940-56b8-4100-4447-08d8353b065c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2020 10:18:09.7718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s6HiqY0UILkp6WJ83rHHrpwc353738RmoD2fBTdbjpzvG5tuiwY0HwAMAqEO1NBrvHCksBDZW1606i0XUYx7Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB1574
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpJIHVuZGVyc3RhbmQgdGhhdCB0aGUgY29tbWl0IGxvZyBuZWVkcyB0byBi
ZSBjb3JyZWN0ZWQuDQooU2hpbW9kYS1zYW4ncyBwb2ludCBpcyBhbHNvIGNvcnJlY3QpDQoNCklm
IHRoZXJlIGlzIGFueXRoaW5nIGVsc2UgdGhhdCBuZWVkcyB0byBiZSBjb3JyZWN0ZWQsIHBsZWFz
ZSBwb2ludCBpdCBvdXQuDQoNCj4gICAgVGhhdCBzZWVtcyBhIGNvbW1vbiBwYXR0ZXJuLCBpbmxs
dWRpbmcgdGhlIFJlbmVzYXMgc2hfZXRoDQo+IGRyaXZlci4uLg0KDQpZZXMuDQpJZiBJIGNhbiBn
ZXQgYW4gUi1DYXIgR2VuMiBib2FyZCwgSSB3aWxsIGFsc28gZml4IHNoX2V0aCBkcml2ZXIuDQoN
Cj4gICAgTm8sIHRoZSBkcml2ZXIncyByZW1vdmUoKSBtZXRob2QgY2FsbHMgcmF2Yl9tZGlvX3Jl
bGVhc2UoKSBhbmQNCj4gdGhhdCBvbmUgY2FsbHMNCj4gZnJlZV9tZGlvX2JpdGJhbmcoKSB0aGF0
IGNhbGxzIG1vZHVsZV9wdXQoKTsgdGhlIGFjdHVhbCByZWFzb24gbGllcw0KPiBzb21ld2VocmUg
ZGVlcGVyIHRoYW4gdGhpcy4uLg0KDQpOby4NClJ1bm5pbmcgcm1tb2QgY2FsbHMgZGVsZXRlX21v
ZHVsZSgpIGluIGtlcm5lbC9tb2R1bGUuYyBiZWZvcmUgcmF2Yl9tZGlvX3JlbGVhc2UoKSBpcyBj
YWxsZWQuDQpkZWxldGVfbW9kdWxlKCkNCiAgIC0+IHRyeV9zdG9wX21vZHVsZSgpDQogICAgIC0+
IHRyeV9yZWxlYXNlX21vZHVsZV9yZWYoKQ0KSW4gdHJ5X3JlbGVhc2VfbW9kdWxlX3JlZigpLCBj
aGVjayByZWZjbnQgYW5kIGlmIGl0IGlzIGNvdW50ZWQgdXAsIHJhdmJfbWRpb19yZWxlYXNlKCkg
aXMgbm90DQpjYWxsZWQgYW5kIHJtbW9kIGlzIHRlcm1pbmF0ZWQuDQoNClRoYW5rcyAmIEJlc3Qg
UmVnYXJkcywNCll1dXN1a2UgQXNoaXp1a2EgPGFzaGlkdWthQGZ1aml0c3UuY29tPg0KDQo+IC0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlcmdlaSBTaHR5bHlvdiA8c2VyZ2Vp
LnNodHlseW92QGdtYWlsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBKdWx5IDMxLCAyMDIwIDE6MDQg
QU0NCj4gVG86IEFzaGl6dWthLCBZdXVzdWtlL+iKpuWhmiDpm4Tku4sgPGFzaGlkdWthQGZ1aml0
c3UuY29tPg0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgtcmVuZXNhcy1zb2NA
dmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjJdIHJhdmI6IEZpeGVkIHRo
ZSBwcm9ibGVtIHRoYXQgcm1tb2QgY2FuIG5vdA0KPiBiZSBkb25lDQo+IA0KPiBIZWxsbyENCj4g
DQo+IE9uIDcvMzAvMjAgMTowMSBQTSwgWXV1c3VrZSBBc2hpenVrYSB3cm90ZToNCj4gDQo+ID4g
cmF2YiBpcyBhIG1vZHVsZSBkcml2ZXIsIGJ1dCBJIGNhbm5vdCBybW1vZCBpdCBhZnRlciBpbnNt
b2QgaXQuDQo+IA0KPiAgICBNb2R1bGFyLiBBbmQgImluc21vZCdpbmcgaXQiLg0KPiANCj4gPiBy
YXZiIGRvZXMgbWRpb19pbml0KCkgYXQgdGhlIHRpbWUgb2YgcHJvYmUsIGFuZCBtb2R1bGUtPnJl
ZmNudA0KPiBpcyBpbmNyZW1lbnRlZA0KPiA+IGJ5IGFsbG9jX21kaW9fYml0YmFuZygpIGNhbGxl
ZCBhZnRlciB0aGF0Lg0KPiANCj4gICAgVGhhdCBzZWVtcyBhIGNvbW1vbiBwYXR0ZXJuLCBpbmxs
dWRpbmcgdGhlIFJlbmVzYXMgc2hfZXRoDQo+IGRyaXZlci4uLg0KPiANCj4gPiBUaGVyZWZvcmUs
IGV2ZW4gaWYgaWZ1cCBpcyBub3QgcGVyZm9ybWVkLCB0aGUgZHJpdmVyIGlzIGluIHVzZQ0KPiBh
bmQgcm1tb2QgY2Fubm90DQo+ID4gYmUgcGVyZm9ybWVkLg0KPiANCj4gICAgTm8sIHRoZSBkcml2
ZXIncyByZW1vdmUoKSBtZXRob2QgY2FsbHMgcmF2Yl9tZGlvX3JlbGVhc2UoKSBhbmQNCj4gdGhh
dCBvbmUgY2FsbHMNCj4gZnJlZV9tZGlvX2JpdGJhbmcoKSB0aGF0IGNhbGxzIG1vZHVsZV9wdXQo
KTsgdGhlIGFjdHVhbCByZWFzb24gbGllcw0KPiBzb21ld2VocmUgZGVlcGVyDQo+IHRoYW4gdGhp
cy4uLiBVbmZvcnR1bmF0ZWx5IEkgZG9uJ3QgaGF2ZSB0aGUgYWZmZWN0ZWQgaGFyZHdhcmUNCj4g
YW55bW9yZS4uLiA6LSgNCj4gDQo+IFsuLi5dDQo+IA0KPiBNQlIsIFNlcmdlaQ0K
