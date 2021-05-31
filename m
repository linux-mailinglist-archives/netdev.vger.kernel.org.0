Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F56C39672E
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 19:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhEaRhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 13:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbhEaRgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 13:36:53 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1704FC053A05
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 09:43:37 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 131so15746541ljj.3
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 09:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=bVxqomzvYzAC27lmLx49Eta6obIy2vIrEL3zsEMbB2A=;
        b=FTfsBGb1Dk32XOBgJ+iCN6JN9JxjykoRv4nu8+Nau2dLtS/aVZiI2BAIlWUrxEHBFT
         NmWRAIy7mABRnOcN1i5dFKQyGt8x3MoRUZ4GBI+yC+yc9yyNLj+HxplEENXUeF0QOftm
         /rz9YvUfY827TODOitIWqRcUU5sVyIxAgQOsdJXLvRUgjV1GVvuPRYSt73+bo5Xr8sHi
         1cwgzN/mjlSCj1m/bN82sb0/J4amJyz/NsR1pS6YmTNUCJZYn4q1aO6Xs5gkjs2J5Je2
         i7ijY8mGf2eyCFMbLVD6Pvtt+mD0YJ15nqz0V9fsseUsoYZ3aUcFJ1IbH3/aA97Fedj/
         qO2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=bVxqomzvYzAC27lmLx49Eta6obIy2vIrEL3zsEMbB2A=;
        b=PKLVzrui/y1a+rRfaXVsQoD+6x8hbfL8uY5vvYJKy9ZDDnz0WbkqDvAC/SPEAWpBRB
         NdHAAsyNlkHqJDEVJqt24KyHZdF3IfXKri3m9tgymitvcq5p5wdVIx8KovqqTSd6OBEy
         NEbWMJStA+jKvy+BdncuunSWT8Cq6RlXuFAGe2ayFQIdkDFltV1kCw54Ce+KjM8nWc7S
         3pMgYV1++DRRbm5j/hwQYv6fQw1DdP6rX2zQUjJ+P4cgwkKPuOCzdCsqnx/U3GP0MuGQ
         QHNfUNTKANm3JszrI/sJCObfOWd6wTobpLn50XBC7leUy/KJERHtr4tMaGsFlG/6ES66
         iDGg==
X-Gm-Message-State: AOAM531e0Qr23qayJDB1bLF27Q9AO9BlJFbQe0/nmL/v8QFnggzPhM6s
        AUDZtowXXu6PA0Rqzn99WElBirWX3jkRTw==
X-Google-Smtp-Source: ABdhPJx8Bqu9lMcMc++Bcnwo3kg/7WjShVUfHWWyjOOF8DLBUcwzKCO/jCe95opNcrvYZ/24by/FWQ==
X-Received: by 2002:a05:651c:4c6:: with SMTP id e6mr17575531lji.326.1622479415106;
        Mon, 31 May 2021 09:43:35 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id n10sm1665671ljj.42.2021.05.31.09.43.34
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Mon, 31 May 2021 09:43:34 -0700 (PDT)
Message-ID: <60B514A0.1020701@gmail.com>
Date:   Mon, 31 May 2021 19:53:52 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     netdev <netdev@vger.kernel.org>
CC:     Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Realtek 8139 problem on 486.
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com> <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com> <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com> <60B41D00.8050801@gmail.com>
In-Reply-To: <60B41D00.8050801@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

31.05.2021 2:17, Nikolai Zhubr:
[...]
> However indeed, it seems a problem was introduced with a rework of
> interrupt handling (rtl8139_interrupt) in 2.6.3, because I have already
> pushed all other differences from 2.6.3 to 2.6.2 and it still keeps
> working fine.
> My resulting minimized diff is still ~300 lines, it is too big and
> complicated to be usefull to post here as is.

Some more input.

I was able to minimize the problematic diff to basically one screenfull, 
it is quite comprehencable now, and I'm including it below. It is the 
change in status/event handling due to a switch to NAPI that intruduced 
the problem.
Now, in some more detailed tests, I observe that _receiving_ still works 
fine. It is _sending_ that suffers, and apparently, only when trying to 
send a lot at a time. In such case I see these warnings:

NETDEV WATCHDOG: eth0: transmit timed out
eth0: link up, 100Mbps, full-duplex, lpa 0xC5E1

It looks like the queue of tx frames somehow gets messed up.

The essential diff fragment:
================================================
  	dev->open = rtl8139_open;
  	dev->hard_start_xmit = rtl8139_start_xmit;
+	dev->poll = rtl8139_poll;
  	dev->weight = 64;
  	dev->stop = rtl8139_close;
  	dev->get_stats = rtl8139_get_stats;
@@ -2015,7 +2010,7 @@
  			tp->stats.rx_bytes += pkt_size;
  			tp->stats.rx_packets++;

-			netif_rx (skb);
+			netif_receive_skb (skb);
  		} else {
  			if (net_ratelimit())
  				printk (KERN_WARNING
@@ -2138,10 +2133,8 @@
  	u16 status, ackstat;
  	int link_changed = 0; /* avoid bogus "uninit" warning */
  	int handled = 0;
-	int boguscnt = max_interrupt_work;

  	spin_lock (&tp->lock);
-	do {
  	status = RTL_R16 (IntrStatus);

  	/* shared irq? */
@@ -2169,8 +2162,14 @@
  	if (ackstat)
  		RTL_W16 (IntrStatus, ackstat);

-	if (netif_running (dev) && (status & RxAckBits))
-		rtl8139_rx (dev, tp, 1000000000);
+	/* Receive packets are processed by poll routine.
+	   If not running start it now. */
+	if (status & RxAckBits){
+		if (netif_rx_schedule_prep(dev)) {
+			RTL_W16_F (IntrMask, rtl8139_norx_intr_mask);
+			__netif_rx_schedule (dev);
+		}
+	}

  	/* Check uncommon events with one test. */
  	if (unlikely(status & (PCIErr | PCSTimeout | RxUnderrun | RxErr)))
@@ -2182,16 +2181,6 @@
  		if (status & TxErr)
  			RTL_W16 (IntrStatus, TxErr);
  	}
-	boguscnt--;
-	} while (boguscnt > 0);
-
================================================


Thank you,

Regards,
Nikolai



>
>
