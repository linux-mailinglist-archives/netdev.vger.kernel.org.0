Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C74423661
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 05:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbhJFDwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 23:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhJFDwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 23:52:15 -0400
X-Greylist: delayed 410 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Oct 2021 20:50:24 PDT
Received: from gimli.rothwell.id.au (gimli.rothwell.id.au [IPv6:2404:9400:2:0:216:3eff:fee1:997a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA85C061749;
        Tue,  5 Oct 2021 20:50:23 -0700 (PDT)
Received: from authenticated.rothwell.id.au (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.rothwell.id.au (Postfix) with ESMTPSA id 4HPKzx3yL0z101M;
        Wed,  6 Oct 2021 14:43:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rothwell.id.au;
        s=201702; t=1633491806;
        bh=XO+0Xhw21W4/0Mk9c03o2/Jf8G9l8/F80awZFNi1ApQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e8gIeca8l2SWih+XLakjitFrSvB/Y8qu4X9ZW/CS6UabTf79w56wUkXI1bjin1NyK
         71TBPrbGzu6B3dRJ7fdAeqFeb3yFtoxWyxof9/oaaesrqYr9bNwJGcfDv91wvq7jMy
         zcpuNFjfau/GrY62Ytrlyh6AFNbAdSuWnb4dBgfoieVOJElKxBD3sxSgdIx8DqctnD
         eun8vghH7rntK5YX18fAmNfbTyv/cPv4XLxpcircFZmqeYdRAlYghLJUb8ZuQFwBYX
         mR7GAts3SwYqKvVyxA1R8c6wnlyMpdyY6W6LyLcJLuReJ8uFgU5b2JzP//dRPnldeZ
         vRG53/0oKAvzw==
Date:   Wed, 6 Oct 2021 14:43:22 +1100
From:   Stephen Rothwell <sfr@rothwell.id.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20211006144322.640b966a@elm.ozlabs.ibm.com>
In-Reply-To: <20211005185217.7fb12960@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211006122315.4e04fb87@canb.auug.org.au>
        <20211005185217.7fb12960@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/U0eCoNvbiJYoTXcpB5kKmJ_";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/U0eCoNvbiJYoTXcpB5kKmJ_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jakub,

On Tue, 5 Oct 2021 18:52:17 -0700 Jakub Kicinski <kuba@kernel.org> wrote:
>
> Applied, thanks. Is this the last one? ;)

No idea :-(

> I wonder what happened to the kbuild bot :S

Does it do ppc builds?

--=20
Cheers,
Stephen Rothwell

--Sig_/U0eCoNvbiJYoTXcpB5kKmJ_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFdG1oACgkQAVBC80lX
0GwVagf/Sc+2+FiM2X+efpF5Zxon+9nwfrG4j0c0/pQqzOGG6xnFSioW+UvtqFDE
bgqr5ODrlVrJbiSQ4E3W5a5UEeq+H+yIqBMFkyutaIc8/KQ8XJH5Gejsh+9V3m+d
m9nPmvfKay8W+LuqUdlWYRZsczROLYO+i1ObYS0xwAqzDJoDWSd95hk2OsplaJ6+
bZIjkaBk4rfM8uM1B4CErSwN5EyaXw/4+BUsy7h1AtVJ78eRhSSXmwIWoa1lwUih
qYXc0i4vGfhUUFQjFxFdxbOL6X9I9GrzMUgSmM2UynfICvd/fgjjtnIwjVDi4i+G
ZBnYAZGTmuq+2yV+a1XMflsvbEmIbw==
=s87e
-----END PGP SIGNATURE-----

--Sig_/U0eCoNvbiJYoTXcpB5kKmJ_--
