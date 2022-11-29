Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B6C63BC31
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiK2IyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiK2IyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:54:04 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AF743AF5
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:53:52 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id j16so21385277lfe.12
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/392GykBtHnWPhSp8IdLCn51RY5siGcKVRp0TZIw73Y=;
        b=AfYOt9xgm8N8sshzqyj5GnPwFJ+Ud+2wHuhE1yU3oqhrEDFnCD4wJ2lbOzn4uBuEqA
         MmcMBM/HS258xdVZOPmlsr5Uas2/bX4R7UcVjJFhEweaWCbGW0YGXzQizUo8Y/N9EluR
         m8vQaDohkKsTnOb2yYTpBzNB9LwCda3WIj/pzf1uZyzvjCJWWHazyjFIAc2dl8otHUre
         +TwGaKsmEzid8rfKECqH9ajtV48SGwvPjZ9Amehm/jOcLDuvTXO63YEqq96IfoZjvgoc
         I+gdbV5hF9a31nqhycfBvK+iWVglwEoi459sE6Z1PNunrHNbIBL0PwPLup+s6WQK1nAg
         6kog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/392GykBtHnWPhSp8IdLCn51RY5siGcKVRp0TZIw73Y=;
        b=Pu1PEQxeKe4d7FzmqucoU3Orhv8rsQ1adPpvhBiEyo3IlHDd/Cp04pmUiucGfjyDyD
         kwyzSJ1rTyBoag9rEufkCTQBdeLGK79YLys5OBBWtwdVZnYfofcALyXdgYv4TUE1t7Nt
         VHXc9VY09ZjuyZvO7aoVNkc4FKpN8JsY0rGjgRLoYCGcZLs9MOK29rEw0fvc0Rvo5PBc
         /1tZsGe1RRnXfVDXf7YWUNOEkBJB9813u6C9eOHw5CmMLmT/3j1mZ6h5EzP6iyScbyb3
         c1i//bO1XobSrPwNObYIU/QuqeNgVzimFP9cmujw+oDT42E2v992CVv97G26kJvnKSng
         +oXQ==
X-Gm-Message-State: ANoB5pmgUrPYCCv+F+scabmOW4qTkdTZR5BKvS44FPgNh7AQedbjY8+1
        M2dJU1eXa6EK/elsdydQsTNObg==
X-Google-Smtp-Source: AA0mqf6qdim8gakdaimBGD+ZKNfFkTChiA2i2Pgz4m5bIeVxjSENpVtYCe5fSjJHTQfXRwe9Xutn2A==
X-Received: by 2002:a05:6512:3703:b0:4a2:22cf:f44d with SMTP id z3-20020a056512370300b004a222cff44dmr13149775lfr.118.1669712030458;
        Tue, 29 Nov 2022 00:53:50 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id c13-20020a056512324d00b004b40f2e25d3sm2133465lfr.122.2022.11.29.00.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Nov 2022 00:53:50 -0800 (PST)
Message-ID: <e4676089-7ce2-e123-4e2a-a7d8835e9118@linaro.org>
Date:   Tue, 29 Nov 2022 09:53:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 2/2] ethernet: stmicro: stmmac: Add SGMII/QSGMII support
 for RK3568
Content-Language: en-US
To:     Chukun Pan <amadeus@jmu.edu.cn>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Wu <david.wu@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20221129072714.22880-1-amadeus@jmu.edu.cn>
 <20221129072714.22880-2-amadeus@jmu.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221129072714.22880-2-amadeus@jmu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/11/2022 08:27, Chukun Pan wrote:
> From: David Wu <david.wu@rock-chips.com>
> 
> The gmac of RK3568 supports RGMII/SGMII/QSGMII interface.
> This patch adds the remaining SGMII/QSGMII support.

Do not use "This commit/patch".
https://elixir.bootlin.com/linux/v5.17.1/source/Documentation/process/submitting-patches.rst#L95

> 
> Run-tested-on: Ariaboard Photonicat (GMAC0 SGMII)
> 
> Signed-off-by: David Wu <david.wu@rock-chips.com>
> [rebase, rewrite commit message]
> Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
> ---
>  .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 210 +++++++++++++++++-
>  1 file changed, 207 insertions(+), 3 deletions(-)
> 

>  
> -static int phy_power_on(struct rk_priv_data *bsp_priv, bool enable)
> +static int rk_gmac_phy_power_on(struct rk_priv_data *bsp_priv, bool enable)
>  {
>  	struct regulator *ldo = bsp_priv->regulator;
>  	int ret;
> @@ -1728,6 +1909,18 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
>  							"rockchip,grf");
>  	bsp_priv->php_grf = syscon_regmap_lookup_by_phandle(dev->of_node,
>  							    "rockchip,php-grf");
> +	bsp_priv->xpcs = syscon_regmap_lookup_by_phandle(dev->of_node,
> +							 "rockchip,xpcs");
> +	if (!IS_ERR(bsp_priv->xpcs)) {
> +		struct phy *comphy;
> +
> +		comphy = devm_of_phy_get(&pdev->dev, dev->of_node, NULL);

So instead of having PHY driver, you added a syscon and implemented PHY
driver here. No. Make a proper PHY driver.

Best regards,
Krzysztof

