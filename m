Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59FDE63FA06
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 22:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiLAVtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 16:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiLAVta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 16:49:30 -0500
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0F7BD0EB;
        Thu,  1 Dec 2022 13:49:29 -0800 (PST)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-1442977d77dso2583237fac.6;
        Thu, 01 Dec 2022 13:49:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=57yzKLWxqL5GldzJ3/QZmz79jz1YFJsrObt0S+latdo=;
        b=MA9QSmzKYupJgeleZKtfiJDbBk1+YakV4N6Yqh86LZOwzNo06t8Ck/ovLGPQNObTwZ
         RnhlFGB9Bi3/owmA7fJ0zpbLWSxQS6sZU6rH7YjwOA/D59pCm0le4esayMa9hmlNQOwc
         GlmBRWb/My0KSpP/9LgPYFuPBjwDEJcVElScbv1YEStzZq+RmqbuWDnJQ7NXsOP9pib4
         fxuPgWIPeOgSRsCIBdKrtFnGaHMoIJWEibcWJN3s4so5jxLGgPyeHcwO0MefYcp1dPSe
         /Z/IcP+IThO41LphbMwqUPUmiJ7zeE1RFpRDE47cpWW/piSJtc3fjJrzZTqVkKbAsqmf
         S24w==
X-Gm-Message-State: ANoB5pnjv4E90g7A3rSU/ifuzJSL4880pikyTpSy+Xo6mbz+cKqvTYYk
        iV9A3P/LyoPBXyYXTwOhQg==
X-Google-Smtp-Source: AA0mqf7kfkqw12wKx8Bg+cNoCItLOK3uTdw4M2dwW24Q+GfB94xcnEKX6GXNa+fAH8H1rAETKDVKtg==
X-Received: by 2002:a05:6870:b19:b0:142:78d9:d216 with SMTP id lh25-20020a0568700b1900b0014278d9d216mr27901961oab.207.1669931369066;
        Thu, 01 Dec 2022 13:49:29 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id r81-20020aca5d54000000b0035b99bbe30bsm2248529oib.54.2022.12.01.13.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 13:49:28 -0800 (PST)
Received: (nullmailer pid 1506354 invoked by uid 1000);
        Thu, 01 Dec 2022 21:49:27 -0000
Date:   Thu, 1 Dec 2022 15:49:27 -0600
From:   Rob Herring <robh@kernel.org>
To:     Samuel Holland <samuel@sholland.org>
Cc:     LABBE Corentin <clabbe.montjoie@gmail.com>,
        linux-sunxi@lists.linux.dev, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <mripard@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3/3] dt-bindings: net: sun8i-emac: Add phy-supply property
Message-ID: <166993136639.1506264.15399520110804856771.robh@kernel.org>
References: <20221125202008.64595-1-samuel@sholland.org>
 <20221125202008.64595-4-samuel@sholland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125202008.64595-4-samuel@sholland.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 25 Nov 2022 14:20:08 -0600, Samuel Holland wrote:
> This property has always been supported by the Linux driver; see
> commit 9f93ac8d4085 ("net-next: stmmac: Add dwmac-sun8i"). In fact, the
> original driver submission includes the phy-supply code but no mention
> of it in the binding, so the omission appears to be accidental. In
> addition, the property is documented in the binding for the previous
> hardware generation, allwinner,sun7i-a20-gmac.
> 
> Document phy-supply in the binding to fix devicetree validation for the
> 25+ boards that already use this property.
> 
> Fixes: 0441bde003be ("dt-bindings: net-next: Add DT bindings documentation for Allwinner dwmac-sun8i")
> Signed-off-by: Samuel Holland <samuel@sholland.org>
> ---
> 
>  .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml     | 3 +++
>  1 file changed, 3 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
