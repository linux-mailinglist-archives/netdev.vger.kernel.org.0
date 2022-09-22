Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1E75E6676
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 17:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiIVPHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 11:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbiIVPHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 11:07:37 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A35FDE0DD
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 08:07:36 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id u18so15154095lfo.8
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 08:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=AICgMCTu4ugKZVgKKYZSCEgyNXOHBsTus/rL4+rxADE=;
        b=V6OmMtcM8HwjnmW517gvagdimCQzKh4oEk+jCZREpCpQaMRh+CUYlJnjHhWQjY+sn6
         O2EMQ4TmRPc0YWA2AXrfK9EAIppOKDmxGDrlHPoDNfxJVW3XtHnP0Fgo5W/reRLAdYHm
         UVYMEVijD6WYE+JDTgZ0vUoZrmyKJTJtPlgAIrAp/2bsvx+1/X6ph9K33pGARnN0DkAP
         AgfZpohHy0hyLAk3+mnfVrclwPJDWSjxwZWLrJM9tgAB6aNIiSgHd7ef4jFxWuZMDLPK
         KNeogYycbDYEqtFUykDyC8n5Xxzcz1p0neVIj97isWerTZuHph+kEpakzCtG+d2YcUpa
         pKIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=AICgMCTu4ugKZVgKKYZSCEgyNXOHBsTus/rL4+rxADE=;
        b=Nqo6+f/n3us6cMP5ZfdQgyakVlPXxgWme3k21+h6fO8ATwp/fSh+HxWNXZoAHBIsyl
         PnneFCf0uPFohBI8VK1/PLZgSojRJIUkTDi1WoPRXwOFosr1fuAwb43Mu/U6ps3dFsuy
         Pauxnz2qXJZAJr7La8P4C1oEU35JRRnnWPEWhpj/pKcfhVgSZObCbK17r+jPa9+Ae3fF
         vHPFurn9f8dYTapJ4Ro14WxyW315niGezBmwBqjkAlrr078oZ4B2cDoHTPGrItzDHoHs
         4nA01dhLSVVgl9t2EDWIrWHW2ZDgyRvIK/gj6JX2ZIntnS4ZGygXO0/p1KcnVs1Kcp8A
         ifiQ==
X-Gm-Message-State: ACrzQf1/UrTuHZ/UnFlIHD8QrT61fxOMA3oFdzBTS4kCrU3cj6pW9GXx
        DZpswLdXpaKbT0rRSzp3roh75g==
X-Google-Smtp-Source: AMsMyM5wWu4phY9miXzBVbKKyNmCh/6w2BSelex3t5iKGlg/9o62Y81D5nF1RPEPAveTSBkz6dR4Ww==
X-Received: by 2002:ac2:4422:0:b0:49f:5c95:9525 with SMTP id w2-20020ac24422000000b0049f5c959525mr1506912lfl.1.1663859254520;
        Thu, 22 Sep 2022 08:07:34 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id u6-20020a05651220c600b0049771081b10sm986478lfr.31.2022.09.22.08.07.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 08:07:33 -0700 (PDT)
Message-ID: <04b9e5ef-f3c7-3400-f9df-2f585a084c5d@linaro.org>
Date:   Thu, 22 Sep 2022 17:07:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [resend PATCH v4 2/2] dt-bindings: net: snps,dwmac: add clk_csr
 property
Content-Language: en-US
To:     Jianguo Zhang <jianguo.zhang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Christophe Roullier <christophe.roullier@st.com>
References: <20220922092743.22824-1-jianguo.zhang@mediatek.com>
 <20220922092743.22824-3-jianguo.zhang@mediatek.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220922092743.22824-3-jianguo.zhang@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/09/2022 11:27, Jianguo Zhang wrote:
> The clk_csr property is parsed in driver for generating MDC clock
> with correct frequency. A warning('clk_csr' was unexpeted) is reported
> when runing 'make_dtbs_check' because the clk_csr property
> has been not documented in the binding file.
> 

You did not describe the case, but apparently this came with
81311c03ab4d ("net: ethernet: stmmac: add management of clk_csr
property") which never brought the bindings change.

Therefore the property was never part of bindings documentation and
bringing them via driver is not the correct process. It bypasses the
review and such bypass cannot be an argument to bring the property to
bindings. It's not how new properties can be added.

Therefore I don't agree. Please make it a property matching bindings, so
vendor prefix, no underscores in node names.

Driver and DTS need updates.

Best regards,
Krzysztof

