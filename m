Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E455B460BD4
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 01:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbhK2Apz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 19:45:55 -0500
Received: from mail-ot1-f41.google.com ([209.85.210.41]:37878 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbhK2Any (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 19:43:54 -0500
Received: by mail-ot1-f41.google.com with SMTP id h19-20020a9d3e53000000b0056547b797b2so23160604otg.4;
        Sun, 28 Nov 2021 16:40:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eht3h2RfIdvDXzUC49NJgqp2VMjoZ0mMWYd22HZWkR8=;
        b=lqibymmI5bOEFZ/1KxamF7dzxm4OpR3vhonsVuP+johyVR/+0qOSQCDya6WcGi7IE0
         d4VnaI9jXerxo0Sf5fmUTSu9OeugpMZ6+vLYsDx+4SAWXb90Y1hzQgnA+7iyuKm64Iay
         tMd5u3Wz7RY846XmJfN1/MSnHuSgNqrW68gUn00N+/BNzWYc+NmeEr1L/JI26c0kneC6
         lOpNGAhWP6vNaYueLorBlUxS2HsdDOO5V2TzB2DQ9teNgBci7Jjm9cuwR8ynfPiyEEKL
         bzEocFXVleEh9AFcnT6aiezbsss4FY/stdzbDDQG0JFFcUsS8aslCSWHWxcb5Aavey/+
         6QxQ==
X-Gm-Message-State: AOAM531lfMK9kk14rXpo+VQvN0jbYLnCF5SBYtwQD31iqNM9bZY3k9Zy
        aIybRuukALi8IGRE7ypQoA==
X-Google-Smtp-Source: ABdhPJyE8vl7EVASoquO7MP9SgO6F7sXPuDQO8JtSNSx9EUT83LSrV5ev+Ikpmp2e3pMCvOTyB5XCA==
X-Received: by 2002:a9d:390:: with SMTP id f16mr42944469otf.325.1638146437939;
        Sun, 28 Nov 2021 16:40:37 -0800 (PST)
Received: from robh.at.kernel.org ([172.58.99.229])
        by smtp.gmail.com with ESMTPSA id n23sm2627359oig.4.2021.11.28.16.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 16:40:37 -0800 (PST)
Received: (nullmailer pid 2905021 invoked by uid 1000);
        Mon, 29 Nov 2021 00:40:35 -0000
Date:   Sun, 28 Nov 2021 18:40:35 -0600
From:   Rob Herring <robh@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/2 v3] dt-bindings: net: Add bindings for
 IXP4xx V.35 WAN HSS
Message-ID: <YaQhg8n6fkwQVIF+@robh.at.kernel.org>
References: <20211122223530.3346264-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122223530.3346264-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Nov 2021 23:35:29 +0100, Linus Walleij wrote:
> This adds device tree bindings for the IXP4xx V.35 WAN high
> speed serial (HSS) link.
> 
> An example is added to the NPE example where the HSS appears
> as a child.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v2->v3:
> - Add address-cells and size-cells to the NPE node so we
>   can number the instance with reg = <>;
> - Add a patternProperties for the HSS nodes to match and
>   reference the HSS schema from there.
> - Found one more queue that was passed using platform data:
>   intel,queue-chl-txready. Add binding for this and add it
>   to the example.
> - Resend along with the driver conversion.
> ChangeLog v1->v2:
> - Add intel vendor prefix on custom queue handle bindings.
> - Make the pkt-tx and pkt-rxfree into arrays of handles.
> 
> Currently only adding these bindings so we can describe the
> hardware in device trees.
> ---
>  ...ntel,ixp4xx-network-processing-engine.yaml |  35 ++++++
>  .../bindings/net/intel,ixp4xx-hss.yaml        | 100 ++++++++++++++++++
>  2 files changed, 135 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
