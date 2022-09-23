Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C535E7685
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 11:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiIWJKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 05:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiIWJKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 05:10:54 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2EB127570;
        Fri, 23 Sep 2022 02:10:53 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 64B1C6602038;
        Fri, 23 Sep 2022 10:10:51 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1663924252;
        bh=5dQSl61o3/d45Zc6JtCNy5byEWYtp/sXtn/FPR8mee0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=TcjIIpAmezqk2QInoHN7/joAu1zk07/Kfi7cH9ft9WKzxDKDSNEldxLKkANAX6gGy
         HAeHai4DWD0fqncMVAK1e3wiBRq2xtkmBGERLqjeGmOyFFn2TisGGgqCCuIFpLJRDu
         1i62xgUq8U/9aDBXM4sYqRWTb+smoi/nXRFqVTZmNgaD4Ra1969DyhAckqLVWb9Uvj
         3MRMA/JRsEEwGP6M0saTXuzRpkbM6g91Q37wHAtjLF+eAgMp2blQalZvvPRWvO8/Cw
         Bs+WK5Lq5/QhU4m4l8Kzj191h86d8vUG/fGPYsFnq20sxUB+XG/NAzs7whejtpteYg
         3QH9MNcbetMIg==
Message-ID: <e0fa3ddf-575d-9e25-73d8-e0858782b73f@collabora.com>
Date:   Fri, 23 Sep 2022 11:10:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v5 4/4] net: stmmac: Update the name of property 'clk_csr'
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
References: <20220923052828.16581-1-jianguo.zhang@mediatek.com>
 <20220923052828.16581-5-jianguo.zhang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20220923052828.16581-5-jianguo.zhang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 23/09/22 07:28, Jianguo Zhang ha scritto:
> Update the name of property 'clk_csr' as 'snps,clk-csr' to align with
> the property name in the binding file.
> 
> Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>
> ---
>   drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> index 9f5cac4000da..18f9952d667f 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> @@ -444,7 +444,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
>   	 * or get clk_csr from device tree.
>   	 */
>   	plat->clk_csr = -1;
> -	of_property_read_u32(np, "clk_csr", &plat->clk_csr);
> +	of_property_read_u32(np, "snps,clk-csr", &plat->clk_csr);

This is going to break MT2712e on old devicetrees.

The right way of doing that is to check the return value of of_property_read_u32()
for "snps,clk-csr": if the property is not found, fall back to the old "clk_csr".

Regards,
Angelo

>   
>   	/* "snps,phy-addr" is not a standard property. Mark it as deprecated
>   	 * and warn of its use. Remove this when phy node support is added.


