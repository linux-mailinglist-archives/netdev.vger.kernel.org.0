Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F421C878B
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 13:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgEGLG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 07:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgEGLG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 07:06:27 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A8DC05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 04:06:25 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id 188so4095517lfa.10
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 04:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MQs6yIrKvyzos8MjJCet7P+baRzk4bTFuPxV4WLxdUQ=;
        b=OTZikvhEK6QYFupO4joDEcys6ZAiOBBbpLganygHOvX3CHBCS6XF/Zfahi3gdEeuCd
         6A5aBfqmUUChRYLf4iW3UcvjJV48yZ7ZwjLFV1UH1WmD85wz5CouKH66nNjtyAM9qw2m
         wmBnX+Ztyz7U5WlXFYu2BAyFUaZBNl8kPuD+Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MQs6yIrKvyzos8MjJCet7P+baRzk4bTFuPxV4WLxdUQ=;
        b=PsPFN+OVo84RCaZPumdpt8A9jbt0G3gk29owyTANpPeP7cHI5rjk8mxmeqGwE0u5ij
         k+gKlrKEJuLD5CJChThBjuYpZ4vUFVQcV6h+A1TkmDWELR8QnPPAtzK0n7ZcQFnZVN3j
         jXLFJhywlhP90pZjLr61Dk22WCIZxSf06JI6eNQhtPAQzAj6FzvVUd1n4FlL7gBkX5vA
         ipVCoRODyP9PxYAA/i1J0AkqbwRR5ekq2SNRg4XadeZnksV28/a04mIaDlDtVs9KWly7
         u1MR+Lt+KSLFtOJtvxcMGZP1vzN3hrijBKE9vobLmh8TezvtyN2KabO3XmEvSDZUFdQA
         aUOw==
X-Gm-Message-State: AGi0PuaRzE3pgIeVAgrzpfSmV1r+39VP5QMf6AIh/kpsCaURStkCFFSw
        rgqU0anODKtPiQ9toaaxjiIFctoSjL/mag==
X-Google-Smtp-Source: APiQypIkSRBpNZQXcj2cfQH18HDKLx0bwGM9/LC4asCtFbvjv57zr5ulHQ05h2V0fad0INRDUPbASw==
X-Received: by 2002:ac2:5691:: with SMTP id 17mr8676103lfr.128.1588849584060;
        Thu, 07 May 2020 04:06:24 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x83sm3604401lfa.65.2020.05.07.04.06.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 04:06:23 -0700 (PDT)
Subject: Re: [PATCH] bridge: increase mtu to 64K
To:     Michael Braun <michael-dev@fami-braun.de>, netdev@vger.kernel.org
Cc:     Li RongQing <roy.qing.li@gmail.com>
References: <aa8b1f36e80728f6fae31d98ba990a2b509b1e34.1588847509.git.michael-dev@fami-braun.de>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <5e214486-5e65-36ce-5145-b3cb77a81503@cumulusnetworks.com>
Date:   Thu, 7 May 2020 14:06:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <aa8b1f36e80728f6fae31d98ba990a2b509b1e34.1588847509.git.michael-dev@fami-braun.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/05/2020 13:32, Michael Braun wrote:
> A linux bridge always adopts the smallest MTU of the enslaved devices.
> When no device are enslaved, it defaults to a MTU of 1500 and refuses to
> use a larger one. This is problematic when using bridges enslaving only
> virtual NICs (vnetX) like it's common with KVM guests.
> 
> Steps to reproduce the problem
> 
> 1) sudo ip link add br-test0 type bridge # create an empty bridge
> 2) sudo ip link set br-test0 mtu 9000 # attempt to set MTU > 1500
> 3) ip link show dev br-test0 # confirm MTU
> 
> Here, 2) returns "RTNETLINK answers: Invalid argument". One (cumbersome)
> way around this is:
> 
> 4) sudo modprobe dummy
> 5) sudo ip link set dummy0 mtu 9000 master br-test0
> 
> Then the bridge's MTU can be changed from anywhere to 9000.
> 
> This is especially annoying for the virtualization case because the
> KVM's tap driver will by default adopt the bridge's MTU on startup
> making it impossible (without the workaround) to use a large MTU on the
> guest VMs.
> 

Hi Michael,
That isn't correct, have you tested with a recent kernel?
After:
commit 804b854d374e
Author: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date:   Fri Mar 30 13:46:19 2018 +0300

    net: bridge: disable bridge MTU auto tuning if it was set manually

You can set the bridge MTU to anything before adding ports.

E.g.:
$ ip l add br1 type bridge
$ ip l set br1 mtu 65000
$ ip l sh dev br1
12: br1: <BROADCAST,MULTICAST> mtu 65000 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether b6:ad:91:dc:5f:39 brd ff:ff:ff:ff:ff:ff

And a second one (ens17, ens18 with MTU 1500, br0 new with MTU 1500):
$ ip l set ens17 master br0
$ ip l set ens18 master br0
$ ip l set br0 mtu 65000
$ ip l sh dev br0
11: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 65000 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether fe:ed:3f:df:94:1f brd ff:ff:ff:ff:ff:ff
$ ip l sh dev ens17
8: ens17: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master br0 state UP mode DEFAULT group default qlen 1000
    link/ether 52:54:00:23:5f:13 brd ff:ff:ff:ff:ff:ff

 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1399064
> 
> Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
> Reported-by: Li RongQing <roy.qing.li@gmail.com>
> 
> --
> If found https://patchwork.ozlabs.org/project/netdev/patch/1456133351-10292-1-git-send-email-roy.qing.li@gmail.com/
> but I am missing any follow up. So here comes a refresh patch that
> addresses the issue raised.
> ---
>  net/bridge/br_if.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> index 4fe30b182ee7..f14e7d2329bd 100644
> --- a/net/bridge/br_if.c
> +++ b/net/bridge/br_if.c
> @@ -496,7 +496,7 @@ static int br_mtu_min(const struct net_bridge *br)
>  		if (!ret_mtu || ret_mtu > p->dev->mtu)
>  			ret_mtu = p->dev->mtu;
>  
> -	return ret_mtu ? ret_mtu : ETH_DATA_LEN;
> +	return ret_mtu ? ret_mtu : (64 * 1024);
>  }
>  
>  void br_mtu_auto_adjust(struct net_bridge *br)
> 
Please CC bridge maintainers on bridge patches.
Note that there's a mechanism in the bridge to disable auto-MTU tuning if the user *changes*
the MTU manually (it's important the MTU actually changes by the op). The auto-tuning has
been a constant headache.

The patch also has a problem - it sets the MTU over ETH_MAX_MTU (65535).

Cheers,
 Nik
