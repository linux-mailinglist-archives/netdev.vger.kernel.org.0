Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387BB61A39D
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 22:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiKDVw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 17:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiKDVwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 17:52:17 -0400
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E02F59FCD;
        Fri,  4 Nov 2022 14:52:06 -0700 (PDT)
Received: by mail-oi1-f172.google.com with SMTP id m204so6530543oib.6;
        Fri, 04 Nov 2022 14:52:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LJ65b2d73h31H2dxaZ+BhUUoIrMpdy/R1N7VEbqG7Uc=;
        b=S3TWB2n1hdCgqnvA1CXBSJ5Bbka10tmBrYCE7/SrgI9a1LMkeNMsCAC89PgPFINlLH
         rE9XvBl6SvUWPyAWTSdsg3CzmexujhcDJRM/k9VXRfggVLxammg2ZJDPQ4OjCWLfpdi3
         BttVMcl+d/ioS9fgAE0Q8DjwVebTN48NhzyxaPdW2qZEbtfKv0kRMp9CatUYoX8n+Igw
         szv2dqCUiMlGjm7zlebO+G6ppe8gDR0gl6PxKGe5XVRvl8tD+MUDegY7witkeb7f5z2Z
         BCiWeYFbS2jHvaGGhmIeMLgCymm+FsSDIhkpNRORlq1u6OUrota8waubMjGoMHbwyv5o
         DrRw==
X-Gm-Message-State: ACrzQf0df5lKkKV9h9cWFxy+nVaaB/WnNzcORaRIs5rAuMFIPKTH7AeV
        MYapZsOcdmG3G8xD1ZsROQ==
X-Google-Smtp-Source: AMsMyM4MufdQwVzqQypGFkIC/+rg9y0XJtwJnjOqRrkvsoM31jRHCQ/InJY9xJ+W+nQ8l8p4PwNwSA==
X-Received: by 2002:a54:4003:0:b0:35a:3618:58de with SMTP id x3-20020a544003000000b0035a361858demr9618273oie.185.1667598725523;
        Fri, 04 Nov 2022 14:52:05 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id s124-20020acac282000000b003458d346a60sm100479oif.25.2022.11.04.14.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 14:52:05 -0700 (PDT)
Received: (nullmailer pid 2890887 invoked by uid 1000);
        Fri, 04 Nov 2022 21:52:06 -0000
Date:   Fri, 4 Nov 2022 16:52:06 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>, netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/2] dt-bindings: net: dsa-port: constrain number of
 'reg' in ports
Message-ID: <166759872624.2890831.7969553050259465170.robh@kernel.org>
References: <20221102161512.53399-1-krzysztof.kozlowski@linaro.org>
 <20221102161512.53399-2-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102161512.53399-2-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 02 Nov 2022 12:15:12 -0400, Krzysztof Kozlowski wrote:
> 'reg' without any constraints allows multiple items which is not the
> intention in DSA port schema (as physical port is expected to have only
> one address).
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> ---
> 
> Changes since v2:
> 1. New patch
> ---
>  Documentation/devicetree/bindings/net/dsa/dsa-port.yaml | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
