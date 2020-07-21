Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760F2227549
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgGUCCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:02:40 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:43048 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGUCCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:02:39 -0400
Received: by mail-il1-f196.google.com with SMTP id i18so15074246ilk.10;
        Mon, 20 Jul 2020 19:02:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C6sxjz8cQBHBfpqcqYjPc2k4llIyWqyfVKlT/NeeUxk=;
        b=fPktIKepHuSWTa9tasX5lfhH38n2d/0/pR5ciHLsogN01u6VkwysDx/Ky+/MKUmQq6
         dG6v62AhW5Kh3ApNyVgYbtj15jVLFcRMEdwvXTCS4WMvUTQstyuDDRXfXzq7cZHzB1dJ
         DUbvb6YuddchGoCJWB2fLh+M9VNnIPv68bcCsNQui3wpy8oRwen4PMcwnOn83hZnRYOP
         r7HtmlXDVpuibs334xvR9jcF8axG4LHtEC+QzFexotLYlwXrYhbF8qeArknZtl0nErwZ
         0NlnZ/bl2mqZkD9RxugVv/kXnbOxOYgqnGhgIim9a94cRaVkmd5TdWRsVrSkPP0rgy25
         yTLA==
X-Gm-Message-State: AOAM531V80G00lzGLKCrVAZo2v7Y4BFnVaJmwU3yoarxzRPIsDSXHHux
        RbR6vGr+CM5Q+bZJg+9N2w==
X-Google-Smtp-Source: ABdhPJxX74z9HXclwgDeBM2Q5ozxho0K5hV9uTK/097gQNaE+eInRy3aYrFpJlSzAA0aKm6RFiiX3A==
X-Received: by 2002:a92:8947:: with SMTP id n68mr26670327ild.235.1595296958270;
        Mon, 20 Jul 2020 19:02:38 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id f2sm9869392ioc.52.2020.07.20.19.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 19:02:37 -0700 (PDT)
Received: (nullmailer pid 3375235 invoked by uid 1000);
        Tue, 21 Jul 2020 02:02:36 -0000
Date:   Mon, 20 Jul 2020 20:02:36 -0600
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 1/9] dt-bindings: iommu: renesas,ipmmu-vmsa: Add r8a774e1
 support
Message-ID: <20200721020236.GA3374330@bogus>
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-2-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594676120-5862-2-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 10:35:12PM +0100, Lad Prabhakar wrote:
> Document RZ/G2H (R8A774E1) SoC bindings.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/iommu/renesas,ipmmu-vmsa.yaml | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Rob Herring <robh@kernel.org>
