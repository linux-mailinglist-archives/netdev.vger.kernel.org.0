Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF1A223BCB
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 14:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgGQM5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 08:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgGQM5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 08:57:36 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BB0C061755;
        Fri, 17 Jul 2020 05:57:35 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f18so11027033wrs.0;
        Fri, 17 Jul 2020 05:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=GNUhZylLk3l9RsDrgwZOssjZZX3KXf0nldZGkvUmRoE=;
        b=qHRPQMfiY2uV/kj/JXGvEr+WviNOc/ab55Zb5z+XiLyVz7ECdRLSTyDm1Arka+WCie
         YLNFzEccBDO2rUr9gk2yu0JOSQTfYW673ho9VKN/egTa3v8lMxBU6Sw8Dz2G/8SytnjE
         otQgZLCCp/PoatkANVKjJoH6Nv2C6Sk1nydkapfkLfgb0DfliZXbkhCs7H4r1fpsFoZB
         s6BKKZAw0UpuWhqO9qffti2vhrVtXRN/KZ8nOKybCX8/6WGsTN+Lt4G+xgRD4Gs4wbqM
         6zpwDYp8LCcmfMv9/uk9ybqVoixSc0r8aUGmPd2MU1qeq+Sl4TOci1/vD6ZAnhDfQunV
         wIUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=GNUhZylLk3l9RsDrgwZOssjZZX3KXf0nldZGkvUmRoE=;
        b=Rpm4hnx+diFUJqW889vdRWOwk6J4Ixl0sXG3vMNla/ntsflQNixC8swOgSy/NpbJF2
         QOT9B6030ipeaAk4U6IRdY87W/pvjXKFHlfppW4LA3P78X8Sac5c8uIQayC2zXfsWcRF
         gGuB35zZ0ud7tO1JB9+/6we49X0jDbCJRtFbTc/Jtd9RfOVf6R2QC6MIUrg5vAz0jkDs
         Ko9iisRmcWspe1sQh7wPcgyOv+E+9luN32qztqP9T0VqG2LLNB0WuT5YC/k6nInNiCzN
         Ospge2mOXi7OA3ugpsxW8fsP5Pr+yf5Fwg4vVsJhXwzlg1dJ9sEYW5UTyi47JhAZpJCz
         swtw==
X-Gm-Message-State: AOAM5325ML93CxGCTalsObE711PmWyfIYMlj1yjaci7nzqKMVvYyaW6V
        ti9NTt+wzlvP8UbcM+a3mK4=
X-Google-Smtp-Source: ABdhPJwIEsR/8OFRfeioM9f78CB8bGRiKr0FtJMM2D/cAYH0QjPT6ZJLLOzaQOeUmwlh9BoUUcFpnQ==
X-Received: by 2002:a5d:4903:: with SMTP id x3mr10755351wrq.351.1594990654486;
        Fri, 17 Jul 2020 05:57:34 -0700 (PDT)
Received: from user-9.251.vpn.cf.ac.uk (vpn-users-dip-pool163.dip.cf.ac.uk. [131.251.253.163])
        by smtp.googlemail.com with ESMTPSA id s8sm14094629wru.38.2020.07.17.05.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 05:57:33 -0700 (PDT)
Message-ID: <558daf6d645335b75db2fdda4ef3e4fe39cbdc8f.camel@gmail.com>
Subject: Re: [PATCH net-next] net: ethernet: et131x: Remove unused variable
 'pm_csr'
From:   Mark Einon <mark.einon@gmail.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 17 Jul 2020 13:57:27 +0100
In-Reply-To: <1594982010-30679-1-git-send-email-zhangchangzhong@huawei.com>
References: <1594982010-30679-1-git-send-email-zhangchangzhong@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Zhang,

On Fri, 2020-07-17 at 18:33 +0800, Zhang Changzhong wrote:
> Gcc report warning as follows:
> 
> drivers/net/ethernet/agere/et131x.c:953:6: warning:
>  variable 'pm_csr' set but not used [-Wunused-but-set-variable]
>   953 |  u32 pm_csr;
>       |      ^~~~~~
> drivers/net/ethernet/agere/et131x.c:1002:6:warning:
>  variable 'pm_csr' set but not used [-Wunused-but-set-variable]
>  1002 |  u32 pm_csr;
>       |      ^~~~~~
> drivers/net/ethernet/agere/et131x.c:3446:8: warning:
>  variable 'pm_csr' set but not used [-Wunused-but-set-variable]
>  3446 |    u32 pm_csr;
>       |        ^~~~~~
> 
> After commit 38df6492eb51 ("et131x: Add PCIe gigabit ethernet driver
> et131x to drivers/net"), 'pm_csr' is never used in these functions,
> so removing it to avoid build warning.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/agere/et131x.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 

This makes sense, thanks.

The readl() line modified here is also redundant as it gets called from
the subsequent et1310_in_phy_coma() call. A patch to fix this is on it's
way.

Acked-by: Mark Einon <mark.einon@gmail.com>

Cheers,

Mark

> diff --git a/drivers/net/ethernet/agere/et131x.c
> b/drivers/net/ethernet/agere/et131x.c
> index 865892c..8806e1e 100644
> --- a/drivers/net/ethernet/agere/et131x.c
> +++ b/drivers/net/ethernet/agere/et131x.c
> @@ -950,7 +950,6 @@ static void
> et1310_setup_device_for_multicast(struct et131x_adapter *adapter)
>  	u32 hash2 = 0;
>  	u32 hash3 = 0;
>  	u32 hash4 = 0;
> -	u32 pm_csr;
>  
>  	/* If ET131X_PACKET_TYPE_MULTICAST is specified, then we
> provision
>  	 * the multi-cast LIST.  If it is NOT specified, (and "ALL" is
> not
> @@ -984,7 +983,7 @@ static void
> et1310_setup_device_for_multicast(struct et131x_adapter *adapter)
>  	}
>  
>  	/* Write out the new hash to the device */
> -	pm_csr = readl(&adapter->regs->global.pm_csr);
> +	readl(&adapter->regs->global.pm_csr);
>  	if (!et1310_in_phy_coma(adapter)) {
>  		writel(hash1, &rxmac->multi_hash1);
>  		writel(hash2, &rxmac->multi_hash2);
> @@ -999,7 +998,6 @@ static void et1310_setup_device_for_unicast(struct
> et131x_adapter *adapter)
>  	u32 uni_pf1;
>  	u32 uni_pf2;
>  	u32 uni_pf3;
> -	u32 pm_csr;
>  
>  	/* Set up unicast packet filter reg 3 to be the first two octets
> of
>  	 * the MAC address for both address
> @@ -1025,7 +1023,7 @@ static void
> et1310_setup_device_for_unicast(struct et131x_adapter *adapter)
>  		  (adapter->addr[4] << ET_RX_UNI_PF_ADDR1_5_SHIFT) |
>  		   adapter->addr[5];
>  
> -	pm_csr = readl(&adapter->regs->global.pm_csr);
> +	readl(&adapter->regs->global.pm_csr);
>  	if (!et1310_in_phy_coma(adapter)) {
>  		writel(uni_pf1, &rxmac->uni_pf_addr1);
>  		writel(uni_pf2, &rxmac->uni_pf_addr2);
> @@ -3443,12 +3441,10 @@ static irqreturn_t et131x_isr(int irq, void
> *dev_id)
>  		 * send a pause packet, otherwise just exit
>  		 */
>  		if (adapter->flow == FLOW_TXONLY || adapter->flow ==
> FLOW_BOTH) {
> -			u32 pm_csr;
> -
>  			/* Tell the device to send a pause packet via
> the back
>  			 * pressure register (bp req and bp xon/xoff)
>  			 */
> -			pm_csr = readl(&iomem->global.pm_csr);
> +			readl(&iomem->global.pm_csr);
>  			if (!et1310_in_phy_coma(adapter))
>  				writel(3, &iomem->txmac.bp_ctrl);
>  		}


