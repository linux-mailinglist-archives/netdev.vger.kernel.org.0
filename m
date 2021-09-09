Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E08D4042B8
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 03:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349211AbhIIBUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 21:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348988AbhIIBUa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 21:20:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8030861166;
        Thu,  9 Sep 2021 01:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631150361;
        bh=tdVbevl+aDxkyATd4nlXrr1019b4HiAb+ZLlEGHbwho=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Q1cyOUprqpdZbEvLayrMh+mgppIefqI49VWGrjQaxSkIo3p8edNilgRFSQ/PBay3g
         RIZqxA7/faqLLgi6WzltBQq6k/FYcp1dZc/Dj6kLN1F5fS2s/CXhM/MfoK2i+0qLto
         B8kaguNhOqUjr+uaARmTfKhUqFtWTNHHUPbHVUC8mfFC8Ix0y+zpmdB+pmzy8x9t6u
         EDXVzVHCsojsJ/W9au+/pBYBIkosPdkcbY/GGGgAjS7wrVBF2g4sx9IvsbRUY7wrSz
         PYku3jC5umtQkaYT79SNtPrPnzPPi+uN/MmmgOthkKCJCcenviiYho21+/buRiX0Us
         B+krK1cbzsdLw==
Received: by mail-lf1-f48.google.com with SMTP id n2so346146lfk.0;
        Wed, 08 Sep 2021 18:19:21 -0700 (PDT)
X-Gm-Message-State: AOAM532xaZa8JrhU/3jS8+8ElQTFLX0Aq19vL+kTizqaZu8VK8daSAO2
        mPBQpcu0gg+f2PIOdC2RLmX6+8SV29l5HsC+kOc=
X-Google-Smtp-Source: ABdhPJzbQK5G5b2Cj872WktC8knYxqKRlLbs7wzoVrTt/pg7AKP6TRI9EoAf5LGLuAMBSVQjoANdrbJscEpZXpMnElY=
X-Received: by 2002:a05:6512:3f9f:: with SMTP id x31mr401134lfa.233.1631150359914;
 Wed, 08 Sep 2021 18:19:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210908030240.9007-1-samuel@sholland.org>
In-Reply-To: <20210908030240.9007-1-samuel@sholland.org>
From:   Guo Ren <guoren@kernel.org>
Date:   Thu, 9 Sep 2021 09:19:08 +0800
X-Gmail-Original-Message-ID: <CAJF2gTQ=RoXouwL75JfmxOFzj+x5bfTW=Ae_3Ufyg3ZDA_Qj+Q@mail.gmail.com>
Message-ID: <CAJF2gTQ=RoXouwL75JfmxOFzj+x5bfTW=Ae_3Ufyg3ZDA_Qj+Q@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: sun8i-emac: Add compatible for D1
To:     Samuel Holland <samuel@sholland.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        devicetree <devicetree@vger.kernel.org>, netdev@vger.kernel.org,
        linux-sunxi@lists.linux.dev,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thx Samuel,

Acked-by: Guo Ren <guoren@kernel.org>

On Wed, Sep 8, 2021 at 11:02 AM Samuel Holland <samuel@sholland.org> wrote:
>
> The D1 SoC contains EMAC hardware which is compatible with the A64 EMAC.
> Add the new compatible string, with the A64 as a fallback.
>
> Signed-off-by: Samuel Holland <samuel@sholland.org>
> ---
>  .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml    | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> index 7f2578d48e3f..9eb4bb529ad5 100644
> --- a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> +++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> @@ -19,7 +19,9 @@ properties:
>        - const: allwinner,sun8i-v3s-emac
>        - const: allwinner,sun50i-a64-emac
>        - items:
> -          - const: allwinner,sun50i-h6-emac
> +          - enum:
> +              - allwinner,sun20i-d1-emac
> +              - allwinner,sun50i-h6-emac
>            - const: allwinner,sun50i-a64-emac
>
>    reg:
> --
> 2.31.1
>


-- 
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/
