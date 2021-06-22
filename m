Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD283B09EE
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 18:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhFVQJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 12:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhFVQJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 12:09:24 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1DFC061574;
        Tue, 22 Jun 2021 09:07:07 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id d2so30922676ljj.11;
        Tue, 22 Jun 2021 09:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version;
        bh=KCIXmKwCILOhwqB9l+GLhnAwaEybjjG1O5me3yhI5lg=;
        b=nfKRjJs+1Y4UGGbeudKR44KKeubeW/cf3V8tp63UQ0cQ5xsi6hDPwuOHyrYWYHe5yH
         XSmbA1SC7acNy65CPpOMSphV8JrCzo9bjsNsPqvnvjVtsVfJItbsECKLFN8muKZJYIqY
         Y6w04gnqRttpxlwSMPMxBKwU9J4mtiHLvkmwtOukaRMOzzwxjpQbRJuDyvrvYWNaDOIh
         tgG+/kPmaQabog2ShJQUsl526NfXI69wpILQVOcn/87GSYi9tvIqvWxegRVg5e2Y8Qkf
         KlyLPFK4dTQZe6PPbJ21tSwToV/IAzmh8hbo9NOUfXHTV8vCMUrBSfoj3AxQf8vj8u6x
         vvlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version;
        bh=KCIXmKwCILOhwqB9l+GLhnAwaEybjjG1O5me3yhI5lg=;
        b=UTgnmxejVyPFV5DBjAFm8C/Uvzrjrb4O6xYZWpQbjJ28gI4RCzk4hVue5bIQAN3kYL
         1hjU4i+zgNgQbJzAxaN0Z/lrxq6HGiLs00K0Vv7jI+HTt3sh0XahitWCHMF2bOVflsOh
         fFlR7ODq5zTxUYYyLRfSRMHq/T9PwTWWUlsWRwgNxCf/XZywtWCqTSoeIBdv1kIICktK
         15WUEmYz/VpoObOy+nihoJdkTMOcVUq3oK69KG/niSkgGXefYxGcZi6moj+B/KSOHuYb
         rEdAp9HfHo01VsqO1W3MES3m9RnnXk4qWjRIAUMD95MPMLryDziMjUPPoCwWXiYhtJ5B
         tDHg==
X-Gm-Message-State: AOAM531C6NCb2kHEH5B+Sya1tJfzZivk02sZP5RMTNi8ACvmLxIo859X
        bC6MnafgfFJvP/F9RTEd4eM=
X-Google-Smtp-Source: ABdhPJyV2Z5gTF1YHPQzJtXcqAC3dzMjjfgH4xAqr7qclw8cCRV2WnGXpsxi7vF97B+ET5mgE/ELAw==
X-Received: by 2002:a2e:9e17:: with SMTP id e23mr3813139ljk.177.1624378026019;
        Tue, 22 Jun 2021 09:07:06 -0700 (PDT)
Received: from localhost.localdomain ([94.103.227.192])
        by smtp.gmail.com with ESMTPSA id s21sm307900ljp.131.2021.06.22.09.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 09:07:05 -0700 (PDT)
Date:   Tue, 22 Jun 2021 19:07:01 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     syzbot <syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com>
Cc:     krzysztof.kozlowski@canonical.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] INFO: task hung in port100_probe
Message-ID: <20210622190701.653d94ca@gmail.com>
In-Reply-To: <000000000000c644cd05c55ca652@google.com>
References: <000000000000c644cd05c55ca652@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/UArs2MqmBR/+ql7l/In2wU7"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--MP_/UArs2MqmBR/+ql7l/In2wU7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, 22 Jun 2021 08:43:29 -0700
syzbot <syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    fd0aa1a4 Merge tag 'for-linus' of
> git://git.kernel.org/pub.. git tree:       upstream
> console output:
> https://syzkaller.appspot.com/x/log.txt?x=13e1500c300000 kernel
> config:  https://syzkaller.appspot.com/x/.config?x=7ca96a2d153c74b0
> dashboard link:
> https://syzkaller.appspot.com/bug?extid=abd2e0dafb481b621869 syz
> repro:
> https://syzkaller.appspot.com/x/repro.syz?x=1792e284300000 C
> reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ad9d48300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the
> commit: Reported-by:
> syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com
> 
> INFO: task kworker/0:1:7 blocked for more than 143 seconds.
>       Not tainted 5.13.0-rc6-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> message. task:kworker/0:1     state:D stack:25584 pid:    7 ppid:
> 2 flags:0x00004000 Workqueue: usb_hub_wq hub_event

Hmmm, maybe this will work


#syz test
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master




With regards,
Pavel Skripkin

--MP_/UArs2MqmBR/+ql7l/In2wU7
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-nfc-add-missing-complete-to-avoid-hung.patch

From 450d464332a8dbf5a915c1447af554ca84a163bb Mon Sep 17 00:00:00 2001
From: Pavel Skripkin <paskripkin@gmail.com>
Date: Tue, 22 Jun 2021 19:00:03 +0300
Subject: [PATCH] nfc: add missing complete() to avoid hung

/* .... */

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/nfc/port100.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index 8e4d355dc3ae..c8c421af49b7 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -805,9 +805,15 @@ static void port100_build_cmd_frame(struct port100 *dev, u8 cmd_code,
 	port100_tx_frame_finish(skb->data);
 }
 
+struct port100_sync_cmd_response {
+	struct sk_buff *resp;
+	struct completion done;
+};
+
 static void port100_send_async_complete(struct port100 *dev)
 {
 	struct port100_cmd *cmd = dev->cmd;
+	struct port100_sync_cmd_response *cmd_resp = cmd->complete_cb_context;
 	int status = cmd->status;
 
 	struct sk_buff *req = cmd->req;
@@ -831,6 +837,7 @@ static void port100_send_async_complete(struct port100 *dev)
 	cmd->complete_cb(dev, cmd->complete_cb_context, resp);
 
 done:
+	complete(&cmd_resp->done);
 	kfree(cmd);
 }
 
@@ -883,11 +890,6 @@ static int port100_send_cmd_async(struct port100 *dev, u8 cmd_code,
 	return rc;
 }
 
-struct port100_sync_cmd_response {
-	struct sk_buff *resp;
-	struct completion done;
-};
-
 static void port100_wq_cmd_complete(struct work_struct *work)
 {
 	struct port100 *dev = container_of(work, struct port100,
-- 
2.32.0


--MP_/UArs2MqmBR/+ql7l/In2wU7--
