Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093D054554B
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 22:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240591AbiFIUEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 16:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbiFIUEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 16:04:48 -0400
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E8A5253F;
        Thu,  9 Jun 2022 13:04:47 -0700 (PDT)
Received: by mail-io1-f46.google.com with SMTP id p69so4492746iod.0;
        Thu, 09 Jun 2022 13:04:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aYLB3MXMG/zUWxx6YIU5grgpq0m+C2J/TptDhmwSbzU=;
        b=Duy7Sqd9LkLZ4x1Capr+kGijZeZloVHKmqXp4sEITfSM3o+gT0h5FEK2pB/zhSYHAY
         1mVQiZ555SyO45bH3vJ5LDM0garygWQ5l+J6rpVxtW8Ea/I6PoIQXO5qieYu1AjCuuXl
         m0QTbkz6uQxqzW9K6PmljvsecxEUFTgdhCsdKvO63SmD7ygiN7Dpuz318GiNgsgRhEep
         bdSkZNFpau6eohuI4d/AH6xfkMOXMD+7lFlgvcglmaGBp1p9ssQz95abEnj8TiTsuT5d
         moS3fI27LdFwlf98zAjTb75Ktu1f4Ww39Yn0+W2yb5j1c48LThej7VEbKd3TJeq3ewDL
         8kTw==
X-Gm-Message-State: AOAM531RHYlNzMHEWclQqIOtwYf7V1TAKDpT2NVtOszmB+bdZOFyh/Fo
        myIxJWx5JGDZgjHo44iBkg==
X-Google-Smtp-Source: ABdhPJzPzwcZRopSbyq0oyqhcTeySTRI6+hP54iIEiP9HuD2LWBkyBnv3X+aT3kaJHFPyTFS7p3WQg==
X-Received: by 2002:a5d:9818:0:b0:65b:ae2:863e with SMTP id a24-20020a5d9818000000b0065b0ae2863emr19266534iol.31.1654805086533;
        Thu, 09 Jun 2022 13:04:46 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id s8-20020a92ae08000000b002d149ec2606sm10731012ilh.65.2022.06.09.13.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 13:04:46 -0700 (PDT)
Received: (nullmailer pid 14636 invoked by uid 1000);
        Thu, 09 Jun 2022 20:04:44 -0000
Date:   Thu, 9 Jun 2022 14:04:44 -0600
From:   Rob Herring <robh@kernel.org>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Dan Murphy <dmurphy@ti.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/3] dt-bindings: dp83867: add binding for
 io_impedance_ctrl nvmem cell
Message-ID: <20220609200444.GA14557-robh@kernel.org>
References: <20220606202220.1670714-1-linux@rasmusvillemoes.dk>
 <20220606202220.1670714-2-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606202220.1670714-2-linux@rasmusvillemoes.dk>
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

On Mon, 06 Jun 2022 22:22:18 +0200, Rasmus Villemoes wrote:
> We have a board where measurements indicate that the current three
> options - leaving IO_IMPEDANCE_CTRL at the (factory calibrated) reset
> value or using one of the two boolean properties to set it to the
> min/max value - are too coarse.
> 
> There is no documented mapping from the 32 possible values of the
> IO_IMPEDANCE_CTRL field to values in the range 35-70 ohms, and the
> exact mapping is likely to vary from chip to chip. So add a DT binding
> for an nvmem cell which can be populated during production with a
> value suitable for each specific board.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  .../devicetree/bindings/net/ti,dp83867.yaml    | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
