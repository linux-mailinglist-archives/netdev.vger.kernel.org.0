Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08631E631B
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 15:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390734AbgE1N67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 09:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390569AbgE1N66 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 09:58:58 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82E4920814;
        Thu, 28 May 2020 13:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590674337;
        bh=33GJz+mC9GeZY2YmgHy7gFnjO7ILb8Ua0jkAQw0Q7sk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MKEiduFi9xv+EojGxMx1IoYDAlTurQtN+OSRAuUZJnRvF59uZyaeYskhYnI+fCehj
         dv/3K90YBT4XIjE/cC2RUPfj6qlFxWFnQJzbXWJJSD1INMj7Wxfms5KsCxhDRUTest
         Wh4mmocELBuByjLJbVA4du7IBGZaPTdfE11eYZ3E=
Date:   Thu, 28 May 2020 14:58:54 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 1/2] regmap: provide helpers for simple bit operations
Message-ID: <20200528135854.GF3606@sirena.org.uk>
References: <20200528123459.21168-1-brgl@bgdev.pl>
 <20200528123459.21168-2-brgl@bgdev.pl>
 <20200528132938.GC3606@sirena.org.uk>
 <CAMRc=MejeXv6vd5iRW_EB3XqBtdCWDcV=4BOCDDFd4D0-y9LUA@mail.gmail.com>
 <20200528134802.GE3606@sirena.org.uk>
 <CAMRc=MdL5dkJ+BPzvYXTnLQ_sGtU_7n=8jeSa5=hf8u9Pm+0FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xkXJwpr35CY/Lc3I"
Content-Disposition: inline
In-Reply-To: <CAMRc=MdL5dkJ+BPzvYXTnLQ_sGtU_7n=8jeSa5=hf8u9Pm+0FQ@mail.gmail.com>
X-Cookie: Small is beautiful.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xkXJwpr35CY/Lc3I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 28, 2020 at 03:57:24PM +0200, Bartosz Golaszewski wrote:

> Ok. So I'm seeing there are a lot of macros in regmap.h that could
> become static inlines but given the amount of regmap users: how about
> we do it separately and in the meantime I'll just modify this series
> to use static inlines?

Sure.

--xkXJwpr35CY/Lc3I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7Pw50ACgkQJNaLcl1U
h9C0JAf/dNRWXvfYGQBfIcxntkKP8aep1vOHRifD1xl9zIeMOFNDJ+jgglCgD68t
LLZrN6cUDTo8C3G+FHwH6DGudq5wH8Ag7NsLhzL3SRn8Za4mDk1pxPBZ+tHJPizx
pqViqPY/vDilJVZ902oM2Fp6/9jFj20kbU7uxxr/xeAyARUeOETZDC/0KjXtqHVJ
tzq8L3i9Pz8trE7sZMCeZEf/xesIGKtC6+ZvXe3amr2x86TDxg3ikfIkjIe4+EJx
OjDpvAymwMPb8Y0THGwPr4UC7+9jCZlU9rVz+T1lwfvIKzfekY6YOIqopCBWRkBp
g/ew6KGinl54+fjsY3A++WgGXuWQZA==
=FKaC
-----END PGP SIGNATURE-----

--xkXJwpr35CY/Lc3I--
