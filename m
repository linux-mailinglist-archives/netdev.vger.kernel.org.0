Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90001433E31
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 20:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhJSSOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 14:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbhJSSOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 14:14:51 -0400
X-Greylist: delayed 575 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 19 Oct 2021 11:12:38 PDT
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70996C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 11:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1634666578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ln6fDIelQdu7pPt1Ea6IyCGF5H+PqfVVx6cMKX9jpGE=;
        b=zhiWMjjt9fhFCKQvndXY3K5+G4AELPlwAkF/EyxP5o9aUymSwlfcrI9wTNDt4W0LfcbBFe
        IpfcA95RGHNR+nq+UGIOGNHlBKeHHvJmvYZjLgei//MpWhUWUwjw4wnmFIrGWFFj0NNV4f
        1hgAnedJgrgaWxHvTSKbtWU0Fh03M6g=
From:   Sven Eckelmann <sven@narfation.org>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        mareklindner@neomailbox.ch
Cc:     sw@simonwunderlich.de, a@unstable.cc,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH] batman-adv: prepare for const netdev->dev_addr
Date:   Tue, 19 Oct 2021 20:02:52 +0200
Message-ID: <33425786.lHEVMZF3NE@sven-desktop>
In-Reply-To: <20211019163007.1384352-1-kuba@kernel.org>
References: <20211019163007.1384352-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3738197.mCjuJMru3Q"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart3738197.mCjuJMru3Q
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, mareklindner@neomailbox.ch
Cc: sw@simonwunderlich.de, a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH] batman-adv: prepare for const netdev->dev_addr
Date: Tue, 19 Oct 2021 20:02:52 +0200
Message-ID: <33425786.lHEVMZF3NE@sven-desktop>
In-Reply-To: <20211019163007.1384352-1-kuba@kernel.org>
References: <20211019163007.1384352-1-kuba@kernel.org>

On Tuesday, 19 October 2021 18:30:07 CEST Jakub Kicinski wrote:
> netdev->dev_addr will be constant soon, make sure
> the qualifier is propagated thru batman-adv.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Sven Eckelmann <sven@narfation.org>

Kind regards,
	Sven

--nextPart3738197.mCjuJMru3Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmFvCEwACgkQXYcKB8Em
e0Y5ARAAzLudn8YgxZr1hwMPId7eiSbHQAAuDyqwyaB8ktJvIULjzmLUcD4PsqzR
lrHIA2L1JGu5fmlKsCK+axL43zgYAnVYrFWAwdDgYEm3DLBR8B+Ntv7qcfb8NxuJ
8OrlUwyD8MfkaHMbXR5XRv2OcLFIMplT1qsEYiZvnK8mo3eFvQ3C33kDIL93owT0
+eyPZ0lsClVqpNiREngLv8TQ5NrxMhOWcm/LAQycWtk/JH2fLU1oEZkg6eZnPG8B
1hbqlz7TooVjJee99nL4EuFdg2KAfE6+0sgluTShLPf1qaq9AkK682qWK9o7JT65
qBmCA4yW8dDtZizOYDUWwl2wUDhMDDupSkIwIy//DVt3L9SFOujD/DmoEnTE8uV3
A3cNbtzF5Iv7GD0B4QfyY+hyTvvCgyodbNmL1bes70y8CdjnSDQSvpv9Ft31Ba8A
rPnD3xTcJ02OK8tB37bE6vqVpAWMKceIYz6mUnEXlxZ1zZb4gJY+emZmGSOkxklt
cmFcoJsz5gzqFkRbb23djPgrjp5675BsaiPNxNjXsTj1De5Pkn0bVDuckCrtZvGX
2MkyzivLQ8vTpBn1iQOv8kgr+i+87QbKmXo6gee33rwgubTDCKlY2YxpBz+R42Mg
WOLdSHNt/S7G+Ov7lPCsUEYdROfwLET0hf/g2oyWuneGq93onbg=
=rpsb
-----END PGP SIGNATURE-----

--nextPart3738197.mCjuJMru3Q--



