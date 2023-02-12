Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8741C6939BB
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 20:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjBLT5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 14:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjBLT5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 14:57:32 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A478B72A6;
        Sun, 12 Feb 2023 11:57:30 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id BD5E2201CD;
        Sun, 12 Feb 2023 19:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1676231847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/YE3YkNyItOu9kQieUagTGV2DYYm3vXHAIFtu0T4J3A=;
        b=h9AcuOeonhPR00PnOTQt3IWSH7x+WXlDdenyeUkpPqV6qhMT4VErc6ytKyBScPmO4uvcOG
        PPWYlZqglvFMDHY7daBQI6FVXCV+OW2zzpZMVOHW1kx3e7PjP7SzF8ulrvsIlxozf5Xd+e
        9ogNCiTUVM/lPHSCfyUoDRuX6Zsl46Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1676231847;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/YE3YkNyItOu9kQieUagTGV2DYYm3vXHAIFtu0T4J3A=;
        b=HfkxKIZRfTiw0KZ65GteCOaTcJj6jOk3FP5zi7RTnoDVq0hORe0DscfSK4kKl9hu1dzAXA
        EFtiTh43oz7dbuDg==
Received: from lion.mk-sys.cz (mkubecek.udp.ovpn1.prg.suse.de [10.100.225.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id AE4522C141;
        Sun, 12 Feb 2023 19:57:26 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 1486C605E0; Sun, 12 Feb 2023 20:57:23 +0100 (CET)
Date:   Sun, 12 Feb 2023 20:57:23 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org, bagasdotme@gmail.com
Subject: Re: [PATCH v5 ethtool-next 1/1] add support for IEEE 802.3cg-2019
 Clause 148
Message-ID: <20230212195723.y32z2m4j4tbt4lx6@lion.mk-sys.cz>
References: <cover.1675327734.git.piergiorgio.beruto@gmail.com>
 <d51013e0bc617651c0e6d298f47cc6b82c0ffa88.1675327734.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="v4aw2chwuganwrv2"
Content-Disposition: inline
In-Reply-To: <d51013e0bc617651c0e6d298f47cc6b82c0ffa88.1675327734.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--v4aw2chwuganwrv2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 02, 2023 at 09:53:15AM +0100, Piergiorgio Beruto wrote:
> This patch adds support for the Physical Layer Collision Avoidance
> Reconciliation Sublayer which was introduced in the IEEE 802.3
> standard by the 802.3cg working group in 2019.
>=20
> The ethtool interface has been extended as follows:
> - show if the device supports PLCA when ethtool is invoked without FLAGS
>    - additionally show what PLCA version is supported
>    - show the current PLCA status
> - add FLAGS for getting and setting the PLCA configuration
>=20
> Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>

Sorry for the delay, I missed the patch in the mailing list and did not
get it directly into my inbox. Thankfully I noticed it in patchwork.

> ---
>  Makefile.am        |   1 +
>  ethtool.8.in       |  83 ++++++++++++-
>  ethtool.c          |  21 ++++
>  netlink/extapi.h   |   6 +
>  netlink/plca.c     | 296 +++++++++++++++++++++++++++++++++++++++++++++
>  netlink/settings.c |  82 ++++++++++++-
>  6 files changed, 486 insertions(+), 3 deletions(-)
>  create mode 100644 netlink/plca.c
>=20
> diff --git a/Makefile.am b/Makefile.am
> index 999e7691e81c..cbc1f4f5fdf2 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -42,6 +42,7 @@ ethtool_SOURCES +=3D \
>  		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
>  		  netlink/module-eeprom.c netlink/module.c netlink/rss.c \
>  		  netlink/desc-rtnl.c netlink/cable_test.c netlink/tunnels.c \
> +		  netlink/plca.c \
>  		  uapi/linux/ethtool_netlink.h \
>  		  uapi/linux/netlink.h uapi/linux/genetlink.h \
>  		  uapi/linux/rtnetlink.h uapi/linux/if_link.h \
> diff --git a/ethtool.8.in b/ethtool.8.in
> index eaf6c55a84bf..c43c6d8b5263 100644
> --- a/ethtool.8.in
> +++ b/ethtool.8.in
[...]
> +.TP
> +.BI node\-cnt \ N
> +The node-cnt [1 .. 255] should be set after the maximum number of nodes =
that
> +can be plugged to the multi-drop network. This parameter regulates the m=
inimum
> +length of the PLCA cycle. Therefore, it is only meaningful for the coord=
inator
> +node (\fBnod-id\fR =3D 0). Setting this parameter on a follower node has=
 no
> +effect. The \fBnode\-cnt\fR parameter maps to IEEE 802.3cg-2019 clause=
=20
> +30.16.1.1.3 (aPLCANodeCount).
> +.TP
> +.BI to\-tmr \ N
> +The TO timer parameter sets the value of the transmit opportunity timer =
in=20
> +bit-times, and shall be set equal across all the nodes sharing the same
> +medium for PLCA to work. The default value of 32 is enough to cover a li=
nk of
> +roughly 50 mt. This parameter maps to  IEEE 802.3cg-2019 clause 30.16.1.=
1.5
> +(aPLCATransmitOpportunityTimer).
> +.TP
> +.BI burst\-cnt \ N
> +The \fBburst\-cnt\fR parameter [0 .. 255] indicates the extra number of =
packets
> +that the node is allowed to send during a single transmit opportunity.
> +By default, this attribute is 0, meaning that the node can send a sigle =
frame=20
> +per TO. When greater than 0, the PLCA RS keeps the TO after any transmis=
sion,
> +waiting for the MAC to send a new frame for up to \fBburst\-tmr\fR BTs. =
This can
> +only happen a number of times per PLCA cycle up to the value of this par=
ameter.
> +After that, the burst is over and the normal counting of TOs resumes.
> +This parameter maps to IEEE 802.3cg-2019 clause 30.16.1.1.6 (aPLCAMaxBur=
stCount).
> +.TP
> +.BI burst\-tmr \ N
> +The \fBburst\-tmr\fR parameter [0 .. 255] sets how many bit-times the PL=
CA RS
> +waits for the MAC to initiate a new transmission when \fBburst\-cnt\fR i=
s=20
> +greater than 0. If the MAC fails to send a new frame within this time, t=
he burst
> +ends and the counting of TOs resumes. Otherwise, the new frame is sent a=
s part
> +of the current burst. This parameter maps to IEEE 802.3cg-2019 clause
> +30.16.1.1.7 (aPLCABurstTimer). The value of \fBburst\-tmr\fR should be s=
et
> +greater than the Inter-Frame-Gap (IFG) time of the MAC (plus some margin)
> +for PLCA burst mode to work as intended.

There are some trailing spaces in these paragraphs.

> +.RE
> +.TP
> +.B \-\-get\-plca\-status
> +Show the current PLCA status for the given interface. If \fBon\fR, the P=
HY is
> +successfully receiving or generating the BEACON signal. If \fBoff\fR, th=
e PLCA
> +function is temporarily disabled and the PHY is operating in plain CSMA/=
CD mode.
>  .SH BUGS
>  Not supported (in part or whole) on all network drivers.
>  .SH AUTHOR
> @@ -1532,7 +1610,8 @@ Alexander Duyck,
>  Sucheta Chakraborty,
>  Jesse Brandeburg,
>  Ben Hutchings,
> -Scott Branden.
> +Scott Branden,
> +Piergiorgio Beruto.
>  .SH AVAILABILITY
>  .B ethtool
>  is available from

Do you have a strong reason to add your name here? In general, I rather
see lists like these as a historical relic. In this case, the list has
not been updated since 2017 and even before that, I'm pretty sure it is
only a small fraction of contributors. IMHO the git log serves the
purpose much better today.

[...]
> diff --git a/netlink/settings.c b/netlink/settings.c
> index 1107082167d4..a349e270dff9 100644
> --- a/netlink/settings.c
> +++ b/netlink/settings.c
[...]
> @@ -923,7 +987,10 @@ int nl_gset(struct cmd_context *ctx)
>  	    netlink_cmd_check(ctx, ETHTOOL_MSG_LINKINFO_GET, true) ||
>  	    netlink_cmd_check(ctx, ETHTOOL_MSG_WOL_GET, true) ||
>  	    netlink_cmd_check(ctx, ETHTOOL_MSG_DEBUG_GET, true) ||
> -	    netlink_cmd_check(ctx, ETHTOOL_MSG_LINKSTATE_GET, true))
> +	    netlink_cmd_check(ctx, ETHTOOL_MSG_LINKSTATE_GET, true) ||
> +	    netlink_cmd_check(ctx, ETHTOOL_MSG_LINKSTATE_GET, true) ||

You accidentally duplicated the line here.

> +	    netlink_cmd_check(ctx, ETHTOOL_MSG_PLCA_GET_CFG, true) ||
> +	    netlink_cmd_check(ctx, ETHTOOL_MSG_PLCA_GET_STATUS, true))
>  		return -EOPNOTSUPP;
> =20
>  	nlctx->suppress_nlerr =3D 1;
> @@ -943,6 +1010,12 @@ int nl_gset(struct cmd_context *ctx)
>  	if (ret =3D=3D -ENODEV)
>  		return ret;
> =20
> +	ret =3D gset_request(nlctx, ETHTOOL_MSG_PLCA_GET_CFG,
> +			   ETHTOOL_A_PLCA_HEADER, plca_cfg_reply_cb);
> +
> +	if (ret =3D=3D -ENODEV)
> +		return ret;
> +
>  	ret =3D gset_request(nlctx, ETHTOOL_MSG_DEBUG_GET, ETHTOOL_A_DEBUG_HEAD=
ER,
>  			   debug_reply_cb);
>  	if (ret =3D=3D -ENODEV)
> @@ -950,6 +1023,13 @@ int nl_gset(struct cmd_context *ctx)
> =20
>  	ret =3D gset_request(nlctx, ETHTOOL_MSG_LINKSTATE_GET,
>  			   ETHTOOL_A_LINKSTATE_HEADER, linkstate_reply_cb);
> +
> +	if (ret =3D=3D -ENODEV)
> +		return ret;
> +
> +
> +	ret =3D gset_request(nlctx, ETHTOOL_MSG_PLCA_GET_STATUS,
> +			   ETHTOOL_A_PLCA_HEADER, plca_status_reply_cb);
>  	if (ret =3D=3D -ENODEV)
>  		return ret;

Please make the whitespace consistent with existing code, i.e. no empty
line between gset_request() call and the test of ret and no double empty
line.

As I have no actual objections, I can adjust the whitespace issues here
and in ethtool.8.in if you would prefer to avoid v6 before moving on to
the MAC merge series.

Michal

--v4aw2chwuganwrv2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmPpRJ4ACgkQ538sG/LR
dpWdPwgApccWyVwdw5CfaaabNORB3hR+fIHo+dU11o7aILHL84NA/yjsUEtRm58m
pMKYlNgjn4/4TfW4lguB9qQBYklbm8fOz9KC4sqp1lgZy0Wtd0xdNqnfkchfa047
Vl9OebV3h5g60CpoNn6TLMQfGqLxePmq5JY2OfGgDGMKmKiKGhqd3zPWz5murRJh
aARcjZDJSjn3wYSundrMIl8KZ2Q0uEi36hup9rgIK/N+g6nBmdtVo2Gwo0V85+tO
TLv6wvXmLbwjIj9zt5Rm84vuQJgH8Ddo3TYv/17DlxIU1EutCK7C1P+GtjY3SNQ+
DTQxPuksEbWblywQArjT5+DB5cxFNw==
=kWER
-----END PGP SIGNATURE-----

--v4aw2chwuganwrv2--
