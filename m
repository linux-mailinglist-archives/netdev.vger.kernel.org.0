Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E837D57E68B
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 20:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236337AbiGVSbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 14:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235096AbiGVSby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 14:31:54 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44A681485
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 11:31:53 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id m9so6370184ljp.9
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 11:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hrYf+kS/eMHYzQ1cCDYyuj5+w2jPGUuJe7GfAQ3ZFAc=;
        b=YvABktm3E6d/2fWtcKrw990CSH6WCkg7XgxgrPltc+EvNEeDY7qel28BKQZNlwRWm1
         DUkrCYuihV0XGw/eufExSOV0IY7v23Z6Wrfd59cXCSt5YRhrbKKcVbamkVrQphwWog9/
         eo3xuUHDSwDWxo5+XO4Qq9TZTS2LSCVjnOxOhIItb2i8jIboTrKjsUPER8szLIyT+WeV
         05K96+NwGsyhHaZAPy76OoALnNI9a2kBxSAxcF0YThx6JuzMkhxFoMXzSfOijT21XoWC
         2QCzy4sFTOhSuerp2yEi0XvYnGARXwvWzxBmvP9ZhDR9nOYdNkNkJFBi9wdPle8FNLim
         aZ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hrYf+kS/eMHYzQ1cCDYyuj5+w2jPGUuJe7GfAQ3ZFAc=;
        b=7WeUzjQ0xa2xdfPfn9UHzJoG+K4kbzmoZtXuGwCjr4b/9+jMZPlEC2VzAHO0l/zsHq
         u8Qj2L583Rb2nxeqayXDVh7v6Jt7d0ISSWELHhqMpw6hXw9ftj8GgFK/0QNlHnZLLI3S
         v9q2gXRCqn0GGPjLLASiIje3rCXPYefYNSPcYmdtLX3kPj2SD3zxSF/SgoLNXImM+YpS
         entzAv/2Fe/lRluwmDaz4gumZSP+aRy2O9C1rPmXd0YPdp8ReSsnOH8jXFaHog1wnFo2
         QWlucG4eJIJW4vAVIPZP+g5yBeW/UtQK7jFVc0Yo3dyfa4/jPKT4qzwX4tZuDgnDxNzN
         yNXQ==
X-Gm-Message-State: AJIora8hIy0cbfwijsaFMofVHNPzir3BVs+AhC5wTk5sXZMun+Jj0HPm
        BdBMUfRDLI0djXAVOdkDuqicKA==
X-Google-Smtp-Source: AGRyM1tsEhq4uRAMKypq9Eg45aRVXJYgskfWdEsALlbCtw03xaoSeghNBTZkggCr9SYq92KU6YMHuw==
X-Received: by 2002:a2e:b7c7:0:b0:25d:d901:c2af with SMTP id p7-20020a2eb7c7000000b0025dd901c2afmr450469ljo.244.1658514711970;
        Fri, 22 Jul 2022 11:31:51 -0700 (PDT)
Received: from [192.168.10.173] (93.81-167-86.customer.lyse.net. [81.167.86.93])
        by smtp.gmail.com with ESMTPSA id j2-20020a056512344200b0047f84ec0ac0sm1189905lfr.69.2022.07.22.11.31.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 11:31:51 -0700 (PDT)
Message-ID: <1f51fa3a-8f51-a873-d0f5-bc945c3bbf22@linaro.org>
Date:   Fri, 22 Jul 2022 20:31:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 1/3] dt-bindings: net: cdns,macb: Add versal compatible
 string
Content-Language: en-US
To:     Harini Katakam <harini.katakam@xilinx.com>,
        nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        harini.katakam@amd.com, devicetree@vger.kernel.org,
        radhey.shyam.pandey@xilinx.com
References: <20220722110330.13257-1-harini.katakam@xilinx.com>
 <20220722110330.13257-2-harini.katakam@xilinx.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220722110330.13257-2-harini.katakam@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/07/2022 13:03, Harini Katakam wrote:
> From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> 
> Add versal compatible string.


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
