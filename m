Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A969F1EAD95
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731011AbgFASq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:46:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731035AbgFASqX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 14:46:23 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BE83206C3;
        Mon,  1 Jun 2020 18:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591037183;
        bh=e5Qef3dmczUwuHZqTw6EERJ4IhHrefksgJsUZASLXQE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EPRxpUAViQ0TEernHJkDM4zYgOXqmLTcvMqM4OttqWWxcHD4GsmHNr0zDVhFEC4Od
         v+BIBXqxrL4FbuGy57NSvvb/gxTjry4yKgfOHMuf8BI/qTuFdAZVQzeawwAPxyYx58
         zRVHM6EimWYc0OArYHS8BFgMHU4LwTJftqwVZhqM=
Date:   Mon, 1 Jun 2020 19:46:20 +0100
From:   Mark Brown <broonie@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     brgl@bgdev.pl, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, kuba@kernel.org, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        fparent@baylibre.com, stephane.leprovost@mediatek.com,
        pedro.tsai@mediatek.com, andrew.perepech@mediatek.com,
        bgolaszewski@baylibre.com
Subject: Re: [PATCH v3 0/2] regmap: provide simple bitops and use them in a
 driver
Message-ID: <20200601184620.GF45647@sirena.org.uk>
References: <20200528154503.26304-1-brgl@bgdev.pl>
 <20200601.113536.134620919829517847.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="924gEkU1VlJlwnwX"
Content-Disposition: inline
In-Reply-To: <20200601.113536.134620919829517847.davem@davemloft.net>
X-Cookie: Help a swallow land at Capistrano.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--924gEkU1VlJlwnwX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 01, 2020 at 11:35:36AM -0700, David Miller wrote:

> > v2 -> v3:
> > - drop unneeded ternary operator

> Series applied to net-next, thank you.

I already applied patch 1 and sent a pull request to Linus for it.  As I
said:

| Let me know if you need a pull request for this, given the merge window
| is likely to open over the weekend I figured it's likely too late to
| apply the second patch before then.

Hopefully this merges cleanly...  ideally we'd have had that pull
request.

--924gEkU1VlJlwnwX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7VTPwACgkQJNaLcl1U
h9BC5Qf+Pqf/FZV1N/xA1qCR5gdSQfu1xeoilmJVrmPkNe7ZPkKJw08ysvy2BAQO
FWtv1JeTxdz13haQKXAmahMt6vZ7SfvpE0SKsW9UQskdbLt3Ib1BhoJk3TPr9u5Y
9TKyGAUpkjmvXkM/GLOEGiqWcy6FbAuPmc/NsFaCaHv6MpjefCKi7qFs+u4rNMJG
OfbU/RjMmOjojflkQWTLxMbOcW79doEFgvx1fRxvRcg4NRZOEfMRnWjIp5Eb3J5S
kBrG02l6iQCsuFijjLFRC4tpFKG5LAld12jDjRwiCgsw9YpNU/6piftFObxGzBsl
t07Asv5z8Ea2gvA5oCJzjkYVpgMY+w==
=PMqK
-----END PGP SIGNATURE-----

--924gEkU1VlJlwnwX--
