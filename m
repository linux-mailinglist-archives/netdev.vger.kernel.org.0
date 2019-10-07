Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AABD7CDFC4
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 13:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfJGLAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 07:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727252AbfJGLAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 07:00:44 -0400
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E1D920867;
        Mon,  7 Oct 2019 11:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570446043;
        bh=2hAjkYW/sfqFwCOnRXqcJFaaj969edeRaZ+eZJxXYHI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CqacMOAjiY9jXabDsPJfVFjUbmireDFbYDBflbIRNIeoFdqfxFDFMVmxqSxYVuqJM
         MhlOiwI3o9iS1qxGhlo03ndHoIsQKVSvoayywiTF3JDXgyNm5d8cALyRFsiODGQwXv
         c57dKe6UpQn8FQ0u1XvCUKzjj4EW+K0ogPe6qYR4=
Date:   Mon, 7 Oct 2019 13:00:40 +0200
From:   Maxime Ripard <mripard@kernel.org>
To:     Alexandre Torgue <alexandre.torgue@st.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Alexandru Ardelean <alexaundru.ardelean@analog.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] dt-bindings: media: Fix id path for sun4i-a10-csi
Message-ID: <20191007110040.2mt5uxroos3hz6ic@gilmour>
References: <20191007102552.19808-1-alexandre.torgue@st.com>
 <20191007102552.19808-2-alexandre.torgue@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wtovumvb4os5l27j"
Content-Disposition: inline
In-Reply-To: <20191007102552.19808-2-alexandre.torgue@st.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wtovumvb4os5l27j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Alexandre,

On Mon, Oct 07, 2019 at 12:25:50PM +0200, Alexandre Torgue wrote:
> This commit fixes id path of allwinner,sun4i-a10-csi.yaml location.
>
> Fixes: c5e8f4ccd775 ("media: dt-bindings: media: Add Allwinner A10 CSI binding")
> Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>

I just merged a patch addressing the same issue earlier today.

Thanks!
Maxime

--wtovumvb4os5l27j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXZsa2AAKCRDj7w1vZxhR
xR8JAQCMAvM7SXG96je2bRTkUdjCkS6bG6EOoW4hgbX9bxr8cwEAmc4iiWubk//+
S/jhKMDsvRBYt8C8CRty0bIvFTuRdQg=
=+t0N
-----END PGP SIGNATURE-----

--wtovumvb4os5l27j--
