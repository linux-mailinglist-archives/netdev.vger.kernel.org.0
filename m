Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D939A61A466
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 23:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiKDWlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 18:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiKDWkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 18:40:11 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A731543AFA;
        Fri,  4 Nov 2022 15:39:35 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id l2so3894064qtq.11;
        Fri, 04 Nov 2022 15:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R50+qGHasF9a2tgewRCqbm/yII7klbTbUf0jSIqn1LY=;
        b=JRAQAdY/ZB+Se2w45iAN7NyM++gCPTMmGqbawUMXXZ5sQhaUbr93UU/zBTaPkgoX0b
         ccAcjkN0pMfarYTFISIhIjJS6zTXEFA/ju4GU1cEUn0kkViy5ve9O0Mnm82Gvia5bQdX
         T2IxuVJV0uEjorncVsDC0kPr4eR494RvXS1j5X11LAxwCeKLBtOJy33j/FWL1TS+gvvB
         NyzIJn/Jv252sVwb1CdX9V71mTJ+hiiK/6FPJKvVAtzDa8bT2bkIzqytJkfYuscyYMsl
         1guVxwurkE/re7r9sqfRsH26O9bxeXRGOlmeus8s9c/QEAU84btI+YScV4nFh+NixBPQ
         neBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R50+qGHasF9a2tgewRCqbm/yII7klbTbUf0jSIqn1LY=;
        b=jOchD5/4I3TGdDRnRD+WYHNrLUW4fe7lGgUalec2ZaKQwJ8owz7CzkVZZCOrkj2Ws3
         U/dX57vZBK1vHB0KucWpoyRawBSgOXKIRc5chwHUtIrYh1NGDcso/8qeN6uaDFW9jMf8
         96QrQroqNk+wyLupNRfONNeQ40IHwcEWOCVC2cOd6xAgVf2l5Us3PwUzndtjhHgpCs8K
         pz00HRNm5J4k9wNDcf5b0b4y2nfr97oQaDyJOwfaeAeenk5fHRTfEIOKaCLGmjpgxHpj
         lW66GCejIW8CcxrGdfUa2u4il9oRAhnwjG1DjSLOJfb+lU7f94wEk5s+dTPsdbz1p8/n
         FGtA==
X-Gm-Message-State: ACrzQf07F49J5YHlbMEL1EZ0/K27fI0M1U11m98VFjJrAWF4rZFFhWWj
        HBDFGzeWVgi60tVqQFcdxQM=
X-Google-Smtp-Source: AMsMyM4AigwKtzvchKZMgq+A9Yx5ISeno2IDEjJMpMNcpBxXU4/TQQQO3W1KuhHN7+Y36I4E1Pgz4w==
X-Received: by 2002:a05:622a:450:b0:39d:9a0:3b with SMTP id o16-20020a05622a045000b0039d09a0003bmr30971918qtx.213.1667601574708;
        Fri, 04 Nov 2022 15:39:34 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id fg26-20020a05622a581a00b00399b73d06f0sm419233qtb.38.2022.11.04.15.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 15:39:34 -0700 (PDT)
Message-ID: <028cf7d9-3f47-d849-cc02-e1b852e4d922@gmail.com>
Date:   Fri, 4 Nov 2022 15:39:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v3 2/2] dt-bindings: net: dsa-port: constrain number of
 'reg' in ports
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221102161512.53399-1-krzysztof.kozlowski@linaro.org>
 <20221102161512.53399-2-krzysztof.kozlowski@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221102161512.53399-2-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/22 09:15, Krzysztof Kozlowski wrote:
> 'reg' without any constraints allows multiple items which is not the
> intention in DSA port schema (as physical port is expected to have only
> one address).
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

