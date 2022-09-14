Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463B75B8EAC
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 20:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiINSOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 14:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiINSOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 14:14:02 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A5B86B45;
        Wed, 14 Sep 2022 11:13:57 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1663179235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lmN2Y2Wq4e7hsS7ZumQmRX4d0MnXHOoZ9o5FIDOff7c=;
        b=ivbETLClmFh9NKYGi244xr2/GGIcNXW139cj+hI9NPFJ6BKRdYxv0sw6dQDX0vHOQ3AIL9
        9Qm8Rc3DTiz04YoU7s/r74OrFc0snbgMjnSDpvGoGPR6nnnooYmdEwDkVripIrgeN+OmDe
        inKh9wQGsYTQnMaIJPm1cTrXal7a7+AVLJG/CRKEZuWwx+q+BLT5H14XLDfCqLgMbad6Z3
        3sWcvngBskvW7l/HSgwPVQbP/lasMV42zNR6d1yEEOfYWlqknbXqAq50RnRljqaaN5jEG7
        8/zwYyyAa6p0c40zNFDZNiuoq7JG/lf+S8XeXdxKXBZyYyKEDV8hao5x3qJJkw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1663179235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lmN2Y2Wq4e7hsS7ZumQmRX4d0MnXHOoZ9o5FIDOff7c=;
        b=9J5ded8K6t7pqsHiP0IsRA1QHXSrVHe/KhCUcJC+FuEC0y4jraHjSpo69Qxi2BBVnuVeNb
        0iBxziVv/TsA9LDA==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 08/13] net: dsa: hellcreek: deny tc-taprio
 changes to per-tc max SDU
In-Reply-To: <20220914153303.1792444-9-vladimir.oltean@nxp.com>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-9-vladimir.oltean@nxp.com>
Date:   Wed, 14 Sep 2022 20:13:53 +0200
Message-ID: <87a671bz8e.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed Sep 14 2022, Vladimir Oltean wrote:
> Since the driver does not act upon the max_sdu argument (which it
> should, in full offload mode), deny any other values except the default
> all-zeroes, which means that all traffic classes should use the same MTU
> as the port itself.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/hirschmann/hellcreek.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hir=
schmann/hellcreek.c
> index ea8bbfce0f1f..8ef7816627b6 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek.c
> +++ b/drivers/net/dsa/hirschmann/hellcreek.c
> @@ -1814,10 +1814,15 @@ static int hellcreek_port_setup_tc(struct dsa_swi=
tch *ds, int port,
>  {
>  	struct tc_taprio_qopt_offload *taprio =3D type_data;
>  	struct hellcreek *hellcreek =3D ds->priv;
> +	int tc;
>=20=20
>  	if (type !=3D TC_SETUP_QDISC_TAPRIO)
>  		return -EOPNOTSUPP;
>=20=20
> +	for (tc =3D 0; tc < TC_MAX_QUEUE; tc++)
> +		if (taprio->max_sdu[tc])
> +			return -EOPNOTSUPP;

I'd rather like to see that feature implemented :-). Something like below.

From=203d44683979bf50960125fa3005b1142af61525c7 Mon Sep 17 00:00:00 2001
From: Kurt Kanzenbach <kurt@linutronix.de>
Date: Wed, 14 Sep 2022 19:51:40 +0200
Subject: [PATCH] net: dsa: hellcreek: Offload per-tc max SDU from tc-taprio

Add support for configuring the max SDU per priority and per port. If not
specified, keep the default.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
=2D--
 drivers/net/dsa/hirschmann/hellcreek.c | 61 +++++++++++++++++++++++---
 drivers/net/dsa/hirschmann/hellcreek.h |  7 +++
 2 files changed, 61 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirsc=
hmann/hellcreek.c
index 5ceee71d9a25..1b22710e1641 100644
=2D-- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -128,6 +128,16 @@ static void hellcreek_select_prio(struct hellcreek *he=
llcreek, int prio)
 	hellcreek_write(hellcreek, val, HR_PSEL);
 }
=20
+static void hellcreek_select_port_prio(struct hellcreek *hellcreek, int po=
rt,
+				       int prio)
+{
+	u16 val =3D port << HR_PSEL_PTWSEL_SHIFT;
+
+	val |=3D prio << HR_PSEL_PRTCWSEL_SHIFT;
+
+	hellcreek_write(hellcreek, val, HR_PSEL);
+}
+
 static void hellcreek_select_counter(struct hellcreek *hellcreek, int coun=
ter)
 {
 	u16 val =3D counter << HR_CSEL_SHIFT;
@@ -1537,6 +1547,42 @@ hellcreek_port_prechangeupper(struct dsa_switch *ds,=
 int port,
 	return ret;
 }
=20
+static void hellcreek_setup_maxsdu(struct hellcreek *hellcreek, int port,
+				   const struct tc_taprio_qopt_offload *schedule)
+{
+	int tc;
+
+	for (tc =3D 0; tc < 8; ++tc) {
+		u16 val;
+
+		if (!schedule->max_sdu[tc])
+			continue;
+
+		hellcreek_select_port_prio(hellcreek, port, tc);
+
+		val =3D (schedule->max_sdu[tc] & HR_PTPRTCCFG_MAXSDU_MASK)
+			<< HR_PTPRTCCFG_MAXSDU_SHIFT;
+
+		hellcreek_write(hellcreek, val, HR_PTPRTCCFG);
+	}
+}
+
+static void hellcreek_reset_maxsdu(struct hellcreek *hellcreek, int port)
+{
+	int tc;
+
+	for (tc =3D 0; tc < 8; ++tc) {
+		u16 val;
+
+		hellcreek_select_port_prio(hellcreek, port, tc);
+
+		val =3D (HELLCREEK_DEFAULT_MAX_SDU & HR_PTPRTCCFG_MAXSDU_MASK)
+			<< HR_PTPRTCCFG_MAXSDU_SHIFT;
+
+		hellcreek_write(hellcreek, val, HR_PTPRTCCFG);
+	}
+}
+
 static void hellcreek_setup_gcl(struct hellcreek *hellcreek, int port,
 				const struct tc_taprio_qopt_offload *schedule)
 {
@@ -1720,7 +1766,10 @@ static int hellcreek_port_set_schedule(struct dsa_sw=
itch *ds, int port,
 	}
 	hellcreek_port->current_schedule =3D taprio_offload_get(taprio);
=20
=2D	/* Then select port */
+	/* Configure max sdu */
+	hellcreek_setup_maxsdu(hellcreek, port, hellcreek_port->current_schedule);
+
+	/* Select tdg */
 	hellcreek_select_tgd(hellcreek, port);
=20
 	/* Enable gating and keep defaults */
@@ -1772,7 +1821,10 @@ static int hellcreek_port_del_schedule(struct dsa_sw=
itch *ds, int port)
 		hellcreek_port->current_schedule =3D NULL;
 	}
=20
=2D	/* Then select port */
+	/* Reset max sdu */
+	hellcreek_reset_maxsdu(hellcreek, port);
+
+	/* Select tgd */
 	hellcreek_select_tgd(hellcreek, port);
=20
 	/* Disable gating and return to regular switching flow */
@@ -1814,15 +1866,10 @@ static int hellcreek_port_setup_tc(struct dsa_switc=
h *ds, int port,
 {
 	struct tc_taprio_qopt_offload *taprio =3D type_data;
 	struct hellcreek *hellcreek =3D ds->priv;
=2D	int tc;
=20
 	if (type !=3D TC_SETUP_QDISC_TAPRIO)
 		return -EOPNOTSUPP;
=20
=2D	for (tc =3D 0; tc < TC_MAX_QUEUE; tc++)
=2D		if (taprio->max_sdu[tc])
=2D			return -EOPNOTSUPP;
=2D
 	if (!hellcreek_validate_schedule(hellcreek, taprio))
 		return -EOPNOTSUPP;
=20
diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirsc=
hmann/hellcreek.h
index c96b8c278904..66b989d946e4 100644
=2D-- a/drivers/net/dsa/hirschmann/hellcreek.h
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -37,6 +37,7 @@
 #define HELLCREEK_VLAN_UNTAGGED_MEMBER	0x1
 #define HELLCREEK_VLAN_TAGGED_MEMBER	0x3
 #define HELLCREEK_NUM_EGRESS_QUEUES	8
+#define HELLCREEK_DEFAULT_MAX_SDU	1536
=20
 /* Register definitions */
 #define HR_MODID_C			(0 * 2)
@@ -72,6 +73,12 @@
 #define HR_PRTCCFG_PCP_TC_MAP_SHIFT	0
 #define HR_PRTCCFG_PCP_TC_MAP_MASK	GENMASK(2, 0)
=20
+#define HR_PTPRTCCFG			(0xa9 * 2)
+#define HR_PTPRTCCFG_SET_QTRACK		BIT(15)
+#define HR_PTPRTCCFG_REJECT		BIT(14)
+#define HR_PTPRTCCFG_MAXSDU_SHIFT	0
+#define HR_PTPRTCCFG_MAXSDU_MASK	GENMASK(10, 0)
+
 #define HR_CSEL				(0x8d * 2)
 #define HR_CSEL_SHIFT			0
 #define HR_CSEL_MASK			GENMASK(7, 0)
=2D-=20
2.30.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmMiGeETHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgodvD/490l2utyqICGQb59kwR72N4d+XkGjo
sD0vQfVLoYIma/lsl4NHqZGEhCPeVEEgeuUGMeiJoGezmcWPd6c4AERIcxnceDif
SePQC2yxMmLYJ6xxIPtfNJmsrh2h+j5owAsVFheWUUGKUfnxZP8wUSo/Ikj6zJUC
G55BmA4Y1lV9zQBduwgbNnu+3PwpdoSIIt0gCymmC0k+7ab8RpdP+rfpZHfLjgSA
XJkWYWjCUHknDqiXorC5Xr+wtSBbb6Mu1L/MHjhpuagUSvxAkh6kzfJI8cVO/MzA
gqam9bz4G/fncuaVg7ppCLqIR50BZZ/oroofL/EjYIsU/LfEikOC7lVvUQiozpr5
S121+Lks7K0LA7nWFFwL3XeJwJOyODHLA4qdAvibP2QfDiHpheDPzCGETtVP9F+2
oHgAS1tMFF5A4iYzix8koy+wloi0uqqG19eh3LvNWtHzu3Pe4D33XmTd7DvU3aYb
UGHJXDouAIHRW33aGVn0srk/6M0AfV4lLNhEHsDn4MfEgTkn6QzdUt+6iRLaix+4
19ehXlkFQBQpLqvJ2zm8DOaZBsTwUkyAbc9ns5mgHdFNMXvUh12YsRO1cXOs3UmS
kvFOh4DH2Ork+dn5mTnfv5wX5EoJJjw2c7faFetej0Xx62CfwCTXPoglRw5q9rDR
fwcVerdot81ukA==
=97Yc
-----END PGP SIGNATURE-----
--=-=-=--
