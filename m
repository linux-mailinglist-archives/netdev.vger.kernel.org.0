Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3748493D8E
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 16:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355893AbiASPpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 10:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242199AbiASPps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 10:45:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF250C061574;
        Wed, 19 Jan 2022 07:45:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97A37B81A0D;
        Wed, 19 Jan 2022 15:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1238AC004E1;
        Wed, 19 Jan 2022 15:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642607145;
        bh=lGvpU5SU2oeO2Gj2gUOdONvIDUBxvoCyLVrP9LdAyK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uFHSCn+eRhus5s0gMFtlk4M/7JhocnfANlW1cVHA0G6W01cpJd8F+h8fndGiFBKZn
         nCZZCtAQC4k7abNvVhvbVvzHZ7dwbuD74/T+NiX/IT3CWwnmAbzJ0EI/MN3ouRA4NK
         JcMa2vYnHRlxojVgmRVHQy8kAseKCb6RYvwbbz/tuDQ+FYrQPMEKinDs+/J/QCmOle
         OH44fC1gV0pSNhO5CC8MUprlf5WJ73QIy9YW2JqYDexDIA+m9Gz2JyKjFMMikgheJ8
         PhLYlTQI+6mhi8SuY2B8vNy7F68ziMiWUL/NDEe4veZOx2TcwQKBwmk2W+zhD/Bwkn
         UzTQKF64F/eMw==
Date:   Wed, 19 Jan 2022 15:45:29 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Vinod Koul <vkoul@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Lee Jones <lee.jones@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Jingoo Han <jingoohan1@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Viresh Kumar <vireshk@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-ide@vger.kernel.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org, dmaengine@vger.kernel.org,
        linux-pm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-remoteproc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Improve phandle-array schemas
Message-ID: <YegyGbGcwSNo49gY@sirena.org.uk>
References: <20220119015038.2433585-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="czK8d+IES+j+3Pl3"
Content-Disposition: inline
In-Reply-To: <20220119015038.2433585-1-robh@kernel.org>
X-Cookie: This bag is recyclable.
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--czK8d+IES+j+3Pl3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 18, 2022 at 07:50:38PM -0600, Rob Herring wrote:
> The 'phandle-array' type is a bit ambiguous. It can be either just an
> array of phandles or an array of phandles plus args. Many schemas for
> phandle-array properties aren't clear in the schema which case applies
> though the description usually describes it.

Acked-by: Mark Brown <broonie@kernel.org>

--czK8d+IES+j+3Pl3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHoMhgACgkQJNaLcl1U
h9AndQf6AqqY9YG2aSYiiYYVIPZoOOjUX2h6CnkvjYCVewt5gN+SxENXpgaLc0p7
vUq1Rp5AXTu7uFjL2ebgJ8UZPO5cjNIcj81k5OTqRYCvRBqWrPJpsacwSvuNAIUC
wrrUMNkFdRa0zaMGhMzVeaIAH9o5nqER6z2qXqGG9ccVbPBok8wg6W1xQCDlmyp8
wzYMD1gLPXMihGy7mzkZd/BHFVdUjKVmYlGiUNl7GI9MVp6v8wt8BbDP4qng30Yz
BLjhS3YyPDXdeYumU5Mvht+JzYmhn8Ihggw6dbQf6dO/UjwL+5ApN6em8mMhc0VH
9cXSuI+tv6I8BrIvDkVLV+hVCpjdBg==
=GpmZ
-----END PGP SIGNATURE-----

--czK8d+IES+j+3Pl3--
