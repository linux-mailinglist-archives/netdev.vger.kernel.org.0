Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126CE611DB8
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 00:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiJ1Wvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 18:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiJ1Wva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 18:51:30 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE6B215521
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 15:51:29 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 64655224BF;
        Fri, 28 Oct 2022 22:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1666997488; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W9eisdRlzj471yPDD71u7NMYY7QjBQAF9lX1/gem854=;
        b=tyr9CmbLRRAerdQP+0In6pMR/kxwkozCgddD4272KUF8nBDa/1Rod9vh2uT3TnSaOtjGfK
        haA3MrasjWl8vK6fb+y3x8r3QNAW7+k72MwWUSWj2bl/HVpMwLjhuWe0pOwlG7pb1+eIFD
        mioZXgWV7S2dEO4gyXIxaJIGb2hbagg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1666997488;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W9eisdRlzj471yPDD71u7NMYY7QjBQAF9lX1/gem854=;
        b=vsCKWDoDmYEKGxZVWuoK98ulSsNuRc49flzi0UojB61gWmF4KzoMyY8AgoaBWNTzLz/BSQ
        slpl0fu9T5m0ryDg==
Received: from lion.mk-sys.cz (unknown [10.163.29.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 5BFE62C141;
        Fri, 28 Oct 2022 22:51:28 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 3DCA960941; Sat, 29 Oct 2022 00:51:28 +0200 (CEST)
Date:   Sat, 29 Oct 2022 00:51:28 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc:     NETDEV ML <netdev@vger.kernel.org>
Subject: Re: [PATCH] ethtool: fix man page errors
Message-ID: <20221028225128.nwhsqdjbme6kx3d5@lion.mk-sys.cz>
References: <20221024163946.7170-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hfje2yswg5sdbfto"
Content-Disposition: inline
In-Reply-To: <20221024163946.7170-1-xose.vazquez@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hfje2yswg5sdbfto
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 24, 2022 at 06:39:46PM +0200, Xose Vazquez Perez wrote:
> troff: <standard input>:82: warning: macro '.' not defined
> troff: <standard input>:252: warning: macro 'RN' not defined
> troff: <standard input>:698: warning: macro 'E' not defined
>=20
> Cc: Michal Kubecek <mkubecek@suse.cz>
> Cc: NETDEV ML <netdev@vger.kernel.org>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> Tested with:
> man --warnings -E UTF-8 -l -Tutf8 -Z ethtool.8 > /dev/null
> groff -z -wall -b -e -t ethtool.8
>=20
> ---
>  ethtool.8.in | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/ethtool.8.in b/ethtool.8.in
> index dee39dd..c4477f0 100644
> --- a/ethtool.8.in
> +++ b/ethtool.8.in
> @@ -79,7 +79,7 @@
>  .\"	\(*NC - Network Classifier type values
>  .\"
>  .ds NC \fBether\fP|\fBip4\fP|\fBtcp4\fP|\fBudp4\fP|\fBsctp4\fP|\fBah4\fP=
|\fBesp4\fP|\fBip6\fP|\fBtcp6\fP|\fBudp6\fP|\fBah6\fP|\fBesp6\fP|\fBsctp6\fP
> -..
> +.
>  .\"
>  .\" Start URL.
>  .de UR
> @@ -249,7 +249,7 @@ ethtool \- query or control network driver and hardwa=
re settings
>  .RB [\fBeth\-phy\fP]
>  .RB [\fBeth\-mac\fP]
>  .RB [\fBeth\-ctrl\fP]
> -.RN [\fBrmon\fP]
> +.RB [\fBrmon\fP]
>  .RB ]
>  .HP
>  .B ethtool \-\-phy\-statistics

These two changes look good to me.

> @@ -695,7 +695,7 @@ naming of NIC- and driver-specific statistics across =
vendors.
>  .RS 4
>  .TP
>  .B \fB\-\-all\-groups
> -.E
> +.RE
>  .TP
>  .B \fB\-\-groups [\fBeth\-phy\fP] [\fBeth\-mac\fP] [\fBeth\-ctrl\fP] [\f=
Brmon\fP]
>  Request groups of standard device statistics.

I believe ".RE" is wrong here as it would result in "--groups ..." not
indented correctly (like "-t --test" rather than like "--all-groups").
The same problem already exists between "--groups ..." and
"--phy-statistics" which is incorrectly indented. IMHO the ".RE" should
not come until after "--phy-statistics", i.e.

--8<--------
@@ -695,14 +694,13 @@ naming of NIC- and driver-specific statistics across =
vendors.
 .RS 4
 .TP
 .B \fB\-\-all\-groups
-.E
 .TP
 .B \fB\-\-groups [\fBeth\-phy\fP] [\fBeth\-mac\fP] [\fBeth\-ctrl\fP] [\fBr=
mon\fP]
 Request groups of standard device statistics.
-.RE
 .TP
 .B \-\-phy\-statistics
 Queries the specified network device for PHY specific statistics.
+.RE
 .TP
 .B \-t \-\-test
 Executes adapter selftest on the specified network device. Possible test m=
odes are:
--8<--------

Michal

--hfje2yswg5sdbfto
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmNcXOkACgkQ538sG/LR
dpUUOwgAtXF5+mRhdR10ZQ2XdzHvN/RzxD+q1mS9HMu/49qbgASF3jppFx/+4T+4
FFBq3w20PlM7q2fFnfC+0RMYqW1b9O00hc0eS+0W+W3jEpNPwd5eqHR5AaNtqfmc
aaVB4vum3kx2QCGcYFeYMSipCcp0JlZM4bHG5elcYhu23PBwzXZKfjHMfe5lXcVj
Y0k4P+QeDv4ZRRREqfdvXCOj+za9KThDhlIECLv6pn602oIzQ3FA2YsgdzLgbHgi
GsnKUll5UnysOxIaIC8hbDHwBmyK9FPvzSpFUL7R7e4eOAFGAPWpwTYtcYikkWpY
Pny6bo+8tu8MRnR0jTiWKYi/l7ExNw==
=J2Ee
-----END PGP SIGNATURE-----

--hfje2yswg5sdbfto--
