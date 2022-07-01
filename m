Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51438563B22
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 22:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbiGAUVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiGAUVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:21:35 -0400
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60EA3B542;
        Fri,  1 Jul 2022 13:21:34 -0700 (PDT)
Received: by mail-io1-f43.google.com with SMTP id p128so3329420iof.1;
        Fri, 01 Jul 2022 13:21:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x0tbuo5st4idBI23tWtiFcOGiGqnqdTdNrO12I1u6mw=;
        b=rzX5D/wPzZcAF7HEAGMicWhWa0OqNczBb+TSLOHQSomLGs/MLC7eR9E1zuAuYof1Om
         14DiYhLGLV1GrsV2P2H9XXlsEnlbH4EYw8ul98vcrC33oFteSUqUJbVsVhFD413LLDse
         DbZKhxkxOByHhc+g2QBQw9xH2FPghpUJwrvRNYNtYAwJq3W07tq1jFbHyczBgADJaFaH
         BCXdLglS6kY8wDQbdTbN5sWDEasapgJyv78gDWGEz9fVzWNY0j+8RHBNyl5yDANgzDct
         KHtHfy7L5zKRMjWInZ2Hp10n/SM2e8VxVervBaeuc/vbOtVOz5XoAptRwFbGMH4anx9S
         mqGA==
X-Gm-Message-State: AJIora8DRINIYiAKv38yyKQ3xAh7P/cZMgejYx9+n3vZkslxq/iSeyyN
        xgTtEKigrtPvt3IH7PJKXA==
X-Google-Smtp-Source: AGRyM1sh6iqL6VFnZp1Deu8xXkJM6thegM5ZDmojm43S2jm0iAW6aMBCC36S5AT0zAMshycO/N+rQA==
X-Received: by 2002:a05:6638:1686:b0:33e:9977:2e1f with SMTP id f6-20020a056638168600b0033e99772e1fmr3975605jat.7.1656706894172;
        Fri, 01 Jul 2022 13:21:34 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id y41-20020a02952c000000b00339e1b107d9sm10166587jah.60.2022.07.01.13.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 13:21:33 -0700 (PDT)
Received: (nullmailer pid 1457047 invoked by uid 1000);
        Fri, 01 Jul 2022 20:21:31 -0000
Date:   Fri, 1 Jul 2022 14:21:31 -0600
From:   Rob Herring <robh@kernel.org>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     linux@armlinux.org.uk, hkallweit1@gmail.com, pabeni@redhat.com,
        Madhuri.Sripada@microchip.com, andrew@lunn.ch,
        linux-kernel@vger.kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org, UNGLinuxDriver@microchip.com,
        robh+dt@kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net
Subject: Re: [PATCH v3 net-next 1/2] dt-bindings: net: Updated
 micrel,led-mode for LAN8814 PHY
Message-ID: <20220701202131.GA1456987-robh@kernel.org>
References: <20220701035709.10829-1-Divya.Koppera@microchip.com>
 <20220701035709.10829-2-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701035709.10829-2-Divya.Koppera@microchip.com>
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

On Fri, 01 Jul 2022 09:27:08 +0530, Divya Koppera wrote:
> Enable led-mode configuration for LAN8814 phy
> 
> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> ---
> v2 -> v3:
> - No change
> 
> v1 -> v2:
> - Updated micrel,led-mode property for LAN8814 PHY
> ---
>  Documentation/devicetree/bindings/net/micrel.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
