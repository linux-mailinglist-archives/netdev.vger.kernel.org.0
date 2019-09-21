Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 482DFB9BDE
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 03:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730757AbfIUBfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 21:35:43 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33839 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730577AbfIUBfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 21:35:42 -0400
Received: by mail-wm1-f66.google.com with SMTP id y135so10689000wmc.1;
        Fri, 20 Sep 2019 18:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sbLPiHDoe6UMP3Ze87gNVKe6Z2eMfGIB7czVmJMuNP4=;
        b=fQCA0U5znFXcYEro9L+Rc2dMruHMo+aP017tag97/ycu44Fu0jiar9ss2ZQgsOFnu2
         fFf2ekLoQPzsHaL7l467AlCN0gWTdDr2n9SXk+NQHUAe//m2K9u03o639+uERrAosY3E
         3WuMFUav/jaQSmUfsZBOokDPo4O45B2X/TOjC53P55kOaoDimRXwAeti9Qr2QhhM4/BJ
         L/L2ASbdKEjoPsJ7MMMwTDUIqf00YnChMgs+Pf4rkT121+Z4PQOHecZ4/7BkS6YXBBm7
         +d431lWRMnJbzOh1uQCk2zDE0Wdawc7QnvSXA4ZznlP9ZbCrNKwmpRraX/Gu8SgSPB2t
         +MVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sbLPiHDoe6UMP3Ze87gNVKe6Z2eMfGIB7czVmJMuNP4=;
        b=OQubn8rDf7WXzyMOpuaXZFLaw1+ao3eGg2xgBzQRVOwkjPTrMdMWO4fVl/s70G1Pye
         gwg/mu+hROzjYlnqFZTeikQmJapu099u6XvDEi3FRlA2j+TDOprHY4fJhHDN8/AxzJ1Z
         rRi70hk/I1A/p0OorhUhnXFZQNTSdZFsSvDFQ0uSbC+VE+UNljuU8DWqJXcf0Ncv1ZPv
         6OnPxP4mr4MYpRUFJhIChPiZx2fyDMiO0b546wqpMGbXESPRuYpxsBHzlQg7rFHYhq4/
         7jgeGMaduo2BKXzYEUjsMSf2cQ1Lf+XM4y+okeLsZrbTToLAyo8YytuEViG8+SUQcYeH
         hKwg==
X-Gm-Message-State: APjAAAXBFqFLIhr9ydnzyGCvH/e6kUrfcv5t3khkTS3vUgioCnTXNGVs
        WLpZO21k5HMfIDPG32b+YHQ=
X-Google-Smtp-Source: APXvYqwmr/uZaRoVkCAf0QgmyFCVNJsgAdof9HUvw8yZhqjdL2MKDH4x1ROx36QOoB7p3U6Xd8UkDg==
X-Received: by 2002:a1c:e906:: with SMTP id q6mr5022203wmc.136.1569029741007;
        Fri, 20 Sep 2019 18:35:41 -0700 (PDT)
Received: from localhost (p200300E41F0FEE00021F3CFFFE37B91B.dip0.t-ipconnect.de. [2003:e4:1f0f:ee00:21f:3cff:fe37:b91b])
        by smtp.gmail.com with ESMTPSA id y3sm3869203wrw.83.2019.09.20.18.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 18:35:38 -0700 (PDT)
Date:   Sat, 21 Sep 2019 03:35:37 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 0/2] net: stmmac: Enhanced addressing mode for DWMAC
 4.10
Message-ID: <20190921013537.GC86019@mithrandir>
References: <20190920170036.22610-1-thierry.reding@gmail.com>
 <fa2fafac-f193-3cef-666a-767859d41f91@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JgQwtEuHJzHdouWu"
Content-Disposition: inline
In-Reply-To: <fa2fafac-f193-3cef-666a-767859d41f91@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--JgQwtEuHJzHdouWu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 20, 2019 at 10:02:28AM -0700, Florian Fainelli wrote:
> On 9/20/19 10:00 AM, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > The DWMAC 4.10 supports the same enhanced addressing mode as later
> > generations. Parse this capability from the hardware feature registers
> > and set the EAME (Enhanced Addressing Mode Enable) bit when necessary.
>=20
> Do you think these two patches should have companion Fixes: tag? They
> are definitively bug fixes, but maybe you would also want those to be
> back ported to -stable trees?

I wouldn't really consider these bug fixes. They're more along the lines
of feature additions. The driver previously didn't support EAME and that
was fine. The fact that it never worked under specific circumstances is
not a bug or regression, really.

Thierry

> > Thierry Reding (2):
> >   net: stmmac: Only enable enhanced addressing mode when needed
> >   net: stmmac: Support enhanced addressing mode for DWMAC 4.10
> >=20
> >  drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  1 +
> >  .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  4 ++--
> >  .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 22 +++++++++++++++++++
> >  .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  3 +++
> >  .../ethernet/stmicro/stmmac/dwxgmac2_dma.c    |  5 ++++-
> >  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  6 +++++
> >  include/linux/stmmac.h                        |  1 +
> >  7 files changed, 39 insertions(+), 3 deletions(-)
> >=20
>=20
>=20
> --=20
> Florian

--JgQwtEuHJzHdouWu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl2FfmYACgkQ3SOs138+
s6FseQ/+KuW4pJjrgxcRnR7eVA3n7gakuqezBPcH1vTtwGh9sQlShZa1WatorptO
SA4Y7Raxod4Ed4cSsIE8WO6e2EA3EO9cPNqAzpw+Cdf5/AzcT0X1QZ7/3h6pJJXR
PGh3ZvdrSSskL4M389UIKLzM4Z/2AHmQBWZbhJCKGux5TQ+B2S05TWxhotjUNqC8
r8fDMb19ECYlUA7IVSt23oQ1DqFN5vYzUpwPbCBZt3FN4v9/K5npkdLIiFL4jtZp
O2645NSIBK3mGC+C163VHB5BUlQrcxmWTkB4Cb8RzfoJ/6zuv848+c29UQKcj0Pc
l+dxKaYVty+GYfI2JEhmmsRI9/ZgLzhO56rQchjS4Itm3bff/RPAynuTvl9AUSpA
naFKBab95eg7Y1tHN6+VhuGU/vHwVLocssWfvZ5F10SdpjOaKzoaz7Kqj9EwtrzU
0jOINKrcrWYHYiPFrvfXjwSpIQugZeYAr3aFj7UASfc0drWgGK3OFqYfPHUbvLYH
dhrj+0uiKJKMgjzA6/c23SEmKjrVnobRY5GgKBNiATywD/iVM35XN64XPtfij+GK
7/iqK/VfxWl9e4VCWnX51YI82+uiz8fFPHKjo94lxBtuz3LWTirg7Ag/iy05Ins7
rRcotpiMGP429kEhwCbBhEFDrpLruC5pIFO7IGYjtCQIzu3Dz/E=
=FbkH
-----END PGP SIGNATURE-----

--JgQwtEuHJzHdouWu--
