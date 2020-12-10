Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0D72D6427
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 18:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392752AbgLJR4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 12:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392977AbgLJR4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 12:56:02 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7DBC0613CF;
        Thu, 10 Dec 2020 09:55:22 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id e2so4913929pgi.5;
        Thu, 10 Dec 2020 09:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hrVQ7SVyCoaV1mjAfYlqW3Uy9TiAxEzQ/B4ofiIVHhQ=;
        b=W8nZhFPOpQyWe0xWfiZWqiCgkc2gW68guoHYsVDHeAyMCEgyPRCRgLtKy6YZ8BILgE
         wo05WAGEinVfSYssL1rP5IdDgxg1kDUsJnNkKVd73x1vTIGEyy4XtfSiJCToV4iw3TGh
         g/7dljAlpKdU4KO8DE46IamX0ajc8IMABUru42Sd3kgtKbn22J9jHQZPzTf34c1qR8mi
         T6WFAe4nkKCi4JT77gegip2CrxptUdbiWEZdzIehDXE+ftNwWU4SBSWtyOHFjxiaBHH0
         gU7cYg7qDXoehvpkIDHtGWSg9o6GRJ62qydXw/ARodQUtwQtif8kTxWtjA41MCw8SzKd
         axrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hrVQ7SVyCoaV1mjAfYlqW3Uy9TiAxEzQ/B4ofiIVHhQ=;
        b=nAhCM3yoWw42veSxi3asbHkHx5/hYQFxHk6PiPZE0tWKY+AA9Gx07sXdDG/0ILcZxU
         CEYgHKFih04RtSdSwZEdE/DGUJkcDFwTiTVhCg3NWvLPBEOjCpkkKnmfb5qITbQIktgK
         LPof8rzXpeD8JrYfUmSjtXCM3fSK5lRuzh0MXjI6bzpyhH+YTFJ+nbSSDctIWck+ZgEb
         h8IQt+cabPkQtYNG0jBEXE5bzqkfLheojoK85ZPkNqaXiDpNNfIvKFzthhES6jXRe9QQ
         e4kMBsLHBUGTP8AJTiqRyhJWDdmmqsPpT4WzwMMIHyv04RWaIEVFQK426RCDXdlY8j4A
         11eA==
X-Gm-Message-State: AOAM5304Gz78gGfOTE/P6t82Q0xQ8te4ASkn/3Ei2Vn3LvqjeRQrCgGv
        4oijNe43m3CWKYlc4/sLWuogEUiuz2A=
X-Google-Smtp-Source: ABdhPJx/k5t3uIeCLO/BipkM+UFAvT+G5JAF7k94zNJ+MieGAcyrddPn8g/0JEGNm7Ng6/he+OTrBA==
X-Received: by 2002:a63:b910:: with SMTP id z16mr7690969pge.358.1607622921713;
        Thu, 10 Dec 2020 09:55:21 -0800 (PST)
Received: from [10.230.29.166] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p15sm6969707pgl.19.2020.12.10.09.55.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 09:55:21 -0800 (PST)
Subject: Re: [PATCH] net/netconsole: Support VLAN for netconsole
To:     Libing Zhou <libing.zhou@nokia-sbell.com>, davem@davemloft.net,
        mingo@redhat.com, Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201210100742.8874-1-libing.zhou@nokia-sbell.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <40a77a26-9944-245e-cb16-6690221efbd0@gmail.com>
Date:   Thu, 10 Dec 2020 09:55:16 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201210100742.8874-1-libing.zhou@nokia-sbell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/10/2020 2:07 AM, Libing Zhou wrote:
> During kernel startup phase, current netconsole doesn’t support VLAN
> since there is no VLAN interface setup already.
> 
> This patch provides VLAN ID and PCP as optional boot/module parameters
> to support VLAN environment, thus kernel startup log can be retrieved
> via VLAN.
> 
> Signed-off-by: Libing Zhou <libing.zhou@nokia-sbell.com>
> ---
>  Documentation/networking/netconsole.rst | 10 ++++-
>  drivers/net/netconsole.c                |  3 +-
>  include/linux/netpoll.h                 |  3 ++
>  net/core/netpoll.c                      | 58 ++++++++++++++++++++++++-
>  4 files changed, 70 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/networking/netconsole.rst b/Documentation/networking/netconsole.rst
> index 1f5c4a04027c..a08387fcc3f0 100644
> --- a/Documentation/networking/netconsole.rst
> +++ b/Documentation/networking/netconsole.rst
> @@ -13,6 +13,8 @@ IPv6 support by Cong Wang <xiyou.wangcong@gmail.com>, Jan 1 2013
>  
>  Extended console support by Tejun Heo <tj@kernel.org>, May 1 2015
>  
> +VLAN support by Libing Zhou <libing.zhou@nokia-sbell.com>, Dec 8 2020
> +
>  Please send bug reports to Matt Mackall <mpm@selenic.com>
>  Satyam Sharma <satyam.sharma@gmail.com>, and Cong Wang <xiyou.wangcong@gmail.com>
>  
> @@ -34,7 +36,7 @@ Sender and receiver configuration:
>  It takes a string configuration parameter "netconsole" in the
>  following format::
>  
> - netconsole=[+][src-port]@[src-ip]/[<dev>],[tgt-port]@<tgt-ip>/[tgt-macaddr]
> + netconsole=[+][src-port]@[src-ip]/[<dev>],[tgt-port]@<tgt-ip>/[tgt-macaddr][-V<vid:pcp>]
>  
>     where
>  	+             if present, enable extended console support
> @@ -44,11 +46,17 @@ following format::
>  	tgt-port      port for logging agent (6666)
>  	tgt-ip        IP address for logging agent
>  	tgt-macaddr   ethernet MAC address for logging agent (broadcast)
> +	-V            if present, enable VLAN support
> +	vid:pcp       VLAN identifier and priority code point
>  
>  Examples::
>  
>   linux netconsole=4444@10.0.0.1/eth1,9353@10.0.0.2/12:34:56:78:9a:bc
>  
> +or using VLAN::
> +
> + linux netconsole=4444@10.0.0.1/eth1,9353@10.0.0.2/12:34:56:78:9a:bc-V100:1
> +
>  or::
>  
>   insmod netconsole netconsole=@/,@10.0.0.2/
> diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
> index 92001f7af380..f0690cd6a744 100644
> --- a/drivers/net/netconsole.c
> +++ b/drivers/net/netconsole.c
> @@ -36,7 +36,6 @@
>  #include <linux/inet.h>
>  #include <linux/configfs.h>
>  #include <linux/etherdevice.h>
> -
>  MODULE_AUTHOR("Maintainer: Matt Mackall <mpm@selenic.com>");
>  MODULE_DESCRIPTION("Console driver for network interfaces");
>  MODULE_LICENSE("GPL");
> @@ -46,7 +45,7 @@ MODULE_LICENSE("GPL");
>  
>  static char config[MAX_PARAM_LENGTH];
>  module_param_string(netconsole, config, MAX_PARAM_LENGTH, 0);
> -MODULE_PARM_DESC(netconsole, " netconsole=[src-port]@[src-ip]/[dev],[tgt-port]@<tgt-ip>/[tgt-macaddr]");
> +MODULE_PARM_DESC(netconsole, " netconsole=[src-port]@[src-ip]/[dev],[tgt-port]@<tgt-ip>/[tgt-macaddr][-V<vid:pcp>]");
>  
>  static bool oops_only = false;
>  module_param(oops_only, bool, 0600);
> diff --git a/include/linux/netpoll.h b/include/linux/netpoll.h
> index e6a2d72e0dc7..8ab3f25cadae 100644
> --- a/include/linux/netpoll.h
> +++ b/include/linux/netpoll.h
> @@ -31,6 +31,9 @@ struct netpoll {
>  	bool ipv6;
>  	u16 local_port, remote_port;
>  	u8 remote_mac[ETH_ALEN];
> +	bool vlan_present;
> +	u16 vlan_id;
> +	u8 pcp;
>  };
>  
>  struct netpoll_info {
> diff --git a/net/core/netpoll.c b/net/core/netpoll.c
> index 2338753e936b..077a7aec51ae 100644
> --- a/net/core/netpoll.c
> +++ b/net/core/netpoll.c
> @@ -478,6 +478,14 @@ void netpoll_send_udp(struct netpoll *np, const char *msg, int len)
>  
>  	skb->dev = np->dev;
>  
> +	if (np->vlan_present) {
> +		skb->vlan_proto = htons(ETH_P_8021Q);
> +
> +		/* htons for tci is done in __vlan_insert_inner_tag, not here */
> +		skb->vlan_tci = (np->pcp << VLAN_PRIO_SHIFT) + (np->vlan_id & VLAN_VID_MASK);
> +		skb->vlan_present = 1;
> +	}

This does not seem to be the way to go around this, I would rather
specifying eth0.<VID> on the netconsole parameters and automatically
create a VLAN interface from that which would ensure that everything
works properly and that the VLAN interface is linked to its lower device
properly.

If you prefer your current syntax, that is probably fine, too but you
should consider registering a VLAN device when you parse appropriate
options.
-- 
Florian
