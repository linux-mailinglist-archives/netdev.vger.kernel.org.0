Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408F36940DC
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjBMJXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjBMJXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:23:44 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84726E9C
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:23:42 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id o18so11418163wrj.3
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cHoRZcfHnIFM/oC3aOpK3TRch8E+QyoPOEKfxdwkBv8=;
        b=KoDMYqGadRN7PsbcW9GwxNijCYtY/+rQK2zDk7nJQcE1QA2dP049DBiOqVnnig+9Cy
         +FveKLRo76vu/dhorjmsfqKskxbu2Vx8oekRd72gpDbZYSPXJ9o2WnU8OmSbb0+aDdsc
         IRP2L+1znjb/SUtUD4X6zbxGyYft3Fc43vZ0TlNunnuCeAuKhlrlCw2Ihgsi7H632u5C
         4qDd8ULILsIncDdioChS4WYvKKyt0OFfHWp8OtAIOHdMl6TQtEbm6P+t1lF87aOHiwss
         VPJdeIlDtY0tRvCBShC8O0ufhE5n0W7LStEO8OCgE5zfzMxvOx8fekOTwFqXMFc0+KPO
         +2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cHoRZcfHnIFM/oC3aOpK3TRch8E+QyoPOEKfxdwkBv8=;
        b=G2x2xFllj/KqWh4LjdwPexP/wv/j77dOiPLeKSZMLaj/lFRqx7TlYh24XjBPPLNqQ1
         y5EK/2vuZ/mjlV7hPN2SILZX/QkGgtPf0Qhh+BF+ap+2VRu8pYvczE+6PRJ8ftLLvATh
         +6odyBg8BYYhduCZJ37uDTY9ybTlg2qLsjEFGw3gGDDfyxygmWguX2ftyeZyWVX8gj6r
         cDaGXP6s/2gEdB2CSjjF8miwqel+Q+w9WbbX6InAbXIUEIJoE7BdgbMaVw/1NOE7XT5r
         MnBW+7FalitRFH3EVUU/GrIn1R5J8C/UMiO3VxdZso8qwp11Actcv0kJtwU9eP3nsZqD
         cTbg==
X-Gm-Message-State: AO0yUKWc2bRJGYLATCRqck2D7QIeWuJWZ3tovav40vJ32XY0BRkMj2Ni
        oXAWa/rTeLSpgJGFYnSKTHKz4g==
X-Google-Smtp-Source: AK7set+5J2AHVY7RTQkkXF+Kq1camPxBbxMZhhHAmk/fwsI1GQPGvSOL9sQseWRnR6eKLc1S3b1XlA==
X-Received: by 2002:adf:e442:0:b0:2c5:4fb2:80a8 with SMTP id t2-20020adfe442000000b002c54fb280a8mr5675765wrm.12.1676280221262;
        Mon, 13 Feb 2023 01:23:41 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id p24-20020a05600c1d9800b003dd1bd0b915sm16209935wms.22.2023.02.13.01.23.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 01:23:40 -0800 (PST)
Message-ID: <44d672f9-2a79-4291-9ff8-7b3a48e61c16@linaro.org>
Date:   Mon, 13 Feb 2023 10:23:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 06/12] dt-bindings: mfd: syscon: Add StarFive JH7100
 sysmain compatible
Content-Language: en-US
To:     Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
        Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-7-cristian.ciocaltea@collabora.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230211031821.976408-7-cristian.ciocaltea@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/02/2023 04:18, Cristian Ciocaltea wrote:
> From: Emil Renner Berthing <kernel@esmil.dk>
> 
> Document StarFive JH7100 SoC compatible for sysmain registers.
> 


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

