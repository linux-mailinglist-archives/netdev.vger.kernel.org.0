Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF16B5BF867
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 09:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiIUH6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 03:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbiIUH6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 03:58:10 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC3386705;
        Wed, 21 Sep 2022 00:58:05 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 773956601F3F;
        Wed, 21 Sep 2022 08:58:03 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1663747084;
        bh=0xsbhBJNnes4Z0TBPmMmlIFfmkNNIidigNEkveeWtaY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=PyVZhdv9kT8W+gGErFJHisjYNIFDGZNMw7siSAAwE7VmBgT2dYiSyyBCVvdd2VKV9
         mmogZgBDUWpn+09igSMhfwh7CO9oPVuJwGOE3jbYX/uvfVYB8ZlhRzU5wrlGpU5fLj
         wsm1VkHYkK2f+shmF8UilbhBmCWFwdPJg5iowBV4ouNVU+dbfTC13+pki+x/SoKg2e
         mqviDtaSl+gYXESkwAA/y+w6eDyLfsWefWiBIZYSYH2Elm0s6LnKuroKqWfzA8W+yi
         M3gGzDdakgQPTMo2SGorY2QTtbUFTxB8NMgRzkpN8VdJmw8G8dkMt+264CcvyAwC0e
         WcG6Bg6cZIJRw==
Message-ID: <17847e6b-8954-c9b7-d5e0-99dbdf5146cf@collabora.com>
Date:   Wed, 21 Sep 2022 09:58:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v3 1/2] dt-bindings: net: mediatek-dwmac: add support for
 mt8188
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
References: <20220921070721.19516-1-jianguo.zhang@mediatek.com>
 <20220921070721.19516-2-jianguo.zhang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20220921070721.19516-2-jianguo.zhang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 21/09/22 09:07, Jianguo Zhang ha scritto:
> Add binding document for the ethernet on mt8188
> 
> Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


