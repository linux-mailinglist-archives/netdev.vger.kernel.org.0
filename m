Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33FC9374899
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 21:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbhEETVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 15:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbhEETVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 15:21:11 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1FBC061574;
        Wed,  5 May 2021 12:20:14 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id t22so2556816pgu.0;
        Wed, 05 May 2021 12:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=xG4CkhP31fGArm2BMLtxriorMyFvjtjk47bw7VlRKzQ=;
        b=UBuxliqgU/jcTAw8Kbd9hcrNymLe6XxzAsEDP+YUNx/iyLGwiZTYwSUtji6qySa0dP
         u5/02El2GJPArH/QIurSjD6FouToTFfNJtwLBvDQ2THi+pqwr4ThDXYBY8IxVYqdUWWE
         NzRKWM0xerpQeT63F3zhyi2MBXq+dyytCG/+LRdyjTQ2sjJo6xPrOLDACYVm9fzQtgUw
         6jD+XexWDjTqgoVT+5qQT/w+PfkIA49O9gQhi1qfipONMprQmcQjndtxkI8b01Ribhy1
         /PHkromTS+OOQ+0iiqYRstpDG+E26Eq9OAMlAKkuwUO7UbkxUUdqOgv5rhb+N8Yn+cP5
         y+tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=xG4CkhP31fGArm2BMLtxriorMyFvjtjk47bw7VlRKzQ=;
        b=Q/eRKgJuxFpnbvF41faGDwN5g0prYlMolIwZIjc9Xg2BzQrmaCLIFO3Wo9Fly3/jMc
         zdnGyAbIM82Uac59dm/hgJ40J6hUSA/DkDcbsRJYWwQ1/eXqLlO2efJwn7+Mgd1Zwpv0
         Uzu4HELyzWBHoK5SiZ9QSLVLX6XZaEODlc1Bw/HVQS63nuR3vzE81WGhLzdXNBcFP1Md
         qmj3cGHZw9P6vIAMMft8OJvAKEx0Bd/tyZY1o7MWE36lcd+Y7Ki2ubzgwGnShixstHSd
         OO3wwAw0tc0QgoQxOq6WNXQSQuqhV9cOVZaZXRdHmN8wnO2P5rkQlWuGkZrP44K7KO4Y
         nZBQ==
X-Gm-Message-State: AOAM533ZaM4pZnvTXIC/XOpubc7j4Gn7X3tbOvpu5QZfY35L8qlIt7Vj
        YZG9BevZcSrDiT8l/SD+36SE+hFyd/II4epvuT0=
X-Google-Smtp-Source: ABdhPJy39W09PsKtkxJu5IB4oPqjNz+pvbDgZJtRPBmayBoiMDJtBcUkUXuL7y4B/ZmXZRp4Y4rj+g==
X-Received: by 2002:a65:4286:: with SMTP id j6mr439992pgp.261.1620242414301;
        Wed, 05 May 2021 12:20:14 -0700 (PDT)
Received: from pallavi ([106.206.111.61])
        by smtp.gmail.com with ESMTPSA id b6sm73468pjk.13.2021.05.05.12.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 12:20:13 -0700 (PDT)
Date:   Thu, 6 May 2021 00:50:07 +0530
From:   Pallavi Prabhu <rpallaviprabhu@gmail.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ipv6: netfilter.c: fix missing line after declaration
Message-ID: <20210505192007.GA12080@pallavi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed a missing line after a declaration for proper coding style.

Signed-off-by: Pallavi Prabhu <rpallaviprabhu@gmail.com>
---
 net/ipv6/netfilter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index ab9a279dd6d4..7b1671f48593 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -81,6 +81,7 @@ static int nf_ip6_reroute(struct sk_buff *skb,
 
 	if (entry->state.hook == NF_INET_LOCAL_OUT) {
 		const struct ipv6hdr *iph = ipv6_hdr(skb);
+
 		if (!ipv6_addr_equal(&iph->daddr, &rt_info->daddr) ||
 		    !ipv6_addr_equal(&iph->saddr, &rt_info->saddr) ||
 		    skb->mark != rt_info->mark)
-- 
2.25.1

