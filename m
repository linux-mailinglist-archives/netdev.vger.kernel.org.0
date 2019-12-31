Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1984B12D7D0
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 11:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfLaKMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 05:12:39 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41035 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbfLaKMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 05:12:34 -0500
Received: by mail-lj1-f193.google.com with SMTP id h23so35914228ljc.8
        for <netdev@vger.kernel.org>; Tue, 31 Dec 2019 02:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sYidT8cA6/M5ZOcRmE0d5onegqqpe9/lv8i6pNEaUps=;
        b=X2ayaav5pA7MM+KDIIY6EVL62/ilIJWRbII6hQrPv8J6spDZIOjE4LnOX7dGL/7wwl
         dle64UH91jWQiLP9rol7pBRG4MYWWZJY3SlOw/K1Cw7VxlFi5Z3haVOyOHLT1Q2KIQCw
         xwWS/iiiTl4dbgjuyRkXiEJI4uE5H4+faG+qAXS0Rc2ZYlNZP2owOnFsG1+tog7CLDVl
         kPw27rrAQNE5NSzM1zTx/DtbqUhh2kN5Sy8oW01lIAI0XzfnoshuuKZB/WJgxBZCPgOn
         QjdfN0IrLOHhAfNW5M38q2vnbPu0Cu6hn0CK5yHL/y4wDbZKE2ZpoMp6oKJbVkFXAK++
         A8uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sYidT8cA6/M5ZOcRmE0d5onegqqpe9/lv8i6pNEaUps=;
        b=sD1Z9sOuUTDgfyqNc66EztiREJrMmRaRFA6KAbAw+EkND703DO8X0PyfmKfQBvKZ5e
         Q0tHr/aDowpkxfB5qGA5csQxLGNYhfZCMFZFrp7qA/rdhv6TDWlqWuGoAxpxq6ZqN1sF
         rBeteqr4VI63GMpBU5APnDqaGtnziFH5ghZMulqdAtnFFsQwLlUFLWA2Z0oARVVPIlCe
         pK4Wq49lm7UbgIiWWkMk7w9ciZ229NDcAyy/cMeboNbCdptfRiD+Nv3RdfYKf2ptzN2k
         +ncyf1aW1+Bj/9FPkhlReJtiOsm798lm8EmYZYikkG88P4xOLhC1k3M8SQ5S6urDx7XB
         4bzw==
X-Gm-Message-State: APjAAAVqMuP9t79XLiiYqdkKNvL9fypi4mgFzyvbbVawkbE4KYOPkTPV
        pRMniNCZ7Qf9iMNTahySRTzYfA==
X-Google-Smtp-Source: APXvYqz3o9BNQOLYRcJKaBB89OeIbOZreMSdC+Y1SprnU0gutIUg4V9KRPDOu+KX+7jC75FdTe8Kfg==
X-Received: by 2002:a2e:8797:: with SMTP id n23mr40379304lji.176.1577787151735;
        Tue, 31 Dec 2019 02:12:31 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:646:8dc9:cad:7023:48c4:5145? ([2a00:1fa0:646:8dc9:cad:7023:48c4:5145])
        by smtp.gmail.com with ESMTPSA id z7sm23586452lfa.81.2019.12.31.02.12.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Dec 2019 02:12:31 -0800 (PST)
Subject: Re: [PATCH] stmmac: debugfs entry name is not be changed when udev
 rename device name.
To:     Jiping Ma <jiping.ma2@windriver.com>, peppe.cavallaro@st.com,
        alexandre.torgue@st.com
Cc:     joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
References: <20191231020302.71792-1-jiping.ma2@windriver.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <57dcdaa1-feff-1134-919e-57b37e306431@cogentembedded.com>
Date:   Tue, 31 Dec 2019 13:12:29 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191231020302.71792-1-jiping.ma2@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 31.12.2019 5:03, Jiping Ma wrote:

> Add one notifier for udev changes net device name.
> 
> Signed-off-by: Jiping Ma <jiping.ma2@windriver.com>
> ---
>   .../net/ethernet/stmicro/stmmac/stmmac_main.c | 38 ++++++++++++++++++-
>   1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index b14f46a57154..c1c877bb4421 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -4038,6 +4038,40 @@ static int stmmac_dma_cap_show(struct seq_file *seq, void *v)
>   }
>   DEFINE_SHOW_ATTRIBUTE(stmmac_dma_cap);
>   
> +/**
> + * Use network device events to create/remove/rename
> + * debugfs file entries
> + */
> +static int stmmac_device_event(struct notifier_block *unused,
> +			       unsigned long event, void *ptr)
> +{
> +	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
> +	struct stmmac_priv *priv = netdev_priv(dev);
> +
> +	switch (event) {
> +	case NETDEV_CHANGENAME:
> +		if (priv->dbgfs_dir)
> +			priv->dbgfs_dir = debugfs_rename(stmmac_fs_dir,
> +							 priv->dbgfs_dir,
> +							 stmmac_fs_dir,
> +							 dev->name);
> +		break;
> +
> +	case NETDEV_GOING_DOWN:
> +		break;
> +
> +	case NETDEV_UP:
> +		break;

    Why not merge the above 2 cases? Or just remove them('event' is not *enum*)?

> +	}
> +
> +done:
> +	return NOTIFY_DONE;
> +}
[...]

MBR, Sergei
