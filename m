Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9F2331616
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 19:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhCHSaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 13:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhCHS3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 13:29:55 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75C6C06174A;
        Mon,  8 Mar 2021 10:29:54 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id t85so2465107pfc.13;
        Mon, 08 Mar 2021 10:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=hS02wbSzoMEK3YSbr170NOiHipyHYM37/iMcT14Z2+A=;
        b=tPOLzSoD85YhF9xFbhFle9qe+XmtXMmjQ8f5rmALiw5Yh4c+gw8V+xx2qSSEB4vWdg
         NSpkbLizQ1YGBm/ErXcsu+1eglVoRE8puiNANH8TWO36qmaqa6f4CAJPMvvKrwxxFrdm
         lcnrAgkFvkZsC2F8R+9QWNr5pBxkqb22S6pGGEm2T6Ilbo9IDDGTut1ZwhUeiYbupiOP
         teTej9BsQst9l1LoAFOTBRh1TXFbrgCjtASz4ttPD1p0QFNk030BBqevzJ3DcTKZR6dK
         K4q/0aOf9sBnbzwbPqKunL4b2pP00YVyllL7em8R6uYwsX/7K8tvVsBs0OC4+7sFi5+4
         vqKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hS02wbSzoMEK3YSbr170NOiHipyHYM37/iMcT14Z2+A=;
        b=WeYUZshrYZWDfItiraARSRWiKSlRRdz+PIwdat8vROfjbXgTnjmHDX4e6WbhJcP24n
         2linNLew1ro7vl5DAMTk2KccuWfkQgrDjKADk1dSa7ouerxzE62HaKSeX1tD+AeDPAbI
         VPbwO3Nj1Z18e2Mb/I5MJwQQke9iSghvsaLwzAKMV62zdCR+8GOBk1Kkx5YKTQHm+VFc
         wT/vmzOvFck1RuSAVSVpeJRWZZpPVStZ0ziAqbyKKzlo6jheONoTDZPaTXzvFcSr+N3j
         puZvsgtlPFmZI6CX8EOrzZKXRHstELZAyXjaeEVoR9V4oKA9eF93HD48ljcM87b2ta8y
         n/cQ==
X-Gm-Message-State: AOAM531DxdsR7cN7vf8YIGCfRbKuNFYcdSxlN+fY+7UDY62Gao/bvTao
        neX0qFR5r2Eg5NzLzzG4qr1EhnzBXuY=
X-Google-Smtp-Source: ABdhPJzsID4IOnXez6qvwq4S8JVIauf6XFNQIk0VqcqAsWAhDVrzpqZwN+9JEecuyJJDKj4tYy07OA==
X-Received: by 2002:a65:46cd:: with SMTP id n13mr21249568pgr.414.1615228194095;
        Mon, 08 Mar 2021 10:29:54 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q64sm11376120pfb.6.2021.03.08.10.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 10:29:53 -0800 (PST)
Subject: Re: [PATCH] net: dsa: b53: mmap: Add device tree support
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        jonas.gorski@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210308180715.18571-1-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <06dab800-d554-e807-8a72-427c6e99e4de@gmail.com>
Date:   Mon, 8 Mar 2021 10:29:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210308180715.18571-1-noltari@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/21 10:07 AM, Álvaro Fernández Rojas wrote:
> Add device tree support to b53_mmap.c while keeping platform devices support.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>  drivers/net/dsa/b53/b53_mmap.c | 36 ++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
> index c628d0980c0b..b897b4263930 100644
> --- a/drivers/net/dsa/b53/b53_mmap.c
> +++ b/drivers/net/dsa/b53/b53_mmap.c
> @@ -228,12 +228,48 @@ static const struct b53_io_ops b53_mmap_ops = {
>  	.write64 = b53_mmap_write64,
>  };
>  
> +static int b53_mmap_probe_of(struct platform_device *pdev,
> +			     struct b53_platform_data **ppdata)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = dev->of_node;
> +	struct b53_platform_data *pdata;
> +	void __iomem *mem;
> +
> +	mem = devm_platform_ioremap_resource(pdev, 0);
> +	if (IS_ERR(mem))
> +		return PTR_ERR(mem);
> +
> +	pdata = devm_kzalloc(dev, sizeof(struct b53_platform_data),
> +			     GFP_KERNEL);
> +	if (!pdata)
> +		return -ENOMEM;
> +
> +	pdata->regs = mem;
> +	pdata->chip_id = BCM63XX_DEVICE_ID;
> +	pdata->big_endian = of_property_read_bool(np, "big-endian");
> +	of_property_read_u16(np, "brcm,ports", &pdata->enabled_ports);
> +
> +	*ppdata = pdata;
> +
> +	return 0;
> +}
> +
>  static int b53_mmap_probe(struct platform_device *pdev)
>  {
> +	struct device_node *np = pdev->dev.of_node;
>  	struct b53_platform_data *pdata = pdev->dev.platform_data;
>  	struct b53_mmap_priv *priv;
>  	struct b53_device *dev;
>  
> +	if (np) {
> +		int ret = b53_mmap_probe_of(pdev, &pdata);
> +		if (ret) {
> +			dev_err(&pdev->dev, "OF probe error\n");
> +			return ret;
> +		}
> +	}

I would be keen on making this less "OF-centric" and just have it happen
whenever pdata is NULL such that we have an easier transition path if we
wanted to migrate bcm63xx to passing down the switch base register
address a platform_device source in the future (not that I expect it to
happen though).

Other than that, the logic looks sound.
-- 
Florian
