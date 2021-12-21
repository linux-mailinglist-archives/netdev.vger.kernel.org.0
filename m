Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F1D47BEB4
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 12:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236981AbhLULPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 06:15:25 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:45167 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236868AbhLULPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 06:15:24 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JJDQJ6X2bz4xd4;
        Tue, 21 Dec 2021 22:15:20 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1640085322;
        bh=zZkCmuM8dy4u5SSNbvtKZOSY0KcRa0sAsxjjN0iRWV8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bs8jiSf/vPfTKKvCvF4JagdjJXCr5cFOvXW8b9lQUuE4Hne9MfQkZIoqwPB4myzcg
         OB9Nq5xi4jzNDk2ZAYexdioBmMIFTJUfzupBQWdjbYkozWkW5TBqrZX5dFLQ+Gcmk2
         tiigMsntVg4AukNjmKqjXmVx4hCdZHEy5IGzBjjw90KwTABrxiCe40freTUq+2bD+I
         vg4fTYX4zvgUCOAxgBwAhk5cdcUKavjkQUsYB/4PTNdTB2tkjD/HLz5LfdK//ISk3Y
         w5gvfRa5BTfySimwUSkJqC06gjXwYrI7DZiKA5sz/JEXBKbTKkD/SewMkwo0+JiFRc
         B8WKtOGqxQAig==
Date:   Tue, 21 Dec 2021 22:15:19 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Wen Gong <quic_wgong@quicinc.com>,
        Ayala Beker <ayala.beker@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the mac80211-next tree
Message-ID: <20211221221519.75dff443@canb.auug.org.au>
In-Reply-To: <82d41a8b2c236fa40697094a3d4a325865bde2b2.camel@sipsolutions.net>
References: <20211221115004.1cd6b262@canb.auug.org.au>
        <82d41a8b2c236fa40697094a3d4a325865bde2b2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/mdMhyTlXJ9ilgL7/L=l+t69";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/mdMhyTlXJ9ilgL7/L=l+t69
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

On Tue, 21 Dec 2021 12:02:57 +0100 Johannes Berg <johannes@sipsolutions.net=
> wrote:
>
> Thanks for the heads-up, also on the merge issue.
>=20
> I'll pull back net-next and fix this.

Or just let Dave know when you ask him to merge your tree ...

--=20
Cheers,
Stephen Rothwell

--Sig_/mdMhyTlXJ9ilgL7/L=l+t69
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHBt0cACgkQAVBC80lX
0GxbTwf8DfhkfVzmA7j2mmLtUtXDDkcNcISrPuY/pUkPdzruPDtH1FggXnOMmlx0
CL58GtGrSM42GF2ijl48GSVSekZFcMslCg6Pliaj13j+MHXc5oYRVwTJ5RnsIiTz
zbrnnHcrUgr2/MdozDuyuJ1KE71s3Ob/rcoBUWFAF9VMrdMhLDePbqZmJxvvjpsI
vi/yMi5/TJ6jfVxyTOjhzw5cs/Jjlv3bvPo+poQeMbbA2siYgVSyI34G8aVeKXQY
XF80i+ExgZm81YUzdwInrwlpoYiIi1O3sRHFJCAIUS/VSP4FoOR/Z/SdU4WgNZ6L
kJjn18KucsujyqMzBqpBRAIFJLBxjQ==
=pY8G
-----END PGP SIGNATURE-----

--Sig_/mdMhyTlXJ9ilgL7/L=l+t69--
