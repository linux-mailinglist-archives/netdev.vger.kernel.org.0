Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15192D4889
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 19:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgLISDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 13:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbgLISDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 13:03:34 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1727C0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 10:02:53 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id w4so1639145pgg.13
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 10:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=I5oqeXJGYWCS5I3GZe6iJ/uI1nEaQDlo5ahKfTZrQxU=;
        b=ms+3ifkmomxZx1fpbh86I6gUljxcDqH4op4xQnVmPOGRdBABYpnJHE71gP4zzXmWpV
         Fgzn2va8jJ1GzuN0+OdfNGAR8iN/Fh5T9Ed+Ra4UZ+GLfSS0NhtTUbIo8FAKZ4xTw2Xg
         JRFSg71R6MaQzdtJduz5oOH71cp+80kTBM8f+0sMlV+BUK8wkIiz0yfL1WZZIBX9W1+b
         ryLb9HasoVdN9Gjit8SHzhx91hlQiE83VAJCyEAa5xHmrfS/L1MjecExmVnBpZdUDJox
         vqCfPWnMFSqPbrmn4XNglGWfK3oQrGHhfzLEZVrLMvNo43D1C4ZPxp4O9npOiV+lBB6X
         F2kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=I5oqeXJGYWCS5I3GZe6iJ/uI1nEaQDlo5ahKfTZrQxU=;
        b=eHWt0teQZSkXpXnhEq+c0O5g53HJCTb2ycrcUU+5MfwjFKLmHcwmZ8vNVapg3dKBIX
         azZXjWrFzwwd6qxzVY1RGcpfEiILY5VNnJhNwyokq0tazVg2fhsVauDQ1Hxr/UHa1vuZ
         kNBmhzWH8v6gC1a7Co1xPxHCuMQ703F34mD9s5nVRGZnPQ9oI+0aqHT6MFX8FMA47Y7e
         JbZacN8Idh0Q1raRrs9+VttclPPZVwBa81LNp4ylwQk3gIhpIepb7oQ4rtvuE/sU3yge
         PwzxugFkWQ2OcFk+1EMNABG6JwugZTIvBLlRW+Hnt3zbzjBImpDJgHcB3RnDF0GtriFq
         fr9g==
X-Gm-Message-State: AOAM533A8GZSxmjrnSmVm1yXgaLYKYwUSBU60N0zanANAY/DC3iQRuYy
        VW1vTtUGgJ6iG7W7Mlm+Z81itw==
X-Google-Smtp-Source: ABdhPJyf4Tn1LStsnEmaPHRB0sKLv3Qnx9Fnmj0BviaeIBMIziONtZJpbHF8B7x8Rc2N+LuERQFZpA==
X-Received: by 2002:a63:4509:: with SMTP id s9mr2950777pga.316.1607536973606;
        Wed, 09 Dec 2020 10:02:53 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id g5sm3193868pfr.87.2020.12.09.10.02.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 10:02:52 -0800 (PST)
Subject: Re: [PATCH net-next] drivers: net: ionic: simplify the return
 expression of ionic_set_rxfh()
To:     Zheng Yongjun <zhengyongjun3@huawei.com>, drivers@pensando.io,
        davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201208135353.11708-1-zhengyongjun3@huawei.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <9275ad90-ee7e-6e23-6a33-bb0f7a2e2eeb@pensando.io>
Date:   Wed, 9 Dec 2020 10:02:51 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201208135353.11708-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/20 5:53 AM, Zheng Yongjun wrote:
> Simplify the return expression.
>
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Acked-by: Shannon Nelson <snelson@pensando.io>

> ---
>   drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 7 +------
>   1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> index 35c72d4a78b3..0832bedcb3b4 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> @@ -738,16 +738,11 @@ static int ionic_set_rxfh(struct net_device *netdev, const u32 *indir,
>   			  const u8 *key, const u8 hfunc)
>   {
>   	struct ionic_lif *lif = netdev_priv(netdev);
> -	int err;
>   
>   	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
>   		return -EOPNOTSUPP;
>   
> -	err = ionic_lif_rss_config(lif, lif->rss_types, key, indir);
> -	if (err)
> -		return err;
> -
> -	return 0;
> +	return ionic_lif_rss_config(lif, lif->rss_types, key, indir);
>   }
>   
>   static int ionic_set_tunable(struct net_device *dev,

