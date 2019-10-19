Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B603BDD944
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 17:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfJSPKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 11:10:37 -0400
Received: from mail-eopbgr150089.outbound.protection.outlook.com ([40.107.15.89]:33154
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725810AbfJSPKg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Oct 2019 11:10:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUbYu9kb+8Gg0qkftO0I11puGq6Bmf18R0LYOEYjCqBXM5TdJ2NELGAFlaHtnrlOOCAbsU5O9FH9xV9L/oT64UGLnMiFkpIkTbyDPxG3FjQ+paoYwNXYUohloAqX3yC/cw44ImJyGEBN81A2H+WnGnDnY5+h58W9sgANz2glo2DDapDWlV7Lg+abG4OfXKX1kJAg1DL/DJaGvzGG99aeOlLUMZ7u1FN5IWt2thkLiLDYc8iYzJ9b1271H6Bnq+i2DVV85868vVLXFdKfBsea6A85quFs00Cv2dJ9e2QGYRdgGs0AiJWm9a/gnPpsW2sALon7+JDlbzSZJnx53TwAOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QU+F+RdmUPKoeSZ1CTyPixjpuSiPinH8EHzFUNbJjoA=;
 b=Iu+UGsfgQZGDos0LW0dXjs8Kqtjx/sCiUBv7NFAV5ewTgbE+CJ6MImBq0Ll9G0jkFQCv134QAj2g8Tp5+A1JPQFjFcIjE5hlQUts55zf6k47xNEikjLS0F8nJcaMb9f+qNlAEg2URgOpHMeqp1DvIFeiFLRHWwxcwy/WpqjvqRHoQl5C5cPPBWXWMxlhtPx0CZRXs8+p7kWbgv+VpAx1N/au4g57I613GtdItQXCBt9IIoADhiO3bwOwTiy3FOsXqADNoePae/tnQAJt0B66NdgSL3Zt/yGcL/NlTQwUC8BLGigQduLK378Noue2+61cp5ZWpaj5R6xZyr6I4Y8hgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=inf.elte.hu; dmarc=pass action=none header.from=inf.elte.hu;
 dkim=pass header.d=inf.elte.hu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ikelte.onmicrosoft.com; s=selector2-ikelte-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QU+F+RdmUPKoeSZ1CTyPixjpuSiPinH8EHzFUNbJjoA=;
 b=F6eJt093KsvctX3QwaHJvFT7ZOKF+nnOugV1c5z95J7kEEQUJ1maWAaKctdIjmsQV3DFbv3E8i+8RsxNVaHueUxGAwYcRn18+tPi4lx+2iCvZ3R2MBIUmJ6aCYzM60KRGqs63nE7NNW0dX3/BCDgzPAj/OF1J02PVAC+ErhQKtg=
Received: from DB8PR10MB2620.EURPRD10.PROD.OUTLOOK.COM (20.179.12.155) by
 DB8PR10MB3547.EURPRD10.PROD.OUTLOOK.COM (10.186.165.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.21; Sat, 19 Oct 2019 15:10:28 +0000
Received: from DB8PR10MB2620.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a10a:13f1:1b17:f1b6]) by DB8PR10MB2620.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a10a:13f1:1b17:f1b6%3]) with mapi id 15.20.2347.028; Sat, 19 Oct 2019
 15:10:28 +0000
From:   Fejes Ferenc <fejes@inf.elte.hu>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Error when loading BPF_CGROUP_INET_EGRESS program with bpftool
Thread-Topic: Error when loading BPF_CGROUP_INET_EGRESS program with bpftool
Thread-Index: AQHVUOwCsMyGQq9J8Eq5fTM6eAC0Wqb31WIAgAAnVoCAAZquAIBo5V0A
Date:   Sat, 19 Oct 2019 15:10:25 +0000
Message-ID: <CAAej5Na29DMoQmiXn1VThLH2e3hqvBWqXB8Ah5sPv0Cm-csarQ@mail.gmail.com>
References: <CAAej5NbkQDpDXEtsROmLmNidSP8qN3VRE56s3z91zHw9XjtNZA@mail.gmail.com>
 <CAEf4BzZ27SnYkQ=psqxeWadLhnspojiJGQrGB0JRuPkP+GTiNQ@mail.gmail.com>
 <CAAej5NbwZ80MNQYxP4NiJXheAn1DcSgm+O3zQQgCoP03HGHEgQ@mail.gmail.com>
 <CAEf4BzZqj-kuFC0Jv-i3k-sSdZE6ThihvqXvnss5rDR7ZRYGzQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZqj-kuFC0Jv-i3k-sSdZE6ThihvqXvnss5rDR7ZRYGzQ@mail.gmail.com>
Accept-Language: hu-HU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR07CA0126.eurprd07.prod.outlook.com
 (2603:10a6:207:8::12) To DB8PR10MB2620.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:b2::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fejes@inf.elte.hu; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAVIVDgB22dxb/td2b7pkgQklhxIJ3F/IO9NFUW2EpXW088kszRw
        oSRyGGTNc3sNOYYlijqJMABHgCp9vjDvAw7UR2Y=
x-google-smtp-source: APXvYqwdsk3t9BJ1hovWhC7t2vdjNyyEEzlQJXqYRxZPKc6RV9Uw8n0otJDU2sxEW8bjiy4eIlx4cRoG/WfQ/R/gA04=
x-received: by 2002:a05:600c:2908:: with SMTP id
 i8mr11607948wmd.20.1571497823305; Sat, 19 Oct 2019 08:10:23 -0700 (PDT)
x-gmail-original-message-id: <CAAej5Na29DMoQmiXn1VThLH2e3hqvBWqXB8Ah5sPv0Cm-csarQ@mail.gmail.com>
x-originating-ip: [209.85.128.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9df43cb7-ad2e-4bda-d928-08d754a677b3
x-ms-traffictypediagnostic: DB8PR10MB3547:
x-microsoft-antispam-prvs: <DB8PR10MB354718E6504FFFA13E1B382CE16F0@DB8PR10MB3547.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01952C6E96
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(376002)(39850400004)(136003)(346002)(199004)(189003)(5660300002)(6436002)(6862004)(478600001)(498394004)(186003)(6246003)(305945005)(7736002)(26005)(61266001)(2906002)(66066001)(86362001)(9686003)(6512007)(4326008)(52116002)(64756008)(66446008)(66556008)(66946007)(316002)(8936002)(102836004)(66476007)(55446002)(71190400001)(25786009)(81166006)(81156014)(229853002)(8676002)(76176011)(386003)(3846002)(6116002)(6486002)(446003)(786003)(256004)(14444005)(6506007)(71200400001)(5024004)(486006)(6666004)(99286004)(14454004)(476003)(11346002)(95326003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR10MB3547;H:DB8PR10MB2620.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: inf.elte.hu does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TOSOzhCIhkOonVx26bRKEOiiLeg5GSZPS1MtiAwiBwQgBdPnpikWNYr2F5hAo3vW624g34ii1hpfZvlC3YsQkxRFR7OpAlsipXqgzKa1UUy0fDm6CyEkcrwgJQhmP+LPT8XaLfYz61Vt1KVlOH0FIEkmuR23JFgtQxJXhgnoDfFuvWKOgV3uDhSRFhb8pfKFx9dIAuHHxeBKMqBowBJL0DuD2mpmYYHgmGVznuBq9s2qqNMIYtrymct7d1oQ0ZK66aNYQv/tzSsgC/ERl3yauG9xROdolX53rCLdOWHtllgifn08xD6rbb8mo5jaWMR0TZpXe5uC87biJLYXwpBrhJUdkhJI9fCfyb8UPHZHpu6nhvwoiORVFKYMtBXIj8tWA+B6CcLmJnM9zoPGcZk/acJLUItavKKgBGB4DzBsFECVKdHK2vz31gS7/6V22qPm
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A186C3C3427B4C43AEE61D7FFE41439E@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: inf.elte.hu
X-MS-Exchange-CrossTenant-Network-Message-Id: 9df43cb7-ad2e-4bda-d928-08d754a677b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2019 15:10:26.0155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0133bb48-f790-4560-a64d-ac46a472fbbc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rmTnN7y/WUvn2uEB9+Aq6r2ltpLk2MbKVK/OkltFuNTC+hNmDYKF35g90OLvFPFVcbv01JJnHt31rhEkgaDU0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3547
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U29ycnkgZm9yIHRoZSBsYXRlIHJlcGx5LiBJIGhhdmUgc29tZSB0aW1lIHRvIHRyeSBpdCBhZ2Fp
bi4NCkkgZG93bmxvYWRlZCBhIGZyZXNoIFVidW50dSAxOS4xMCBpbWFnZSwgd2hpY2ggaGF2ZSBi
cGZ0b29sIGluY2x1ZGVkDQpmcm9tIHRoZSBsaW51eC10b29scy1nZW5lcmljIHBhY2thZ2UuIFRo
ZW4gdHJpZWQgdG8gbG9hZCBhIHByb2dyYW0NCndpdGggMCBvciAxIHJldHVybiBjb2RlOiBib3Ro
IHdvcmtzLg0KQWZ0ZXIgdGhhdCBJIHRyaWVkIHRvIGxvYWQgdGhlIG9yaWdpbmFsIHByb2dyYW0s
IHdpdGggcmV0dXJuIGNvZGUgMiBvcg0KMyBhbmQgZ290IHRoZSBzYW1lIGVycm9yIG1lc3NhZ2Uu
DQoNCj4gV2hhdCB3YXMgdGhlIGVycm9yIG1lc3NhZ2UgeW91IGdvdCBhZnRlciB5b3UgcHJvdmlk
ZWQgY29ycmVjdCBwcm9ncmFtDQo+IGF0dGFjaCB0eXBlPw0KDQpzdWRvIGJwZnRvb2wgcHJvZyBs
b2FkYWxsIGhibS5vIC9zeXMvZnMvYnBmL2hibTIgdHlwZSBjZ3JvdXBfc2tiL2VncmVzcw0KDQps
aWJicGY6IGxvYWQgYnBmIHByb2dyYW0gZmFpbGVkOiBJbnZhbGlkIGFyZ3VtZW50DQpsaWJicGY6
IC0tIEJFR0lOIERVTVAgTE9HIC0tLQ0KbGliYnBmOg0KOyByZXR1cm4gQUxMT1dfUEtUIHwgUkVE
VUNFX0NXOw0KMDogKGI3KSByMCA9IDMNCjE6ICg5NSkgZXhpdA0KQXQgcHJvZ3JhbSBleGl0IHRo
ZSByZWdpc3RlciBSMCBoYXMgdmFsdWUgKDB4MzsgMHgwKSBzaG91bGQgaGF2ZSBiZWVuDQppbiAo
MHgwOyAweDEpDQpwcm9jZXNzZWQgMiBpbnNucyAobGltaXQgMTAwMDAwMCkgbWF4X3N0YXRlc19w
ZXJfaW5zbiAwIHRvdGFsX3N0YXRlcyAwDQpwZWFrX3N0YXRlcyAwIG1hcmtfcmVhZCAwDQoNCmxp
YmJwZjogLS0gRU5EIExPRyAtLQ0KbGliYnBmOiBmYWlsZWQgdG8gbG9hZCBwcm9ncmFtICdjZ3Jv
dXBfc2tiL2VncmVzcycNCmxpYmJwZjogZmFpbGVkIHRvIGxvYWQgb2JqZWN0ICdoYm0ubycNCkVy
cm9yOiBmYWlsZWQgdG8gbG9hZCBvYmplY3QgZmlsZQ0KDQpTYW1lIGNvbW1hbmQgd2l0aCBzdHJh
Y2U6DQpicGYoQlBGX1BST0dfTE9BRCwge3Byb2dfdHlwZT1CUEZfUFJPR19UWVBFX0NHUk9VUF9T
S0IsIGluc25fY250PTIsDQppbnNucz0weDU1ODg4OWI1OWJhMCwgbGljZW5zZT0iR1BMIiwgbG9n
X2xldmVsPTAsIGxvZ19zaXplPTAsDQpsb2dfYnVmPU5VTEwsIGtlcm5fdmVyc2lvbj1LRVJORUxf
VkVSU0lPTigwLCAwLCAwKSwgcHJvZ19mbGFncz0wLA0KcHJvZ19uYW1lPSJoYm0iLCBwcm9nX2lm
aW5kZXg9MCwNCmV4cGVjdGVkX2F0dGFjaF90eXBlPUJQRl9DR1JPVVBfSU5FVF9JTkdSRVNTLCAu
Li59LCAxMTIpID0gLTEgRUlOVkFMDQooSW52YWxpZCBhcmd1bWVudCkNCmJwZihCUEZfUFJPR19M
T0FELCB7cHJvZ190eXBlPUJQRl9QUk9HX1RZUEVfQ0dST1VQX1NLQiwgaW5zbl9jbnQ9MiwNCmlu
c25zPTB4NTU4ODg5YjU5YmEwLCBsaWNlbnNlPSJHUEwiLCBsb2dfbGV2ZWw9MSwgbG9nX3NpemU9
MTY3NzcyMTUsDQpsb2dfYnVmPSIiLCBrZXJuX3ZlcnNpb249S0VSTkVMX1ZFUlNJT04oMCwgMCwg
MCksIHByb2dfZmxhZ3M9MCwNCnByb2dfbmFtZT0iaGJtIiwgcHJvZ19pZmluZGV4PTAsDQpleHBl
Y3RlZF9hdHRhY2hfdHlwZT1CUEZfQ0dST1VQX0lORVRfSU5HUkVTUywgLi4ufSwgMTEyKSA9IC0x
IEVJTlZBTA0KKEludmFsaWQgYXJndW1lbnQpDQoNClN0cmFjZSBlcnJvciBpcyB0aGUgc2FtZSwg
ZXZlbiBpZiBJIG1hbnVhbGx5IHNldCB0aGUgdHlwZSB0byBjZ3JvdXBfc2tiL2VncmVzczoNCmJw
ZihCUEZfUFJPR19MT0FELCB7cHJvZ190eXBlPUJQRl9QUk9HX1RZUEVfQ0dST1VQX1NLQiwgaW5z
bl9jbnQ9MiwNCmluc25zPTB4NTVhZTQ2Mjk2YmEwLCBsaWNlbnNlPSJHUEwiLCBsb2dfbGV2ZWw9
MCwgbG9nX3NpemU9MCwNCmxvZ19idWY9TlVMTCwga2Vybl92ZXJzaW9uPUtFUk5FTF9WRVJTSU9O
KDAsIDAsIDApLCBwcm9nX2ZsYWdzPTAsDQpwcm9nX25hbWU9ImhibSIsIHByb2dfaWZpbmRleD0w
LA0KZXhwZWN0ZWRfYXR0YWNoX3R5cGU9QlBGX0NHUk9VUF9JTkVUX0lOR1JFU1MsIC4uLn0sIDEx
MikgPSAtMSBFSU5WQUwNCihJbnZhbGlkIGFyZ3VtZW50KQ0KYnBmKEJQRl9QUk9HX0xPQUQsIHtw
cm9nX3R5cGU9QlBGX1BST0dfVFlQRV9DR1JPVVBfU0tCLCBpbnNuX2NudD0yLA0KaW5zbnM9MHg1
NWFlNDYyOTZiYTAsIGxpY2Vuc2U9IkdQTCIsIGxvZ19sZXZlbD0xLCBsb2dfc2l6ZT0xNjc3NzIx
NSwNCmxvZ19idWY9IiIsIGtlcm5fdmVyc2lvbj1LRVJORUxfVkVSU0lPTigwLCAwLCAwKSwgcHJv
Z19mbGFncz0wLA0KcHJvZ19uYW1lPSJoYm0iLCBwcm9nX2lmaW5kZXg9MCwNCmV4cGVjdGVkX2F0
dGFjaF90eXBlPUJQRl9DR1JPVVBfSU5FVF9JTkdSRVNTLCAuLi59LCAxMTIpID0gLTEgRUlOVkFM
DQooSW52YWxpZCBhcmd1bWVudCkNCg0KSSBub3RpY2VkIHlvdSBkaWQgYSBtYWpvciByZXN0cnVj
dHVyaW5nIGluIGxpYmJwZiwgSSB3aWxsIHRyeSBvdXQNCndoZXRoZXIgbXkgcHJvYmxlbSBzdGls
bCBleGlzdCB3aXRoIHRoZSBuZXcgdmVyc2lvbi4NCg0KRmVyZW5jDQo=
