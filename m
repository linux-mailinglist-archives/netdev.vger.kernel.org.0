Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84E537999D
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 00:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhEJWEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 18:04:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231807AbhEJWEt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 18:04:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E56C61040;
        Mon, 10 May 2021 22:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620684223;
        bh=Ga4I0r8tVy2u+77ySaPHZRkDyjttK1GlRQ45qAXDDGY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OBnLFf64VUW275JQ0ZhIP22IwN/b0kZCT9quLN+tqcOdv4Ji0t/uBMC18p9FCSYYz
         AKMdtSxYC8D+0WX6S2kKBFWyOnmIyxJ1vaNflNJKpFlSwIBd9ebI/cwdyl9w5WU9Vu
         ZrD0pSaeuTuAqqSyUuFqCcyBYOwXOHul0hkVYa0H5lQypznYIHmVm1hFqtL4JmML5g
         UhFHIuz1ov6FNaSsMZBjsKDiUHoZR0EkLlHn2HVL+9YvK05EufxqC3jgZawGy7Qo2R
         yb+mswfRltVOc5vIAsglBnZNjFQOK4vhPQtfpsIquvpkZQ8ht4u86FCESEDM78DKOo
         a6/m57Hf/9SbA==
Date:   Mon, 10 May 2021 23:03:03 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Georgi Djakov <djakov@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Odelu Kukatla <okukatla@codeaurora.org>,
        Alex Elder <elder@kernel.org>,
        Shengjiu Wang <shengjiu.wang@nxp.com>,
        linux-clk@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-iio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: More removals of type references on common
 properties
Message-ID: <20210510220303.GE4496@sirena.org.uk>
References: <20210510204524.617390-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="OZkY3AIuv2LYvjdk"
Content-Disposition: inline
In-Reply-To: <20210510204524.617390-1-robh@kernel.org>
X-Cookie: Beam me up, Scotty!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--OZkY3AIuv2LYvjdk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 10, 2021 at 03:45:24PM -0500, Rob Herring wrote:
> Users of common properties shouldn't have a type definition as the
> common schemas already have one. A few new ones slipped in and
> *-names was missed in the last clean-up pass. Drop all the unnecessary
> type references in the tree.

Acked-by: Mark Brown <broonie@kernel.org>

--OZkY3AIuv2LYvjdk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCZrZYACgkQJNaLcl1U
h9BnKwf/Z134oVRMYcotQgN8s5J/xgwf2QImV1mvL+RIHKYjJlyARPtcQni65ppK
kBXjEC4LHxqFVlIrlrJfEST6iFTyPm1loKXZJcVvWY6vytNmswI2I4CdEJ1ni6Tc
EbsF3hoyBU3llDDoOwwj/RdeQPaoSR3x608OaWFPOaNUW+Z8IL38hmQCIQKzOAkh
qSD4lvREiasStstHcWZP4n1zy6VoNrRyGJ7Lk8lLY+VrgnBep/moN+3IbpomPjow
VqvyYkr15OhzegEJ0n88HvNWv1SHSy3+7O5GiABguaOYx2waWTD1FffrfxDcts8c
3ipGtVLahbT+uQ3Lo4HLskPQmk3abQ==
=0dIA
-----END PGP SIGNATURE-----

--OZkY3AIuv2LYvjdk--
