Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B480260E362
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbiJZOcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233731AbiJZOc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:32:29 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C68FF25F
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:32:28 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id h10so11566369qvq.7
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KsmuzRKKaUB6WHX3gUEBWTikPz5Qncyumloh3N+8ABA=;
        b=M5TMAE5sy7A990nf/BNmAXdCy+OZXswI3aLNx44wSvxa2Y60r0ELrzDm3S9EHsmdWV
         EHNqy45ATprsi1/E6kyz6IFjn7NnZaFYRy8LKapINhJ53iEZWSIXB5rPzJIlURwIZA1u
         I+PtqFrvah0JQNLCBCU3HhfsTgoz3GfUIyFGN02loxIwOMNaR9oNihA0A4wArJCc+FRw
         jXx1ie+3Ig8MvAevrS7w/qbEKHBp/N+mOWBs5bXxWuGgN/YJh+1w4/rYGJ1qdpk+g+bl
         TLY7Yx3dGGqfNZgu2uDO9QLVIQ0ItizjvZlcRoePz1Bz1MSQd3bn7xzgxo2Hh6/SCk1E
         IKzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KsmuzRKKaUB6WHX3gUEBWTikPz5Qncyumloh3N+8ABA=;
        b=b718NB4t9dgBMvZMuPIcTQ6BctaqgBrvQU/jxeO+3MqNngZAPH4Mox9PnAmIcnkAae
         VPkLROzjM6F7pqcEe9w9U10xe91J6pYX1Z/xh+J8kQlLQWYjht9JQNb6+0thwogjwwpx
         kry8LLi0CcqKAj0hSBqcUvCDlr7RTViElxtgqwpU+lZT5ya1IrFZK5dpJY36fCqaRF8U
         hFrgPViqlf+NfgbqF+6sCPlTdJOm/9oukEXfrvJGT1hMO+o1e0D2uvam6pDHKQIVL/DO
         Pg8lIjpg+nNsuSKSwa14rxPyeXqhqLgfruVUUsVCHYs1yk2ydbfxBLD42ULiK7w5r/PT
         exmw==
X-Gm-Message-State: ACrzQf3DpoH02PLWsSy6KuEdLwBp21crmFJnEsEhvVkA12Z293iwN3+u
        Dg2GsxkWQed+jFmfqxGnZy2n8byu5yAuIA==
X-Google-Smtp-Source: AMsMyM6qnlgeQVjneuzws0s2FvSzmE2JFy9e4/CGKLWbwVCK6VTNr/ZP7ZvzbpLEUl6qkHxFmQyavw==
X-Received: by 2002:ad4:5ca7:0:b0:4bb:97ea:27b5 with SMTP id q7-20020ad45ca7000000b004bb97ea27b5mr1910488qvh.104.1666794747320;
        Wed, 26 Oct 2022 07:32:27 -0700 (PDT)
Received: from [192.168.1.11] ([64.57.193.93])
        by smtp.gmail.com with ESMTPSA id cj20-20020a05622a259400b0039cc665d60fsm3202443qtb.64.2022.10.26.07.32.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 07:32:26 -0700 (PDT)
Message-ID: <be1984de-b69e-3124-3b80-e977578e06c4@linaro.org>
Date:   Wed, 26 Oct 2022 10:32:24 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 1/1] dt-bindings: net: snps,dwmac: Document queue config
 subnodes
Content-Language: en-US
To:     Sebastian Reichel <sebastian.reichel@collabora.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com
References: <20221021171055.85888-1-sebastian.reichel@collabora.com>
 <761d6ae2-e779-2a4b-a735-960c716c3024@linaro.org>
 <20221024222850.5zq426cnn75twmvn@mercury.elektranox.org>
 <aa146042-2130-9fc3-adcd-c6d701084b4a@linaro.org>
 <20221025141732.z65kswaptgeuz2cl@mercury.elektranox.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221025141732.z65kswaptgeuz2cl@mercury.elektranox.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/10/2022 10:17, Sebastian Reichel wrote:
> Hi,
> 
> On Mon, Oct 24, 2022 at 07:28:29PM -0400, Krzysztof Kozlowski wrote:
>> Old binding did not document "tx-queues-config". Old binding had
>> "snps,mtl-tx-config" which was a phandle, so this is an ABI break of
>> bindings.
>>
>> You are changing the binding - adding new properties.
> 
> The new binding still has the phandle. The only thing I changed is
> explicitly allowing the referenced node to be a subnode of the dwmac
> node. This is 100% compatible, since the binding does not specify
> where the referenced node should be. Only the example suggested it
> could be next to the ethernet node. But changing any properties in
> the config node means a ABI break requiring code changes.
> 
> Note, that right now 4/7 devicetrees with snps,mtl-tx-config already
> follow the scheme I documented. The other 3 have the queue config
> below the root node like the current example:
> 
> has the queues config in /:
>  * arch/arm/boot/dts/artpec6.dtsi
>  * arch/arm64/boot/dts/mediatek/mt2712e.dtsi
>  * arch/arm64/boot/dts/qcom/sa8155p-adp.dts
> 
> has the queues config in the ethernet node:
>  * arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi
>  * arch/arm64/boot/dts/freescale/imx8mp-evk.dts
>  * arch/arm64/boot/dts/rockchip/rk3568.dtsi
>  * arch/arm64/boot/dts/rockchip/rk356x.dtsi
> 
> After my change both are considered valid. Anyways I'm doing this
> for rk3588 and planned to follow the subnode style. But if I have
> to fully fix this mess I will just put the queue config to the
> root node instead and let somebody else figure this out.

Yeah, let it be.

Best regards,
Krzysztof

