Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC98466A767
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 01:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjANANu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 19:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbjANANt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 19:13:49 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58399869DC
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 16:13:48 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 111D85C7E9;
        Sat, 14 Jan 2023 00:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1673655227; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+nsUMq54FPhuJ1/XVGnKipIvwrCPzZG9npI7coSJXRs=;
        b=BrFro3DR94wOj24/Bb5wNX34oB/MdtxP59T7Xfbi2A4jf3d8lMHn3wXVlXrPERtwvmnNS1
        xlU++gnJ1jiO4F4jUifNXGtfLzRBr5sV55VQbHDX1DWKE4r1+jov/2foU4KCLWLA17DpPy
        TqXq7EimeQvHisPz8/VOF0wTzQ88usU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1673655227;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+nsUMq54FPhuJ1/XVGnKipIvwrCPzZG9npI7coSJXRs=;
        b=Pz1B44hFR3KzDieP/E02Q+tbpEVkEQSLScsbKPK70kEJ3up0nW9fm1+ILBU2s5GMSLqOad
        I86C/RLy+cHqCcDg==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 042E42C141;
        Sat, 14 Jan 2023 00:13:47 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id C85DD60330; Sat, 14 Jan 2023 01:13:46 +0100 (CET)
Date:   Sat, 14 Jan 2023 01:13:46 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Markus Mayer <mmayer@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH ethtool 3/3] marvell.c: Fix build with musl-libc
Message-ID: <20230114001346.tm3f7f5px7swjuzf@lion.mk-sys.cz>
References: <20230113233148.235543-1-f.fainelli@gmail.com>
 <20230113233148.235543-4-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="s5rcijuhrxyeliyt"
Content-Disposition: inline
In-Reply-To: <20230113233148.235543-4-f.fainelli@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--s5rcijuhrxyeliyt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 13, 2023 at 03:31:48PM -0800, Florian Fainelli wrote:
> After commit 1fa60003a8b8 ("misc: header includes cleanup") we stopped
> including net/if.h which resolved the proper defines to pull in
> sys/types.h and provide a definition for u_int32_t. With musl-libc we
> need to define _GNU_SOURCE to ensure that sys/types.h does provide a
> definition for u_int32_t.
>=20
> Fixes: 1fa60003a8b8 ("misc: header includes cleanup")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  marvell.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/marvell.c b/marvell.c
> index d3d570e4d4ad..be2fc36b8fc5 100644
> --- a/marvell.c
> +++ b/marvell.c
> @@ -6,7 +6,7 @@
>   */
> =20
>  #include <stdio.h>
> -
> +#define _GNU_SOURCE
>  #include "internal.h"
> =20
>  static void dump_addr(int n, const u8 *a)

I would prefer replacing u_intXX_t types with standard uintXX_t and
including <stdint.h>. That would be consistent with the rest of the
code which uses ISO uintXX_t types or (older code) kernel uXX types.

Michal

--s5rcijuhrxyeliyt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmPB87YACgkQ538sG/LR
dpVy8AgAx/mjoBZtlF0Sd2gBNVfB9/aR9GuZe8/xXg5YfBgg/Z2NGAhyiN/xA6/I
I6B8xdSQeIBRbLbxPLL3Ig6fOsctMl32L6OwTEpJL6T8x2fFYlJOq9jd6XaFIsEy
RMCobhaQbBWZg+l7GirSMbgDuY1jVxkEA/y1jNh/rByA8MCVqIGkh7Wl9NFl0Oh4
8zHYOt1jq8zA/DaI/Iz7DdH3vvEpbUWPc8dqbcjQqnuP6jdweo7wOgVi0fm4aJGg
l9JX1CM+5+Xh/dARxw5LPTlFR1RVpdGEaVUpLB72FvY6fBBs5RyxqxtSjbZLHoa1
Ud594xldhNegy3ahx8a4+3gvEq8PbA==
=+Els
-----END PGP SIGNATURE-----

--s5rcijuhrxyeliyt--
