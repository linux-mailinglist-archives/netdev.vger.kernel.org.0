Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C280048F1F7
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 22:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiANVSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 16:18:12 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:59435 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiANVSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 16:18:12 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JbDfn6TZnz4y4m;
        Sat, 15 Jan 2022 08:18:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1642195090;
        bh=aqd+9WcXOs53PGQiQ5d6p966oQvb4Ym651YYmVvLbjE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YZax+LF7uTRPl6eHye+HHpO5u/NsJK5NeR25+UgQGkdIgCl8M6If5ejZ/zdbXmQ4n
         IgiqMrXhU+GrjXWUyYdRB6/eOd27QZgEjzVri4xITP1hX1GfEYvRPqBbj7uSY6Tne8
         X4qFW7VTTLglalr4h8qv+BwX5ppb2ocZSWFSqFHAjihuuqzPgj5FjF0wzSFm3T0KQc
         +fMEApy1TvHY5TajYuK9E/Rl3PALgjyaEVFLglJ4LfZ1P98So95eXecCNpWxrnAfQY
         +FESqhOf0QsDvjmEJ+m4AbjAwdXaVUMFAeYgQ1gGBwKGCPIB6r5ZY9gF8ILBtc5yhT
         iEqP4EU5C7KJA==
Date:   Sat, 15 Jan 2022 08:18:09 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com
Subject: Re: [PATCH wireless] MAINTAINERS: add common wireless and
 wireless-next trees
Message-ID: <20220115081809.64c9fec5@canb.auug.org.au>
In-Reply-To: <20220114133415.8008-1-kvalo@kernel.org>
References: <20220114133415.8008-1-kvalo@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/54f_YPH=tNa4afEtyMIegyt";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/54f_YPH=tNa4afEtyMIegyt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

On Fri, 14 Jan 2022 15:34:15 +0200 Kalle Valo <kvalo@kernel.org> wrote:
>
> For easier maintenance we have decided to create common wireless and
> wireless-next trees for all wireless patches. Old mac80211 and wireless-d=
rivers
> trees will not be used anymore.
>=20
> While at it, add a wiki link to wireless drivers section and a patchwork =
link
> to 802.11, mac80211 and rfkill sections.
>=20
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Kalle Valo <kvalo@kernel.org>
> ---
>=20
> Stephen, please use these new trees in linux-next from now on.

Done from today.  I have set you and Johannes as contacts along with
the linux-wireless mailing list.  Also, I assume you meant to mention
that I should use the branches called "main".

--=20
Cheers,
Stephen Rothwell

--Sig_/54f_YPH=tNa4afEtyMIegyt
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHh6JEACgkQAVBC80lX
0GykRwf/dF3ug/FXpM5DXFuCbr7Jxx/z5/BTp5RrYTaNiqiS8xtKDYsUUkvB+ErC
EcFYzush/ySH743I9rH9TPJxuWn1qt7WOmfkfiWpbCF1+/e+25vD+JfF8E5xWpC1
TE6//171OE6nX5KcksOpDjf0bg0jKaS6q8BoKByvwEg3NNvsJennJTRHHMeZSJU9
u56jxF6Elb+WHe4rFSFeoPvBf5SOSk9Ti6nwT334Y3NHm+xKu0cbfbw6Mk8AWzRK
vSeaOq3GdImBW1bYfUUaxR+Ohes6w/53xU9kpvCLZ1xYjamoWxWJy0OevGCBcGUp
zoPG7pFdeNvgUwEKdw/4t3biAkDBMQ==
=E95i
-----END PGP SIGNATURE-----

--Sig_/54f_YPH=tNa4afEtyMIegyt--
