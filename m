Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 086CD9CB68
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 10:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbfHZIRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 04:17:01 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42451 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbfHZIRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 04:17:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id b16so14361505wrq.9;
        Mon, 26 Aug 2019 01:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=74z3xC3VYXkmWGZRy7p/H1mcXDigxEXrzEQ/VRALV90=;
        b=t134rvZIqCmnE4kK/Anpve2nGoJbmL0iesSXud7v4ukoFsEU24csoNqYbD5s4SsFir
         4f7E5kJmjCIFLnhPRU+woyVShN4NrouLLpEUHhT44Xh5hShzrB1kimL0i1cUsMb4BHbB
         +nEkuY0r7dJZ03VdwDkfXX6tTU+T/LcVrazD0eeFNcIWIx01ccxsnEq2oLlyF3vwYvS+
         ZZpJxpTlYJLXDXWpyp9hbjpgKfs33nPJWjbcSE7LMrV2V0CKkbB9mnEWaRLrYiEz7fY5
         EgBnvWrGethXwXfFZASM4VLO66RwZC/wJuy1Wx5HZjmS6+KW176zjRdVAF98Sv/jljHP
         eZMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=74z3xC3VYXkmWGZRy7p/H1mcXDigxEXrzEQ/VRALV90=;
        b=rSzEoz6kCh2jIMmDI6KqBnPSyg0PHNfziphUZmA2SOr9HfRhEVQDl4Nu1/gAk4D4Wx
         0lsWTL+KgTo6RqpIjLVyK2KraC92+JLrdlIO9t3u/7uOMJfayg0glf4nRAhOv3f1wy2c
         gfaswvoLTYspqL/cDSKpT1Dnvu2PezUye+RMZpupV/QT/99gqcK6xKODmYDSNDOM5R3l
         IioXB51+H1/fiuv2wjz9MmPOSCPX+aVLnzWH6BKgixsjcT5KZV5TGajWzYXDRSb9y5tP
         npRgkHYpx436jVis4GVBeL+sWf4rOG2lJ74ybo+V8cPzOwqy/A37sRoWriHGwWCdXyNu
         tWfA==
X-Gm-Message-State: APjAAAW/MxxHxKVmZe1H3SgfjW66fP/DtVUNzWLhVE7nWgyI58M1KMUC
        a0HGxms3HEr26l/v3OXMRWhIZhtD
X-Google-Smtp-Source: APXvYqzT7TpOrHR1CFu32oOsdZKish5+16FKx5Gd0NcsENim33I574EURNQLyIKUAfie7c48Rv2Htg==
X-Received: by 2002:adf:e708:: with SMTP id c8mr21024163wrm.25.1566807418720;
        Mon, 26 Aug 2019 01:16:58 -0700 (PDT)
Received: from [192.168.8.147] (220.171.185.81.rev.sfr.net. [81.185.171.220])
        by smtp.gmail.com with ESMTPSA id 5sm9505091wmg.42.2019.08.26.01.16.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 01:16:58 -0700 (PDT)
Subject: Re: [PATCH] net: Adding parameter detection in
 __ethtool_get_link_ksettings.
To:     Dongxu Liu <liudongxu3@huawei.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190826072332.14736-1-liudongxu3@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <aa0a372e-a169-7d78-0782-505cbdab8f90@gmail.com>
Date:   Mon, 26 Aug 2019 10:16:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190826072332.14736-1-liudongxu3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/26/19 9:23 AM, Dongxu Liu wrote:
> The __ethtool_get_link_ksettings symbol will be exported,
> and external users may use an illegal address.
> We should check the parameters before using them,
> otherwise the system will crash.
> 
> [ 8980.991134] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [ 8980.993049] IP: [<ffffffff8155aca7>] __ethtool_get_link_ksettings+0x27/0x140
> [ 8980.994285] PGD 0
> [ 8980.995013] Oops: 0000 [#1] SMP
> [ 8980.995896] Modules linked in: sch_ingress ...
> [ 8981.013220] CPU: 3 PID: 25174 Comm: kworker/3:3 Tainted: G           O   ----V-------   3.10.0-327.36.58.4.x86_64 #1
> [ 8981.017667] Workqueue: events linkwatch_event
> [ 8981.018652] task: ffff8800a8348000 ti: ffff8800b045c000 task.ti: ffff8800b045c000
> [ 8981.020418] RIP: 0010:[<ffffffff8155aca7>]  [<ffffffff8155aca7>] __ethtool_get_link_ksettings+0x27/0x140
> [ 8981.022383] RSP: 0018:ffff8800b045fc88  EFLAGS: 00010202
> [ 8981.023453] RAX: 0000000000000000 RBX: ffff8800b045fcac RCX: 0000000000000000
> [ 8981.024726] RDX: ffff8800b658f600 RSI: ffff8800b045fcac RDI: ffff8802296e0000
> [ 8981.026000] RBP: ffff8800b045fc98 R08: 0000000000000000 R09: 0000000000000001
> [ 8981.027273] R10: 00000000000073e0 R11: 0000082b0cc8adea R12: ffff8802296e0000
> [ 8981.028561] R13: ffff8800b566e8c0 R14: ffff8800b658f600 R15: ffff8800b566e000
> [ 8981.029841] FS:  0000000000000000(0000) GS:ffff88023ed80000(0000) knlGS:0000000000000000
> [ 8981.031715] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 8981.032845] CR2: 0000000000000000 CR3: 00000000b39a9000 CR4: 00000000003407e0
> [ 8981.034137] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 8981.035427] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 8981.036702] Stack:
> [ 8981.037406]  ffff8800b658f600 0000000000009c40 ffff8800b045fce8 ffffffffa047a71d
> [ 8981.039238]  000000000000004d ffff8800b045fcc8 ffff8800b045fd28 ffffffff815cb198
> [ 8981.041070]  ffff8800b045fcd8 ffffffff810807e6 00000000e8212951 0000000000000001
> [ 8981.042910] Call Trace:
> [ 8981.043660]  [<ffffffffa047a71d>] bond_update_speed_duplex+0x3d/0x90 [bonding]
> [ 8981.045424]  [<ffffffff815cb198>] ? inetdev_event+0x38/0x530
> [ 8981.046554]  [<ffffffff810807e6>] ? put_online_cpus+0x56/0x80
> [ 8981.047688]  [<ffffffffa0480d67>] bond_netdev_event+0x137/0x360 [bonding]
> ...
> 
> Signed-off-by: Dongxu Liu <liudongxu3@huawei.com>
> ---
>  net/core/ethtool.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> index 6288e69..9a50b64 100644
> --- a/net/core/ethtool.c
> +++ b/net/core/ethtool.c
> @@ -545,6 +545,8 @@ int __ethtool_get_link_ksettings(struct net_device *dev,
>  {
>  	ASSERT_RTNL();
>  
> +	if (!dev || !dev->ethtool_ops)
> +		return -EOPNOTSUPP;

I do not believe dev can possibly be NULL at this point.

>  	if (!dev->ethtool_ops->get_link_ksettings)
>  		return -EOPNOTSUPP;
>  
> 

I tried to find an appropriate Fixes: tag.

It seems this particular bug was added either by

Fixes: 9856909c2abb ("net: bonding: use __ethtool_get_ksettings")

or generically in :

Fixes: 3f1ac7a700d0 ("net: ethtool: add new ETHTOOL_xLINKSETTINGS API")

