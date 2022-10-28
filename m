Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFE2611D7E
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 00:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiJ1Wpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 18:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJ1Wpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 18:45:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A72FFC6EE
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 15:45:48 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D01171FFFD;
        Fri, 28 Oct 2022 22:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1666997146; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/SvBRPXSuaVxEiAgg9su2F4Avpq38TkdclQDzuGUSJA=;
        b=MIwclEyfHmfHtjeWXFXzk3UsXdLnOCE9/0t1I/9x1JgVgwGsd9N3Oncrwe4G+IokN96F4X
        H6Kj8Gef91670x+QEXm7AtRdNG5G79t2Kna8l1Jvk/TSzQH4B7D+qiFtz0v+6a7O4ta+Zm
        op0jqXArKMZR/e/ru89jGBYtpAu93+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1666997146;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/SvBRPXSuaVxEiAgg9su2F4Avpq38TkdclQDzuGUSJA=;
        b=aVotWMVMKmsVeV81m2PHvN7cDKu1fKWIArmdUHqlAoM+t/zJQF3jz8QNpH9uu3zDbAfvYc
        Lm5+GlrDfb8k5uBw==
Received: from lion.mk-sys.cz (unknown [10.163.29.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C8E112C141;
        Fri, 28 Oct 2022 22:45:46 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 4CEA460941; Sat, 29 Oct 2022 00:45:41 +0200 (CEST)
Date:   Sat, 29 Oct 2022 00:45:41 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc:     NETDEV ML <netdev@vger.kernel.org>
Subject: Re: [PATCH] ethtool: fix man page errors
Message-ID: <20221028224541.3nxji3wrza3ohm62@lion.mk-sys.cz>
References: <20221024163946.7170-1-xose.vazquez@gmail.com>
 <20221025143048.lobgevuyvvgkoisb@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vwxyclqstwbdugrk"
Content-Disposition: inline
In-Reply-To: <20221025143048.lobgevuyvvgkoisb@lion.mk-sys.cz>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vwxyclqstwbdugrk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 25, 2022 at 04:30:48PM +0200, Michal Kubecek wrote:
> On Mon, Oct 24, 2022 at 06:39:46PM +0200, Xose Vazquez Perez wrote:
> > troff: <standard input>:82: warning: macro '.' not defined
> > troff: <standard input>:252: warning: macro 'RN' not defined
> > troff: <standard input>:698: warning: macro 'E' not defined
> >=20
> > Cc: Michal Kubecek <mkubecek@suse.cz>
> > Cc: NETDEV ML <netdev@vger.kernel.org>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > ---
> > Tested with:
> > man --warnings -E UTF-8 -l -Tutf8 -Z ethtool.8 > /dev/null
> > groff -z -wall -b -e -t ethtool.8
>=20
> These errors are not related to the patch, v6.0 gives exactly the same
> result. The changes below should fix them but I'll rather double check
> before submitting it, I'm not very familiar with the syntax.

Sorry for the noise, I thought this was sent as a response to my earlier
patch. I'll send a proper review in a moment.

Michal

--vwxyclqstwbdugrk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmNcW44ACgkQ538sG/LR
dpUj5AgAuDtNFQ04fnhQk/7FL0tB0K5n4CeNhoXHKVtkmLvUsrVHQ0tUOFPeKW7c
fWd0fwwqwzcMw3EGC5WfjmmomNbvZLA/h3knAOawKqjgALgaUNi9r7VktmPSDN5/
kC6gdace/ZvemwyObQX9qL3nQcd9ZodbIoRw9Z/nDDXKYAn20wEVsKmeBICK+HOv
+5XZfJzFvIDW6pImZmIrNFb5QSKLAsUIZ70SI2HN3P/s89o0YeZtE90uxkntTdY3
uRpn//FBKJ1UnkZWKz6YB5m4qQNMFrwrzx+oGcnOomYcN+A8Wt3ZfQ/PbvaOfDou
UzA4aMIFwghqsCLl04hnGbmXP2ZRrw==
=gSp3
-----END PGP SIGNATURE-----

--vwxyclqstwbdugrk--
