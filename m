Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6029C52ACD8
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 22:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352965AbiEQUhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 16:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241415AbiEQUhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 16:37:40 -0400
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20AB2FFC4;
        Tue, 17 May 2022 13:37:39 -0700 (PDT)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-edf3b6b0f2so92613fac.9;
        Tue, 17 May 2022 13:37:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YJ/g+N+frsFeUBRUIZZcLHsE+4AmcmYs415GdYVs7PU=;
        b=aVBkRH0ysKUMBb78XiJs4EJSTjnhqEUtTus67wdTrUM9H0v/mIIGe/NHMCJTwvutzc
         w6r3nrcQpHCDIFbgZeQQn0/OvSRuh1ighV35Lb5HyaVSpSEezpT8TX+oI0wNGEjrZdSS
         ZMMwQADbShSoNH5sWabymk6VSvCYZ7IvBrOaQ1w2NItfF69ybhCkBtvv/ErkUEwfQOTZ
         ENoDFgLgfZ/MuDT2tUenphIm9x/zenIJarefEtS5MeBT0HOEt2WfljLTCJVYI4l52dSr
         Qs1nsWcclhGlFSyvlpTtyTPspQfFu3E4Sr1I4b+KQGzvNUasMQnYbjmsmL1+dgOCKAd+
         puMg==
X-Gm-Message-State: AOAM533AqnhNSaxIc8i5SaUDtG39unaR4giOQi9QUlN7SEXsWqIZLaQC
        lWaFWXhlyL4nE7WvamiZHA==
X-Google-Smtp-Source: ABdhPJxBncrepNVcSnbcipiZ6gs1h1FVeBg+V08G/WW79lWSiDRNBP405jmaewROF8jc71honMgxzA==
X-Received: by 2002:a05:6870:4596:b0:da:b3f:2b1d with SMTP id y22-20020a056870459600b000da0b3f2b1dmr20604993oao.188.1652819859252;
        Tue, 17 May 2022 13:37:39 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id 185-20020a4a14c2000000b0035eb4e5a6b1sm217659ood.7.2022.05.17.13.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 13:37:38 -0700 (PDT)
Received: (nullmailer pid 1594561 invoked by uid 1000);
        Tue, 17 May 2022 20:37:37 -0000
Date:   Tue, 17 May 2022 15:37:37 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, ansuelsmth@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        John Crispin <john@phrozen.org>, linux-doc@vger.kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH RESEND 2/5] dt-bindings: net: allow Ethernet devices as
 LED triggers
Message-ID: <20220517203737.GA1590689-robh@kernel.org>
References: <20220505135512.3486-1-zajec5@gmail.com>
 <20220505135512.3486-3-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220505135512.3486-3-zajec5@gmail.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 03:55:09PM +0200, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This allows specifying Ethernet interfaces and switch ports as triggers
> for LEDs activity.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  Documentation/devicetree/bindings/net/ethernet-controller.yaml | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index 4f15463611f8..ebeb4446d253 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -232,6 +232,9 @@ properties:
>            required:
>              - speed
>  
> +allOf:
> +  - $ref: /schemas/leds/trigger-source.yaml

There's no need to add this here. A device binding still has to list 
'#trigger-source-cells' and set it's value to 0 or 1 cell.

Rob
