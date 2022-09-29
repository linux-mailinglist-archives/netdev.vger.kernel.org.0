Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA425EFE93
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 22:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiI2UUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 16:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiI2UU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 16:20:29 -0400
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7493848C81;
        Thu, 29 Sep 2022 13:20:22 -0700 (PDT)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-131c8ccae75so3156920fac.3;
        Thu, 29 Sep 2022 13:20:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=lA+NSHyxjLzjJuiTqQbaeBr4bD4+BZYVTUZyg3a+e6I=;
        b=Qh3K0YegOYNhLHMaC4qskalmv/mrpWIoEWAOJFy/7+iS2TJ2XJRRC+XelUYy/NIv+a
         7pu8H5FFIiBcgKGdZBfH9XnsrcBScBGM+vT1/Dd585+GbUUC5n5ebRaesRLe/693cXXE
         jBZvp6XgcOt3yAy0bCjNVAWLdD5emz7CMwbr+FsvKZxuhxKrjNvuXa+tH2Wz0Un0G3KW
         Uwv0ptDfjT8I4wUxrObQgJ8LgXkHuCRIq2cbBiMsATbnqGJk9Ij3ibjz2U7w91dtj5UQ
         MXcJtSsNrwO54pfkzqks7CP4i1p7q8A8HEG71XA0XnyYxDGSzUp67lVHyik7R7m7k1Va
         91lw==
X-Gm-Message-State: ACrzQf1VEtNru4XiJfxyiLKjKxUOWRfRhJSOwdlih/bgazAvnlnYx5s9
        sZ1A9AJhsysaPHTvTndNCg==
X-Google-Smtp-Source: AMsMyM4kgp3WdXEV9mKyTY9xUcZODIn8D7eADYuFc6yei1RBdOy+dXpm4bfqNeZy/1en2rI3CJPohA==
X-Received: by 2002:a05:6870:e886:b0:131:c8fe:1b60 with SMTP id q6-20020a056870e88600b00131c8fe1b60mr2881971oan.248.1664482821737;
        Thu, 29 Sep 2022 13:20:21 -0700 (PDT)
Received: from macbook.herring.priv (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id h94-20020a9d2f67000000b0065932853f5esm143270otb.61.2022.09.29.13.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 13:20:21 -0700 (PDT)
Received: (nullmailer pid 2671518 invoked by uid 1000);
        Thu, 29 Sep 2022 20:20:20 -0000
Date:   Thu, 29 Sep 2022 15:20:20 -0500
From:   Rob Herring <robh@kernel.org>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     Eric Dumazet <edumazet@google.com>, devicetree@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        michael@amarulasolutions.com, linux-can@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: Re: [RFC PATCH v4 2/5] dt-bindings: net: can: add STM32 bxcan DT
 bindings
Message-ID: <166448281995.2671458.4285477773516650346.robh@kernel.org>
References: <20220925175209.1528960-1-dario.binacchi@amarulasolutions.com>
 <20220925175209.1528960-3-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220925175209.1528960-3-dario.binacchi@amarulasolutions.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 25 Sep 2022 19:52:06 +0200, Dario Binacchi wrote:
> Add documentation of device tree bindings for the STM32 basic extended
> CAN (bxcan) controller.
> 
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> 
> ---
> 
> Changes in v4:
> - Remove "st,stm32f4-bxcan-core" compatible. In this way the can nodes
>  (compatible "st,stm32f4-bxcan") are no longer children of a parent
>   node with compatible "st,stm32f4-bxcan-core".
> - Add the "st,gcan" property (global can memory) to can nodes which
>   references a "syscon" node containing the shared clock and memory
>   addresses.
> 
> Changes in v3:
> - Remove 'Dario Binacchi <dariobin@libero.it>' SOB.
> - Add description to the parent of the two child nodes.
> - Move "patterProperties:" after "properties: in top level before "required".
> - Add "clocks" to the "required:" list of the child nodes.
> 
> Changes in v2:
> - Change the file name into 'st,stm32-bxcan-core.yaml'.
> - Rename compatibles:
>   - st,stm32-bxcan-core -> st,stm32f4-bxcan-core
>   - st,stm32-bxcan -> st,stm32f4-bxcan
> - Rename master property to st,can-master.
> - Remove the status property from the example.
> - Put the node child properties as required.
> 
>  .../bindings/net/can/st,stm32-bxcan.yaml      | 83 +++++++++++++++++++
>  1 file changed, 83 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
