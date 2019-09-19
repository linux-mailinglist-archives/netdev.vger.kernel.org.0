Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E30FB833B
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 23:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390366AbfISVWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 17:22:07 -0400
Received: from vulcan.natalenko.name ([104.207.131.136]:57666 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389506AbfISVWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 17:22:06 -0400
Received: from mail.natalenko.name (vulcan.natalenko.name [IPv6:fe80::5400:ff:fe0c:dfa0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 7C7A75E280C;
        Thu, 19 Sep 2019 23:22:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1568928123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nvfXNPCQg7B581+MslvcoEWLTwJp2jXTw915+YqYF0w=;
        b=i+KmjjbSSriAGy62TJ1qhcGVNLO3g7OTsgglPkt+ylvBzx6jO8DN1KJC1G2E6e9r6WBPpC
        7jhQtsboDmL2YJti9HlWuBCv+SX3r9pn1DrTs5XWew3eOCy59rO0cShMGjnGs1VIXrHqRR
        5WsU9Sl7rOlJFZMVm7RfAOz1hR8C9w0=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 19 Sep 2019 23:22:03 +0200
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     linux-mediatek@lists.infradead.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Roy Luo <royluo@google.com>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: mt76x2e hardware restart
In-Reply-To: <deaafa7a3e9ea2111ebb5106430849c6@natalenko.name>
References: <deaafa7a3e9ea2111ebb5106430849c6@natalenko.name>
Message-ID: <c6d621759c190f7810d898765115f3b4@natalenko.name>
X-Sender: oleksandr@natalenko.name
User-Agent: Roundcube Webmail/1.3.10
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=arc-20170712; t=1568928123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nvfXNPCQg7B581+MslvcoEWLTwJp2jXTw915+YqYF0w=;
        b=ETc2q7YURCqlrETsKKeQkoPlDZrCqCFYY89AXGwPNhu+uYOEQZFte02NHPleOvqNzi05+G
        48LhJrMbwsTLyDxU3rcisz7iw7H9EfnL0KLSfhvwRodWvQW3eHZFlcgZe9OdbYoM9Qg9Pg
        TSghhu0PLaDijtfAcg83a9yrI4P0ook=
ARC-Seal: i=1; s=arc-20170712; d=natalenko.name; t=1568928123; a=rsa-sha256;
        cv=none;
        b=FDKorXnDcAKDb8+CrT3w5/PyCrZwO9676UXdBc0WwqcyPOB/xTGw21uNIzbPGPSOJYQNCm
        z5viRpMuMdaOVmBOTY+aor9YJhQf0kk6lmyVVvh1uRubEjaYOfnyqCYmJGq9C6JaDhCIiY
        uJj764/pFLr/8vhgqNFjwIDtuc4v+/8=
ARC-Authentication-Results: i=1;
        vulcan.natalenko.name;
        auth=pass smtp.auth=oleksandr@natalenko.name smtp.mailfrom=oleksandr@natalenko.name
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.09.2019 18:24, Oleksandr Natalenko wrote:
> [  +9,979664] mt76x2e 0000:01:00.0: Firmware Version: 0.0.00
> [  +0,000014] mt76x2e 0000:01:00.0: Build: 1
> [  +0,000010] mt76x2e 0000:01:00.0: Build Time: 201507311614____
> [  +0,018017] mt76x2e 0000:01:00.0: Firmware running!
> [  +0,001101] ieee80211 phy4: Hardware restart was requested

IIUC, this happens due to watchdog. I think the following applies.

Watchdog is started here:

=== mt76x02_util.c
130 void mt76x02_init_device(struct mt76x02_dev *dev)
131 {
...
155         INIT_DELAYED_WORK(&dev->wdt_work, mt76x02_wdt_work);
===

It checks for TX hang here:

=== mt76x02_mmio.c
557 void mt76x02_wdt_work(struct work_struct *work)
558 {
...
562     mt76x02_check_tx_hang(dev);
===

Conditions:

=== mt76x02_mmio.c
530 static void mt76x02_check_tx_hang(struct mt76x02_dev *dev)
531 {
532     if (mt76x02_tx_hang(dev)) {
533         if (++dev->tx_hang_check >= MT_TX_HANG_TH)
534             goto restart;
535     } else {
536         dev->tx_hang_check = 0;
537     }
538
539     if (dev->mcu_timeout)
540         goto restart;
541
542     return;
543
544 restart:
545     mt76x02_watchdog_reset(dev);
===

Actual check:

=== mt76x02_mmio.c
367 static bool mt76x02_tx_hang(struct mt76x02_dev *dev)
368 {
369     u32 dma_idx, prev_dma_idx;
370     struct mt76_queue *q;
371     int i;
372
373     for (i = 0; i < 4; i++) {
374         q = dev->mt76.q_tx[i].q;
375
376         if (!q->queued)
377             continue;
378
379         prev_dma_idx = dev->mt76.tx_dma_idx[i];
380         dma_idx = readl(&q->regs->dma_idx);
381         dev->mt76.tx_dma_idx[i] = dma_idx;
382
383         if (prev_dma_idx == dma_idx)
384             break;
385     }
386
387     return i < 4;
388 }
===

(I don't quite understand what it does here; why 4? does each device 
have 4 queues? maybe, my does not? I guess this is where watchdog is 
triggered, though, because otherwise I'd see mcu_timeout message like 
"MCU message %d (seq %d) timed out\n")

Once it detects TX hang, the reset is triggered:

=== mt76x02_mmio.c
446 static void mt76x02_watchdog_reset(struct mt76x02_dev *dev)
447 {
...
485     if (restart)
486         mt76_mcu_restart(dev);
===

mt76_mcu_restart() is just a define for this series here:

=== mt76.h
555 #define mt76_mcu_restart(dev, ...)  
(dev)->mt76.mcu_ops->mcu_restart(&((dev)->mt76))
===

Actual OP:

=== mt76x2/pci_mcu.c
188 int mt76x2_mcu_init(struct mt76x02_dev *dev)
189 {
190     static const struct mt76_mcu_ops mt76x2_mcu_ops = {
191         .mcu_restart = mt76pci_mcu_restart,
192         .mcu_send_msg = mt76x02_mcu_msg_send,
193     };
===

This triggers loading the firmware:

=== mt76x2/pci_mcu.c
168 static int
169 mt76pci_mcu_restart(struct mt76_dev *mdev)
170 {
...
179     ret = mt76pci_load_firmware(dev);
===

which does the printout I observe:

=== mt76x2/pci_mcu.c
  91 static int
  92 mt76pci_load_firmware(struct mt76x02_dev *dev)
  93 {
...
156     dev_info(dev->mt76.dev, "Firmware running!\n");
===

Too bad it doesn't show the actual watchdog message, IOW, why the reset 
happens. I guess I will have to insert some pr_infos here and there.

Does it make sense? Any ideas why this can happen?

More info on the device during boot:

===
[  +0,333233] mt76x2e 0000:01:00.0: enabling device (0000 -> 0002)
[  +0,000571] mt76x2e 0000:01:00.0: ASIC revision: 76120044
[  +0,017806] mt76x2e 0000:01:00.0: ROM patch build: 20141115060606a
===

-- 
   Oleksandr Natalenko (post-factum)
