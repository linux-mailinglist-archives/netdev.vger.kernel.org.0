Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30514051D7
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354391AbhIIMi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:38:58 -0400
Received: from mail-ot1-f46.google.com ([209.85.210.46]:37479 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351614AbhIIMeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 08:34:14 -0400
Received: by mail-ot1-f46.google.com with SMTP id i3-20020a056830210300b0051af5666070so2259643otc.4;
        Thu, 09 Sep 2021 05:33:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=mgK7NOGoFgYko3sL9/CnFKWvO1Nc0SwAG4V9JvFppl0=;
        b=MwASJW5zaS47XJzk+OUMFCM8579zUeVFHmrZiTvd/73yfZn3/Ksa1AhBkLNG4ebrvg
         JMhGG4weOt07iMTQQp6XEqELjBkHqIi++UCN64RejODnNcEUAFWtU5AWVXZfItF4ONOw
         jezomeqlOt9AS8QXXTA7/o6MpW1VosXnp6KtUgQs42QTXe85oldC6QfizVKuhJltSCJ6
         JMH2qVJlR4yxm/uV24pRT+GpkKB2jqGQDoc+5hJbp3fyys2jZrhbUH9u2vmOd3eRy9Cz
         IAQhxFwg6GahPRjI5UbdrCwWFV0/lLNZ7l78KOljL6yWx/Jbbh2ecIyTtt3qTZp9yt38
         5jiw==
X-Gm-Message-State: AOAM533Hyf1r8POXE325IHB1GbIN1ZdMhD3czKuMmAbUILg66jAEff+y
        mORvBymB3JQ2Ald0C6Mzvw==
X-Google-Smtp-Source: ABdhPJw1M/AsCCVywKipuhZa6/5nA/2P6FN5EmeeX004LUh08SNTosLeVyAGlWR8c1Aqa3bmnf0Ltw==
X-Received: by 2002:a9d:641a:: with SMTP id h26mr2231113otl.15.1631190782575;
        Thu, 09 Sep 2021 05:33:02 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id x4sm361101ood.2.2021.09.09.05.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 05:33:01 -0700 (PDT)
Received: (nullmailer pid 200342 invoked by uid 1000);
        Thu, 09 Sep 2021 12:32:53 -0000
From:   Rob Herring <robh@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
In-Reply-To: <20210908221118.138045-1-linus.walleij@linaro.org>
References: <20210908221118.138045-1-linus.walleij@linaro.org>
Subject: Re: [PATCH] dt-bindings: net: Add bindings for IXP4xx V.35 WAN HSS
Date:   Thu, 09 Sep 2021 07:32:53 -0500
Message-Id: <1631190773.296990.200341.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 09 Sep 2021 00:11:18 +0200, Linus Walleij wrote:
> This adds device tree bindings for the IXP4xx V.35 WAN high
> speed serial (HSS) link.
> 
> An example is added to the NPE example where the HSS appears
> as a child.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Currently only adding these bindings so we can describe the
> hardware in device trees.
> ---
>  ...ntel,ixp4xx-network-processing-engine.yaml |  26 ++++
>  .../bindings/net/intel,ixp4xx-hss.yaml        | 129 ++++++++++++++++++
>  2 files changed, 155 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.example.dt.yaml: npe@c8006000: '#address-cells', '#size-cells', 'hss@0' do not match any of the regexes: 'pinctrl-[0-9]+'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1526025

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

