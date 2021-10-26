Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE06C43AC74
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 08:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbhJZGx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 02:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234370AbhJZGxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 02:53:54 -0400
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1303C061767
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 23:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1635231087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sXZPCO+K9iz6r8Jr0Y1Mf/siG+PaXpPzZyiBwgb6O9w=;
        b=yxR4432YXVP55R6tvO9S7z0V7PS37LdEYb0R6SB3NftKxzUdLTprlerIIvTqdsvF63HsUJ
        GFpZKCGbof7ydV/7Mf/6vLVbrhBjye+5wgonKlzuVZALn5Y2qFYLM5VbKY0anjb6DuqEly
        RslbsRh6W9Q2JrouFJumUJumaDivKI4=
From:   Sven Eckelmann <sven@narfation.org>
To:     mareklindner@neomailbox.ch, Jakub Kicinski <kuba@kernel.org>
Cc:     sw@simonwunderlich.de, a@unstable.cc, davem@davemloft.net,
        Pavel Skripkin <paskripkin@gmail.com>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+28b0702ada0bf7381f58@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: batman-adv: fix error handling
Date:   Tue, 26 Oct 2021 08:51:20 +0200
Message-ID: <2283323.BJRDQVktmA@ripper>
In-Reply-To: <20211025174950.1bec22fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <2056331.oJahCzYEoq@sven-desktop> <2526100.mKikVBQdmv@sven-l14> <20211025174950.1bec22fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1884404.dNYcoPC7rg"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart1884404.dNYcoPC7rg
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: mareklindner@neomailbox.ch, Jakub Kicinski <kuba@kernel.org>
Cc: sw@simonwunderlich.de, a@unstable.cc, davem@davemloft.net, Pavel Skripkin <paskripkin@gmail.com>, b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, syzbot+28b0702ada0bf7381f58@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: batman-adv: fix error handling
Date: Tue, 26 Oct 2021 08:51:20 +0200
Message-ID: <2283323.BJRDQVktmA@ripper>
In-Reply-To: <20211025174950.1bec22fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <2056331.oJahCzYEoq@sven-desktop> <2526100.mKikVBQdmv@sven-l14> <20211025174950.1bec22fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>

On Tuesday, 26 October 2021 02:49:50 CEST Jakub Kicinski wrote:
[...]
> > Acked-by: Sven Eckelmann <sven@narfation.org>
> 
> FWIW I'm marking this as "Awaiting upstream" in netdev patchwork,
> please LMK if you prefer for it to be applied directly.

Please apply this directly. Thanks

Kind regards,
	Sven
--nextPart1884404.dNYcoPC7rg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmF3pWgACgkQXYcKB8Em
e0ZXrRAAz8YPPokOa159qdcM2v2sLSPMwVaTHKdKXPXvXPJa5pZuzHLvHw/JB/+M
TjW4etUJiDDzrwG9Aqhc7jzAYSZYqLVJWU01NKtE7ZO5LcC/nutOFy6jjP/AhzAX
O+NTKuCK6hIsLhwqdmXWsH/1erL4VB0yPhOeVS97ue0cK4gnF8dwABguDCZQwMhc
cEYyDB3D9UO132lIHXagjTnVe5BSjFhDMragJOyhAScxRF+ky5F9P7Z0NuoKD7l8
ExOb2hhWtSzPengt+Y5cGh3DygrhDLxisWFD+k05xj2KvhGWH6+oD8xsI8GppL9u
H1AJrzKGNRt9w7qEAAU2hH957NzkMnTplGCPtjnaSGDb4UtqVDthYPcIsXF7qW/N
+QASHuogp8zoavb+5eRgRI0dEfPr0epwAwT8VeBpMD4Ia8+RZeoKv89koXM85O3m
MxvQ2uhCUAASNvhkcSVK5dK51kg3WJ7YBCofIU+882wOeb8Ooz0qR0cyOLACV1MV
zZx4DFRsBOSSrL2TL2f3ljG30hyH4m0jIZ+TWewfQYl5E4kXnT15rrDFL/yL7MXD
j1BJuZ0mR3276a1MOh2rAJ0w//xOVLjIRe5ogTXPoB8K49tTjwxYasfZQPu7v6R5
vQzWC6AHBvxMXu3S/+mX0YosasEQItbsGZq4TDGBqegGFaw5hr4=
=o3a0
-----END PGP SIGNATURE-----

--nextPart1884404.dNYcoPC7rg--



