Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0238F3831D
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 05:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfFGDZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 23:25:05 -0400
Received: from mail-eopbgr10045.outbound.protection.outlook.com ([40.107.1.45]:61078
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726538AbfFGDZD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 23:25:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+EtCBeln92J7nHXuvFyN5UFN0jhE14mp0qp4igWJXs=;
 b=qnSJo9LalO+uEKnwxsLOCcUGuAcQ+pc13Um+yYEhZGFbx3G65lJr52BKA/sblVlKDicEb/wShAP7zsq9pufms1Eq9g1jdhREhezPiNaySE8LHklUDg6+aUAAoxH6eJZO7JHRtPPi7CCtBHkvbfWTwhGk3FbdOsJyV8SUkXneAK4=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2237.eurprd05.prod.outlook.com (10.169.135.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Fri, 7 Jun 2019 03:24:58 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::10d7:3b2d:5471:1eb6]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::10d7:3b2d:5471:1eb6%10]) with mapi id 15.20.1965.011; Fri, 7 Jun 2019
 03:24:58 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: RE: [PATCH iproute2-next] devlink: Increase bus,device buffer size to
 64 bytes
Thread-Topic: [PATCH iproute2-next] devlink: Increase bus,device buffer size
 to 64 bytes
Thread-Index: AQHVHF3n6qqa9dKhTkOJicT4s2CKZaaOvZiAgADKyYA=
Date:   Fri, 7 Jun 2019 03:24:58 +0000
Message-ID: <VI1PR0501MB227132F1F83B7FFB08EE0C3FD1100@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190606114919.27811-1-parav@mellanox.com>
 <20190606081859.1098a856@hermes.lan>
In-Reply-To: <20190606081859.1098a856@hermes.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.21.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 509aeb64-2a58-4431-7a53-08d6eaf7b7f5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2237;
x-ms-traffictypediagnostic: VI1PR0501MB2237:
x-microsoft-antispam-prvs: <VI1PR0501MB223760FDB192E7B7335540DAD1100@VI1PR0501MB2237.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(396003)(39850400004)(366004)(13464003)(199004)(189003)(7696005)(229853002)(6116002)(14454004)(478600001)(66476007)(53546011)(26005)(33656002)(76176011)(186003)(55236004)(6506007)(3846002)(256004)(102836004)(53936002)(66946007)(4326008)(486006)(81166006)(81156014)(73956011)(78486014)(71200400001)(8676002)(316002)(8936002)(68736007)(76116006)(6916009)(71190400001)(99286004)(6436002)(66066001)(305945005)(54906003)(7736002)(55016002)(74316002)(476003)(25786009)(9686003)(2906002)(9456002)(86362001)(107886003)(446003)(5660300002)(66556008)(66446008)(64756008)(52536014)(6246003)(11346002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2237;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MgbZ/35i0OO4YRQeM4L4Lhf9ggh6h4F3OtChLwrvPKa8zZAdwH7CeA2srBaoetGNqllk0fWhjFzD9DRsbllaoSrdavhXxjk2a5B2nWO+heRFtSuXxJLt8ZaUjPny6IY30NAfn/jAQjlivaJcBD1yo9DJZN69lBOTa83onj7AoRNrQ2cjeGi8q/YqXlAJD1v/rN56Kwi7HUMJLjiNSsxXwFXXkDSV0zl7rSo3P6HkO4eHG+B5YIKOGRDNciMERLO/81l1H1WCBuULeWv9JOj0DZ+LqvofOcKTUMsC22weq5bsGtqOZS4Sg9G5B7gqqPLkB0UzhOT7Z7CZSe0NGbxdMMAy7jiA6eL5NRTseZeg0juOXXNG62RuPY9mI/FQson2CnR3E/MobBvDoXNlDcnjRB1YuC6QVWJZG0Wk8N7idB8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 509aeb64-2a58-4431-7a53-08d6eaf7b7f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 03:24:58.2462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2237
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Thursday, June 6, 2019 8:49 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: dsahern@gmail.com; netdev@vger.kernel.org; Jiri Pirko
> <jiri@mellanox.com>
> Subject: Re: [PATCH iproute2-next] devlink: Increase bus,device buffer si=
ze to
> 64 bytes
>=20
> On Thu,  6 Jun 2019 06:49:19 -0500
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > Device name on mdev bus is 36 characters long which follow standard
> > uuid RFC 4122.
> > This is probably the longest name that a kernel will return for a
> > device.
> >
> > Hence increase the buffer size to 64 bytes.
> >
> > Acked-by: Jiri Pirko <jiri@mellanox.com>
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> >
> > ---
> >  devlink/devlink.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/devlink/devlink.c b/devlink/devlink.c index
> > 436935f8..559f624e 100644
> > --- a/devlink/devlink.c
> > +++ b/devlink/devlink.c
> > @@ -1523,7 +1523,7 @@ static void __pr_out_handle_start(struct dl *dl,
> > struct nlattr **tb,  {
> >  	const char *bus_name =3D
> mnl_attr_get_str(tb[DEVLINK_ATTR_BUS_NAME]);
> >  	const char *dev_name =3D
> mnl_attr_get_str(tb[DEVLINK_ATTR_DEV_NAME]);
> > -	char buf[32];
> > +	char buf[64];
> >
> >  	sprintf(buf, "%s/%s", bus_name, dev_name);
> >
> > @@ -1616,7 +1616,7 @@ static void __pr_out_port_handle_start(struct dl
> *dl, const char *bus_name,
> >  				       uint32_t port_index, bool try_nice,
> >  				       bool array)
> >  {
> > -	static char buf[32];
> > +	static char buf[64];
> >  	char *ifname =3D NULL;
> >
> >  	if (dl->no_nice_names || !try_nice ||
>=20
> I will take this now no need to wait for next

Ok. thanks.
