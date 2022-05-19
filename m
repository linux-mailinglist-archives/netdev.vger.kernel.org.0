Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A0F52DF1B
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 23:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245111AbiESVUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 17:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbiESVUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 17:20:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF53ED726;
        Thu, 19 May 2022 14:20:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52B84B8250B;
        Thu, 19 May 2022 21:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C6FC385AA;
        Thu, 19 May 2022 21:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652995205;
        bh=SvQDWvHaw/Ro4+sDEA3LzYO4ioj59uSH1d5BBRvD684=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lZPvgxQ/0GEOJbdI/RsIgFr7yLZfcUJvpqzkwIfYr6DnYL+2Rhom2zrrp9ZJYTqpF
         2BbR9KFYoHbcXxtwZrm5jEIxoonOr6uHesOrfW2SzdnjGAFe7wRyLtBeOLomEHF142
         GyhjeqDrl/+/XblALv6RzMdFZz//uCum30g8tGHTm+Jh2eHBkWU+fpxNxNOYIVKpdO
         Yz+zapxuT0saXPNbmmikHL5VGRFl3k5i/okcNGRFGOcWY43CajAV5gIwlk5K91/tPl
         FY3nh2Cq1LMWd9FJmk7x7tKje3C8gCWlhNIHrrazJdMY61SXsJMc302TGt3KV0Bc7z
         VYeES8NTlFwKw==
Date:   Thu, 19 May 2022 22:19:54 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Peter Rosin <peda@axentia.se>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sebastian Reichel <sre@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <mripard@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-gpio@vger.kernel.org,
        linux-input@vger.kernel.org, chrome-platform@lists.linux.dev,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix properties without any type
Message-ID: <Yoa0egr9vhTHcxjp@sirena.org.uk>
References: <20220519211411.2200720-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eXFy+XxgE7404o6q"
Content-Disposition: inline
In-Reply-To: <20220519211411.2200720-1-robh@kernel.org>
X-Cookie: Some restrictions may apply.
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--eXFy+XxgE7404o6q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 19, 2022 at 04:14:11PM -0500, Rob Herring wrote:
> Now that the schema tools can extract type information for all
> properties (in order to decode dtb files), finding properties missing
> any type definition is fairly trivial though not yet automated.
>=20
> Fix the various property schemas which are missing a type. Most of these
> tend to be device specific properties which don't have a vendor prefix.
> A vendor prefix is how we normally ensure a type is defined.

Acked-by: Mark Brown <broonie@kernel.org>

--eXFy+XxgE7404o6q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKGtHkACgkQJNaLcl1U
h9CTcgf/YrxaonL9unlOXD9rVNzVh2gBFZV2wTefQuNDSwkIM40MNQLcoafgcXo5
gFwpnXnCULN4HW9E4gsxeDnj3lcvR/bPgnNtrHetwyPKH/I99KJSgtm6605GyKWF
4d5cVzASF5iCk9z6tn51f2x6jCCLVkVoAOOohCc3nYr1YbXRtQSnKKS8vYaNyqVq
/sELkTEEdwMdl9AML+9S0amyFoPS92ZdcFlFWZIjjzPmidXQxZuL7tGvs9O56vj+
QUESokWc4u2ziIcTQT9X0XXb9dDJjhXWaFiHNc38F7o+ad3kBXAhgzzBzMC/6fLI
/352XipOMFDBOV9MMA03nK4kEtXQBA==
=MbOe
-----END PGP SIGNATURE-----

--eXFy+XxgE7404o6q--
