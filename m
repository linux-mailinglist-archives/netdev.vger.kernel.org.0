Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96F03675F9
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 02:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343806AbhDVABA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 20:01:00 -0400
Received: from mail-ej1-f51.google.com ([209.85.218.51]:34494 "EHLO
        mail-ej1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbhDVAA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 20:00:57 -0400
Received: by mail-ej1-f51.google.com with SMTP id x12so45242662ejc.1;
        Wed, 21 Apr 2021 17:00:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2JL2V3NXWQBb90Vo2vfBCKJ+qrXt9jjeoFCM0+9Pju4=;
        b=uknmiXyDqOxsbLXClhY3Xaso76D8f9kGJATScB7oUdGdD6SrBeKxmoRLu3KK9r6Ri2
         KdNqsQuCVhBL0Z+Oa7Iipwu56h8fwjbA0k0A+FcgwpJq206YgHO/PjAcdRta5AwrdTiS
         HjbK7xF928wNrJZ3e5LLBk+nLzFAqJSojiEFgJBvwQF44Sn2V1yb1yURpnjtNNS6re12
         lIJzPcJfkF4f8xtczGSPx8nLBWBE0+Q0Oe6nwe+sx25V8Nyo10QrdrP/piE4QNUkyozu
         o6mQliAbvqwS64yuOqUNQVt9lJzx5+6Ek/Xjix9IoyAjEWgkEI7NsRRTlu4+JZy8Gh1v
         kXjw==
X-Gm-Message-State: AOAM530lQzD86IR9OIh94DyXeZMVIikKDplYzloIi8j1dWcI748LLI9/
        E7EZbMQkTR8BYzYEOeXWWSOT/7RVqOk=
X-Google-Smtp-Source: ABdhPJzQ+erOow4g+dooyi0nIoT8MkLLs1Srco76KRIRA37xQp412xwh7QMRV0pPPDykkYmEt5Sm6A==
X-Received: by 2002:a17:906:11d8:: with SMTP id o24mr402423eja.386.1619049623031;
        Wed, 21 Apr 2021 17:00:23 -0700 (PDT)
Received: from localhost (net-188-216-18-127.cust.vodafonedsl.it. [188.216.18.127])
        by smtp.gmail.com with ESMTPSA id g20sm624674edu.91.2021.04.21.17.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 17:00:21 -0700 (PDT)
Date:   Thu, 22 Apr 2021 01:59:57 +0200
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 126/190] Revert "net: openvswitch: fix a NULL pointer
 dereference"
Message-ID: <20210422015957.4f6d4dfa@linux.microsoft.com>
In-Reply-To: <20210421130105.1226686-127-gregkh@linuxfoundation.org>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
        <20210421130105.1226686-127-gregkh@linuxfoundation.org>
Organization: Microsoft
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Apr 2021 15:00:01 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This reverts commit 6f19893b644a9454d85e593b5e90914e7a72b7dd.
> 
> Commits from @umn.edu addresses have been found to be submitted in
> "bad faith" to try to test the kernel community's ability to review
> "known malicious" changes.  The result of these submissions can be
> found in a paper published at the 42nd IEEE Symposium on Security and
> Privacy entitled, "Open Source Insecurity: Stealthily Introducing
> Vulnerabilities via Hypocrite Commits" written by Qiushi Wu
> (University of Minnesota) and Kangjie Lu (University of Minnesota).
> 
> Because of this, all submissions from this group must be reverted from
> the kernel tree and will need to be re-reviewed again to determine if
> they actually are a valid fix.  Until that work is complete, remove
> this change to ensure that no problems are being introduced into the
> codebase.
> 
> Cc: Kangjie Lu <kjlu@umn.edu>
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/openvswitch/datapath.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 9d6ef6cb9b26..99e63f4bbcaf 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -443,10 +443,6 @@ static int queue_userspace_packet(struct
> datapath *dp, struct sk_buff *skb, 
>  	upcall = genlmsg_put(user_skb, 0, 0, &dp_packet_genl_family,
>  			     0, upcall_info->cmd);
> -	if (!upcall) {
> -		err = -EINVAL;
> -		goto out;
> -	}
>  	upcall->dp_ifindex = dp_ifindex;
>  
>  	err = ovs_nla_put_key(key, key, OVS_PACKET_ATTR_KEY, false,
> user_skb);

This patch seems good to me, but given the situation I'd like another
pair of eyes on it, at least.

Regards,
-- 
per aspera ad upstream
