Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93C2443E4D
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 09:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhKCIYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 04:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhKCIYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 04:24:38 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992ABC061714;
        Wed,  3 Nov 2021 01:22:02 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so873067pjl.2;
        Wed, 03 Nov 2021 01:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a/GNLPALkwGhXSrYcUSU/+LJnWVp6grMHuVzBxpcEmw=;
        b=bTmBb2iy82QYSSSNyvZQcNqDGtebZN8kR2NEI/H0GSud9PT7S4pYNpyoZqKfmTDOmK
         8pRRrYDimrVU7dQeMMHq1otsJE+n2rOFO4kaz2qo6N8r3J+odIFAL1Xs7j8c0tAkDIB4
         ORddHNoDsfMpGEvvjQMqJilDJ1k02hYIc+IVWBTEd16sX4KCysfvozxebPj1iWEvKsB7
         zusKhMbyrFqrsLe64syE95i0flXXS+z1FcttIQp6tAICI2F9htV7TIE5hKRRKFPO9/BW
         W9UwgO1QzaMGfafnrwIDL08ICa1T1FsH6BUgeM8rp4sxd2UaBY/cIeaQmOa83v7Vbx7q
         WZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a/GNLPALkwGhXSrYcUSU/+LJnWVp6grMHuVzBxpcEmw=;
        b=vS53GFysl0AaxycItka+g2y12DJxjf7yLxWiPjv/tDtAnief/5aENEKLR1GaTkUJWs
         r24T1LwoFZOOMoh8Z+lrb9/9Z3mfzaRA1d+Lg5dILijHf7nNpi7tek68P2UNuxS6zUFE
         b1dqLPmkV/pPdxM7Sc/p1M64DEqWvVmldT/fTr9IRMsMN8qQBTg/DLTPAqy5GJIz7fLA
         p2eDMPCJ80G2RQH/lo67Yo2GeUr7cZAXeJzUfPLt0AdTPsfsdWuznOyi3BjKbZY0XJH/
         SgkNgZt5T+th34Xmc40e1zk6Bq3bNbeJB4gQ/s/Rw8IRTofFyp1Hdi6ARPUtjq57gp4X
         j1jA==
X-Gm-Message-State: AOAM531XffrIDozmT0zf8ONxHZLzFno/QM5xj+t8S5+k1ea8WGIH5814
        Tt5eKMCYM+uvaoPJunlWw3UgN7nsM6g=
X-Google-Smtp-Source: ABdhPJzPMtLcFImQ1WrmTVNQjxgRPBpZUmaGBHr5bpkdBoJrfpU8aJcHGUNg4Nt/Fd3kKdsEN0/v2Q==
X-Received: by 2002:a17:902:c713:b0:141:bbb2:1ec7 with SMTP id p19-20020a170902c71300b00141bbb21ec7mr27591643plp.57.1635927721847;
        Wed, 03 Nov 2021 01:22:01 -0700 (PDT)
Received: from kakao-entui-MacBookPro.local ([203.246.171.161])
        by smtp.gmail.com with ESMTPSA id b1sm1246891pfv.110.2021.11.03.01.21.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 01:22:01 -0700 (PDT)
Subject: Re: [PATCH] amt: Remove duplicate include
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1635911107-63759-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <5c97b741-35d6-86bf-1007-8051a913b709@gmail.com>
Date:   Wed, 3 Nov 2021 17:21:58 +0900
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1635911107-63759-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ko
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiapeng,

On 2021. 11. 3. 오후 12:45, Jiapeng Chong wrote:
> Clean up the following includecheck warning:
> 
> ./drivers/net/amt.c: net/protocol.h is included more than once.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>   drivers/net/amt.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/amt.c b/drivers/net/amt.c
> index 60a7053..6697f8b 100644
> --- a/drivers/net/amt.c
> +++ b/drivers/net/amt.c
> @@ -12,7 +12,6 @@
>   #include <linux/igmp.h>
>   #include <linux/workqueue.h>
>   #include <net/net_namespace.h>
> -#include <net/protocol.h>
>   #include <net/ip.h>
>   #include <net/udp.h>
>   #include <net/udp_tunnel.h>
> 

target repo is "net-next".

Reviewed-by: Taehee Yoo <ap420073@gmail.com>
