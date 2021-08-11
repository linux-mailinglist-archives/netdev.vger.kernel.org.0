Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B623E9986
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 22:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbhHKUPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 16:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbhHKUPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 16:15:14 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6E6C061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 13:14:50 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id t3so3783268qkg.11
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 13:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=PcvopykQh/3PtmhBCIlPZJdQReUFglDS3l8cV4U+sYw=;
        b=TiEwiEC8vwtPtlm+CDfI8GTaLGpgB2DB70/IJfvrh8heMyO8saE/INq2cdh041B2TV
         w7QtuqickjHjbSD0gK+5BsX4lPez9WF0NXiUk/JLv3zpsKdjTYlVhp9KZgJ+6J3TPP6D
         +s2IzMZB7P5v7TnX4nfSLXyIBprc0Y2YMLsdjIbJuv0zNtqlWVlgtuCVU2N05iUi2Gvd
         tCfHr5D+RmBHLM3KohdIkZMYpypdXQXcgDmKGiC2w3TRAuy8kagNzB1/fO64g8kdUYS+
         d7n3oJuR6I9k/engoarTGkNaMUbsh+Sbq/+tnCEooowERPYjH/BFNFPVDDFVpVLpf4qJ
         Wbvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=PcvopykQh/3PtmhBCIlPZJdQReUFglDS3l8cV4U+sYw=;
        b=kQZR0JIiCfs84dMFGV6fOE0TJ/SvV0DMTGCGEGHiizCnqYoh+3QQVSxSpxgEHCtudf
         av/mSOgywdj3lksyYQu2yAboDdch0OMD02PwEO+WZyGZDlQEX8FkU0eJQyAFoY3qC1Fo
         hCf4SYECWWsyd2NzarD2JKq52DGlpLuTUhkzzPR4FK5650V9KuvMMHMV5NfhYyoS/qJr
         tc3vHoaQPdf1QwS+hV/uaymGTfnBeytdwLsSGxyqL7oPcoMun2BmYRKptrwB9ugHtdnt
         3mMBqu0rhXDQkOEMJQoYrG8Dt85trpcdsu0fYLdbxEc1R5RIxNg0yRXAnr1wYXmTgVPp
         mnDw==
X-Gm-Message-State: AOAM530ApYNkCf+5zq+yDaE+yyynUOuqLQzKkKhi1w9uSQvWjXKsr8nZ
        3qbkoc88WHbm9DneqolDSuA=
X-Google-Smtp-Source: ABdhPJzlZNlm49lFNPUUP+tEf4CY2116IT9t4u1alTCL2vXaemWYxBmO17g2urpZOb9JKwr+iI7F3A==
X-Received: by 2002:a05:620a:13c2:: with SMTP id g2mr811728qkl.259.1628712889126;
        Wed, 11 Aug 2021 13:14:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 10sm116668qkv.135.2021.08.11.13.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 13:14:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 11 Aug 2021 13:14:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] net: igmp: increase size of mr_ifc_count
Message-ID: <20210811201446.GA1088467@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 12:57:15PM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Some arches support cmpxchg() on 4-byte and 8-byte only.
> Increase mr_ifc_count width to 32bit to fix this problem.
> 
> Fixes: 4a2b285e7e10 ("net: igmp: fix data-race in igmp_ifc_timer_expire()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Guenter Roeck <linux@roeck-us.net>

This patch fixes the build problems I had observed.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks,
Guenter

> ---
>  include/linux/inetdevice.h | 2 +-
>  net/ipv4/igmp.c            | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
> index 53aa0343bf694cb817e00ff597b52ce046e29d2c..aaf4f1b4c277c4ad38e1f0742bb480d3bb003287 100644
> --- a/include/linux/inetdevice.h
> +++ b/include/linux/inetdevice.h
> @@ -41,7 +41,7 @@ struct in_device {
>  	unsigned long		mr_qri;		/* Query Response Interval */
>  	unsigned char		mr_qrv;		/* Query Robustness Variable */
>  	unsigned char		mr_gq_running;
> -	unsigned char		mr_ifc_count;
> +	u32			mr_ifc_count;
>  	struct timer_list	mr_gq_timer;	/* general query timer */
>  	struct timer_list	mr_ifc_timer;	/* interface change timer */
>  
> diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
> index a51360087b19845a28408c827032e08dabf99838..00576bae183d30518e376ad3846d4fe6025aaea7 100644
> --- a/net/ipv4/igmp.c
> +++ b/net/ipv4/igmp.c
> @@ -803,7 +803,7 @@ static void igmp_gq_timer_expire(struct timer_list *t)
>  static void igmp_ifc_timer_expire(struct timer_list *t)
>  {
>  	struct in_device *in_dev = from_timer(in_dev, t, mr_ifc_timer);
> -	u8 mr_ifc_count;
> +	u32 mr_ifc_count;
>  
>  	igmpv3_send_cr(in_dev);
>  restart:
> -- 
> 2.32.0.605.g8dce9f2422-goog
> 
