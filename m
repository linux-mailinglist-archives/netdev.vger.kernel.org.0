Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C6522754E
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgGUCCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:02:54 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38359 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGUCCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:02:53 -0400
Received: by mail-io1-f67.google.com with SMTP id l1so19717958ioh.5;
        Mon, 20 Jul 2020 19:02:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ler81PLDj8c/ETj2nxI+bIOhjpg0lok1Sis4qfEHFDg=;
        b=g+u5Qu0aD6S79h5wDbe7jh0y9l9WVsEvt1oDlu1g+Fp4c0xnTa6EpdGxer2zY7PIxq
         jEzLe/s9jmRDSzYQxwfP0ine52JH1wcVSIVAc3SqIRJwTknrL3yqgKSlTS5sLKDGzpGZ
         3wcY4ZTqRTwEhEsCarVO4FpLC3Lytt+CoZfJqXjFS7nbI8+nrYZoyybguieaM9AB7Jts
         1pUS8m0uGlhpvDlqxaT63RaQx8GD309CWERl0jh/939kKcPeytzxthxLS3rI4JNmm0q2
         ewqHKmppsqVYKyhsJ9vHv6YQft2TIl8YSN0EJfp6l83GUUPA2N7LrhbDVH+0hRrQ1SBb
         4Diw==
X-Gm-Message-State: AOAM533Y9qFiEBY1A/unNSXJzVNDRFowrF7X4RezJ5PP066O9EMgQByB
        OBtPU0N5m4ebn3y8d3V2EQ==
X-Google-Smtp-Source: ABdhPJwZCe2h4AviiyvIFBGlgC05v7ot4+I1iDQiZQydaBNoQO+wiOKKAdBuVl53L7vk3LV4pAgx3A==
X-Received: by 2002:a05:6602:2fd5:: with SMTP id v21mr25481598iow.41.1595296972677;
        Mon, 20 Jul 2020 19:02:52 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id w7sm7795817iov.1.2020.07.20.19.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 19:02:52 -0700 (PDT)
Received: (nullmailer pid 3375633 invoked by uid 1000);
        Tue, 21 Jul 2020 02:02:50 -0000
Date:   Mon, 20 Jul 2020 20:02:50 -0600
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     dmaengine@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Joerg Roedel <joro@8bytes.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        iommu@lists.linux-foundation.org,
        linux-renesas-soc@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        linux-gpio@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 6/9] dt-bindings: gpio: renesas,rcar-gpio: Add r8a774e1
 support
Message-ID: <20200721020250.GA3375580@bogus>
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-7-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594676120-5862-7-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 22:35:17 +0100, Lad Prabhakar wrote:
> Document Renesas RZ/G2H (R8A774E1) GPIO blocks compatibility within the
> relevant dt-bindings.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/gpio/renesas,rcar-gpio.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
