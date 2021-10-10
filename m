Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7687742835A
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 21:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbhJJTeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 15:34:02 -0400
Received: from mail-oi1-f180.google.com ([209.85.167.180]:35687 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbhJJTeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 15:34:00 -0400
Received: by mail-oi1-f180.google.com with SMTP id n64so21705314oih.2;
        Sun, 10 Oct 2021 12:32:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=NGTSSq09OiVGe7/LXjwqn9Mcn/15vZpUh6914NVuzpY=;
        b=LoF6OIWinV3zYBMCuL5FL8HuimfEw7f/Ea0pdkdSvcZ/ZZ9Mlz5SqXb0WmCi1RZNh/
         rEvpWWY4b0h/GHPDc/93eGD8MRpUQUPuvXjnt0HxxDow9WOvNrwbm+jSudEKQ/jXz/cq
         PAm7a6qJiA3gsXZAvdambiJWHu8jCD1tuYR5ta33RACEYQOiwZcbyX2u0F5G39DGUQjZ
         84iM5H28d/wv6gLf2zfyEsM/aB0VeiVvbyv4ISnhegi7U9xQP7+JFUWSWQsfSO0EcLBK
         HRkXnjz1AXZNRH5EfH5SDVm401zs84ud1AAID/RmJZYDeYZuWEO9A7hAnHI8WFYgZ1fS
         aZvQ==
X-Gm-Message-State: AOAM531mBaGyzRN7LvSMfB1W0qUkd++9oZ1JQlQex7KE0XgJEPsXku3l
        /ured9r+BLXqp0gCxvXIvqw+zvSy3Q==
X-Google-Smtp-Source: ABdhPJxlAPoy959d/SPj7ZhJSf3KRkT7vxIHxfMRgSQ5JBv6wAdbf3sMiTZBDSDeJr1uSDYD3a/YDA==
X-Received: by 2002:aca:b909:: with SMTP id j9mr24150548oif.1.1633894321220;
        Sun, 10 Oct 2021 12:32:01 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id k4sm1254065oic.48.2021.10.10.12.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 12:32:00 -0700 (PDT)
Received: (nullmailer pid 3158668 invoked by uid 1000);
        Sun, 10 Oct 2021 19:31:56 -0000
From:   Rob Herring <robh@kernel.org>
To:     David Heidelberg <david@ixit.cz>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, ~okias/devicetree@lists.sr.ht
In-Reply-To: <20211009161941.41634-1-david@ixit.cz>
References: <20211009161941.41634-1-david@ixit.cz>
Subject: Re: [PATCH v3] dt-bindings: net: nfc: nxp,pn544: Convert txt bindings to yaml
Date:   Sun, 10 Oct 2021 14:31:56 -0500
Message-Id: <1633894316.431235.3158667.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 09 Oct 2021 18:19:42 +0200, David Heidelberg wrote:
> Convert bindings for NXP PN544 NFC driver to YAML syntax.
> 
> Signed-off-by: David Heidelberg <david@ixit.cz>
> ---
> v2
>  - Krzysztof is a maintainer
>  - pintctrl dropped
>  - 4 space indent for example
>  - nfc node name
> v3
>  - remove whole pinctrl
>  .../bindings/net/nfc/nxp,pn544.yaml           | 61 +++++++++++++++++++
>  .../devicetree/bindings/net/nfc/pn544.txt     | 33 ----------
>  2 files changed, 61 insertions(+), 33 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/pn544.txt
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1538804


pn547@28: 'clock-frequency' is a required property
	arch/arm64/boot/dts/qcom/msm8992-msft-lumia-octagon-talkman.dt.yaml
	arch/arm64/boot/dts/qcom/msm8994-msft-lumia-octagon-cityman.dt.yaml

