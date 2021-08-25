Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142E13F733B
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240207AbhHYK2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:28:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240167AbhHYK2P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 06:28:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14E3161212;
        Wed, 25 Aug 2021 10:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629887249;
        bh=/dGcdnDJQSuikSxYpLybghGo6DeDQ9TcuR3g7ByXcx8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YzQfIITYt+EvmJkw15OcJ5ISgWzmfAAa9l1OY26UMXJYFyuibz1c+h+8Mk1FZCuHQ
         kAJTQSl0ONbTNT/9lrv6hzN6QhLVWUwE815h7VOrCdY8YvCWgS3u1bctTLujiM8iyu
         M2sRBLq78Vru85NB9m3LEF3gSubrENg5UHN8Qhq244f/WJpBeL5APGDRjTizsqga+P
         R+am+zkLRFhNBWRZjsjF1VkOahqzMZZHXYrgTUgbynHQ0MUTdn3jtNfP6dJ5fNKPOR
         2OS8+sxjO8jOeELe4bpM0maGGU4KaC22/bulQY5Ka345TX0/+psJIL/4XIVTsRsbp1
         lpZrdGca7ZZAQ==
Date:   Wed, 25 Aug 2021 11:27:01 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vinod Koul <vkoul@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Vignesh R <vigneshr@ti.com>, Marc Zyngier <maz@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        dmaengine@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-serial@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Use 'enum' instead of 'oneOf' plus 'const'
 entries
Message-ID: <20210825102701.GB5186@sirena.org.uk>
References: <20210824202014.978922-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
In-Reply-To: <20210824202014.978922-1-robh@kernel.org>
X-Cookie: MY income is ALL disposable!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 24, 2021 at 03:20:14PM -0500, Rob Herring wrote:

> 'enum' is equivalent to 'oneOf' with a list of 'const' entries, but 'enum'
> is more concise and yields better error messages.

Acked-by: Mark Brown <broonie@kernel.org>

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmEmGvUACgkQJNaLcl1U
h9AfCwf/TPAwmd3i8vLyV5kU4MWAOn8zovhbZ+gXG2hJek5nLRjdW7eTl2yXz1gx
xdOp2MMA5ldnXUjncRKHMJYykdL7ZtEsOUWT44WgHT0h1WEQzTHSnoVgkt/DDbsP
tuovH5NV986VPCJXIC+mBkt5a4MPzdD1nYVmPss+8R+HXfTRZauTlZefXvwCzNDT
Md/IxPvIbcqw5Ks12P4kdojbEGB92MONTO3vRYkzCeY1toRL9fOY3DJE30Kd6o3+
hzCYzeRkTgoibpK8oG+ZqMOJ38/shj8Wiyfovdhd7LOj9orgkbGdGRi10R1997IR
tDWFSsOVWZ8p+r2ZuI06T7GlVjygag==
=GpUP
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
