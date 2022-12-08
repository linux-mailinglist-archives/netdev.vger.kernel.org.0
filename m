Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E99646A45
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiLHIRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLHIRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:17:41 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56541164
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 00:17:39 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9D2242238E;
        Thu,  8 Dec 2022 08:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670487458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6zdHfslB7n6ySGgD27bYgdMgGk7khak8MJMiJ9Uy9xk=;
        b=Q8YfXW+lvSDnECX0rVabpid/m2kq0OEIoaWe1yMSrurSrsRwa+X6SRY7hYaxi+OhgFcN+R
        dW8x8FIQU/I3E/9siHNyYQD4+O047QxIllnXrPVSCQmThSub1QHaUo0+IsXIuv6/vK323U
        9H4wLe8Stqjww0P+E8ttJnlsMFcCdW8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670487458;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6zdHfslB7n6ySGgD27bYgdMgGk7khak8MJMiJ9Uy9xk=;
        b=wNonAeDllxDFDC/7lCRlg35iOKg0/DjDcoJRmkVXZkoDrSddrtslbYv/2i1cTS8i7TnJCR
        RWqNIBMggmfCKxBA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9332D2C141;
        Thu,  8 Dec 2022 08:17:38 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 689866045E; Thu,  8 Dec 2022 09:17:38 +0100 (CET)
Date:   Thu, 8 Dec 2022 09:17:38 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v2 01/13] ethtool: convert boilerplate licenses
 to SPDX
Message-ID: <20221208081738.ncnvukcohtuufug3@lion.mk-sys.cz>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
 <20221208011122.2343363-2-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3cwhgvqv7mczv7p5"
Content-Disposition: inline
In-Reply-To: <20221208011122.2343363-2-jesse.brandeburg@intel.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3cwhgvqv7mczv7p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 07, 2022 at 05:11:10PM -0800, Jesse Brandeburg wrote:
> Used scancode (ScanCode-Toolkit) to find some licenses that have
> old boilerplate style.
>=20
> In the interests of enabling better automated code License scanning,
> convert these to SPDX as the Linux kernel source has done.
>=20
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

Acked-by: Michal Kubecek <mkubecek@suse.cz>

--3cwhgvqv7mczv7p5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmORnZ0ACgkQ538sG/LR
dpXuqwf/b1vXOm5zFgIq2Uq1Kucbr3ONvFKj4V5mtdss+eJBXnu4DH7x/BM4weNw
iks41GGx/n4D2Q7+wboomKMIBW5H8p3yRgeEr9nH0amVM50hn4xdHbloDvEsy9MJ
KQGGGGFtLioBAdCNTuMqixhAkDWeka78H3fovlPPQASTXaKDzFLd3Qgv7fC4N3Ns
rs7n+GSgPqJwcCo2gJFHfjk3wW5jDb2OaU/RGw/iARhG+idzOT4ciCLok7AGoUox
8kRH+ryPs7Cn/i5vzDUq6s4IGkuBQt1bA2xFlSOONkTa3Jg5Pa/VIn7eUJwq4POp
jjbSuyjwXTw20/8/GE3c1UHUoagM9Q==
=MzaX
-----END PGP SIGNATURE-----

--3cwhgvqv7mczv7p5--
