Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25095EB321
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 15:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfJaOuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 10:50:16 -0400
Received: from mail-eopbgr20075.outbound.protection.outlook.com ([40.107.2.75]:13703
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727841AbfJaOuQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 10:50:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aaOtaH4Yh7Smv1jZ3sQ0xLwp0QB4opJ3oKW+U/hQnnQBQDA52KojPJ3bcnj6WhI0Nc3wXoDNX8ymMWKJ/GB0MMIENyV2CaQ8I2hplWl//Fo3nAVvCY7XywwwGHvbPkbuvyfcp3Cn17BehbWjpngjRpA7kH3NiVgoxt1AtCsUbCIECBATlN/0q8R2ZkPNpne3a4tkkrYI5+XeX34nnSYlvOKyah3WRR1MukblctUbhXWaAnbCKTuZDbvOVOxYY5318CrD4ZP8s1PruVCknPoNuX8ZmQt6Gt8mZiMO0AqdU25UXxxusNgTa2vuKtvONP/4DAggCS76h80pO5CExY+5hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jCzdv03QLD88HBwhD46h1EV0cNa8FJmNESc2zP7AHKU=;
 b=KcadlvcHE6Lth255QFn4/v5ecwomPyVpiU2w/fxW5xgIbz261hhS6VRmXRr3lDM8t6FDZGsJF+gsB1Aee70oJeduKzSfhu6Dko6PDkMPcrkG6ZYJJkRfTmP4b4Et0SsC0PU9PFaVMd96nTk8nApkgWRZjZESzBCF7SOhdnSQth05kIALPWSUsRm72kKGHrZFeLh4b5y1hFBMLLcCOViU5DiGxkPWmBAvIgN3xmV87cjVAJ2kZKOA2XpA3sqe7FWvAo+eUTm/fwxHGMeHkI80K3s39odPC9Js5u+yqfLYojIiWfpenrrTKgb2uLPQWdZ7uujTErjvrUHkpKf9pA8soA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jCzdv03QLD88HBwhD46h1EV0cNa8FJmNESc2zP7AHKU=;
 b=LSJE1PgWWu1Wj5KoJuKRUMkDYg1RoMcekYW0KfFneR3chtVPh8Kko4KLVPUQOZKpn48ibWls8SVQ7/7B8KmfTCdyh1oISB7B6GrOwpIHaymn+/bDM7rJz+DEvU9J32ebsLLk3LsmW+2eqP3e3hH4sa/IVzlzODD7kaYgQqWgJMI=
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com (10.171.189.29) by
 AM4PR05MB3172.eurprd05.prod.outlook.com (10.171.186.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Thu, 31 Oct 2019 14:50:12 +0000
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc]) by AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc%4]) with mapi id 15.20.2408.016; Thu, 31 Oct 2019
 14:50:12 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: RE: [PATCH 2/3] ip: Present the VF VLAN tagging mode
Thread-Topic: [PATCH 2/3] ip: Present the VF VLAN tagging mode
Thread-Index: AQHVj3ne4Xs9tw3n4EafaZDxGLzvaqd009jw
Date:   Thu, 31 Oct 2019 14:50:12 +0000
Message-ID: <AM4PR05MB33135476A7BB5BB7CC7D91F2BA630@AM4PR05MB3313.eurprd05.prod.outlook.com>
References: <1572463033-26368-1-git-send-email-lariel@mellanox.com>
        <1572463033-26368-3-git-send-email-lariel@mellanox.com>
 <20191030162920.3ec8549d@hermes.lan>
In-Reply-To: <20191030162920.3ec8549d@hermes.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-originating-ip: [4.78.163.159]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 12414954-e69b-4e8f-9a05-08d75e11a1fb
x-ms-traffictypediagnostic: AM4PR05MB3172:|AM4PR05MB3172:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB317222A90187030137A2DF03BA630@AM4PR05MB3172.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 02070414A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(199004)(189003)(81156014)(6116002)(33656002)(7736002)(3846002)(305945005)(81166006)(8676002)(74316002)(2906002)(446003)(8936002)(11346002)(66066001)(476003)(478600001)(25786009)(486006)(5660300002)(66476007)(107886003)(316002)(55016002)(66556008)(64756008)(66946007)(54906003)(6246003)(52536014)(6506007)(6436002)(66446008)(186003)(71200400001)(99286004)(229853002)(9686003)(14454004)(102836004)(76116006)(6916009)(4326008)(26005)(7696005)(256004)(71190400001)(86362001)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3172;H:AM4PR05MB3313.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vUXvE62USVfcwhpHmG3EGabAZaod0s5qhYHiurGUffCZyQc9Jec0R+SIxlQIHry5lGdsHyouqo13YW4sxyUfoT9sPr1GllSKDeYOsFEON92SZie96paLHhNZwek0+3IrZ3/NDZJuRcg/zd0yQSGMyOxMhUXnQ1LTSpJP6xcA6VqFB6WKuVd3nsX2solEwmkZoX/KjzoCsDPg5Xw1oh1frHj+kG5yEDWhTS0iN5YMIqchkXBJEUyCNZSDNjyRURNBbSEvB1sBWwdLoaFTGVeWqmrE6XRIkaBCRhTqbKNjjAvuJY0hHgQ2GB+H11ClkKHbigR5LA6uXZFvPcTGkLarQjZHRSUuvdyXLSjvqJ+9r+WZw4Zk4LeRZmzon3yof3WUtaTHp04u9mVUhZu6Ir5WjVEpHMgx5CpFTNDAoLe37Is6d6KJNOCtP1GARjMS4JCb
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12414954-e69b-4e8f-9a05-08d75e11a1fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2019 14:50:12.0310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lYVlVC3k125d9sTaQnF46kO8yu+qOVZXl8gMaGCVTQzlFmjUf4fTyh0/XqkdUYT1cDo6YpWvSS3K0Z9lRVcyMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3172
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Oct 2019 19:29:32 +0000
Stephen Hemminger <stephen@networkplumber.org> wrote
> On Wed, 30 Oct 2019 19:17:32 +0000
> Ariel Levkovich <lariel@mellanox.com> wrote:
>=20
> > +		if (vlan_mode->mode =3D=3D IFLA_VF_VLAN_MODE_TRUNK)
> > +			print_string(PRINT_ANY,
> > +				     "vlan-mode",
> > +				      ", vlan-mode %s",
> > +				      "trunk");
> > +		else if (vlan_mode->mode =3D=3D IFLA_VF_VLAN_MODE_VST)
> > +			print_string(PRINT_ANY,
> > +				     "vlan-mode",
> > +				     ", vlan_mode %s",
> > +				     "vst");
> > +		else if (vlan_mode->mode =3D=3D IFLA_VF_VLAN_MODE_VGT)
> > +			print_string(PRINT_ANY,
> > +				     "vlan-mode",
> > +				     ", vlan-mode %s",
> > +				     "vgt");
>=20
> This seems like you want something like:
>=20
> 		print_string(PRINT_ANY, "vlan-mode", ", vlan-mode %s",
> 				vlan_mode_str(vlan_mode->mode);
>=20
> and why the comma in the output? the convention for ip commands is that
> the output format is equivalent to the command line.
Thanks for your review Stephen.
I'll fix the if/else to the suggested line.
I see the comma is used when presenting other VF attributes as well like li=
nk-state, spoof, trust.
So what is the right convention here?
