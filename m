Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0FE563B86
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 23:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbiGAU4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiGAU4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:56:32 -0400
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16EDA5A2F6;
        Fri,  1 Jul 2022 13:56:32 -0700 (PDT)
Received: by mail-io1-f49.google.com with SMTP id k15so3376714iok.5;
        Fri, 01 Jul 2022 13:56:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2W4otq92zFfalH+gxfmLA9wF6s9cXLd7pPhg0IWZ1yQ=;
        b=MNSUS5f348sA+k9ARbYS++LhJbhsnmd94gKxpjBnmyzFf2g7VEWJX0uEKMVSaQiS9h
         AZLDiC4VgKGy2WHHF9jt6TrT/V6SGTP9KO0TGPkPmpcpvRssYJQSwuqZivdB81LS+cqG
         Vs3XEKHOJtOq7d5cEeGjeEjKseCOZ5s4AYYRbT6CKrjvm13SztcYL1RJTUCuNU4HYgCl
         cxMGUjBYLu9yk+n8qzQIdwHGAjpvx5o4eH/Aper4Fi8s+abHvqP3leeU5XsdOwTAEbzR
         bidTyAUkqWK63hgzLN5pyPqP/JzRklpZanrIRh29x0MQeqFZoJQeBFA1aQsEwHt8ETbw
         hbZQ==
X-Gm-Message-State: AJIora/H1Y4tpHD8hxA8XEtVc3OpwnpdOP9KmkSJCnncXvQDYRr57qvO
        kA8p4mWNscZM0qkg2OdoYA==
X-Google-Smtp-Source: AGRyM1vhDtJesvNuuONXYiZ73XevaIFapti+fRC1a89IqwmrRBoeM2BSI/jdY7PvT2MbMKmjxRT+Og==
X-Received: by 2002:a02:9f09:0:b0:339:e88d:f9bd with SMTP id z9-20020a029f09000000b00339e88df9bdmr10352168jal.298.1656708991347;
        Fri, 01 Jul 2022 13:56:31 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id i20-20020a5d88d4000000b00674ef48b124sm10600409iol.51.2022.07.01.13.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 13:56:31 -0700 (PDT)
Received: (nullmailer pid 1514827 invoked by uid 1000);
        Fri, 01 Jul 2022 20:56:29 -0000
Date:   Fri, 1 Jul 2022 14:56:29 -0600
From:   Rob Herring <robh@kernel.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, linux-sunxi@lists.linux.dev,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Samuel Holland <samuel@sholland.org>
Subject: Re: [PATCH v12 1/7] dt-bindings: arm: sunxi: Add H616 EMAC compatible
Message-ID: <20220701205629.GA1514772-robh@kernel.org>
References: <20220701112453.2310722-1-andre.przywara@arm.com>
 <20220701112453.2310722-2-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701112453.2310722-2-andre.przywara@arm.com>
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

On Fri, 01 Jul 2022 12:24:47 +0100, Andre Przywara wrote:
> The Allwinner H616 contains an "EMAC" Ethernet MAC compatible to the A64
> version.
> 
> Add it to the list of compatible strings.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml       | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
