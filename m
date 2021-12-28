Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9726480CC8
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 20:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237166AbhL1T0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 14:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237163AbhL1T0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 14:26:02 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802C9C061574;
        Tue, 28 Dec 2021 11:26:02 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id n10-20020a7bc5ca000000b00345c520d38eso10508338wmk.1;
        Tue, 28 Dec 2021 11:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=2vpugym1M5qAjGT2V5YgNmyvz4BSY6twefpMD7FFki0=;
        b=EVtyLosfcxQD0nqU1SWOcnBQUuMmQOEi4W5NE7/4sL/3zLoTfbB0Qb+hOIvy5bOHEB
         A9quK0LBPOykTTKcVWKgjqncDhEiytKwY/FqOgfxdVrUtfkWKtaHG15fPafweMcneeXM
         3xUdjP48v3882hqHl7jEixOAJnWpYcLEKYHZOZ54z24eUmAf4/M9I0ef+YdX8VkfOHxf
         bjjAFisabfiO2JFY3mUjZvCjlVMm6JnX9GKBu71XXxu7nPTfg2wYzaYIEs8z69sjctSp
         AyKx34Tw1HEQA/5LSBhf2+Q8H40gaoeQ9WMFFBHNfvTXSHB/QY1voSKccXXo2CoQUGjN
         j/yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=2vpugym1M5qAjGT2V5YgNmyvz4BSY6twefpMD7FFki0=;
        b=A8aqcgfh8V1HlFYBUWmvtIYmqQ1+ocT1E7zhblK87hGIt4GM0w+osVq09LohbV7hmF
         1C0V8Qgo97nS91uUSJDzh2rN0N3W5pwIAXTME1Il5O97rMk2pnmBVVdWew179GNIB83V
         3iq9Sxo7ypMY3spJaBRq/X4RmfYgpkvueSBaQhVtDVBPz9o++kcXGGbytcK+EcaHoIye
         93TNzHoO9r42Y8lLvpKYgFlb6rL3wFbz+FyGxgdTFdqtVZV66wqKPYQSleSHGQdBl735
         S5dsfEu2lDso2/IiraiiAOeyGHJYDYB7Il70tieakBPCNZvgsO/j4vcyfWl9TTTTK1rR
         Zelw==
X-Gm-Message-State: AOAM5328oajrLlDZbnveB8HSNPB8Jy4ZDb9fumW7W0cdXl74bpWbGRp/
        t/kEL2hGRUiVQpJSZKRYfdiybzwLBbo=
X-Google-Smtp-Source: ABdhPJyIGcr3GAYzNRieIyHZ0aGg5vMWPMmmpNRd119jNwAALdMiyvjTbcgigGMEt2P9VTnGnrjRFg==
X-Received: by 2002:a05:600c:4ec7:: with SMTP id g7mr18289275wmq.152.1640719561035;
        Tue, 28 Dec 2021 11:26:01 -0800 (PST)
Received: from ?IPV6:2003:ea:8f24:fd00:3128:feb5:7973:36af? (p200300ea8f24fd003128feb5797336af.dip0.t-ipconnect.de. [2003:ea:8f24:fd00:3128:feb5:7973:36af])
        by smtp.googlemail.com with ESMTPSA id m12sm20160274wrp.49.2021.12.28.11.26.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Dec 2021 11:26:00 -0800 (PST)
Message-ID: <da2cd97c-bd64-ebbd-549b-259ca56e3023@gmail.com>
Date:   Tue, 28 Dec 2021 20:25:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        kernel test robot <oliver.sang@intel.com>
Cc:     Michael Kelley <mikelley@microsoft.com>,
        Nishanth Menon <nm@ti.com>, Jason Gunthorpe <jgg@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        lkp@lists.01.org, lkp@intel.com, nic_swsd@realtek.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20211227150535.GA16252@xsang-OptiPlex-9020> <87czlgd14o.ffs@tglx>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [genirq/msi] 495c66aca3:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/mutex.c
In-Reply-To: <87czlgd14o.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.12.2021 19:40, Thomas Gleixner wrote:
> On Mon, Dec 27 2021 at 23:05, kernel test robot wrote:
>>
>> FYI, we noticed the following commit (built with gcc-9):
>>
>> commit: 495c66aca3da704e063fa373fdbe371e71d3f4ee ("genirq/msi: Convert to new functions")
>> https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git irq/msi
>> kern  :err   : [  126.209306] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:280
>> kern  :err   : [  126.209308] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 5183, name: ls
>> kern  :err   : [  126.209311] preempt_count: 2, expected: 0
>> kern  :warn  : [  126.209312] CPU: 2 PID: 5183 Comm: ls Not tainted 5.16.0-rc5-00091-g495c66aca3da #1
>> kern  :warn  : [  126.209315] Hardware name: Hewlett-Packard HP Pro 3340 MT/17A1, BIOS 8.07 01/24/2013
>> kern  :warn  : [  126.209316] Call Trace:
>> kern  :warn  : [  126.209318]  <TASK>
>> kern :warn : [  126.209319] dump_stack_lvl (lib/dump_stack.c:107) 
>> kern :warn : [  126.209323] __might_resched.cold (kernel/sched/core.c:9539 kernel/sched/core.c:9492) 
>> kern :warn : [  126.209326] ? kasan_unpoison (mm/kasan/shadow.c:108 mm/kasan/shadow.c:142) 
>> kern :warn : [  126.209330] mutex_lock (kernel/locking/mutex.c:280) 
>> kern :warn : [  126.209335] ? __mutex_lock_slowpath (kernel/locking/mutex.c:279) 
>> kern :warn : [  126.209339] ? _raw_spin_lock_irqsave (arch/x86/include/asm/atomic.h:202 include/linux/atomic/atomic-instrumented.h:513 include/asm-generic/qspinlock.h:82 include/linux/spinlock.h:185 include/linux/spinlock_api_smp.h:111 kernel/locking/spinlock.c:162) 
>> kern :warn : [  126.209342] ? _raw_read_unlock_irqrestore (kernel/locking/spinlock.c:161) 
>> kern :warn : [  126.209344] msi_get_virq (kernel/irq/msi.c:332) 
>> kern :warn : [  126.209349] pci_irq_vector (drivers/pci/msi/msi.c:1085 drivers/pci/msi/msi.c:1077) 
>> kern :warn : [  126.209354] rtl8169_netpoll (drivers/net/ethernet/realtek/r8169_main.c:4722) 
>> kern :warn : [  126.209358] netpoll_poll_dev (net/core/netpoll.c:166 net/core/netpoll.c:195) 
>> kern :warn : [  126.209363] netpoll_send_skb (net/core/netpoll.c:350 net/core/netpoll.c:376) 
>> kern :warn : [  126.209367] write_msg (drivers/net/netconsole.c:862 drivers/net/netconsole.c:836) netconsole
> 
> Fix below.
> 
> Thanks,
> 
>         tglx
> ---
>  drivers/net/ethernet/realtek/r8169_main.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -615,6 +615,7 @@ struct rtl8169_private {
>  	struct ring_info tx_skb[NUM_TX_DESC];	/* Tx data buffers */
>  	u16 cp_cmd;
>  	u32 irq_mask;
> +	int irq;
>  	struct clk *clk;
>  
>  	struct {
> @@ -4698,7 +4699,7 @@ static int rtl8169_close(struct net_devi
>  
>  	cancel_work_sync(&tp->wk.work);
>  
> -	free_irq(pci_irq_vector(pdev, 0), tp);
> +	free_irq(tp->irq, tp);
>  
>  	phy_disconnect(tp->phydev);
>  
> @@ -4719,7 +4720,7 @@ static void rtl8169_netpoll(struct net_d
>  {
>  	struct rtl8169_private *tp = netdev_priv(dev);
>  
> -	rtl8169_interrupt(pci_irq_vector(tp->pci_dev, 0), tp);
> +	rtl8169_interrupt(tp->irq, tp);
>  }
>  #endif
>  
> @@ -4753,8 +4754,7 @@ static int rtl_open(struct net_device *d
>  	rtl_request_firmware(tp);
>  
>  	irqflags = pci_dev_msi_enabled(pdev) ? IRQF_NO_THREAD : IRQF_SHARED;
> -	retval = request_irq(pci_irq_vector(pdev, 0), rtl8169_interrupt,
> -			     irqflags, dev->name, tp);
> +	retval = request_irq(tp->irq, rtl8169_interrupt, irqflags, dev->name, tp);
>  	if (retval < 0)
>  		goto err_release_fw_2;
>  
> @@ -4771,7 +4771,7 @@ static int rtl_open(struct net_device *d
>  	return retval;
>  
>  err_free_irq:
> -	free_irq(pci_irq_vector(pdev, 0), tp);
> +	free_irq(tp->irq, tp);
>  err_release_fw_2:
>  	rtl_release_firmware(tp);
>  	rtl8169_rx_clear(tp);
> @@ -5341,6 +5341,7 @@ static int rtl_init_one(struct pci_dev *
>  		dev_err(&pdev->dev, "Can't allocate interrupt\n");
>  		return rc;
>  	}
> +	tp->irq = pci_irq_vector(pdev, 0);
>  
>  	INIT_WORK(&tp->wk.work, rtl_task);
>  
> @@ -5416,8 +5417,7 @@ static int rtl_init_one(struct pci_dev *
>  		return rc;
>  
>  	netdev_info(dev, "%s, %pM, XID %03x, IRQ %d\n",
> -		    rtl_chip_infos[chipset].name, dev->dev_addr, xid,
> -		    pci_irq_vector(pdev, 0));
> +		    rtl_chip_infos[chipset].name, dev->dev_addr, xid, tp->irq);
>  
>  	if (jumbo_max)
>  		netdev_info(dev, "jumbo features [frames: %d bytes, tx checksumming: %s]\n",

Thanks for the patch, I'll submit it with your SoB.

Apart from pci_irq_vector() incl. underlying msi_get_virq(), are there more functions
that must not be called from atomic context any longer? Maybe the new constraint
should be added to kernel-doc of affected functions?
