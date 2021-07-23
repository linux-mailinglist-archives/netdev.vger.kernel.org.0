Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620DB3D427D
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 23:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhGWVR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 17:17:27 -0400
Received: from mail-io1-f49.google.com ([209.85.166.49]:46606 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbhGWVR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 17:17:26 -0400
Received: by mail-io1-f49.google.com with SMTP id u15so4161871iol.13;
        Fri, 23 Jul 2021 14:57:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FHPmTs+5gI8XKJ8Ql3COF1J8xxHSJMyndwn+3+KFeQQ=;
        b=NQK/RNIvWj4SFVcBwBdV8C0kSsB7opqAi9fSPuIC3m2Tnf7Z6TRGnqNbWjbirYMYzE
         mH6O88IuXaeY2b3+VGhH2lpujoCYrbxZ7Uvw+lWswFUjAkt4CIQR1AzLRgqJ4vVcKMRo
         8OR4xPFuN9oC66JTYwq8X2aQh3g6/QzE05teq/Y37rpMlFESxnPUOz27tU53EdXQ4SpX
         9mEYuSsQm2gPgtKiUU4rpKWuS15Iax3kFqk36EsANKVLaUrIixHU9Hrbl12XydDL4T/S
         dRaPIEjFI9zd+n9cNsMf0TmgfWFyLPs62qE0Gp8fJxgcgttWgpoTrL/TVf+sf4HNUUOw
         2K/Q==
X-Gm-Message-State: AOAM531jCKsk1tQ3yJIEHp4QS2qhEMua4+ZPeSYtuq6A+rHCuOo6eS0w
        /leD2HX8uKu53KdRY9PfYQ==
X-Google-Smtp-Source: ABdhPJzY7XrtqklCcRf34fVm6kGYCEEM4gCi6zLzAevl639xq5MEeYAWihl8UJrmIpd7CB1PWICdOA==
X-Received: by 2002:a05:6602:3423:: with SMTP id n35mr5561153ioz.188.1627077479506;
        Fri, 23 Jul 2021 14:57:59 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id b15sm350840ilq.85.2021.07.23.14.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 14:57:58 -0700 (PDT)
Received: (nullmailer pid 2665649 invoked by uid 1000);
        Fri, 23 Jul 2021 21:57:57 -0000
Date:   Fri, 23 Jul 2021 15:57:57 -0600
From:   Rob Herring <robh@kernel.org>
To:     Maxime Ripard <maxime@cerno.tech>
Cc:     Frank Rowand <frowand.list@gmail.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Chen-Yu Tsai <wens@csie.org>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 26/54] dt-bindings: net: dwmac: Fix typo in the R40
 compatible
Message-ID: <20210723215757.GA2665619@robh.at.kernel.org>
References: <20210721140424.725744-1-maxime@cerno.tech>
 <20210721140424.725744-27-maxime@cerno.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721140424.725744-27-maxime@cerno.tech>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Jul 2021 16:03:56 +0200, Maxime Ripard wrote:
> Even though both the driver and the device trees all use the
> allwinner,sun8i-r40-gmac compatible, we documented the compatible as
> allwinner,sun8i-r40-emac in the binding. Let's fix this.
> 
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jose Abreu <joabreu@synopsys.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Maxime Ripard <maxime@cerno.tech>
> ---
>  .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml  | 4 ++--
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml       | 6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
