Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D4B58294B
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 17:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbiG0PHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 11:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbiG0PHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 11:07:33 -0400
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C36A419BC;
        Wed, 27 Jul 2022 08:07:32 -0700 (PDT)
Received: by mail-io1-f47.google.com with SMTP id h145so13758462iof.9;
        Wed, 27 Jul 2022 08:07:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8MYU1C1Gf7UHC58BS9Fb3z6GOWxr/TCVQxg2HCYcGTU=;
        b=VotZ3zuhbwCMvl+lJtErSA1WTcaE4x+plHLfkae9GSoc6fBRXEDzxC5yaeM4wfZLri
         R5Q/aRbM7MUFMejQ7XrSyfkmtWp57u5SRjvTvz/3jfsLoYEhvprYSW7A0n1fYL3paZgq
         mcXpAKGnNkdVpgHab8UQDoHaj19hh5Akb+2gQGnZlbSHfhK3Sbulx7Ps+ERhrjaWKJ6r
         5ysROZn1RE4/EGuTvPs+EuxbcwNF1i/UCdFkHXxeI/xRyKMPifVBg4A1nM84fa5SsLvt
         ntArobXZKH5buL8C7gBXoNXGOkcuZnDokZoh6dOW7Qsteiw+hBYK4iYUqI/7NnF7VfRG
         6IZg==
X-Gm-Message-State: AJIora8iHkArCo1jiAUuFJsBCe5t0JQf0UJYHTeZB5nEvD3RXizEJctR
        2EZ39sKOlpNkaR1TkxFkCw==
X-Google-Smtp-Source: AGRyM1uRqxS4Ktkk2etja0lWdyVk5P9noSv1jXPVFo9LhOd80OOrtkTskqsYOl8AwnE/bIN8/R1nLA==
X-Received: by 2002:a05:6638:2410:b0:341:5daa:2bc9 with SMTP id z16-20020a056638241000b003415daa2bc9mr9290968jat.306.1658934451793;
        Wed, 27 Jul 2022 08:07:31 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id l11-20020a026a0b000000b0032b3a7817acsm7940084jac.112.2022.07.27.08.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 08:07:31 -0700 (PDT)
Received: (nullmailer pid 2669469 invoked by uid 1000);
        Wed, 27 Jul 2022 15:07:29 -0000
Date:   Wed, 27 Jul 2022 09:07:29 -0600
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH] dt-bindings: net: hirschmann,hellcreek: use absolute
 path to other schema
Message-ID: <20220727150729.GA2669407-robh@kernel.org>
References: <20220726115650.100726-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726115650.100726-1-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jul 2022 13:56:50 +0200, Krzysztof Kozlowski wrote:
> Absolute path to other DT schema is preferred over relative one.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  .../devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml       | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
