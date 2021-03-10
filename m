Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5A43349AF
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhCJVOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbhCJVNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 16:13:52 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1DDC061574;
        Wed, 10 Mar 2021 13:13:52 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id t18so2338999pjs.3;
        Wed, 10 Mar 2021 13:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Skolmugct/C6AkZJfzCSNQoBwc2mDUq1YCjWpdexzGA=;
        b=B3Abr8kxMIWi2RcA6HrQcHZVu7e8PswDIa4w5MvmTUSAywK5blVflseYu6UguWjGqX
         ZInwUR9ex2QtUlNpEdZsb7CWdIzUJ7yIqhW5GYjrIpVDdS1SVk3GUw2W0rXWufOb8Kdv
         8Bln+5hB5lsuj4xrCHw7LKlkHV/DXlSQB7uJMJBKEOji7hoWYCmVpsk1tWtggyKQ8wQL
         tRByHnFZRb2829/pUQ1jAkow1t37lzvllJ5JlIpT/ah07hIquHvsiWyhseYsau+2hmWJ
         rYaxzhY1uSganvS3m9mZBxcPchblGQI+U8h/CO3PlVHAN+4o+0xc+hoivtskAW8quPcO
         MpdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Skolmugct/C6AkZJfzCSNQoBwc2mDUq1YCjWpdexzGA=;
        b=ZgZqkynb9Ie0lmUbOjQhRQgSHA2RmPOHeCPPJeAZfOnUANDuXrDBCQXHnDQBtfJxdT
         cQwO7Uw3hH+jDsH+SYQsWjNPmgzJSkqpspbSExmw7Y3TzDdJK6I3OIfuyH1KviLXgW4v
         5wh1mDyoVH3wajY2ag5ojjIzORD6x12m2RcWSH0xQ2o6Twtn1jjZEIefRn8aaA0RQ80I
         3F09H9NvZ4alXqndpqY3W2aS2wRLIQHlSJ25eRbKou3dbYqOqDquWEAWWizXbJmv4WqQ
         SZaodxDPyFLWfuAceA/Hge7Z0ESMKaeWrSkgtkUdOEBjVRsYkfuofTRzpt34G+s4AJ5D
         xCig==
X-Gm-Message-State: AOAM533A7oQHl+2E7zxQ/LZGvJfSnP6UgDoevv9ngZ2u+xXaxpIcuoKY
        IhxnYUnjF9NR3cBdzFWAnDM=
X-Google-Smtp-Source: ABdhPJywmvft8TIrJCD2T+ltjsu1giCMsULwm8FJFgkhaJ65VwNwAxFvv/Ao/r1EMwd2ONgmP15TQw==
X-Received: by 2002:a17:90a:bd90:: with SMTP id z16mr5591639pjr.123.1615410831676;
        Wed, 10 Mar 2021 13:13:51 -0800 (PST)
Received: from localhost ([122.179.55.249])
        by smtp.gmail.com with ESMTPSA id i10sm429131pgo.75.2021.03.10.13.13.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Mar 2021 13:13:51 -0800 (PST)
Date:   Thu, 11 Mar 2021 02:43:43 +0530
From:   Shubhankar Kuranagatti <shubhankarvk@gmail.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bkkarthik@pesu.pes.edu
Subject: [PATCH] net: ipv4: route.c: fix space before tab
Message-ID: <20210310211343.rpmffzhwhf7nogp7@kewl-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The extra space before tab space has been removed.

Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
---
 net/ipv4/route.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 02d81d79deeb..55f2813a000d 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -21,7 +21,7 @@
  *		Alan Cox	:	Added BSD route gw semantics
  *		Alan Cox	:	Super /proc >4K
  *		Alan Cox	:	MTU in route table
- *		Alan Cox	: 	MSS actually. Also added the window
+ *		Alan Cox	:	MSS actually. Also added the window
  *					clamper.
  *		Sam Lantinga	:	Fixed route matching in rt_del()
  *		Alan Cox	:	Routing cache support.
@@ -41,7 +41,7 @@
  *		Olaf Erb	:	irtt wasn't being copied right.
  *		Bjorn Ekwall	:	Kerneld route support.
  *		Alan Cox	:	Multicast fixed (I hope)
- * 		Pavel Krauz	:	Limited broadcast fixed
+ *		Pavel Krauz	:	Limited broadcast fixed
  *		Mike McLagan	:	Routing by source
  *	Alexey Kuznetsov	:	End of old history. Split to fib.c and
  *					route.c and rewritten from scratch.
@@ -54,8 +54,8 @@
  *	Robert Olsson		:	Added rt_cache statistics
  *	Arnaldo C. Melo		:	Convert proc stuff to seq_file
  *	Eric Dumazet		:	hashed spinlocks and rt_check_expire() fixes.
- * 	Ilia Sotnikov		:	Ignore TOS on PMTUD and Redirect
- * 	Ilia Sotnikov		:	Removed TOS from hash calculations
+ *	Ilia Sotnikov		:	Ignore TOS on PMTUD and Redirect
+ *	Ilia Sotnikov		:	Removed TOS from hash calculations
  */
 
 #define pr_fmt(fmt) "IPv4: " fmt
@@ -2246,7 +2246,7 @@ out:	return err;
 	if (res->type == RTN_UNREACHABLE) {
 		rth->dst.input= ip_error;
 		rth->dst.error= -err;
-		rth->rt_flags 	&= ~RTCF_LOCAL;
+		rth->rt_flags	&= ~RTCF_LOCAL;
 	}
 
 	if (do_cache) {
-- 
2.17.1

