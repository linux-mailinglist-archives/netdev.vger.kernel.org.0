Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9198678A67
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 23:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbjAWWKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 17:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232236AbjAWWKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 17:10:54 -0500
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8FE11157;
        Mon, 23 Jan 2023 14:10:34 -0800 (PST)
Received: by mail-oi1-f181.google.com with SMTP id r132so11669374oif.10;
        Mon, 23 Jan 2023 14:10:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jqf3ykpr6ToMSBFuuB2WWuFXP7qmuhxvweAK3SLJC5g=;
        b=NfdRjdVyrMtMsoS5Uq4J8MjSPdppga4cbFX/wwNtVSklN6RmjJDYxsv/f/gYzPAHkk
         CzJbcUoL9dggCvIHN9TT8lo1WaPlSEtwfBUTcKTiCuZ16M7x59gspdJAZ92IyaCKWOnW
         2C5U5St4V5hmBTCMpL+6nAfk7aLznPry3s5jqpCmUZPwRkxEbDgBsxaVvj9i7Q8s2NXi
         T++ag8kBlqlGzpQN2jcqjOLmmgrWqrOWeEc8Zg7n3smadLK3NqaLDSsOWplDZOAAVsG0
         cdmssQF6fiCpyh/2K2bMkcDK0yTUwIHTArsSXZ/qG1VAPBnmyG542patZp7ObGBwiB0K
         pJwA==
X-Gm-Message-State: AFqh2krN1p1v4oWA5Rw3rtRUbg7FmiKSMJDtZd06A3dWbeMs+yt1tZR5
        Lvz7AleRT4YDGGh5X3RDXA==
X-Google-Smtp-Source: AMrXdXuz4zNklvw7KV5YArQenHBZ/SuWOxF/VO/FYbNyYaA8GnyfBy2x4rnMWSYUpPFvIHix28z1eg==
X-Received: by 2002:a54:4009:0:b0:35e:80f2:65cd with SMTP id x9-20020a544009000000b0035e80f265cdmr12307769oie.35.1674511803061;
        Mon, 23 Jan 2023 14:10:03 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id r124-20020aca4482000000b0036eb408a81fsm249833oia.24.2023.01.23.14.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 14:10:02 -0800 (PST)
Received: (nullmailer pid 2727149 invoked by uid 1000);
        Mon, 23 Jan 2023 22:10:02 -0000
Date:   Mon, 23 Jan 2023 16:10:02 -0600
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] dt-bindings: net: asix,ax88796c: allow SPI peripheral
 properties
Message-ID: <167451180153.2727091.1942850731444590312.robh@kernel.org>
References: <20230120144329.305655-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120144329.305655-1-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 20 Jan 2023 15:43:29 +0100, Krzysztof Kozlowski wrote:
> The AX88796C device node on SPI bus can use SPI peripheral properties in
> certain configurations:
> 
>   exynos3250-artik5-eval.dtb: ethernet@0: 'controller-data' does not match any of the regexes: 'pinctrl-[0-9]+'
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  Documentation/devicetree/bindings/net/asix,ax88796c.yaml | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
