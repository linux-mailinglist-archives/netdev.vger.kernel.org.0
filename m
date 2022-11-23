Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064D6635C22
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 12:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbiKWLv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 06:51:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236580AbiKWLvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 06:51:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B8265E4;
        Wed, 23 Nov 2022 03:51:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F0BBB81F15;
        Wed, 23 Nov 2022 11:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD3DC433B5;
        Wed, 23 Nov 2022 11:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669204311;
        bh=phhd+Gdc/wkAagQCT1G+/rsG794g5og7Pbf7/CZVfeY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A/UzU6ivTd7IAAFQyDa/xI56j3AVN0e9T9sqCMWjOQK0LOvk93P9YZcJM7mYQCe3H
         pZVpc0QVqoFJ6BQo8jEGEG8//6cz/70/xFnYxnTf6iWQo2IPN4vp0rovKJul2ynDS7
         cqITQ8IvmMGxZzMeF5Jc5PK5yievH389a8eqTa2ecraq09+nACKfLdggnG5lqyuU1z
         B/dwqWpM/0npZ/9q4VdLBfrDkikv7X4TCqiMBK9zxZE+NBzPx1jWihEWE5LlQ+yWF8
         V7vz62NbMcQdm2aK51F7C1MMFqXD05wTDR0JorXwXTIpu/Pgam7GykElLzxkXx5eqf
         e4gwx9p9cBBjg==
Date:   Wed, 23 Nov 2022 11:51:42 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Alexander Lobakin <alobakin@mailbox.org>
Cc:     Alexander Lobakin <alobakin@pm.me>, linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] treewide: fix object files shared between several
 modules
Message-ID: <Y34JTrCARZ1Gllsi@sirena.org.uk>
References: <20221119225650.1044591-1-alobakin@pm.me>
 <Y3oWYhw9VZOANneu@sirena.org.uk>
 <20221122213754.45474-1-alobakin@mailbox.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yzeGM2sBEGtnAUH/"
Content-Disposition: inline
In-Reply-To: <20221122213754.45474-1-alobakin@mailbox.org>
X-Cookie: I'm rated PG-34!!
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yzeGM2sBEGtnAUH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 22, 2022 at 10:37:54PM +0100, Alexander Lobakin wrote:
> From: Mark Brown <broonie@kernel.org>
> > On Sat, Nov 19, 2022 at 11:03:57PM +0000, Alexander Lobakin wrote:

> > Your mails appear to be encrypted which isn't helping with
> > review...

> Oh I'm sorry. I gave ProtonMail one more chance. I had the same
> issue with them at spring, they told me then that it's a super-pro
> builtin feature that I can't disable :clownface: They promised to
> "think on it" tho, so I thought maybe after half a year...
> Nope. Ok, whatever. My workaround will be the same as Conor's, just
> to change the provider lol.
> Should be better now?

Yes, everything's fine now - thanks for looking into it.

--yzeGM2sBEGtnAUH/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmN+CU0ACgkQJNaLcl1U
h9ARigf9GW+E64m62h0pb2LtRUO0gPTWvPUn+ORptGnHGlsvJVhzigffMuHNhxY9
0nhYtG/KF7hqMTiL5BFqCp2qI2FUGIEAS2DqHgNDuysHP18pMah388xpWdnCrmAi
m6snZhHVpJKaCo6te9Sn+L+ilFbmGYdyInKp7QsOAFHj7YJ9ceiK90BefO8GTR4T
Dz7B5fHFhaWWRAjR+KWZSrJPAMGVGLb0ezkStlrTeMoo4dSnzsNDqpy1n6N5hie3
h5Xuh0oj7jPRtJV8d0vqzeE9sjF6eI0WxDA9+Jt/WQP03fUF2XPJqsia/u8RUGQN
b4rLpDDGVV72tJgL6eFoJU2Pdxc7qQ==
=8oQE
-----END PGP SIGNATURE-----

--yzeGM2sBEGtnAUH/--
