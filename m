Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B2D67EEF
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 14:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbfGNMPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 08:15:30 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40955 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728302AbfGNMPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jul 2019 08:15:30 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45mlws5CXkz9sBt;
        Sun, 14 Jul 2019 22:15:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1563106527;
        bh=zCtnZaNPQCWLcBCQ4GnLDTPHFxRXQKg3Uco8fUMs/U8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jTRXk0IqFLeHoB8sGWzc2i22FhF6SW/SCFSUW/u07ueo3s10Jeif0IMxnB0oCl5m3
         AMOl6TXpvUDkOVmKa3woAO3MsRh0MvvJQmoCb+sgNw5zH7SghS6sAchSZ4roNxk9lF
         LEXQL+KrjSMUp8jP6f2oqbGzHKQfRUq4C5sMjQo7UMscoKxWq5gJASd1VThFTyrCD3
         H/mqvKvihbZq7aNRjOSTg0fc3CzZedbZrHRRyz7vwbx/DJl+B4Jout2o6afRutxRWm
         EN55QGbp316iJc6d80KW1uaCFEM8cCqF/dxP6bRIPHDvCoevUcEOoamg+GhOtzfhy3
         B7HHUSEav77Nw==
Date:   Sun, 14 Jul 2019 22:15:11 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20190714221511.7717d6de@canb.auug.org.au>
In-Reply-To: <4f524361-9ea3-7c04-736d-d14fcb498178@mellanox.com>
References: <20190712165042.01745c65@canb.auug.org.au>
        <4f524361-9ea3-7c04-736d-d14fcb498178@mellanox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/HR3_qu0kY4vLk3q+cvEgK6A"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/HR3_qu0kY4vLk3q+cvEgK6A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Tariq,

On Sun, 14 Jul 2019 07:55:48 +0000 Tariq Toukan <tariqt@mellanox.com> wrote:
>
> How do you think we should handle this?

Dave doesn't rebase his trees, so all you can really do is learn from
it and not do it again :-)

--=20
Cheers,
Stephen Rothwell

--Sig_/HR3_qu0kY4vLk3q+cvEgK6A
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0rHM8ACgkQAVBC80lX
0GwXrQf9H3vPyShbxrWd+9Vw75CQ+e1v8Qe34v6K9YkmD6yt/KWC9vXzjXMdV33b
Remz+W/t1DdbhDcJ2/i1fJo5kwvmhY9hfKwN+rHXpWoDnmopGBQJItC1dqybGQq7
TxIVmJKEIFFIRDDRNYyCbuRS+3oyW8fwxTeXsVaRqYyxoKnUOkoTqbwE2xxtMnWN
bBwNrJwL6WHyJCAEJgusV38lBbQAhRQ06vsS4m7feWqv1hPxTWdo2TYcrQJ74YhA
Qc+AcfWCRk9t4W7ip2qU3bgP9Q7LE8c3DMdD6E5fjjfb+3uHz3MxKTdrypUAACxB
BUWpzU7CPpv8TLe0UuPkIWQhHq4ULw==
=bBcO
-----END PGP SIGNATURE-----

--Sig_/HR3_qu0kY4vLk3q+cvEgK6A--
