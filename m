Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B766DB089
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjDGQ0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjDGQ0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:26:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD793E42;
        Fri,  7 Apr 2023 09:26:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50A3061046;
        Fri,  7 Apr 2023 16:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16475C433EF;
        Fri,  7 Apr 2023 16:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680884761;
        bh=31YPyfeUF3tjc+oEPEaQTSlMUGS+j/TI5LwT22a9auY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RTNMZtzbtMZBDgtMlAktX/dNlgYm4NQnRbQ/JrOhACoJQ0HZeuXNW2ESg17l21vIC
         MYCgDaq12JAYoGnhW32j2ATMSa6grCdEf/OUmOlIuGL/cltNOv4WYERI8nuLHOsWZu
         +5PHRw8Rs++YAGsTcbO/xTr9BpKdrJnYOiJq+k7DHmWxj7lDKjALX2qnNJVcBacOtw
         p5J4M2itHpegXpSGZlKpKSTZ2CzcGqUrdkabELEMbSjtyI8ZQAVtHFumZiAW+JTReT
         E1Fuk+RWMlC2ucDcX8qN8dXaoKqNzzmGkCm64RhrmBlxTXgUd7cPkAf9jtjtjjSdLz
         4XrguHQVrJtrg==
Date:   Fri, 7 Apr 2023 17:25:58 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Lee Jones <lee@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH] regmap: allow upshifting register addresses before
 performing operations
Message-ID: <ZDBEFvPKj9A+k+Ag@sirena.org.uk>
References: <20230407152604.105467-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7Z7rWWvINZxig8W7"
Content-Disposition: inline
In-Reply-To: <20230407152604.105467-1-maxime.chevallier@bootlin.com>
X-Cookie: Single tasking: Just Say No.
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7Z7rWWvINZxig8W7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 07, 2023 at 05:26:04PM +0200, Maxime Chevallier wrote:
> Similar to the existing reg_downshift mechanism, that is used to
> translate register addresses on busses that have a smaller address
> stride, it's also possible to want to upshift register addresses.

There were some KUnit tests added for regmap, could you add
coverage for this there please?

--7Z7rWWvINZxig8W7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmQwRBUACgkQJNaLcl1U
h9A8Rwf8CMPWvJbwg3+OFB0SJa7Dbf74xYKn5tR/Gyso1BhQqEGG2kOqAE7/NqX8
Pp++/7F2pf2XMLF5eLYhb6Mrnvj2w3ZHPbtV9LY4KIFBG7g+5uAcqUKFlkWtMCsP
9vkDTrkubilu6Vkmqn7q1Z5M/3VtQOMeDaY6ZxUAE+Jp0/9w0SzVnx9XNUvXTnif
t8I0Qmq1JXWrxXNjhWXdApfNcEioPQ1FsPVkFOqVd56j9VBhGLOAOfXVLgNZgYFn
HUI61vVAYaHaXDhr+SJgOeZWfJMJ0BQsBTI/p0+InQWjixalaPMs6LHU9qNFyHur
a8rC6a9FFb5O1WQqG87rcSZfgvS88A==
=4r79
-----END PGP SIGNATURE-----

--7Z7rWWvINZxig8W7--
