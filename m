Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99A516338A
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 11:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfGIJgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 05:36:07 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43621 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfGIJgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 05:36:07 -0400
Received: by mail-lf1-f66.google.com with SMTP id c19so7307654lfm.10
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 02:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XU2IBGyFRzKn02DPmdzj6szchTRAPUpG4CBxe0IbZxM=;
        b=xIz67RFwEx4FnMHMwebDTUVE9XLXFv8FCz7wp9SaGHdJlEH5Z3EEk3wEuu7Mtp2zbG
         M4T+EmJW0LsmjGJoak92C7bJ2U6zeKs+oNarpfT7EgB7rYP8h9/LGM+aOKvCcGQbR1Kw
         qYwWOxViWDwiGlwbH4ipBaOha885QznmvsQtbk7LHgiVDrTnSNvX4BzCWSdGBD7Cf0H1
         Rj3W3NjOQku2W/94ZTyRcy/ZV2iB+q7HTarYXQBoDq2XBVxy2UoamJNPIu2wSpbVi+U4
         gMBmx/57gTp6NgVzCPbl8TipJ3u+A3U2lC+cXeqODlnqu7tBNqCfAuqpV6Mf7Fck3HLQ
         RFng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XU2IBGyFRzKn02DPmdzj6szchTRAPUpG4CBxe0IbZxM=;
        b=DbeKiYuWb5KSXYhB/dylz+ll9s9jciZpKwo/Jqsp6TzESsnc9+abYndZFXThzDISBN
         OCbyKghzeedZDEVc69MurdnaxKobR1yd1X9XVFnVZKd/y46w6y6uzFb2lSgl1oA6NhA/
         QBdnT0ZJYkKxvrYz2WuXFK2LLOdK7Ay41hjOkwVhKJBq5DrCgfiCElbTNOVDKiZFQnxB
         N7gCfazVq1p+XrDUzkWm4WnvoxInBG5qB36w2O1w6k/bFtIb30qGZPUUTgrBxCnpeTOh
         EqZVC43Sp2AELpNBHwJDtE8nq36uBml09JSsjSwSKQaFb7zzyNvJiesiMGx0mcr+tvhg
         QVFA==
X-Gm-Message-State: APjAAAWNejw44mjoivHSoba96On5wmAbciqXNw7cZO0Q9oTj1KXE9DQW
        HX4oN7Vuu7dUkc4LhuU3+a8RsQ==
X-Google-Smtp-Source: APXvYqxGrufPNKdsqBBStgGj1iNyRF54W7AS2XauiAm/Fr8QXkxDauZ+cr22x87ZgqJU7N1c+XgycQ==
X-Received: by 2002:a19:ec15:: with SMTP id b21mr11999025lfa.32.1562664965397;
        Tue, 09 Jul 2019 02:36:05 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:293:b564:5d38:7bfd:30:5ce9? ([2a00:1fa0:293:b564:5d38:7bfd:30:5ce9])
        by smtp.gmail.com with ESMTPSA id i17sm2828273lfp.94.2019.07.09.02.36.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 02:36:04 -0700 (PDT)
Subject: Re: [PATCH v2 05/10] net: hisilicon: HI13X1_GMAX need dreq reset at
 first
To:     Jiangfeng Xiao <xiaojiangfeng@huawei.com>, davem@davemloft.net,
        robh+dt@kernel.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, mark.rutland@arm.com,
        dingtianhong@huawei.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, leeyou.li@huawei.com,
        nixiaoming@huawei.com, jianping.liu@huawei.com,
        xiekunxun@huawei.com
References: <1562643071-46811-1-git-send-email-xiaojiangfeng@huawei.com>
 <1562643071-46811-6-git-send-email-xiaojiangfeng@huawei.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <890c48d1-76b8-5aea-e175-aa7d9967acd2@cogentembedded.com>
Date:   Tue, 9 Jul 2019 12:35:57 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562643071-46811-6-git-send-email-xiaojiangfeng@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 09.07.2019 6:31, Jiangfeng Xiao wrote:

> HI13X1_GMAC delete request for soft reset at first,
> otherwise, the subsequent initialization will not
> take effect.
> 
> Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
> ---
>   drivers/net/ethernet/hisilicon/hip04_eth.c | 24 ++++++++++++++++++++++++
>   1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
> index fe61b01..19d8cfd 100644
> --- a/drivers/net/ethernet/hisilicon/hip04_eth.c
> +++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
[...]
> @@ -853,6 +867,15 @@ static int hip04_mac_probe(struct platform_device *pdev)
>   		goto init_fail;
>   	}
>   
> +#if defined(CONFIG_HI13X1_GMAC)
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	priv->sysctrl_base = devm_ioremap_resource(d, res);

    There's devm_platform_ioremap_resource() now.

> +	if (IS_ERR(priv->sysctrl_base)) {
> +		ret = PTR_ERR(priv->sysctrl_base);
> +		goto init_fail;
> +	}
> +#endif
> +
>   	ret = of_parse_phandle_with_fixed_args(node, "port-handle", 2, 0, &arg);
>   	if (ret < 0) {
>   		dev_warn(d, "no port-handle\n");
[...]

MBR, Sergei
