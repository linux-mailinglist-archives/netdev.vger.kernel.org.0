Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94EEBADBC9
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 17:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfIIPIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 11:08:52 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38281 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbfIIPIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 11:08:52 -0400
Received: by mail-wm1-f65.google.com with SMTP id o184so15117415wme.3;
        Mon, 09 Sep 2019 08:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bkcaGhT4i1YczVLSYGucQECEKh6an5T4AF5+XBynpKQ=;
        b=Iv3YgMINM8MI4r/hatRem1z/iT7ykqT8egkiqnuw52yBf+jDx6cY8WMhkxN8Nx4Gpi
         Stb1ZTPDWwC5HNYyLx/DZkFI+zu4H9RTejkzkyxtS73PhdBwAcW9Q+0CNeXHUAyHOSsO
         Ut3Rbv0smOf0k8b9LxG09zqfYQXff1nDYTKSQRX4+slyBkQhqTj9k9+Fen6McEfCKZr1
         zfNmh8io4htRpFg7jsZjteNezKKkXVegLtxJBYz/nAikGdObGcKW4ESvSySY4o5H4lSz
         4Nf2jSLC2d0VLFBlHUSLgqusntK9QOuVKQBWYZKIA+tZXqYJMbMJBSuN/Vfq88eXnJH1
         EOSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bkcaGhT4i1YczVLSYGucQECEKh6an5T4AF5+XBynpKQ=;
        b=BkZb15p6oOMxvhkj7DWIz5B9MHo04RnpSBDxeUtqrBYGblkl0B8fAvjegh9PXLyoBl
         MZ+jeddWg0wtVC/kwPL2CLdEX0WpxKFa3Nh/xEhx1V+wzHBhiB6U26jrk2kN3oDOjmJi
         qB7mB/kRk9O7Eno2H6pGSh7ngfeIPA/afUTl1Ijc1rJEq5IN70zZYa6c4qpfO8arVHOB
         y7jEfXTL+GuO7KfGns2Xhh+6UgvaRQ0Gl1Mvfgx8g3wjyasNbVBnSyRVMxGTr1Z+VY9p
         8bmkFWgQFFHqsVYIyc0Mm1anPpkeco9BSBu6AAmqEJOvuXHn5AOjPcpqfMzz9l8S7Wic
         4F6A==
X-Gm-Message-State: APjAAAWKpjPFyHbQd/VHrBF0FufwvbRYxpWF8ZOaYftXQ3xLMdPOwl3J
        QTHAeAs71Ws15xxjJezVGWrQ9Z+b
X-Google-Smtp-Source: APXvYqzZIZfIilwh1VWSffFxyOjQ5MCeUQJyfmu51e37HvfyP8HfRgJclAH0CfxzNJsRxLXoAItULw==
X-Received: by 2002:a1c:6a0a:: with SMTP id f10mr19220017wmc.121.1568041729853;
        Mon, 09 Sep 2019 08:08:49 -0700 (PDT)
Received: from localhost (p2E5BE0B8.dip0.t-ipconnect.de. [46.91.224.184])
        by smtp.gmail.com with ESMTPSA id 33sm14670646wra.41.2019.09.09.08.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 08:08:47 -0700 (PDT)
Date:   Mon, 9 Sep 2019 17:08:46 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: stmmac: Support enhanced addressing
 mode for DWMAC 4.10
Message-ID: <20190909150846.GA27056@ulmo>
References: <20190909123627.29928-1-thierry.reding@gmail.com>
 <20190909123627.29928-2-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20190909123627.29928-2-thierry.reding@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 09, 2019 at 02:36:27PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> The address width of the controller can be read from hardware feature
> registers much like on XGMAC. Add support for parsing the ADDR64 field
> so that the DMA mask can be set accordingly.
>=20
> This avoids getting swiotlb involved for DMA on Tegra186 and later.
>=20
> Also make sure that the upper 32 bits of the DMA address are written to
> the DMA descriptors when enhanced addressing mode is used.
>=20
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  1 +
>  .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  4 ++--
>  .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 20 +++++++++++++++++++
>  .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  1 +
>  4 files changed, 24 insertions(+), 2 deletions(-)

I just ran into a case where this is not enough. The problem is that the
driver not only doesn't fill in the upper 32 bits of the DMA address in
the descriptors, it also doesn't program the upper 32 bits of the DMA
address of the descriptors when initializing the channels. I'll update
the patch for that case as well.

Thierry

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl12avoACgkQ3SOs138+
s6HKiw//TWM7ZrQDzc7XyoxuJLTo+cDwrkPcfuhx7j7KcMxyjDbUv1HqMhzxrs+Q
iHgY3b2d3LubovfTDeEq+N1uDfFsv6T+dNQg7FVo7lFsRbEnwdt8bwQrvDsfVjCD
e9aAPCp1tazMPiMLGvTpKyH/yLz6VECXcYNUH/bT/sp86NstNlmTatU10pyZC0sd
JIAKcIUesQMZVwwObof1C3Y0XMuMuTnVu0PP6hVqxe19ajV++jDylqBNq1kanbHM
GQTZoVy3ax/xwZM+RfQF6OO8bUfcDR4TRzjVEeksBCK6rMG4FLBnihHWDejN7f0N
WwBUlNGB+y1Mpfm5Dg5lao+SyyhGFPLQyHKaemxAWRWMXQeo21A+hOXGd29wwkec
4nwIeIj5YSLzN/xGel4+aJz8awfrAq+9ufCKPgz1zalXMbgq7uqY05jyiGzgqmEZ
UIEj5iNCHnZcCDpzxspLGD1mtmIGC90zwdSayLvKrTjVj0wtjkuwHsg5AYe7aqxT
ChEYn11wD088dLymiO70+r8puQR/YdHvdBNxOe2KMA4p6P/JEujUTG1IBYeH0x+H
ii2vhX4hMJFp8T19Tqntfpt0YNhny9thbFfybokv4NyaIPG4QNWLB9ZioO1SzcO0
yM33lw0ZFBc9pF6Fny2z9u7pyfCrFap3fSbynCZxBe9WNg/o4OM=
=EFgV
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
