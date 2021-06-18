Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773A63AC8DA
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 12:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbhFRKd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 06:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhFRKd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 06:33:27 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E94CC06175F;
        Fri, 18 Jun 2021 03:31:18 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id r5so15889408lfr.5;
        Fri, 18 Jun 2021 03:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version;
        bh=g4/qGuk/1/nz4pBAW/oHx6jsVKdAhDT4gL8XIM+UEbw=;
        b=NRM0Ge7YhUGBMsEl5Iyaawj5asmHnsIWpfhqU7Ow5JvNlYo3pDj6c5ynpBU2GZQe8a
         fa1CoopOlagRLXgms9G35rW9dxunF+NzkJ2DBO6NuTFEotMCRMhRz5nIm+Sn6Vp7wRtS
         l7nPzMp8r41iGxt9OIoEaA3YGihGATIeHEfe5yDsfUJIqdGFFsENgAySrffX762aLTLB
         WC0mZY2F+xo1DIDteQd4MRSG+0ckpUzVp1Pc9+Iwzq746yshKIe9nimCnZyDL0aTLoY8
         v5TCEsF228GhOigI6inSYW9NrztZyQKlYFNsb2XJ8RlaEg+Ia5x2UxUSQ2OPalrUU99Q
         TNmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version;
        bh=g4/qGuk/1/nz4pBAW/oHx6jsVKdAhDT4gL8XIM+UEbw=;
        b=dMvkQ/1n/Pe3sd4JGWbqAzQChFGb2wjDKKUqdzQMg8VxQhUAhK9vJGFjcnLMop5gQA
         TDGV7kOO+4jAAF3lFKCFkot9Zct2o0wM0XSP8yNerz1eWmWs08jIMbqjphDoDQKcnINK
         OZhiQhTTvgP1j0Ckb4gslskXrACBFU0b8QLqw5KXpUikJGTYn6WM1QZP/qeLocKEV/SV
         ncm+kzjjthD6nG2ZJnJc4KtA8XoBg6sVe5Kb3Pnueq542bR06u6bn5EGT5nVJxalg2Gf
         fUsKrSh/kWO07yp2VRME+VW+Vob0lFm35m51UbCtQrt88phjIPaaJgpTZy92xD6p5omt
         1qjQ==
X-Gm-Message-State: AOAM532S6HwXrNDpTkDATXlNFZdcA2QHkpUWcUsa3lKg36nm5PifhdTd
        i/Fo+R+/BZx3fn+WXPE4d5Q=
X-Google-Smtp-Source: ABdhPJzafu1C5lE/FDfrwGeYwTXNxayFAUcapiQpRf/CYdxwHBO2mIJHIqT5l/pN9wx7V0ibdNDk0w==
X-Received: by 2002:a05:6512:32c8:: with SMTP id f8mr2552467lfg.204.1624012276761;
        Fri, 18 Jun 2021 03:31:16 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.24])
        by smtp.gmail.com with ESMTPSA id y186sm862298lfc.282.2021.06.18.03.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 03:31:16 -0700 (PDT)
Date:   Fri, 18 Jun 2021 13:31:12 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     syzbot <syzbot+90d241d7661ca2493f0b@syzkaller.appspotmail.com>
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] divide error in ath9k_htc_swba
Message-ID: <20210618133112.596c60d8@gmail.com>
In-Reply-To: <0000000000002a48dd05c506e7cc@google.com>
References: <0000000000002a48dd05c506e7cc@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/ND5+UpciWZ4eDZH8.=U10wy"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--MP_/ND5+UpciWZ4eDZH8.=U10wy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, 18 Jun 2021 02:25:22 -0700
syzbot <syzbot+90d241d7661ca2493f0b@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    37fdb7c9 Merge tag 'v5.13-rc6' into usb-next
> git tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
> usb-testing console output:
> https://syzkaller.appspot.com/x/log.txt?x=1702bbebd00000 kernel
> config:  https://syzkaller.appspot.com/x/.config?x=e3b6ba4f6e6c6ddf
> dashboard link:
> https://syzkaller.appspot.com/bug?extid=90d241d7661ca2493f0b syz
> repro:
> https://syzkaller.appspot.com/x/repro.syz?x=113b98b8300000 C
> reproducer:   https://syzkaller.appspot.com/x/repro.c?x=134650f7d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the
> commit: Reported-by:
> syzbot+90d241d7661ca2493f0b@syzkaller.appspotmail.com

 
#syz test
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master





With regards,
Pavel Skripkin

--MP_/ND5+UpciWZ4eDZH8.=U10wy
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-net-wireless-ath9k-fix-divide-error.patch

From d9a4de91e4752866c78019fbeadaa471543550a5 Mon Sep 17 00:00:00 2001
From: Pavel Skripkin <paskripkin@gmail.com>
Date: Fri, 18 Jun 2021 13:29:27 +0300
Subject: [PATCH] net: wireless: ath9k: fix divide error

/* ---- */

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          | 1 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 2 ++
 drivers/net/wireless/ath/ath9k/wmi.c          | 6 ++++++
 3 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 0a1634238e67..1aaacdcda7ea 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -532,6 +532,7 @@ struct ath9k_htc_priv {
 #endif
 	struct mutex mutex;
 	struct ieee80211_vif *csa_vif;
+	atomic_t initialized;
 };
 
 static inline void ath_read_cachesize(struct ath_common *common, int *csz)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index ff61ae34ecdf..c3288bb07137 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -965,6 +965,8 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
 	if (ret)
 		goto err_init;
 
+	atomic_set(&priv->initialized, 1);
+
 	return 0;
 
 err_init:
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index fe29ad4b9023..a5f31ee86f04 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -146,6 +146,12 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
 	unsigned long flags;
 	u16 cmd_id;
 
+	if (!atomic_read(&priv->initialized))
+		/* If tasked has been called with uninitalized ath9k_htc_priv,
+		 * it can cause divide-by-zero error in ath9k_htc_swba
+		 */
+		return;
+
 	do {
 		spin_lock_irqsave(&wmi->wmi_lock, flags);
 		skb = __skb_dequeue(&wmi->wmi_event_queue);
-- 
2.32.0


--MP_/ND5+UpciWZ4eDZH8.=U10wy--
