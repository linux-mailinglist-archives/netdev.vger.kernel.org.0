Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3841F6BD9CC
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 21:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjCPUGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 16:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCPUGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 16:06:10 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D0C2D16C
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 13:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=9XVfwpf6PQxCQPfUPCAyQmTR7d/W
        9R51WSU8T0xjWo4=; b=HUBPFEuVJOZXjZPIl1hPl9QHzLpzdfhTNfzaByRvA6dU
        ng1hSeBHjvpQOuXHnSj9631ZPfVgCIpedzwjh5tLhzX55b1fzZDzJNEEjWYUxPmK
        jWrIPbdtoNS6NSg1yZMV297H+iHP7udmp3SVoWsn43yMep5T9cYzeKjWYG+wG78=
Received: (qmail 3995789 invoked from network); 16 Mar 2023 21:06:04 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 16 Mar 2023 21:06:04 +0100
X-UD-Smtp-Session: l3s3148p1@leWP/Qn3tt0gAQnoAE7tAFGL8McTDZ8b
Date:   Thu, 16 Mar 2023 21:06:04 +0100
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] ravb: avoid PHY being resumed when interface
 is not up
Message-ID: <ZBN2rE8WxLoQ1DVX@shikoro>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org
References: <20230315074115.3008-1-wsa+renesas@sang-engineering.com>
 <20230315074115.3008-2-wsa+renesas@sang-engineering.com>
 <78e0a047-ad0a-2ca6-10f7-9734a191cefd@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="UfjXLvpANprGkFuP"
Content-Disposition: inline
In-Reply-To: <78e0a047-ad0a-2ca6-10f7-9734a191cefd@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--UfjXLvpANprGkFuP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks!

> This is a pattern that a lot of drivers have, for better or for worse, it
> would be neat if we couldcome up with a common helper that could work mostly
> with OF configurations, what do you think?

I am not so experienced in this subsystem, so I only could identify 4
drivers which need this pattern, with one not using OF. So, while I
trust you with a helper being useful, I'd like to pass this task to
someone more experienced here.


--UfjXLvpANprGkFuP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQTdqwACgkQFA3kzBSg
KbaYlA//bo7VtRK5WSXQn51NKl4rMHtB9BTc1yrc2gzQsKpOKlLENgKC1gOwS86L
VuRkXc02GTzJyAy8UOdNj+yzey0WWGV7qa2DqDIzSyh6BJLQ8Pmn059o9x82zjoX
XvrECX8FHufdmBK5cEXazfMSrYo156idd08NKhlkdVCAWGxFcjqxvr0KAuXmlGMt
fPpOYBjuG2uzprKBlVN1hCR0hsub/gyZAS055YUX+bPdlNC4Ifg8Zwoueb6dzXVT
OVge5/DxHJKKMAGQ+lor70mGzLDp0diunAj2bIe4NqCTDat07vDLU7v0X+mYW3ZE
hkCyQdkI623WeOmmKvRO+fLILslUsvGO7t/I29Yirsy5Q4o7wy8J9g3cIxqq+Xyl
AM9irVpO21menOKIyOEGt/6OZ1R700bZK7MnwiSsbmJaTqb9eRfAvU0CW6iZGzYg
6YPZXu+GTuitn16wpRZQR0YSWztWlN5dwau2dh9KxsH7zEVdUS+IKSz5a70b/N21
wRR0vG4yan41aWXi61bKDxtVenVsCXiHwEuhokg9Gbif7PtFKshWkatc7hdf9/ei
jBGIWb3e9rDOF7wbPvzPt/1Gisl5pIoQDQtLObDN1oYVgN4cXG1Y3z6qD5Hs03yQ
CejsPr6IFhUJGS321oSAGQF62zvST3XmJAfhJZZzfYWCt4b+uGE=
=QgGW
-----END PGP SIGNATURE-----

--UfjXLvpANprGkFuP--
