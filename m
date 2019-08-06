Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96D2F837C0
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732195AbfHFRPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:15:17 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34089 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728189AbfHFRPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:15:17 -0400
Received: by mail-qk1-f194.google.com with SMTP id t8so63477792qkt.1;
        Tue, 06 Aug 2019 10:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=4ETp3KDACY7J/KgmMynjvWyuPGRUs1Kf57shq9pOwbQ=;
        b=N1tVemlQ1uZQCsg9PxNkrnC/r3XUrVeg/zEtgWh0JJiiMJf7C9iRSMrVpEZvBJkuEl
         5DK/Y6nYTtUPitLqahaHLay7adP42zFYjdh3uLrk8lj/4QE01WVzH9XsycTM75J6/StK
         ZDTG+E0LpmvCLzp/qSmlxAcQe/IUid1PAHThA72eDOsG5HcWlUONjOa0mwy7zB2x+Roi
         alvE1RikovkKRZXcIE1dI2sIIVggLxy1SAdi8IPDChTqTFNZnx8C99gkkNvU/Aka9bYl
         7jrQEZjdjPra0BqzbmrMrC/4PfbKT2w2lXKU6f3zVXTkm0dTMDIr25IXg8ZOuG6VBU0A
         k7VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=4ETp3KDACY7J/KgmMynjvWyuPGRUs1Kf57shq9pOwbQ=;
        b=aA+XS4llcRZTlDrtaywXJGa76Cq9qhgBZiaUASVK8ucPuDi34vtka26GgYSuRu5rgu
         zls0vvt+quhttNODaYvcLAL+BSiyIkWfP7AxWtuNu+epi3dmKBlqR26zCrjiW3Ku8Qy6
         p1Sx/sqIozeImfgqACGqMuA6ZimPXY5cbp9jaa9JBflFks2qrr2JTO+6nc3r42F5r659
         JH2BMHo4wwEbW6umWy6QsSmoq5xBYi28RjC2mx8K/W8uS/gSvGS/gyErJuJLqImS/jup
         6g6lRi30gir+EZ0J368kMqrefhkWi7BoxNjv7E8BZntdBJYOSFLtla51bKqWW/cNweid
         YSEw==
X-Gm-Message-State: APjAAAW1PdWSW435PH/ggqofvxsTVfFN0JnnBTvXpR15NIB/86ZAbYs7
        sYPcr7QfhRSzXNQN22eJmRclwi3X
X-Google-Smtp-Source: APXvYqxFob69tzsh98NPvybxoKP7u40j8vHxvy/oDLks9hNpdI8xC5iNcOhAHGE3qKe+2u36tcMwmQ==
X-Received: by 2002:a37:490d:: with SMTP id w13mr4012485qka.179.1565111715675;
        Tue, 06 Aug 2019 10:15:15 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id q17sm34096809qtl.13.2019.08.06.10.15.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 10:15:14 -0700 (PDT)
Date:   Tue, 6 Aug 2019 13:15:13 -0400
Message-ID: <20190806131513.GB2822@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Chen-Yu Tsai <wens@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: dsa: Check existence of .port_mdb_add
 callback before calling it
In-Reply-To: <20190806075325.9011-1-wens@kernel.org>
References: <20190806075325.9011-1-wens@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chen-Yu,

On Tue,  6 Aug 2019 15:53:25 +0800, Chen-Yu Tsai <wens@kernel.org> wrote:
> From: Chen-Yu Tsai <wens@csie.org>
> 
> With the recent addition of commit 75dad2520fc3 ("net: dsa: b53: Disable
> all ports on setup"), users of b53 (BCM53125 on Lamobo R1 in my case)
> are forced to use the dsa subsystem to enable the switch, instead of
> having it in the default transparent "forward-to-all" mode.
> 
> The b53 driver does not support mdb bitmap functions. However the dsa
> layer does not check for the existence of the .port_mdb_add callback
> before actually using it. This results in a NULL pointer dereference,
> as shown in the kernel oops below.
> 
> The other functions seem to be properly guarded. Do the same for
> .port_mdb_add in dsa_switch_mdb_add_bitmap() as well.
> 
> b53 is not the only driver that doesn't support mdb bitmap functions.
> Others include bcm_sf2, dsa_loop, lantiq_gswip, mt7530, mv88e6060,
> qca8k, realtek-smi, and vitesse-vsc73xx.

I don't know what you mean by that, there's no "mdb bitmap function"
support for drivers, only the port_mdb_{prepare,add,del} callbacks...
> 
>     8<--- cut here ---
>     Unable to handle kernel NULL pointer dereference at virtual address 00000000
>     pgd = (ptrval)
>     [00000000] *pgd=00000000
>     Internal error: Oops: 80000005 [#1] SMP ARM
>     Modules linked in: rtl8xxxu rtl8192cu rtl_usb rtl8192c_common rtlwifi mac80211 cfg80211
>     CPU: 1 PID: 134 Comm: kworker/1:2 Not tainted 5.3.0-rc1-00247-gd3519030752a #1
>     Hardware name: Allwinner sun7i (A20) Family
>     Workqueue: events switchdev_deferred_process_work
>     PC is at 0x0
>     LR is at dsa_switch_event+0x570/0x620
>     pc : [<00000000>]    lr : [<c08533ec>]    psr: 80070013
>     sp : ee871db8  ip : 00000000  fp : ee98d0a4
>     r10: 0000000c  r9 : 00000008  r8 : ee89f710
>     r7 : ee98d040  r6 : ee98d088  r5 : c0f04c48  r4 : ee98d04c
>     r3 : 00000000  r2 : ee89f710  r1 : 00000008  r0 : ee98d040
>     Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
>     Control: 10c5387d  Table: 6deb406a  DAC: 00000051
>     Process kworker/1:2 (pid: 134, stack limit = 0x(ptrval))
>     Stack: (0xee871db8 to 0xee872000)
>     1da0:                                                       ee871e14 103ace2d
>     1dc0: 00000000 ffffffff 00000000 ee871e14 00000005 00000000 c08524a0 00000000
>     1de0: ffffe000 c014bdfc c0f04c48 ee871e98 c0f04c48 ee9e5000 c0851120 c014bef0
>     1e00: 00000000 b643aea2 ee9b4068 c08509a8 ee2bf940 ee89f710 ee871ecb 00000000
>     1e20: 00000008 103ace2d 00000000 c087e248 ee29c868 103ace2d 00000001 ffffffff
>     1e40: 00000000 ee871e98 00000006 00000000 c0fb2a50 c087e2d0 ffffffff c08523c4
>     1e60: ffffffff c014bdfc 00000006 c0fad2d0 ee871e98 ee89f710 00000000 c014c500
>     1e80: 00000000 ee89f3c0 c0f04c48 00000000 ee9e5000 c087dfb4 ee9e5000 00000000
>     1ea0: ee89f710 ee871ecb 00000001 103ace2d 00000000 c0f04c48 00000000 c087e0a8
>     1ec0: 00000000 efd9a3e0 0089f3c0 103ace2d ee89f700 ee89f710 ee9e5000 00000122
>     1ee0: 00000100 c087e130 ee89f700 c0fad2c8 c1003ef0 c087de4c 2e928000 c0fad2ec
>     1f00: c0fad2ec ee839580 ef7a62c0 ef7a9400 00000000 c087def8 c0fad2ec c01447dc
>     1f20: ef315640 ef7a62c0 00000008 ee839580 ee839594 ef7a62c0 00000008 c0f03d00
>     1f40: ef7a62d8 ef7a62c0 ffffe000 c0145b84 ffffe000 c0fb2420 c0bfaa8c 00000000
>     1f60: ffffe000 ee84b600 ee84b5c0 00000000 ee870000 ee839580 c0145b40 ef0e5ea4
>     1f80: ee84b61c c014a6f8 00000001 ee84b5c0 c014a5b0 00000000 00000000 00000000
>     1fa0: 00000000 00000000 00000000 c01010e8 00000000 00000000 00000000 00000000
>     1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>     1fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
>     [<c08533ec>] (dsa_switch_event) from [<c014bdfc>] (notifier_call_chain+0x48/0x84)
>     [<c014bdfc>] (notifier_call_chain) from [<c014bef0>] (raw_notifier_call_chain+0x18/0x20)
>     [<c014bef0>] (raw_notifier_call_chain) from [<c08509a8>] (dsa_port_mdb_add+0x48/0x74)
>     [<c08509a8>] (dsa_port_mdb_add) from [<c087e248>] (__switchdev_handle_port_obj_add+0x54/0xd4)
>     [<c087e248>] (__switchdev_handle_port_obj_add) from [<c087e2d0>] (switchdev_handle_port_obj_add+0x8/0x14)
>     [<c087e2d0>] (switchdev_handle_port_obj_add) from [<c08523c4>] (dsa_slave_switchdev_blocking_event+0x94/0xa4)
>     [<c08523c4>] (dsa_slave_switchdev_blocking_event) from [<c014bdfc>] (notifier_call_chain+0x48/0x84)
>     [<c014bdfc>] (notifier_call_chain) from [<c014c500>] (blocking_notifier_call_chain+0x50/0x68)
>     [<c014c500>] (blocking_notifier_call_chain) from [<c087dfb4>] (switchdev_port_obj_notify+0x44/0xa8)
>     [<c087dfb4>] (switchdev_port_obj_notify) from [<c087e0a8>] (switchdev_port_obj_add_now+0x90/0x104)
>     [<c087e0a8>] (switchdev_port_obj_add_now) from [<c087e130>] (switchdev_port_obj_add_deferred+0x14/0x5c)
>     [<c087e130>] (switchdev_port_obj_add_deferred) from [<c087de4c>] (switchdev_deferred_process+0x64/0x104)
>     [<c087de4c>] (switchdev_deferred_process) from [<c087def8>] (switchdev_deferred_process_work+0xc/0x14)
>     [<c087def8>] (switchdev_deferred_process_work) from [<c01447dc>] (process_one_work+0x218/0x50c)
>     [<c01447dc>] (process_one_work) from [<c0145b84>] (worker_thread+0x44/0x5bc)
>     [<c0145b84>] (worker_thread) from [<c014a6f8>] (kthread+0x148/0x150)
>     [<c014a6f8>] (kthread) from [<c01010e8>] (ret_from_fork+0x14/0x2c)
>     Exception stack(0xee871fb0 to 0xee871ff8)
>     1fa0:                                     00000000 00000000 00000000 00000000
>     1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>     1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
>     Code: bad PC value
>     ---[ end trace 1292c61abd17b130 ]---
> 
>     [<c08533ec>] (dsa_switch_event) from [<c014bdfc>] (notifier_call_chain+0x48/0x84)
>     corresponds to
> 
> 	$ arm-linux-gnueabihf-addr2line -C -i -e vmlinux c08533ec
> 
> 	linux/net/dsa/switch.c:156
> 	linux/net/dsa/switch.c:178
> 	linux/net/dsa/switch.c:328
> 
> Fixes: e6db98db8a95 ("net: dsa: add switch mdb bitmap functions")
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
> Changes since v1:
> 
>   - Moved the check to the beginning of dsa_switch_mdb_add()
> 
> Looks like we could also move the ops check out of
> dsa_switch_mdb_prepare_bitmap(), though I suppose keeping the code the
> way it is now is clearer.
> 
> ---
>  net/dsa/switch.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index 4ec5b7f85d51..231af5268656 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -164,6 +164,9 @@ static int dsa_switch_mdb_add(struct dsa_switch *ds,
>  	struct switchdev_trans *trans = info->trans;
>  	int port;
>  
> +	if (!ds->ops->port_mdb_add)
> +		return -EOPNOTSUPP;
> +
>  	/* Build a mask of Multicast group members */
>  	bitmap_zero(ds->bitmap, ds->num_ports);
>  	if (ds->index == info->sw_index)
> -- 
> 2.20.1
> 

I don't understand the crash here, nor the fix. dsa_switch_mdb_add()
is supposed to be called through switchdev with a prepare phase,
which checks for ds->ops->port_mdb_add. Do you mean that a switchdev
MDB object is added somewhere without a prepare phase? If that's
the case, this is what the commit message must say. Then the
ds->ops->port_mdb_add check must go where it is used, that is to say
at the beginning of dsa_switch_mdb_add_bitmap() (similarly to what
dsa_switch_mdb_prepare_bitmap() does), not in dsa_switch_mdb_add.


Thanks,

	Vivien
