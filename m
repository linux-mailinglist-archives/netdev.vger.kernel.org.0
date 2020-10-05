Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41D928371B
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 15:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgJEN7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 09:59:19 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:46968 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgJEN7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 09:59:18 -0400
Received: by mail-oi1-f195.google.com with SMTP id u126so8754289oif.13;
        Mon, 05 Oct 2020 06:59:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=r6JYKyeY4BtCnuSOeZu+oMqaX/WYd8ly12y0glDjlmA=;
        b=nWS3cZN7HOHeOEGuTwfevJG+pFo2kGkw1oQSP6QRQLY1Z9/MlnA2hxIm8n/j60tjf5
         oeoHm3Ipbv5K01EUMLfOQ9D/3IVucSUiY1cpLLFjWryz/vGgJ6LdIVGvUfTse36yJ0h9
         zagI+kauiQKGdVnOakPG/Tf10eRMM2EIj+G6l/nNK/RVBrHmPvT1NA/Hr7bskRu36Q5i
         2UQIQ3PTdYsZrVTg6UhL6aZpKNtePN99dByc9TlFrsp6P4trKQOpfil+R80fKY/92KDl
         0jXmt8DRdMvIt1kR8pjN53TpAU5UBkSSgUwfxjH+7uuC4cfySDQvafOm3hnIjJEzl+zY
         +/FA==
X-Gm-Message-State: AOAM530q+Ub5WzkI/xohGvyADnNca5W8yUuLOW91yEXWLcsaL0Q3303y
        Cur1jSzxjSEIHjSDKjwhHIDEm7LQLywR
X-Google-Smtp-Source: ABdhPJwmZFooFtrhYHH5LpdnwFIThcHkHpCUBDQspUSg7d16eB/oE7GlnV3Mjgm1ErzqQKKckkouOA==
X-Received: by 2002:aca:ba07:: with SMTP id k7mr9054689oif.159.1601906357388;
        Mon, 05 Oct 2020 06:59:17 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 39sm824887otn.57.2020.10.05.06.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 06:59:16 -0700 (PDT)
Received: (nullmailer pid 92964 invoked by uid 1000);
        Mon, 05 Oct 2020 13:59:15 -0000
Date:   Mon, 5 Oct 2020 08:59:15 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        devicetree@vger.kernel.org, jim.cromie@gmail.com,
        linux-samsung-soc@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/4] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
Message-ID: <20201005135915.GA92530@bogus>
References: <20201002192210.19967-1-l.stelmach@samsung.com>
 <CGME20201002192215eucas1p2c1d2baebfe2a9caa11d88175a2899fea@eucas1p2.samsung.com>
 <20201002192210.19967-2-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201002192210.19967-2-l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 02 Oct 2020 21:22:07 +0200, Łukasz Stelmach wrote:
> Add bindings for AX88796C SPI Ethernet Adapter.
> 
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  .../bindings/net/asix,ax88796c-spi.yaml       | 76 +++++++++++++++++++
>  .../devicetree/bindings/vendor-prefixes.yaml  |  2 +
>  2 files changed, 78 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/asix,ax88796c-spi.yaml
> 


My bot found errors running 'make dt_binding_check' on your patch:

Error: Documentation/devicetree/bindings/net/asix,ax88796c-spi.example.dts:23.29-30 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [scripts/Makefile.lib:342: Documentation/devicetree/bindings/net/asix,ax88796c-spi.example.dt.yaml] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1366: dt_binding_check] Error 2


See https://patchwork.ozlabs.org/patch/1376051

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure dt-schema is up to date:

pip3 install git+https://github.com/devicetree-org/dt-schema.git@master --upgrade

Please check and re-submit.

