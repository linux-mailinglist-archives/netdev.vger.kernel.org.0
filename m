Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A2B5EDD64
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 15:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbiI1NCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 09:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbiI1NBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 09:01:45 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031429F0F2;
        Wed, 28 Sep 2022 06:01:42 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 7EEB56602288;
        Wed, 28 Sep 2022 14:01:39 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1664370100;
        bh=ASSVLLMUq+ZRt7bCotXGkZism/xFGgXPWANaZ8iChG4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=jS9D2twkkPXrFJF3UUgu5SbRIKBpOWIsBunhzZtGpzGiqjqawF0318/xw8w6Bmj2Q
         sWAwR3d+8Tw0pslFoyLvSeg/PE/K8w0a+Ls+KJaQjiBDurJc7tCAdnBK7FahHwWMYO
         LLetMT8ysz81Yx84Z3y7rWLIqhBshZy9/Zbv9HMBHgYPioQsoxdC9AXZw5uvZoL+mw
         k5pZbwu4myU6dD/8wgHWUICYiyDd+q6FNotMNjgY6qGDdmr3kgbd7qL+3+a7yPCxZk
         +peD98VDUULl2x16wVwUOpXMxO9UJ+mLN38DialFlw9U2oEMvlensFLSMEMtlWI+eN
         0L6fZc9NYmU2g==
Message-ID: <9fdec950-065f-201a-4de3-823beba5d792@collabora.com>
Date:   Wed, 28 Sep 2022 15:01:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [resend PATCH v6 4/4] net: stmmac: add a parse for new property
 'snps,clk-csr'
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
        linux-mediatek@lists.infradead.org
References: <20220928092308.26019-1-jianguo.zhang@mediatek.com>
 <20220928092308.26019-5-jianguo.zhang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20220928092308.26019-5-jianguo.zhang@mediatek.com>
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
> Parse new property 'snps,clk-csr' firstly because the new property
> is documented in binding file, if failed, fall back to old property
> 'clk_csr' for legacy case
> 
> Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


