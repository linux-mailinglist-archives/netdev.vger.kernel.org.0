Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC95310D44E
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 11:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfK2KmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 05:42:00 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35983 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfK2KmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 05:42:00 -0500
Received: by mail-lf1-f68.google.com with SMTP id f16so22287679lfm.3;
        Fri, 29 Nov 2019 02:41:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9IFwWmBmi/1OdpD2XZHJJ9k8jpfII5eBy+ZRCMvfvYg=;
        b=RrvOUdhpMkGMPmLbYiZfwTtPNjWioe+cvzEMjZ5SsUZMIh/Cpty5tcxFqOLDb7sW/8
         30gB7fKXBgYCHQtERf1wHzxM7kfvI+zmsoG0Tgl15iaubQ8ohqkRV5Mk7p0xHQmfERAL
         NJvJtJkKee0wHIk7SNNGxJ8/rdEBF0noRx/0ZVwgoaPQZmpwbB+EshYoPlUCoh1YtPJM
         vug0lgMG+6cWY0XBVFaosQm9l/qbr0HXAkavJ+7wIxCPHe48/ZwPx70qX4VHEGJeX5Eg
         QGxGR+dfah9AVrMPQhESGiJUPT+0o+5LcA34yKAnf8eoziEA1ofwKDoMf3jtMxykz9Ub
         5t3A==
X-Gm-Message-State: APjAAAX5Ty4GV6PgN1ChZsaU8wWL374s/aQNY6RDaTq3wTClqwnuiBuy
        SJwHsVBbslbs9NOnb+Lphew=
X-Google-Smtp-Source: APXvYqx1SU7zLlEgJN39+4gg+ASZMp4edUhTgvKEJwqTLCoUnb5jfITamqqFUCFM8uouKE8FwRAOCw==
X-Received: by 2002:ac2:410a:: with SMTP id b10mr7900815lfi.135.1575024115425;
        Fri, 29 Nov 2019 02:41:55 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id w11sm11368345lji.45.2019.11.29.02.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 02:41:54 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1iadim-0007cb-Rg; Fri, 29 Nov 2019 11:41:56 +0100
Date:   Fri, 29 Nov 2019 11:41:56 +0100
From:   Johan Hovold <johan@kernel.org>
To:     syzbot <syzbot+1d1597a5aa3679c65b9f@syzkaller.appspotmail.com>
Cc:     amitkarwar@gmail.com, andreyknvl@google.com, davem@davemloft.net,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, siva8118@gmail.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: WARNING: ODEBUG bug in rsi_probe
Message-ID: <20191129104156.GH29518@localhost>
References: <00000000000024bbd7058682eda1@google.com>
 <00000000000080e9260586ead5b5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000080e9260586ead5b5@google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 19, 2019 at 04:54:06PM -0700, syzbot wrote:
> syzbot has found a reproducer for the following crash on:
> 
> HEAD commit:    d34f9519 usb-fuzzer: main usb gadget fuzzer driver
> git tree:       https://github.com/google/kasan/tree/usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=13431e7b200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c73d1bb5aeaeae20
> dashboard link: https://syzkaller.appspot.com/bug?extid=1d1597a5aa3679c65b9f
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12534fdd200000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147c9247200000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+1d1597a5aa3679c65b9f@syzkaller.appspotmail.com
> 
> rsi_91x: rsi_load_firmware: REGOUT read failed
> rsi_91x: rsi_hal_device_init: Failed to load TA instructions
> rsi_91x: rsi_probe: Failed in device init
> ------------[ cut here ]------------
> ODEBUG: free active (active state 0) object type: timer_list hint:  
> bl_cmd_timeout+0x0/0x50 drivers/net/wireless/rsi/rsi_91x_hal.c:577
> WARNING: CPU: 0 PID: 563 at lib/debugobjects.c:325  
> debug_print_object+0x162/0x250 lib/debugobjects.c:325
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 0 PID: 563 Comm: kworker/0:2 Not tainted 5.1.0-rc5-319617-gd34f951 #4
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
> Google 01/01/2011
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0xe8/0x16e lib/dump_stack.c:113
>   panic+0x29d/0x5f2 kernel/panic.c:214
>   __warn.cold+0x20/0x48 kernel/panic.c:571
>   report_bug+0x262/0x2a0 lib/bug.c:186
>   fixup_bug arch/x86/kernel/traps.c:179 [inline]
>   fixup_bug arch/x86/kernel/traps.c:174 [inline]
>   do_error_trap+0x130/0x1f0 arch/x86/kernel/traps.c:272
>   do_invalid_op+0x37/0x40 arch/x86/kernel/traps.c:291
>   invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:973
> RIP: 0010:debug_print_object+0x162/0x250 lib/debugobjects.c:325
> Code: dd c0 a8 b3 8e 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 bf 00 00 00 48  
> 8b 14 dd c0 a8 b3 8e 48 c7 c7 40 9d b3 8e e8 8e c3 d2 fd <0f> 0b 83 05 f9  
> 0f 5a 10 01 48 83 c4 20 5b 5d 41 5c 41 5d c3 48 89
> RSP: 0018:ffff88809e1ef110 EFLAGS: 00010086
> RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff815b1d22 RDI: ffffed1013c3de14
> RBP: 0000000000000001 R08: ffff88809e1cb100 R09: ffffed1015a03edb
> R10: ffffed1015a03eda R11: ffff8880ad01f6d7 R12: ffffffff917e77c0
> R13: ffffffff8161e740 R14: ffffffff96d3ea28 R15: ffff8880a5a75f60
>   __debug_check_no_obj_freed lib/debugobjects.c:785 [inline]
>   debug_check_no_obj_freed+0x2a3/0x42e lib/debugobjects.c:817
>   slab_free_hook mm/slub.c:1426 [inline]
>   slab_free_freelist_hook+0xfb/0x140 mm/slub.c:1456
>   slab_free mm/slub.c:3003 [inline]
>   kfree+0xce/0x280 mm/slub.c:3958
>   rsi_probe+0xdf3/0x140d drivers/net/wireless/rsi/rsi_91x_sdio.c:1178
>   usb_probe_interface+0x31d/0x820 drivers/usb/core/driver.c:361
>   really_probe+0x2da/0xb10 drivers/base/dd.c:509
>   driver_probe_device+0x21d/0x350 drivers/base/dd.c:671
>   __device_attach_driver+0x1d8/0x290 drivers/base/dd.c:778
>   bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:454
>   __device_attach+0x223/0x3a0 drivers/base/dd.c:844
>   bus_probe_device+0x1f1/0x2a0 drivers/base/bus.c:514
>   device_add+0xad2/0x16e0 drivers/base/core.c:2106
>   usb_set_configuration+0xdf7/0x1740 drivers/usb/core/message.c:2021
>   generic_probe+0xa2/0xda drivers/usb/core/generic.c:210
>   usb_probe_device+0xc0/0x150 drivers/usb/core/driver.c:266
>   really_probe+0x2da/0xb10 drivers/base/dd.c:509
>   driver_probe_device+0x21d/0x350 drivers/base/dd.c:671
>   __device_attach_driver+0x1d8/0x290 drivers/base/dd.c:778
>   bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:454
>   __device_attach+0x223/0x3a0 drivers/base/dd.c:844
>   bus_probe_device+0x1f1/0x2a0 drivers/base/bus.c:514
>   device_add+0xad2/0x16e0 drivers/base/core.c:2106
>   usb_new_device.cold+0x537/0xccf drivers/usb/core/hub.c:2534
>   hub_port_connect drivers/usb/core/hub.c:5089 [inline]
>   hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
>   port_event drivers/usb/core/hub.c:5350 [inline]
>   hub_event+0x1398/0x3b00 drivers/usb/core/hub.c:5432
>   process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
>   worker_thread+0x9b/0xe20 kernel/workqueue.c:2415
>   kthread+0x313/0x420 kernel/kthread.c:253
>   ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
> 
> ======================================================

Let's try to test the below combined patch which fixes both the above
use-after-free issue and a second one which syzbot is likely to hit once
the first one is fixed. Let's hope it still applies when using the
commit id from the original report:

#syz test: https://github.com/google/kasan.git d34f9519

Johan


From 0fff9e8be7d92c37c0a03b8f58db415eb042c325 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Thu, 28 Nov 2019 16:07:57 +0100
Subject: [PATCH] rsi: fix use-after-free on failed probe and unbind

Make sure to stop both URBs before returning after failed probe as well
as on disconnect to avoid use-after-free in the completion handler.

Reported-by: syzbot+b563b7f8dbe8223a51e8@syzkaller.appspotmail.com
Fixes: a4302bff28e2 ("rsi: add bluetooth rx endpoint")
Fixes: dad0d04fa7ba ("rsi: Add RS9113 wireless driver")
Cc: stable <stable@vger.kernel.org>     # 3.15
Cc: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Cc: Fariya Fatima <fariyaf@gmail.com>

rsi: fix use-after-free on probe errors

The driver would fail to stop the command timer in most error paths,
something which specifically could lead to the timer being freed while
still active on I/O errors during probe.

Fix this by making sure that each function starting the timer also stops
it in all relevant error paths.

Reported-by: syzbot+1d1597a5aa3679c65b9f@syzkaller.appspotmail.com
Fixes: b78e91bcfb33 ("rsi: Add new firmware loading method")
Cc: stable <stable@vger.kernel.org>     # 4.12
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 12 ++++++------
 drivers/net/wireless/rsi/rsi_91x_usb.c | 18 +++++++++++++++++-
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index f84250bdb8cf..6f8d5f9a9f7e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -622,6 +622,7 @@ static int bl_cmd(struct rsi_hw *adapter, u8 cmd, u8 exp_resp, char *str)
 	bl_start_cmd_timer(adapter, timeout);
 	status = bl_write_cmd(adapter, cmd, exp_resp, &regout_val);
 	if (status < 0) {
+		bl_stop_cmd_timer(adapter);
 		rsi_dbg(ERR_ZONE,
 			"%s: Command %s (%0x) writing failed..\n",
 			__func__, str, cmd);
@@ -737,10 +738,9 @@ static int ping_pong_write(struct rsi_hw *adapter, u8 cmd, u8 *addr, u32 size)
 	}
 
 	status = bl_cmd(adapter, cmd_req, cmd_resp, str);
-	if (status) {
-		bl_stop_cmd_timer(adapter);
+	if (status)
 		return status;
-	}
+
 	return 0;
 }
 
@@ -828,10 +828,9 @@ static int auto_fw_upgrade(struct rsi_hw *adapter, u8 *flash_content,
 
 	status = bl_cmd(adapter, EOF_REACHED, FW_LOADING_SUCCESSFUL,
 			"EOF_REACHED");
-	if (status) {
-		bl_stop_cmd_timer(adapter);
+	if (status)
 		return status;
-	}
+
 	rsi_dbg(INFO_ZONE, "FW loading is done and FW is running..\n");
 	return 0;
 }
@@ -849,6 +848,7 @@ static int rsi_hal_prepare_fwload(struct rsi_hw *adapter)
 						  &regout_val,
 						  RSI_COMMON_REG_SIZE);
 		if (status < 0) {
+			bl_stop_cmd_timer(adapter);
 			rsi_dbg(ERR_ZONE,
 				"%s: REGOUT read failed\n", __func__);
 			return status;
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 53f41fc2cadf..30bed719486e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -292,6 +292,15 @@ static void rsi_rx_done_handler(struct urb *urb)
 		dev_kfree_skb(rx_cb->rx_skb);
 }
 
+static void rsi_rx_urb_kill(struct rsi_hw *adapter, u8 ep_num)
+{
+	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
+	struct rx_usb_ctrl_block *rx_cb = &dev->rx_cb[ep_num - 1];
+	struct urb *urb = rx_cb->rx_urb;
+
+	usb_kill_urb(urb);
+}
+
 /**
  * rsi_rx_urb_submit() - This function submits the given URB to the USB stack.
  * @adapter: Pointer to the adapter structure.
@@ -823,10 +832,13 @@ static int rsi_probe(struct usb_interface *pfunction,
 	if (adapter->priv->coex_mode > 1) {
 		status = rsi_rx_urb_submit(adapter, BT_EP);
 		if (status)
-			goto err1;
+			goto err_kill_wlan_urb;
 	}
 
 	return 0;
+
+err_kill_wlan_urb:
+	rsi_rx_urb_kill(adapter, WLAN_EP);
 err1:
 	rsi_deinit_usb_interface(adapter);
 err:
@@ -857,6 +869,10 @@ static void rsi_disconnect(struct usb_interface *pfunction)
 		adapter->priv->bt_adapter = NULL;
 	}
 
+	if (adapter->priv->coex_mode > 1)
+		rsi_rx_urb_kill(adapter, BT_EP);
+	rsi_rx_urb_kill(adapter, WLAN_EP);
+
 	rsi_reset_card(adapter);
 	rsi_deinit_usb_interface(adapter);
 	rsi_91x_deinit(adapter);
-- 
2.24.0

