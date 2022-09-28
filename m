Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D085EDD68
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 15:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbiI1NCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 09:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbiI1NCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 09:02:20 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C9482742;
        Wed, 28 Sep 2022 06:02:19 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 37358660036A;
        Wed, 28 Sep 2022 14:02:17 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1664370138;
        bh=y5PLlxgX3Iexv58efRMWa8bC+TbN2PS43te+OORk4YI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mgHAZ/IiDaV02YnIl52F9VGR0hRBEtXBCwXUjNOhirIV/mr5QLUrBE+2O7A1AM6EU
         8mTETUWiD3mAblou31Lwqj2LaAE75G3yUjU424cym73Qxfqmq3sx3+5I9BZQ6iDtHB
         ZzB1u6f15pGBqPYPNDo0fehQeRIA9YCfEzdNyObHaVP+yqyuGksdJJtNJDpIPm+TtO
         +lpd/09rf5e/DEdcKN2nHq3g8vEUUPYJ7e80JLrcC9SqstWJRyiWF6D8fc5bgEi9Hu
         BZoq/41lF68xfQosN0vqCRIV0cTLB1sEJFEufmXAJAXGQex7vkXtGbza2cMefP2Dw4
         aV5+7EeZ53RPw==
Message-ID: <9c5eee7a-ddf2-b251-72c8-0792f46b24ec@collabora.com>
Date:   Wed, 28 Sep 2022 15:02:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [resend PATCH v6 2/4] dt-bindings: net: snps,dwmac: add new
 property snps,clk-csr
Content-Language: en-US
To:     Jianguo Zhang <jianguo.zhang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
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
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
References: <20220928092308.26019-1-jianguo.zhang@mediatek.com>
 <20220928092308.26019-3-jianguo.zhang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20220928092308.26019-3-jianguo.zhang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 28/09/22 11:23, Jianguo Zhang ha scritto:
> Add description for new property snps,clk-csr in binding file
> 
> Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


