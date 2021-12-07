Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276E746B5ED
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 09:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbhLGIa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 03:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbhLGIaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 03:30:23 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E564C061354;
        Tue,  7 Dec 2021 00:26:53 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id a9so27721580wrr.8;
        Tue, 07 Dec 2021 00:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=s27C7lmlAoDAm+3Q5jfJV42xoUzp7gqvzXSSXuJO2yQ=;
        b=VqqPRVlydOykPR9OLjGoBGp9xEOL9+MBVFJI/OwVEInwhoGGfNgu0/WgfqUPzt6y49
         0EuE5R7Bp7n6qxKPfTSoF/BZv/wBS2N0HGgKjl9MFbzXvBAdlmj6+hyMH2Z4bI9Wh/zC
         hcVf+ALRx9lXgsfoArOAw6GesKeKZ61HI7SMbsQtvnSOqO8Cg4CC0TXHGp4PTfTNmWl5
         UyI9vRfQuESB18sTuO3cct1dgQfLuIXdilO3Ll0W8/+0RlS24r+D2ODO3wgEl3XS9wM2
         AkudDAVYL7jySFYvynGHkTtMW6rENAn0G86insmW8+FsZzaSpV05rtAKH79y8/4uQd1S
         vWEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=s27C7lmlAoDAm+3Q5jfJV42xoUzp7gqvzXSSXuJO2yQ=;
        b=elZM7XbjcteCmyJTZstknSPx24fkHKnlHgDwpt3jl22QpNNBzNhGpBWPRWDywaZbYL
         D2KrRRs8pYveaBpc/sZEnN4JIx7xw9bbabJ5Iy1HqDYsu5QU8T0O44WvjdLrrG+g/TRC
         4sOg9WFy7mZEIMHidHGT7pXp01eedrfUa1wAavjdLlEFy4KNdOH9CFxXfSuYPeeD3egX
         SxJH+7OkQg+Rx+OuJY/kIcRRiYRTZIQmWAomuf/9vc/zLiYZFi5+/u6rXhrOIGhGm1+k
         A6ipDE+zI9+MTW/GHlm3P4WGbpHybJ9yR9gAjBOWwEnexFZHXAONA8mhqrKXgb8yxaOF
         tRog==
X-Gm-Message-State: AOAM532Ulukb6TZhKJNPg9ahXLmLKovAPA5UFL9YLsdSWJrE+6PG8zpU
        ntoRrLzWY5Md0jsqrfpMK+0=
X-Google-Smtp-Source: ABdhPJwLS7w6seR8wLYqin7zySeB1avuewSm3V/Qm6ZfiI560CtuymhkfoiuhNUjkU1+k58tKV3I8Q==
X-Received: by 2002:a5d:66cd:: with SMTP id k13mr49034886wrw.517.1638865612265;
        Tue, 07 Dec 2021 00:26:52 -0800 (PST)
Received: from orome.fritz.box ([193.209.96.43])
        by smtp.gmail.com with ESMTPSA id m3sm13619818wrv.95.2021.12.07.00.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 00:26:51 -0800 (PST)
Date:   Tue, 7 Dec 2021 09:26:48 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: snps,dwmac: Enable burst length
 properties for more compatibles
Message-ID: <Ya8ayBtEq1UFbAEt@orome.fritz.box>
References: <20211206174147.2296770-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FttgTCTR+G2s7RxK"
Content-Disposition: inline
In-Reply-To: <20211206174147.2296770-1-robh@kernel.org>
User-Agent: Mutt/2.1.3 (987dde4c) (2021-09-10)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FttgTCTR+G2s7RxK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 06, 2021 at 11:41:47AM -0600, Rob Herring wrote:
> With 'unevaluatedProperties' support implemented, the properties
> 'snps,pbl', 'snps,txpbl', and 'snps,rxpbl' are not allowed in the
> examples for some of the DWMAC versions:
>=20
> Documentation/devicetree/bindings/net/intel,dwmac-plat.example.dt.yaml: e=
thernet@3a000000: Unevaluated properties are not allowed ('snps,pbl', 'mdio=
0' were unexpected)
> Documentation/devicetree/bindings/net/stm32-dwmac.example.dt.yaml: ethern=
et@5800a000: Unevaluated properties are not allowed ('reg-names', 'snps,pbl=
' were unexpected)
> Documentation/devicetree/bindings/net/stm32-dwmac.example.dt.yaml: ethern=
et@40028000: Unevaluated properties are not allowed ('reg-names', 'snps,pbl=
' were unexpected)
> Documentation/devicetree/bindings/net/stm32-dwmac.example.dt.yaml: ethern=
et@40027000: Unevaluated properties are not allowed ('reg-names', 'snps,pbl=
' were unexpected)
> Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.example.dt.y=
aml: ethernet@28000000: Unevaluated properties are not allowed ('snps,txpbl=
', 'snps,rxpbl', 'mdio0' were unexpected)
>=20
> This appears to be an oversight, so fix it by allowing the properties
> on the v3.50a, v4.10a, and v4.20a versions of the DWMAC.
>=20
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Jose Abreu <joabreu@synopsys.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 3 +++
>  1 file changed, 3 insertions(+)

Reviewed-by: Thierry Reding <treding@nvidia.com>

--FttgTCTR+G2s7RxK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmGvGsgACgkQ3SOs138+
s6E/zQ//TqO3eVaS4v4+oGjf+UrUbCzMxyoyctSJ/qV8Al9N28EaRyPpD1a3i5Kz
S1uIhM6HEpQQ3jwCpln1H7EuDX+5QHYED/y2UG9GsrfL51PeFsWYrdxjwG57Dq23
StXmzIxGgfHSMeosLBqlL2S7w4vmxeCtVAmZChjWTrtFgMRN/5CFggajD94rIOad
C0IYbl+sN3LvZkmfdGDppFlnLCUWcSmrW0rcK96l9PoR5tvRa77Eqo0a6D3WvArH
VPX4PAOMLw83r+pmcCwftCQ3fmv6wNjlCCO1f4uP4Lo5MWNlxRv+3YEtmmnjtzXj
WlwCAlDWIZuwJpIL7wdiHKXYtyc0UMk0JqqkqMVK7oW2H2U8qf2LwolC2NugMV+N
c1k07cCUSpt/v/KsfB4dMk0yJmeUcGFuPoT/ZLvO04KGee0V2j3LlciM1wndnW0s
qIb0kVT3z5gKsV1X5I4QRapDCxhGVp5W//cNtAFIWNsuVvvj4v09IrCxUw347Q5d
99C1DD+asu3JvbQDSooTPcaK0tTPGvjmyphRqgmlB/wL37tVSgRHluBMRBgOVQmb
/8LJ53lMY04SklatpetvwEbD2/YwIE47RJEJJxngEOCMsQz2yZMqZ5d3jRuY+c7x
jCAPJfDbs6Vho3imqMf96fEr6kh5Lllf8Iem/Boa4EDj2fIlULw=
=N+Xg
-----END PGP SIGNATURE-----

--FttgTCTR+G2s7RxK--
