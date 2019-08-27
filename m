Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBF59F20A
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 20:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbfH0SFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 14:05:08 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:55502 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfH0SFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 14:05:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DSbx0RirMGo+OBFSP+TJXuc3nmap+iJLuSVH/Rmy8Gs=; b=DQvhDlgHJoE4GFWzHcuHQqp4p
        k7ZvS24CwhCT+Sl/T2humti2iwK4fYXKLhBIclCsxJ3w/my5+PSAG1v4N28tnJIPMqrXzIwy4PoWo
        kELtuuo05aozP/UARL6fR/Q03mO2KZVrB4IpNxqLop9kFpdlntNw3ZzV3k9fWXA9a8UVE=;
Received: from 92.41.142.151.threembb.co.uk ([92.41.142.151] helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1i2fq5-0000sH-7f; Tue, 27 Aug 2019 18:05:05 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 706C2D02CE6; Tue, 27 Aug 2019 19:05:02 +0100 (BST)
Date:   Tue, 27 Aug 2019 19:05:02 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     linux-spi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH v2 5/5] ARM: dts: ls1021a-tsn: Use the DSPI controller in
 poll mode
Message-ID: <20190827180502.GF23391@sirena.co.uk>
References: <20190822211514.19288-1-olteanv@gmail.com>
 <20190822211514.19288-6-olteanv@gmail.com>
 <CA+h21hqWGDCfTg813W1WaXFnRsMdE30WnaXw5TJvpkSp0-w5JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rwlp4HDnqjg7pxzw"
Content-Disposition: inline
In-Reply-To: <CA+h21hqWGDCfTg813W1WaXFnRsMdE30WnaXw5TJvpkSp0-w5JA@mail.gmail.com>
X-Cookie: Don't SANFORIZE me!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rwlp4HDnqjg7pxzw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 26, 2019 at 04:10:51PM +0300, Vladimir Oltean wrote:

> I noticed you skipped applying this patch, and I'm not sure that Shawn
> will review it/take it.
> Do you have a better suggestion how I can achieve putting the DSPI
> driver in poll mode for this board? A Kconfig option maybe?

DT changes go through the relevant platform trees, not the
subsystem trees, so it's not something I'd expect to apply.

--rwlp4HDnqjg7pxzw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1lcM0ACgkQJNaLcl1U
h9CfVggAgkZmmBRw2FvR5lO8tg9fAeeferqRJaLr9OpPEupYK4uNoP3Z/zg0Ge9A
O2/56jU1C+jO19IuuQ8zXPAInWSRRLaL/2b0epnxsTRz+NjGzTw5W+4BptoYV0nY
ZVdNbujRph1lSOZwk5vg6ae7U5DKvn33ygXHuCCagrvSlr6dqhXlBBHynn/5U7wy
Nb3mKneIUHaVHbTpcYbFTQTvojd84LkakJsh9gq0lWBZaeyZ8wJYh5rp/iCpinh7
CuPTCnTmxsQq8kfvfCrWR2bcvV1HxhCJIlmxZ/DnNduwhYQ1de9CCcNKzYpEKtWj
iQI2M/wERU2Kt3hCXw1m63+fKmtSIQ==
=E72x
-----END PGP SIGNATURE-----

--rwlp4HDnqjg7pxzw--
