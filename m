Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1493646FC2F
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 08:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237882AbhLJIB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 03:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbhLJIB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 03:01:56 -0500
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7ABC061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 23:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1639122580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W5hkCiSsViIQqXmOrX4HGf1e3s3HJVTt0nQiWJRxh6E=;
        b=xZGYVVavt/jthU15aWmfa+PuSMXJohH54GVugvl77WgmZE7FlbbuEFxYfjix8SkIp1E5dk
        rwOX21cJnDp/rgbhwkmmbQIHbL9n3eYoRB0MBNFC5yOw70PSh3iqE4i6xSAV+K7QERglft
        UWpbd9e0wDA81xWRtp0c89jTiQKHkHE=
From:   Sven Eckelmann <sven@narfation.org>
To:     mareklindner@neomailbox.ch, cgel.zte@gmail.com
Cc:     sw@simonwunderlich.de, a@unstable.cc, davem@davemloft.net,
        kuba@kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cm>
Subject: Re: [PATCH] net/batman-adv:remove unneeded variable
Date:   Fri, 10 Dec 2021 08:49:37 +0100
Message-ID: <5899543.jjpY9eVhVs@ripper>
In-Reply-To: <20211210021917.423912-1-chi.minghao@zte.com.cn>
References: <20211210021917.423912-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6748779.M4W0MkK9z9"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart6748779.M4W0MkK9z9
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: mareklindner@neomailbox.ch, cgel.zte@gmail.com
Cc: sw@simonwunderlich.de, a@unstable.cc, davem@davemloft.net, kuba@kernel.org, b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>, Zeal Robot <zealci@zte.com.cm>
Subject: Re: [PATCH] net/batman-adv:remove unneeded variable
Date: Fri, 10 Dec 2021 08:49:37 +0100
Message-ID: <5899543.jjpY9eVhVs@ripper>
In-Reply-To: <20211210021917.423912-1-chi.minghao@zte.com.cn>
References: <20211210021917.423912-1-chi.minghao@zte.com.cn>

On Friday, 10 December 2021 03:19:17 CET cgel.zte@gmail.com wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Return status directly from function called.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cm>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>

Applied after fixing obvious coding style problems.

Please try to fix the script which creates these automated patch submissions.

Kind regards,
	Sven
--nextPart6748779.M4W0MkK9z9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmGzBpEACgkQXYcKB8Em
e0acZhAA1cmWFrpd8yxGG3wS0K3kSGEyQvHdyDC7hryV0xo+H/2o64b9SjN2C+Sr
AcgR0xLtvMH9txtRkTyucggIxJVbdRT/cBsRz0v9OK+ULuDFVpJof0jhRD5EOMuM
mT74HjR9RGLkylfW4qB0qIEa6XwnYG94NlFqqpyeq5P7+WhPnemRJ/YPAl8MescC
0zRa6rCDnE2LIGnNnXjf7cNAoSvFy6QW685eMIaHzKtq/Pv0dmWhDcM4N8LylpBe
FzjJAFUKf/0AGmjwzMTpoEFEtxTJOOULV9L7supOdLQIOyK/gM0+gOBx/YwylQAX
47XeO3BWHvVTye+z0o/fKYXDPDOiohB3OEblt8avDfI6GzQ2JFtaNqJewLPqQKjW
6GEQOltdB3kFFXr5PsZWVTcB6Yr2fSoUeNiiP8g7yaRx6GcWEOsrOavE9RUmpxzo
NXQYhu3470YaeYgbJ4FILd4r93I08jfHatdGuF2uziXUfbDevhhGooWDpLDO2H1A
eKjCdu+6PIxqV5vsXjjsgMxOH56D5Tko4lxTx64qPcK7tChD4HsVS3ElS+Bj9fvC
OOkm5r58/B4plXbWodEGBNZUTi4u4QiwtTxl1T8gLj4Uzi7tVsITppHy8iB7w7Th
am9wZsMjNDOY1Ml2y0ds7ZN0K60qJT/gM+au3rewR1n1SsVWgiw=
=rlgB
-----END PGP SIGNATURE-----

--nextPart6748779.M4W0MkK9z9--



