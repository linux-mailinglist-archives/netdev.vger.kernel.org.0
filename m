Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6022264064
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 10:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbgIJIry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 04:47:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726847AbgIJIru (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 04:47:50 -0400
Received: from saruman (91-155-214-58.elisa-laajakaista.fi [91.155.214.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C4F920770;
        Thu, 10 Sep 2020 08:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599727668;
        bh=RPokpgxyglYjppmxdwE4ETpgoWb+FLMn8txdhEbALdk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=caMPoUSKexLI6/Cqhtg8fT99cl3GRCJBgwM+b8CDUH4fpndiULhN2ZxxlePCqMtm8
         o+PPIhKL0Yab4dKBUBJb9PAX9HTFJdHyhq4ZrB98n0hws/gO34J2oo99WhyXQG8LAo
         ih4L+nIDe5nvGNhsdtsxYZAUrexQb+0pD4TKBRdk=
From:   Felipe Balbi <balbi@kernel.org>
To:     Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>
Cc:     Kees Cook <kees.cook@canonical.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-rdma@vger.kernel.org,
        iommu@lists.linux-foundation.org, dm-devel@redhat.com,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, intel-wired-lan@lists.osuosl.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-nvme@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-scsi@vger.kernel.org,
        storagedev@microchip.com, sparclinux@vger.kernel.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-parisc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, bpf@vger.kernel.org,
        dccp@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-sctp@vger.kernel.org,
        alsa-devel <alsa-devel@alsa-project.org>
Subject: Re: [trivial PATCH] treewide: Convert switch/case fallthrough; to
 break;
In-Reply-To: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
References: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
Date:   Thu, 10 Sep 2020 11:47:27 +0300
Message-ID: <878sdikogw.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Joe Perches <joe@perches.com> writes:
>  drivers/usb/dwc3/core.c                                   |  2 +-
>  drivers/usb/gadget/legacy/inode.c                         |  2 +-
>  drivers/usb/gadget/udc/pxa25x_udc.c                       |  4 ++--
>  drivers/usb/phy/phy-fsl-usb.c                             |  2 +-

for the drivers above:

Acked-by: Felipe Balbi <balbi@kernel.org>

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAl9Z6B8RHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQZSCRAAuTv1hrqhd9iVfnwXFrfx8dYquoCMc3VI
y1IiULV6avnZvLQTqKviHDvZw05WY6dna714mpLFW1laW3WuhLSD4elIu6cqHaiz
ZgtvtA4bZ/s7ipV+jlZ86S9oIz4MMBbZYhqSN1ZVk50NsUA/1thpcjS0aLI5SAgX
j2dV6BEEHBSgMDwcWLPNwr6f5R/ycEBx3i6HYSSdNtBr1SK+UhbSkwNxdCA9IzH8
1WCugmJdohP26DIYNzFZcssjcSFb5wu2iuHXQXuvOmmAfQmro+gRcnq1SOElae7v
cas67L69RQ5fxskM/XpIYH2AURFnRUNondcJWViUQXHwXF1U0r+FdwXUr8OeFi19
sVEI4FNu7ZqgvhfUlKMpldyUZRIrWb+WZZ5toBQAKFee/3tqTs4Tqh9cwfLL9IU4
ho4tG7J/bd6hASfr0x2dH5Pm7oXKskxmtUpmmSVlNaTpXytiD30+pUvOl9Qg7A+X
tc9h6N3Z6kdVxkJlm1KpUUccPeUtHox549ukAtzKQL4x6PDCdNqBkNDVSIx04FA4
dgyt4O7w4HaWT1GPHH322pG5nNT1dsGT0CC9QA/2AJkoXTY03YGR3dgDw89GNUrP
WPj73gtBbWTwRFuwHQQs8F/E8x2UjBC005aawoKcK2bxBR1fzqz1y8daUaiCftnV
ocu1QwRIgL8=
=BFTp
-----END PGP SIGNATURE-----
--=-=-=--
