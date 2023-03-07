Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8EEA6AE191
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 15:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjCGOBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 09:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjCGOBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 09:01:49 -0500
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4772A54CAD;
        Tue,  7 Mar 2023 06:01:46 -0800 (PST)
Received: by mail-qt1-f180.google.com with SMTP id c19so14277083qtn.13;
        Tue, 07 Mar 2023 06:01:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678197705;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZIwtnbs3hhla8EYiCStTsWUllaDHjZv8F8tfryJtRbU=;
        b=bZ9mWl8l/LK+BrEGpJYUyBoWfy95z60fZV3xygHVryhx1KBP+QhHWI+eyoaFtlsFJ7
         E1W15jUDV8vVj5RbEY4xmKw3OWDRyMHEVnvD4ZRIjQZwOB5LqT8Pw9s72+91o6BnDUqw
         +VUgI60fHsvDnL67KsiO3cgASM8/KCvXOMTOHHi01Fh7PiEuEy7c5Uk/Nu9b5HkbqEd8
         ydQvvnHXJjNAfa/kX/IYQCsq/oQLm87oVFXpy1PHMrr4mW7EZqjJbJCCI8zRmtLIBdr5
         BK4cvO6UBaeTyZ1pu4QPwEIcDuyojDFMDo30QHMXlDWCA0naZ/yrlKL/VWm9ozFc00Aa
         fqEg==
X-Gm-Message-State: AO0yUKWtu6ylwFQl+OhT1HlHx9aZwxdiIJlANUu8c0zypK6T4GlQ573w
        obmHEQTt2D+MvNqp6LbrEA==
X-Google-Smtp-Source: AK7set/ie2Czy1LR7jpiOaAypsEJpBOiJDLh02ocsL9PmQMfeZBp9nReUBtCOPjsaf3yPB5BHxvbMQ==
X-Received: by 2002:a05:622a:488:b0:3bf:c431:ea6e with SMTP id p8-20020a05622a048800b003bfc431ea6emr4245426qtx.3.1678197705142;
        Tue, 07 Mar 2023 06:01:45 -0800 (PST)
Received: from robh_at_kernel.org ([2605:ef80:8082:8c7f:9efe:1ea4:c2ba:e845])
        by smtp.gmail.com with ESMTPSA id s15-20020ac85ecf000000b003afbf704c7csm9360921qtx.24.2023.03.07.06.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 06:01:44 -0800 (PST)
Received: (nullmailer pid 54639 invoked by uid 1000);
        Tue, 07 Mar 2023 14:01:39 -0000
Date:   Tue, 7 Mar 2023 08:01:39 -0600
From:   Rob Herring <robh@kernel.org>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux@armlinux.org.uk, pabeni@redhat.com,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        nsekhar@ti.com, rogerq@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srk@ti.com
Subject: Re: [PATCH net-next] dt-bindings: net: ti: k3-am654-cpsw-nuss:
 Document Serdes PHY
Message-ID: <20230307140139.GA48063-robh@kernel.org>
References: <20230306094750.159657-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306094750.159657-1-s-vadapalli@ti.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 03:17:50PM +0530, Siddharth Vadapalli wrote:
> Update bindings to include Serdes PHY as an optional PHY, in addition to
> the existing CPSW MAC's PHY. The CPSW MAC's PHY is required while the
> Serdes PHY is optional. The Serdes PHY handle has to be provided only
> when the Serdes is being configured in a Single-Link protocol. Using the
> name "serdes-phy" to represent the Serdes PHY handle, the am65-cpsw-nuss
> driver can obtain the Serdes PHY and request the Serdes to be
> configured.
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
> 
> Hello,
> 
> This patch corresponds to the Serdes PHY bindings that were missed out in
> the series at:
> Link: https://lore.kernel.org/r/20230104103432.1126403-1-s-vadapalli@ti.com/
> This was pointed out at:
> https://lore.kernel.org/r/CAMuHMdW5atq-FuLEL3htuE3t2uO86anLL3zeY7n1RqqMP_rH1g@mail.gmail.com/
> 
>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 21 +++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> index 900063411a20..fab7df437dcc 100644
> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> @@ -126,8 +126,25 @@ properties:
>              description: CPSW port number
>  
>            phys:
> -            maxItems: 1
> -            description: phandle on phy-gmii-sel PHY
> +            minItems: 1
> +            maxItems: 2
> +            description:
> +              phandle(s) on CPSW MAC's PHY (Required) and the Serdes
> +              PHY (Optional). phandle to the Serdes PHY is required
> +              when the Serdes has to be configured in Single-Link
> +              configuration.

Like this:

minItems: 1
items:
  - description: CPSW MAC's PHY
  - description: Serdes PHY. Serdes PHY is required
      when the Serdes has to be configured in Single-Link

> +
> +          phy-names:
> +            oneOf:
> +              - items:
> +                  - const: mac-phy
> +                  - const: serdes-phy
> +              - items:
> +                  - const: mac-phy

Drop this and use minItems in 1st 'items' entry.

> +            description:
> +              Identifiers for the CPSW MAC's PHY and the Serdes PHY.
> +              CPSW MAC's PHY is required and therefore "mac-phy" is
> +              required, while "serdes-phy" is optional.

No need to state in plain text what the schema already says.

Rob
