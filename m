Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C040A69BFE6
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 10:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjBSJzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 04:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjBSJzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 04:55:00 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517493A83
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 01:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1676800496; i=frank-w@public-files.de;
        bh=s5t8NHNadT9y7ZTnqxfPe71iPYx9nOvww8T02oQhjvQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=DqVU+N7nBQ8YGOuqsA9uyhQONgzm11dwzeYwACFh4uk0+F/ipSW6Jd4mfhRmXvn3a
         TCE1zQ/OcIwkl85UmxV5VK7OrcpC3xBrbPr9odoQRGjKOs/Pm/Yh4q5do6riyCzztr
         T3KTS+HbTKgb8rVS0YflAwbU25mSSsbfnQ2IgeVMJxtT4kagFRSQzJmxhLE/AZtca+
         C8IVzrLSbijTPxLFmr3g7kxpZVRSxtsUmpU2nkzxIuxZaaHVszEs6otRU7ILim21ln
         l9lvFmlUQV7F17GWoG8h92NIZYQqw5Fejs/zphuxnyxku3srE0VA3a0X4mCDyowtyR
         52GTJvK3jRDUA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.154.15] ([217.61.154.15]) by web-mail.gmx.net
 (3c-app-gmx-bs35.server.lan [172.19.170.87]) (via HTTP); Sun, 19 Feb 2023
 10:49:24 +0100
MIME-Version: 1.0
Message-ID: <trinity-4025f060-3bb8-4260-99b7-e25cbdcf9c27-1676800164589@3c-app-gmx-bs35>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     =?UTF-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Aw: Re: Choose a default DSA CPU port
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 19 Feb 2023 10:49:24 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <a4936eb8-dfaa-e2f8-b956-75e86546fbf3@arinc9.com>
References: <5833a789-fa5a-ce40-f8e5-d91f4969a7c4@arinc9.com>
 <20230218205204.ie6lxey65pv3mgyh@skbuf>
 <a4936eb8-dfaa-e2f8-b956-75e86546fbf3@arinc9.com>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:R10rJ1jQ36hkh1hxV5wIOy9mSUJLEgVxBu8XIUfWthPJ1hxqGk9GQlfbWYa4qN8gCAElV
 ZpdEZ4VGZuCyuEtNApojlZgz1yVectI2qPky7CqQUJNMXQ51d2R3gZHTv3S85YAPdsDmKhfBxH2W
 ddXbUDyYvFTD1X61i5iVTIu5sl/FOku82DVlo24yjvzfa/LQXaWyjH93uRQdBt3SkxAOPdAyD5Tg
 Zd57vDCY5uBeNBvVrWxYUtuLo6zUmpTnKG4jH7Qv8a0yJAWXMUbiwECRLV1JBUp2y54w7JaiE0B2
 /k=
UI-OutboundReport: notjunk:1;M01:P0:UyfMCfmFmxo=;o/1RQ5IdUS0B55lGrat1RlOvpce
 BFyQYg/0wXml4z3p1x8cwoXPWWh/l+XV2cty5xQQMdL3yEOi2Sh1wD7aOj0YCqFzObJKJYapk
 fx70PyWJyebfa5lhaU1gRSJ3OsUYI/JdgF99KjMOwWf19QB59d9COxByqe5UK2h4dGWaNnBMq
 uGsOEYUvw+7C8nQzALRI7ZQ4wGfq0BFUVICaULAb9UIDknNWDBiVVBzcXx8S6NsfC6F8u0/nN
 pdDtGODPkyEHcHmmkFMgIqMB0iye741HGXGKYMO3FIIgDD/YZVbYc/05m9mMH4EQFydo48BmK
 pxJ+tXl2ZLXWWBp3r4cX5HgHsei+SAczpXcdDPcb/+VNbmP3vFXx8lTvhfycvLNqJF5U9Oiof
 TnjmqpI+NcjHW6GQsFloc4mxUC/jwSKlcjke7v0+e9bSHGX8ZLh/Xh0q/XjzIzLqa8sNdDQtC
 490DW/GiDP354vOmUjTrxGYcNg7kDqeNU33Rlz/Oj5TUQ4REuPB5hEB+XQLrdnuFzOyw7PJb6
 7QduEFzlHHeRI4rp/BT2WUQfSlYPZvksTpTc5j/uJ2/urd6WygmKZ7A8H50m2/rZamBPLfIHu
 6p9hR9+eQLtzo+gclRLf/jozQBL4zt3BZiAONrcCnI68k9H5nS33SaIo0gEor+F886JIpaAOP
 zRS+GggvnYw64W3n3qcBn/S3/zsNv7y8I79OOoGlxwbMCIJIrs3RAm3xmXQy0xjwadzOZJSga
 Py2/mTF+42Q7Jpqt07/Av3YMEmt7+Oi7GQUgD++BVNXQIfgZ0HwSSMIB46HKEItNkaGRfl/Rj
 hIonEp0wf1BnjRBsMDAfOD7w==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Gesendet: Sonntag, 19=2E Februar 2023 um 08:35 Uhr
> Von: "Ar=C4=B1n=C3=A7 =C3=9CNAL" <arinc=2Eunal@arinc9=2Ecom>
> On 18=2E02=2E2023 23:52, Vladimir Oltean wrote:

> > Before making any change, I believe that the first step is to be in ag=
reement
> > as to what the problem is=2E

the problem is that the first cpu-port is not always ideal=2E in our case =
driver supports only port6 over
years till we have changed this to get r2pro working which uses only port =
5 (mt7531)=2E

so port6 is tested over long time and port 5 now comes into the view as sp=
are cpu-port for
getting additional bandwidth=2E

> > The current DSA device tree binding has always chosen the numerically =
first
> > CPU port as the default CPU port=2E This was also the case at the time=
 when the
> > mt7530 driver was accepted upstream=2E Clearly there are cases where t=
his choice
> > is not the optimal choice (from the perspective of an outside observer=
)=2E
> > For example when another CPU port has a higher link speed=2E But it's =
not
> > exactly obvious that higher link speed is always better=2E If you have=
 a CPU
> > port at a higher link speed than the user ports, but it doesn't have f=
low
> > control, then the choice is practically worse than the CPU port which =
operates
> > at the same link speed as user ports=2E
> >=20
> > So the choice between RGMII and TRGMII is not immediately obvious to s=
ome code
> > which should take this decision automatically=2E And this complicates =
things
> > a lot=2E If there is no downside to having the kernel take a decision =
automatically,
> > generally I don't have a problem taking it=2E But here, I would like t=
o hear
> > some strong arguments why port 6 is preferable over port 5=2E
>=20
> I'm leaving this to Frank to explain=2E

yes only looking at phy speed may not be the right way, but one way=2E=2E=
=2Ei would like the hw driver
choose the right port which is used as default=2E

currently i try to figure out why dsa_tree_setup_cpu_ports does not use ds=
a_tree_find_first_cpu=2E
the loops looks same, first returns the first one, second skips all furthe=
r which should be same and at the end it calls dsa_tree_find_first_cpu for =
all ports not yet having a cpu-port assigned=2E=2E=2Elooks starnge to me, b=
ut maybe i=20
oversee a detail=2E

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *ds=
t)
{
	list_for_each_entry(dp, &dst->ports, list)
		if (dsa_port_is_cpu(dp))
			return dp;
=2E=2E=2E

static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
{
	cpu_dp =3D dsa_tree_find_first_cpu(dst);
=2E=2E=2E

static int dsa_tree_setup_cpu_ports(struct dsa_switch_tree *dst)
{
=2E=2E=2E
	list_for_each_entry(cpu_dp, &dst->ports, list) {
		if (!dsa_port_is_cpu(cpu_dp))
			continue;
=2E=2E=2E
return dsa_tree_setup_default_cpu(dst);
}

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
so i would change dsa_tree_setup_cpu_ports to something like this (not rea=
dy):

struct dsa_switch_ops {
=2E=2E=2E
	struct dsa_port	*(*get_default_cpu_port)(struct dsa_switch *ds);


static struct dsa_port *dsa_tree_get_default_cpu(struct dsa_switch *ds)
{
	struct dsa_port *cpu_dp;
	struct dsa_switch_tree *dst =3D ds->dst;

	//first let driver choose a cpu_port
	if (ds->ops->get_default_cpu_port)
		cpu_dp =3D ds->ops->get_default_cpu_port(ds);

	//if driver callback not implemented or no result fall back to dsa core d=
efault
	if (!cpu_dp)
		cpu_dp =3D dsa_tree_find_first_cpu(dst);

	return cpu_dp;
}


static int dsa_tree_setup_cpu_ports(struct dsa_switch_tree *dst)
{
	struct dsa_port *cpu_dp, *dp;

	cpu_dp =3D dsa_tree_get_default_cpu(ds); //how to get ds from dst??
=09
	//list_for_each_entry(cpu_dp, &dst->ports, list) {
	//	if (!dsa_port_is_cpu(cpu_dp))
	//		continue;

		/* Prefer a local CPU port */
		dsa_switch_for_each_port(dp, cpu_dp->ds) {
			/* Prefer the first local CPU port found */
			if (dp->cpu_dp)
				continue;

			if (dsa_port_is_user(dp) || dsa_port_is_dsa(dp))
			{
				dp->cpu_dp =3D cpu_dp;
				printk(KERN_ALERT "DEBUG: Passed %s %d cpu:%d set to port %s (%d)\n",_=
_FUNCTION__,__LINE__,cpu_dp->index,dp->name,dp->index);
			}
		}
	//}

	return dsa_tree_setup_default_cpu(dst);
}

and in mt7530=2Ec (can use other values for selecting the better one)

static struct dsa_port *mt753x_get_default_cpu(struct dsa_switch *ds)
{
	struct dsa_port *cpu_dp;
	unsigned int port =3D 0;

	if (dsa_is_cpu_port(ds, 6))
		port=3D6;
	else if (dsa_is_cpu_port(ds, 5))
		port =3D5;
	if (port)
		cpu_dp =3D dsa_to_port(ds, port);
=09
	return cpu_dp;
}

static const struct dsa_switch_ops mt7530_switch_ops =3D {
=2E=2E=2E
	=2Eget_default_cpu_port	=3D mt753x_get_default_cpu,

does not yet compile because i do not know how to get dsa_switch from dsa_=
switch_tree,
but basicly shows how i would do it (select the right cpu at driver level =
without dts properties)=2E

> >=20
> > If there are strong reasons to consider port 6 a primary CPU port and
> > port 5 a secondary one, then there is also a very valid concern of for=
ward
> > compatibility between the mt7530 driver and device trees from the futu=
re
> > (with multiple CPU ports defined)=2E The authors of the mt7530 driver =
must have
> > been aware of the DSA binding implementation's choice of selecting the
> > first CPU port as the default, but they decided to hide their head in
> > the sand and pretend like this issue will never crop up=2E The driver =
has
> > not been coded up to accept port 5 as a valid CPU port until very rece=
ntly=2E
> > What should have been done (*assuming strong arguments*) is that
> > dsa_tree_setup_default_cpu() should have been modified from day one of
> > mt7530 driver introduction, such that the driver has a way of specifyi=
ng
> > a preferred default CPU port=2E
> >=20
> > In other words, the fact that the CPU port becomes port 5 when booting
> > on a new device tree is equally a problem for current kernels as it is
> > for past LTS kernels=2E I would like this to be treated seriously, and
> > current + stable kernels should behave in a reasonable manner with
> > device trees from the future, before support for multiple CPU ports is
> > added to mt7530=2E Forcing users to change device trees in lockstep wi=
th
> > the kernel is not something that I want to maintain and support, if us=
er
> > questions and issues do crop up=2E
> >=20
> > Since this wasn't done, the only thing we're left with is to retroacti=
vely
> > add this functionality to pick a preferred default CPU port, as patche=
s
> > to "net" which get backported to stable kernels=2E Given enough foreth=
ought
> > in the mt7530 driver development, this should not have been necessary,
> > but here we are=2E
> >=20
> > Now that I expressed this point of view, let me comment on why your
> > proposal, Ar=C4=B1n=C3=A7, solves exactly nothing=2E
> >=20
> > If you add a device tree property for the preferred CPU port, you
> > haven't solved any of the compatibility problems:
> >=20
> > - old kernels + new device trees will not have the logic to interpret
> >    that device tree property
> > - old device trees + new kernels will not have that device tree proper=
ty
> >=20
> > so=2E=2E=2E yeah=2E
>=20
> Makes perfect sense=2E I always make the assumption that once the DTs on=
=20
> the kernel source code is updated, it will be used everywhere, which is=
=20
> just not the case=2E

imho there is no way to ensure both ways backwards compatible=2E=2Ein the =
moment you add port5 it
will be the default cpu-port which is what we try to "fix" here=2E either =
driver should select the better one (drivercode not backported if no real f=
ix) or it needs a setting in dts (which is not read in older driver/core)=
=2E

regards Frank
