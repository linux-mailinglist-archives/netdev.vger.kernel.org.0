Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD00397BE6
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 16:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbfHUOCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 10:02:14 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38169 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727696AbfHUOCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 10:02:14 -0400
Received: by mail-wm1-f65.google.com with SMTP id m125so2261220wmm.3
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 07:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:openpgp:autocrypt:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=IZEKwFYXuWCOYE64Kw//BzsntDGfKNxAopmprtAyQf4=;
        b=alBPyLj+2yYgcjmHKaxGD6h85XL3T1+ifV52J1FpG3ih/YSizFZD0hYsq7oROk1Tlv
         d+ECwMsFGF2T46G7Z+OP/ZWy/f8p0EA1whlIJHqR/ax392d0NHicAIfdq1BH+4E/DSfq
         jcU/4wApBE7Dd2Gzq0Pl6i/yagESSLwAGWedVOwmkEwT3l14H5wVlcUXvBl0yDBFebbF
         ty3yEVY0Ruqgy7FpHQ19+FIxLG28S0AKKKTu3+oNSh1/GZAG1ZUcbOdpMo8CiUZiqoax
         vhZ2YlfqZYBT1s7zirLWu6ZZ6RYGjqJj6of94dxbsB1RB6fZTtwzzJ8HQunGX8nDRGzX
         AU3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=IZEKwFYXuWCOYE64Kw//BzsntDGfKNxAopmprtAyQf4=;
        b=nI+SUaNPpr64ROdJpyOboSWWr0JGaCQTHylf0OOfOLUHpWOsZb0B1ltxIpyo8mNtqL
         chH5m40xUcrCAwcV7MLKkZI3RGS0B80TJL3GrMgWWBw9jLNh5jNC7WCYz7C1D5Y9Rmxr
         Jp6R7nX3BsQ+pfU+BM+G8NTq80WIHJDa8uVoNMFbEnFx24105m/NUE5VaYRd0zS9wTvO
         6aFFdM7YOyChYjVqQ+jF6M8VX/fAW6MBOQzsTPupLcNxPzv+aa4PdA8b5XHeW5TVefZt
         3P9jh74mEufOHY5/3eMBFZCy5O33/cxRfZEqApJqbGl7TFb+6O9n6ENGJRbCLcpwBi2E
         IBBQ==
X-Gm-Message-State: APjAAAWVNgLzC+oAIN922Q7S11d1DFB5qZeBWbiqkFDnVwFmAwuh5GGU
        twCCov6acJF0rhubY6oA1BSq4A==
X-Google-Smtp-Source: APXvYqz4tA/t2YZmiPSUxIVU/546/9jfDpXPE2raNA0LgI6EXxb+qQJpmVk20PaXP9puq7m9mxFvAg==
X-Received: by 2002:a1c:1a87:: with SMTP id a129mr180543wma.21.1566396132308;
        Wed, 21 Aug 2019 07:02:12 -0700 (PDT)
Received: from [192.168.1.62] (wal59-h01-176-150-251-154.dsl.sta.abo.bbox.fr. [176.150.251.154])
        by smtp.gmail.com with ESMTPSA id u8sm167571wmj.3.2019.08.21.07.02.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 07:02:11 -0700 (PDT)
Subject: Re: [PATCH net-next] net: stmmac: dwmac-meson: use
 devm_platform_ioremap_resource() to simplify code
To:     YueHaibing <yuehaibing@huawei.com>, davem@davemloft.net,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, khilman@baylibre.com,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
References: <20190821135406.26200-1-yuehaibing@huawei.com>
From:   Neil Armstrong <narmstrong@baylibre.com>
Openpgp: preference=signencrypt
Autocrypt: addr=narmstrong@baylibre.com; prefer-encrypt=mutual; keydata=
 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
 ZaTUOEkgIor5losDrePdPgE=
Organization: Baylibre
Message-ID: <f65f3f5c-5113-ff00-8b9f-f358e7775828@baylibre.com>
Date:   Wed, 21 Aug 2019 16:02:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190821135406.26200-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/08/2019 15:54, YueHaibing wrote:
> Use devm_platform_ioremap_resource() to simplify the code a bit.
> This is detected by coccinelle.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
> index 88eb169..bbc16b5 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
> @@ -46,7 +46,6 @@ static int meson6_dwmac_probe(struct platform_device *pdev)
>  	struct plat_stmmacenet_data *plat_dat;
>  	struct stmmac_resources stmmac_res;
>  	struct meson_dwmac *dwmac;
> -	struct resource *res;
>  	int ret;
>  
>  	ret = stmmac_get_platform_resources(pdev, &stmmac_res);
> @@ -63,8 +62,7 @@ static int meson6_dwmac_probe(struct platform_device *pdev)
>  		goto err_remove_config_dt;
>  	}
>  
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -	dwmac->reg = devm_ioremap_resource(&pdev->dev, res);
> +	dwmac->reg = devm_platform_ioremap_resource(pdev, 1);
>  	if (IS_ERR(dwmac->reg)) {
>  		ret = PTR_ERR(dwmac->reg);
>  		goto err_remove_config_dt;
> 

Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
