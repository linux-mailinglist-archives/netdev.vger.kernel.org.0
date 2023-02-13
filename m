Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0A9694124
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjBMJaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbjBMJ3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:29:38 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CC4199F5
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:27:41 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id az4-20020a05600c600400b003dff767a1f1so8475076wmb.2
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nYh18SRYWwEYT43tGPEGOedVgwnc/ZspcfJBm/Zqmek=;
        b=AKjeUMptruiqhGqwkQ5nHL5+lyE+zu52lmYtfXa5oRKvpSgDnmquHytkHfyWkATZK6
         P+ofaXVgQqlyfPI1iNH3JNSFSwMayGi/2EsRFdVRCNrsGLdBNCKHT9KOCF0sjFVZ7rVX
         zLBnj9KXTsvSqan5Dk9kjiXkerhXvVyW0dXjQVsHR5+S1Vfz0F7cSqG2TmfPVTxm+gpz
         vLs6RHE4dd25pDc52obVhfsPvypjEMQnXMv9VYbiWOdrzjifhTtottn/Uam/oYlBSk3a
         tCUrgfUDq4uSXv1+pZjndkwyBtyYm9nNy5+7bGVrFg4qhm1zV83ydSkVP2RGecBR8Ug6
         5+qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nYh18SRYWwEYT43tGPEGOedVgwnc/ZspcfJBm/Zqmek=;
        b=DL6gh/6PngGgJ3RHsAk/P/LWHRzMDeG4Ev1XZNz13ppXkcafe1J0Qi4Qq9sS3SM5vw
         EgSV5kkjo245rtSz7WkhkpNRu3zxiZNLW+Gn5uD6vtT2+6dQfYxskpRVnrTCw35+Oa/J
         eNIZfpISdzpRK5SdbM8rE3qQGvETZNNkLdCwXkNOHmTyWeGabeoQ4x4nTD1GMFu3s07Z
         n/1zNLgkhwPOn+LMEo9HDR/utH0EAtPgUAz0/HzNBeUUZaT5M5zeggx63eeMAiNZRAB+
         /9cag6Cc79CCf5sR8YW6rA28ODLXCPlSJ2XuESAUeEDsg+Pd59oSJAb9fm1Kz0E1iUWm
         xDuA==
X-Gm-Message-State: AO0yUKXF4B1ulc4psA4bvGVKBBfCplDq9Yh4NAQ4aYFh6jIjwcwklXZ5
        rgGz/W+ONwESjASWARryFWW9iA==
X-Google-Smtp-Source: AK7set9WbqP7fVCp5aNzouWbxo5iZbnRURawxE90BjtXUD6SO1P7jgEKPf81opQ2QS1yr8C6vyNxIQ==
X-Received: by 2002:a05:600c:4a8a:b0:3dc:54e9:dfd7 with SMTP id b10-20020a05600c4a8a00b003dc54e9dfd7mr18140208wmp.25.1676280413915;
        Mon, 13 Feb 2023 01:26:53 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id j37-20020a05600c1c2500b003daf6e3bc2fsm23780634wms.1.2023.02.13.01.26.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 01:26:53 -0800 (PST)
Message-ID: <34d5e299-3b4b-d176-0010-a9af1220f2e3@linaro.org>
Date:   Mon, 13 Feb 2023 10:26:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 11/12] riscv: dts: starfive: jh7100: Add sysmain and gmac
 DT nodes
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
 <20230211031821.976408-12-cristian.ciocaltea@collabora.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230211031821.976408-12-cristian.ciocaltea@collabora.com>
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
> Provide the sysmain and gmac DT nodes supporting the DWMAC found on the
> StarFive JH7100 SoC.
> 
> Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
> ---
>  arch/riscv/boot/dts/starfive/jh7100.dtsi | 38 ++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/arch/riscv/boot/dts/starfive/jh7100.dtsi b/arch/riscv/boot/dts/starfive/jh7100.dtsi
> index 88f91bc5753b..0918af7b6eb0 100644
> --- a/arch/riscv/boot/dts/starfive/jh7100.dtsi
> +++ b/arch/riscv/boot/dts/starfive/jh7100.dtsi
> @@ -164,6 +164,44 @@ rstgen: reset-controller@11840000 {
>  			#reset-cells = <1>;
>  		};
>  
> +		sysmain: syscon@11850000 {
> +			compatible = "starfive,jh7100-sysmain", "syscon";
> +			reg = <0x0 0x11850000 0x0 0x10000>;
> +		};
> +
> +		gmac: ethernet@10020000 {

Aren't the nodes ordered by address?

Best regards,
Krzysztof

