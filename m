Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692A61AEAFB
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 10:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgDRItq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 04:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbgDRItp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 04:49:45 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0200C061A0F
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 01:49:44 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id r17so3758829lff.2
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 01:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6JMWvrxsDtQ9ilM24fbTzz0O+inwACTx3EExqxO39Rw=;
        b=OISfzco/7CbYk6TPPk7+8YkHWT0blNPM9zUkdIpx0Qwcb91aQ8KAPlbA1zypwbsk1X
         M2IZSiPc7vIA5BY/c5/Q6XHICoYSPN+TZEBsZEiE7wKPkt75cQFuTxVm90FsDNHQ9upB
         1kIJb0zrVXadd0IP81uRJbDdXjhWJnSwca5u0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6JMWvrxsDtQ9ilM24fbTzz0O+inwACTx3EExqxO39Rw=;
        b=pKR7cW8hTCKxDSewQe34rqPygEpLalyeC8Iyf6mU4aHpaxvEt1CfAG3NKksgP0YXYI
         Ecg7xq/63AHumXuKJadMXickW3x8BgpngFtMZMB8Uu2/Mo1T3pVsYPNr12LIptGLIpE3
         fXnHN4IG1AejVyeNC03KwPN8Vjp2jHxEv5CgUmbYZIL+nIU4AFUFJP7bhzt5fGtecUgZ
         WVtWCMl30rRdetaI03kClH3Fz/cz0xpaX1wUDCACAG0gn3NMw98MSYv7NZYEnZfze8Tx
         AvTwpfC5wN/xeI1KoIgxLCoJxfbddqZrBV6hJBY9gMGH+6KRPVS9KTrNdrc29m9vjUrO
         p4kA==
X-Gm-Message-State: AGi0PuZJsDmBvcD1NxPuEiLwEfyKIUk4s1RedcGT2RZiohVYvEblS44S
        JaILwir3N2Ys6NoUhA0GN5Kw8A==
X-Google-Smtp-Source: APiQypLmqj5OnHyqza8SkZR6WPy3NfrYePq3we7wW1P7M1KzfkUlSBdmRPPeRKHdNs15ql9bQ222dw==
X-Received: by 2002:a19:c1d3:: with SMTP id r202mr4454730lff.216.1587199783114;
        Sat, 18 Apr 2020 01:49:43 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 4sm10364947ljf.79.2020.04.18.01.49.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 01:49:42 -0700 (PDT)
Subject: Re: [RFC net-next v5 2/9] bridge: mrp: Update Kconfig and Makefile
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, davem@davemloft.net,
        jiri@resnulli.us, ivecera@redhat.com, kuba@kernel.org,
        roopa@cumulusnetworks.com, olteanv@gmail.com, andrew@lunn.ch,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, UNGLinuxDriver@microchip.com
References: <20200414112618.3644-1-horatiu.vultur@microchip.com>
 <20200414112618.3644-3-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <b53142fb-9dd3-7ead-7978-6ac5172c8791@cumulusnetworks.com>
Date:   Sat, 18 Apr 2020 11:49:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200414112618.3644-3-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/04/2020 14:26, Horatiu Vultur wrote:
> Add the option BRIDGE_MRP to allow to build in or not MRP support.
> The default value is N.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  net/bridge/Kconfig  | 12 ++++++++++++
>  net/bridge/Makefile |  2 ++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/net/bridge/Kconfig b/net/bridge/Kconfig
> index e4fb050e2078..51a6414145d2 100644
> --- a/net/bridge/Kconfig
> +++ b/net/bridge/Kconfig
> @@ -61,3 +61,15 @@ config BRIDGE_VLAN_FILTERING
>  	  Say N to exclude this support and reduce the binary size.
>  
>  	  If unsure, say Y.
> +
> +config BRIDGE_MRP
> +	bool "MRP protocol"
> +	depends on BRIDGE
> +	default n
> +	help
> +	  If you say Y here, then the Ethernet bridge will be able to run MRP
> +	  protocol to detect loops
> +
> +	  Say N to exclude this support and reduce the binary size.
> +
> +	  If unsure, say N.
> diff --git a/net/bridge/Makefile b/net/bridge/Makefile
> index 49da7ae6f077..9bf3e1be3328 100644
> --- a/net/bridge/Makefile
> +++ b/net/bridge/Makefile
> @@ -25,3 +25,5 @@ bridge-$(CONFIG_BRIDGE_VLAN_FILTERING) += br_vlan.o br_vlan_tunnel.o br_vlan_opt
>  bridge-$(CONFIG_NET_SWITCHDEV) += br_switchdev.o
>  
>  obj-$(CONFIG_NETFILTER) += netfilter/
> +
> +bridge-$(CONFIG_BRIDGE_MRP)	+= br_mrp.o br_mrp_netlink.o br_mrp_switchdev.o
> 

This is not bisectable, if you choose Y here you'll be missing some files.

