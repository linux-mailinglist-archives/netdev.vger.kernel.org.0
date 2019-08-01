Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD6F87DD80
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 16:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731846AbfHAOKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 10:10:18 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34337 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731843AbfHAOKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 10:10:18 -0400
Received: by mail-pf1-f194.google.com with SMTP id b13so34149812pfo.1
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 07:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Z8h+Poj4+7U/T3qlD1ddBdmlDkiJoP/N0Q3RpsNQwbM=;
        b=RU1gaXqQMVkPB3NWW+zlenk00WILyKD9W5DEwRm86dP0tBwXV9JroDjn/68S9VGVSD
         pHWFU38EUulYcLVtcWGJP5CsDTGDcSoA4qUJqxYbS8rOyuI3JEW/JGsQ0VbmEnYxnLtx
         bgk7qT+5YUby9KZPqSDYfNhIm9B9MBTup9GkNwhdpAusiaIw082csiG8eezt8Y8agh6w
         j4EYxSttErRkUJA3+Uj6nWMlVZmtDE/VVHCAjthWP0oTa5MKsbxg5i7P+B4Qq/wHKQ4D
         rQhdIW68ZEPbo0FCyd0ufRW8HTuVrK5ACPJupd38qaYVaJt1sJOQIupSE5hTueQpAEBQ
         sPLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z8h+Poj4+7U/T3qlD1ddBdmlDkiJoP/N0Q3RpsNQwbM=;
        b=igQlw4JoQ9awEg8q4sIP+gGRT4Wl4vggpFcj/25lXEJpljQiSeiQFsGUTejBe1RDBN
         J4gVMvDCqxfUxHH3Do4V+6dPnFZs2D93b9VcU/B5AylNyCFihAJPgnvvVTfgXl/8p4a7
         GDxxjK/u8UOlXtgvQOuIJajEco26lO8Im6jJWSdKxN2TBsKcYQYUjOkFvg4NHR7vkW2O
         cObLXh7XG9pJQnbWBYnU97YYSrWVv6WLvfPTBZ1kVcO7qzP+G/FyS+y7SsXSKRMOU3aj
         SqyyfcUgWcqKiLGW0urY1j9sRgjdfQJO42DOQRXqY2DQD0HEHUR3M8oPArQpCwxRvKCy
         4kLQ==
X-Gm-Message-State: APjAAAUBA9ouM+M9u9XkHpWDDqppDqZS/zOmQ6HHwrEwys5T0ePXYXRO
        M0eocimM4VWwfgw/lQ68JVBGddxsxQLnJg==
X-Google-Smtp-Source: APXvYqy8FIV7QLG1ZfldWKAnPEUwTm/4y+2Vizsy92nMwa6UmdjZUOPGlI5FHyeJOHU4nUSWQDWYGg==
X-Received: by 2002:a63:b346:: with SMTP id x6mr119990037pgt.218.1564668617394;
        Thu, 01 Aug 2019 07:10:17 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b14sm6003864pga.20.2019.08.01.07.10.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 07:10:16 -0700 (PDT)
Date:   Thu, 1 Aug 2019 22:10:07 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Joe Perches <joe@perches.com>
Cc:     netdev@vger.kernel.org, Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] ibmveth: use net_err_ratelimited when
 set_multicast_list
Message-ID: <20190801141006.GS18865@dhcp-12-139.nay.redhat.com>
References: <20190801090347.8258-1-liuhangbin@gmail.com>
 <209f7fe62e2a79cd8c02b104b8e3babdd16bff30.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <209f7fe62e2a79cd8c02b104b8e3babdd16bff30.camel@perches.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 01, 2019 at 03:28:43AM -0700, Joe Perches wrote:
> Perhaps add the netdev_<level>_ratelimited variants and use that instead
> 
> Somthing like:

Yes, that looks better. Do you mind if I take your code and add your
Signed-off-by info?

Thanks
Hangbin
> 
> ---
>  include/linux/netdevice.h | 54 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 88292953aa6f..37116019e14f 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -4737,6 +4737,60 @@ do {								\
>  #define netdev_info_once(dev, fmt, ...) \
>  	netdev_level_once(KERN_INFO, dev, fmt, ##__VA_ARGS__)
>  
> +#define netdev_level_ratelimited(netdev_level, dev, fmt, ...)		\
> +do {									\
> +	static DEFINE_RATELIMIT_STATE(_rs,				\
> +				      DEFAULT_RATELIMIT_INTERVAL,	\
> +				      DEFAULT_RATELIMIT_BURST);		\
> +	if (__ratelimit(&_rs))						\
> +		netdev_level(dev, fmt, ##__VA_ARGS__);			\
> +} while (0)
> +
> +#define netdev_emerg_ratelimited(dev, fmt, ...)				\
> +	netdev_level_ratelimited(netdev_emerg, dev, fmt, ##__VA_ARGS__)
> +#define netdev_alert_ratelimited(dev, fmt, ...)				\
> +	netdev_level_ratelimited(netdev_alert, dev, fmt, ##__VA_ARGS__)
> +#define netdev_crit_ratelimited(dev, fmt, ...)				\
> +	netdev_level_ratelimited(netdev_crit, dev, fmt, ##__VA_ARGS__)
> +#define netdev_err_ratelimited(dev, fmt, ...)				\
> +	netdev_level_ratelimited(netdev_err, dev, fmt, ##__VA_ARGS__)
> +#define netdev_warn_ratelimited(dev, fmt, ...)				\
> +	netdev_level_ratelimited(netdev_warn, dev, fmt, ##__VA_ARGS__)
> +#define netdev_notice_ratelimited(dev, fmt, ...)			\
> +	netdev_level_ratelimited(netdev_notice, dev, fmt, ##__VA_ARGS__)
> +#define netdev_info_ratelimited(dev, fmt, ...)				\
> +	netdev_level_ratelimited(netdev_info, dev, fmt, ##__VA_ARGS__)
> +
> +#if defined(CONFIG_DYNAMIC_DEBUG)
> +/* descriptor check is first to prevent flooding with "callbacks suppressed" */
> +#define netdev_dbg_ratelimited(dev, fmt, ...)				\
> +do {									\
> +	static DEFINE_RATELIMIT_STATE(_rs,				\
> +				      DEFAULT_RATELIMIT_INTERVAL,	\
> +				      DEFAULT_RATELIMIT_BURST);		\
> +	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
> +	if (DYNAMIC_DEBUG_BRANCH(descriptor) &&				\
> +	    __ratelimit(&_rs))						\
> +		__dynamic_netdev_dbg(&descriptor, dev, fmt,		\
> +				     ##__VA_ARGS__);			\
> +} while (0)
> +#elif defined(DEBUG)
> +#define netdev_dbg_ratelimited(dev, fmt, ...)				\
> +do {									\
> +	static DEFINE_RATELIMIT_STATE(_rs,				\
> +				      DEFAULT_RATELIMIT_INTERVAL,	\
> +				      DEFAULT_RATELIMIT_BURST);		\
> +	if (__ratelimit(&_rs))						\
> +		netdev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
> +} while (0)
> +#else
> +#define netdev_dbg_ratelimited(dev, fmt, ...)				\
> +do {									\
> +	if (0)								\
> +		netdev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
> +} while (0)
> +#endif
> +
>  #define MODULE_ALIAS_NETDEV(device) \
>  	MODULE_ALIAS("netdev-" device)
>  
> 
> 
