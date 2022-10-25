Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD7A60CF05
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbiJYOay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiJYOay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:30:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4718AF418A
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:30:50 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id ECBA821FC9;
        Tue, 25 Oct 2022 14:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1666708248; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C3/7GywoiA3qPX6i4A2QZCiKxQTZoDfxVv/hdsAYfwk=;
        b=UbL5PxYpapOazFvnn9OhpSSSM7eZ2u2+0Q5OcNI81kwXJ7SY5aXQL/6876k4eP2b0PWleo
        qP7j4BBzMlkaHNpZvRjFdcqNvzgPVEOPZVcpJSU7YmZGSxC5qp4sN/5DIqVhWcD2NEmw0A
        AFYE50q5yt3JFKKYoRAevokdbjYQOGo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1666708248;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C3/7GywoiA3qPX6i4A2QZCiKxQTZoDfxVv/hdsAYfwk=;
        b=w7fbruGwlWVyRcy9Q3HCJQiujWjRxKtJVZvVwzXtjPwkoR4tvbPvdzBTOS5ptBFXpAMiRR
        BjEQObeExUmDlgAA==
Received: from lion.mk-sys.cz (unknown [10.163.44.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id DECC22C141;
        Tue, 25 Oct 2022 14:30:48 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id CAF1F60966; Tue, 25 Oct 2022 16:30:48 +0200 (CEST)
Date:   Tue, 25 Oct 2022 16:30:48 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc:     NETDEV ML <netdev@vger.kernel.org>
Subject: Re: [PATCH] ethtool: fix man page errors
Message-ID: <20221025143048.lobgevuyvvgkoisb@lion.mk-sys.cz>
References: <20221024163946.7170-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qmmpawbt6ws3mbql"
Content-Disposition: inline
In-Reply-To: <20221024163946.7170-1-xose.vazquez@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_SOFTFAIL,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qmmpawbt6ws3mbql
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

These errors are not related to the patch, v6.0 gives exactly the same
result. The changes below should fix them but I'll rather double check
before submitting it, I'm not very familiar with the syntax.

Michal

-8<---
diff --git a/ethtool.8.in b/ethtool.8.in
index 1c0e2346f3a1..f34e945e271d 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -79,7 +79,6 @@
 .\"	\(*NC - Network Classifier type values
 .\"
 .ds NC \fBether\fP|\fBip4\fP|\fBtcp4\fP|\fBudp4\fP|\fBsctp4\fP|\fBah4\fP|\=
fBesp4\fP|\fBip6\fP|\fBtcp6\fP|\fBudp6\fP|\fBah6\fP|\fBesp6\fP|\fBsctp6\fP
-..
 .\"
 .\" Start URL.
 .de UR
@@ -249,7 +248,7 @@ ethtool \- query or control network driver and hardware=
 settings
 .RB [\fBeth\-phy\fP]
 .RB [\fBeth\-mac\fP]
 .RB [\fBeth\-ctrl\fP]
-.RN [\fBrmon\fP]
+.RB [\fBrmon\fP]
 .RB ]
 .HP
 .B ethtool \-\-phy\-statistics
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
-8<---

--qmmpawbt6ws3mbql
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmNX8xMACgkQ538sG/LR
dpUOWQgAj85vhtapkhfLLtl2E4cRX1YSlNy1ZLtcK/ky5v7p81eYUul9z7CVWQ5+
hzY08Km4XBd/W31KZqk4dYXpBrd7QrckbBVitGrHTBwG12N/miVZrxtbZZY0w0lD
9BHXCrBzHx77c3m6EFUMOb0rLD6nn0Wa3D2OVpjNuPzWEIWp82u48h+MfwRXUnli
OYOOJ/2DG1RyYM7x/ZhB2IQHR0VdFfuPsKW6lfIaMZaESl/h8++f7CVIdx2tO2JI
IhipPMfw9zLpbpTl1EUrywISfUsflh7NyLJuwIJLVwfjxqgoIWYBULLFcEuLZf78
Qc/suiZpJrQwgLrZvV1YK8Ms8VMCQQ==
=mB4q
-----END PGP SIGNATURE-----

--qmmpawbt6ws3mbql--
