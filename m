Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29823143871
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 09:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgAUIjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 03:39:15 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46510 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgAUIjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 03:39:15 -0500
Received: by mail-lf1-f66.google.com with SMTP id z26so1509262lfg.13
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 00:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hsNWoes18WxCFqI2xo+zG2UAVBdbnLW1RdahXtCWkN4=;
        b=ogeQ32MOdjzdgAmxRr2eY6wFvxsdi2q0zPB1rFdofpYEO51IIsVHTP/MpXts48N+Hu
         4iZtIN1cDXQuFYvBGceJ5W03NNZraJNYMDKMSvJOsV+lneWXcfyzASCoSAqZQihD2yEM
         QdR/SJOIEFHL8SXJ581I6hl5NpDqF6nH7lxfCZQmjvsmwfc9zvkQiN3Xw/YMv82SD2f2
         Ev5dOkK0Dl59TsTdsxmED6+cxcIYkHOvcHdM5IM1NU2kwzezkUMm6G8LimxsPNcxSP/d
         5hJm2EW0ST6IRLKF9J/typuxf8l7gKRBMVHY/PbUh5iEVxcNkVDOrrSBubvTbYNahV9K
         /Sxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hsNWoes18WxCFqI2xo+zG2UAVBdbnLW1RdahXtCWkN4=;
        b=W2rAaYNOV/XfiJpWp7BDGHk1k42cKdRTX45asVpamtwgrE2YFkIb8sZ9IOBLr8/h7v
         /ugaeqVge6THHTQBlgNcvXoKegsTtX3kwtG4eRXZ/xpkgiar1mHotsiPm3mulav/fVkC
         OX6/O+MTHCxR9skBXEQgl0g0BoQw4of9mIUIA3jBbWKXEJAA/glWZERI3S2o9qyf/6mz
         YGH5cC31/hyHUhPiWk15Ly+IpAqlQpjSntjIiz+Nwp3gGBmj4xVZg5tA0t5OZ/mOHqNq
         uOBDKqKp9gXUrFlsAhUbOJLoRfjRGBD0r4+K/ZTsUckRuFs8USN0PeGSceNdvEe465xy
         C4NQ==
X-Gm-Message-State: APjAAAV5NxKdqWV6K0B84g3UZxdr1LKLvQ/5znFGZbln4x/D+VrI5V/u
        8mApsIa+Ju95wTQ2E/sfIXVuJw==
X-Google-Smtp-Source: APXvYqwKhPhYL0ooaJpzntwbDv2rsPpjcDAD4+2ocnxH+WdV/2FygoMaU5dMv0QJe5KSTwUYfqw3Ow==
X-Received: by 2002:ac2:43c6:: with SMTP id u6mr2027596lfl.191.1579595953303;
        Tue, 21 Jan 2020 00:39:13 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:4257:4d38:8de3:4197:be8e:7729? ([2a00:1fa0:4257:4d38:8de3:4197:be8e:7729])
        by smtp.gmail.com with ESMTPSA id b1sm21197686ljp.72.2020.01.21.00.39.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 00:39:12 -0800 (PST)
Subject: Re: [PATCH -next] drivers: net: declance: fix comparing pointer to 0
To:     Chen Zhou <chenzhou10@huawei.com>, davem@davemloft.net,
        mhabets@solarflare.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200121013553.15252-1-chenzhou10@huawei.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <40eb3815-f677-c2fd-3e67-4b39bb332f48@cogentembedded.com>
Date:   Tue, 21 Jan 2020 11:39:05 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200121013553.15252-1-chenzhou10@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 21.01.2020 4:35, Chen Zhou wrote:

> Fixes coccicheck warning:
> 
> ./drivers/net/ethernet/amd/declance.c:611:14-15:
> 	WARNING comparing pointer to 0
> 
> Compare pointer-typed values to NULL rather than 0.

    I don't see NULL in the patch -- you used ! instead.

> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
> ---
>   drivers/net/ethernet/amd/declance.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/amd/declance.c b/drivers/net/ethernet/amd/declance.c
> index 6592a2d..7282ce5 100644
> --- a/drivers/net/ethernet/amd/declance.c
> +++ b/drivers/net/ethernet/amd/declance.c
> @@ -608,7 +608,7 @@ static int lance_rx(struct net_device *dev)
>   			len = (*rds_ptr(rd, mblength, lp->type) & 0xfff) - 4;
>   			skb = netdev_alloc_skb(dev, len + 2);
>   
> -			if (skb == 0) {
> +			if (!skb) {
>   				dev->stats.rx_dropped++;
>   				*rds_ptr(rd, mblength, lp->type) = 0;
>   				*rds_ptr(rd, rmd1, lp->type) =

MBR, Sergei
