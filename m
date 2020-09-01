Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCE82588BF
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 09:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgIAHIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 03:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgIAHIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 03:08:42 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9B2C0612AC;
        Tue,  1 Sep 2020 00:08:41 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id e7so169745qtj.11;
        Tue, 01 Sep 2020 00:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GmXuUYU+0Jf5IK/tkXEzwkvIda53kaFZm8Sq7KP0sFU=;
        b=JOWb9jTrRxl2PkSgSC8c9FlfkpWDLq5/Lhaml4xlqzfc3Un+/SGCfHVvyBP3CWgtjS
         xPEzVDX7bb38uAwHm2qhJ/KNWWCKhGE4T8jWDULYrB8EhTXJNa8ZjVXTS10UokqP0Z/0
         tWN0XysiJmkXbW3ZFovPFiSn4TP10N07s0iZhh6d0BCOcX5LAtnCq81WCMxwPJ6AQZaJ
         /xcqz6qo42a8SYeLtXX3IaprSv02eawXA/LKiqSrrRoCaOo7NeNeOnoJwu571jIKO+nV
         yFcOPttd1LWlld8MKdGnSwhDKYYv4/6ZrHMO69luWoY1bj/FDLkLT5jtRFcZ1qNkeIV/
         i7QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GmXuUYU+0Jf5IK/tkXEzwkvIda53kaFZm8Sq7KP0sFU=;
        b=lW0rFykP4SOtLM3Zy0OphaA5EcyHEcjqO7LHB1ZCvLq8nBArKhlxMspthTQOu/Iw6d
         KBTpGWPbejKNpgwAdc7+MVZ9zFTjNiV5ohzaFUrL0y3FW79Sl4Q5DATvu4GR5d49HZD2
         zoCTznxGmJv5D1gtHhGn5+XVSzjidaMj8PddWa/ezRu5RIiux/0tzXt4v26MXKD9dUU4
         Xj53U8bFO+9tDdKQhdq6Xzwmq+W0VnsiNObdU+SOFIUXmY6S7ribfYn+nbBSXDqy4vkg
         fFPqj9b4PaNcooJK4u2gpRoDCIfK+nPr6QWyiJEPZPswwHjXsCW9dyxqd6VD/I08O5GK
         +a5Q==
X-Gm-Message-State: AOAM5331EOQByRlGRXgqLl8LVH/CaI9EGOas25NgIi32rkwX/xT7t9HC
        7ynAOPOY6fN8iS+hmsCsgX8=
X-Google-Smtp-Source: ABdhPJzf3KOZbzItfgAW+zC8vk2ksm2e5eC805X9mt3sL0983IgO1KRkKb1qurFhVMGIZwSz2J+tIQ==
X-Received: by 2002:ac8:72d3:: with SMTP id o19mr379699qtp.190.1598944120846;
        Tue, 01 Sep 2020 00:08:40 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id l64sm570996qkc.21.2020.09.01.00.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 00:08:39 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        Andy Lavr <andy.lavr@gmail.com>
Subject: [PATCH] mwifiex: Remove unnecessary braces from HostCmd_SET_SEQ_NO_BSS_INFO
Date:   Tue,  1 Sep 2020 00:08:34 -0700
Message-Id: <20200901070834.1015754-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new warning in clang points out when macro expansion might result in a
GNU C statement expression. There is an instance of this in the mwifiex
driver:

drivers/net/wireless/marvell/mwifiex/cmdevt.c:217:34: warning: '}' and
')' tokens terminating statement expression appear in different macro
expansion contexts [-Wcompound-token-split-by-macro]
        host_cmd->seq_num = cpu_to_le16(HostCmd_SET_SEQ_NO_BSS_INFO
                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex/fw.h:519:46: note: expanded from
macro 'HostCmd_SET_SEQ_NO_BSS_INFO'
        (((type) & 0x000f) << 12);                  }
                                                    ^

This does not appear to be a real issue. Removing the braces and
replacing them with parentheses will fix the warning and not change the
meaning of the code.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Link: https://github.com/ClangBuiltLinux/linux/issues/1146
Reported-by: Andy Lavr <andy.lavr@gmail.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 4 ++--
 drivers/net/wireless/marvell/mwifiex/fw.h     | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index d068b9075c32..3a11342a6bde 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -322,9 +322,9 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 
 	adapter->seq_num++;
 	sleep_cfm_buf->seq_num =
-		cpu_to_le16((HostCmd_SET_SEQ_NO_BSS_INFO
+		cpu_to_le16(HostCmd_SET_SEQ_NO_BSS_INFO
 					(adapter->seq_num, priv->bss_num,
-					 priv->bss_type)));
+					 priv->bss_type));
 
 	mwifiex_dbg(adapter, CMD,
 		    "cmd: DNLD_CMD: %#x, act %#x, len %d, seqno %#x\n",
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 8047e307892e..1f02c5058aed 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -513,10 +513,10 @@ enum mwifiex_channel_flags {
 
 #define RF_ANTENNA_AUTO                 0xFFFF
 
-#define HostCmd_SET_SEQ_NO_BSS_INFO(seq, num, type) {   \
-	(((seq) & 0x00ff) |                             \
-	 (((num) & 0x000f) << 8)) |                     \
-	(((type) & 0x000f) << 12);                  }
+#define HostCmd_SET_SEQ_NO_BSS_INFO(seq, num, type) \
+	((((seq) & 0x00ff) |                        \
+	 (((num) & 0x000f) << 8)) |                 \
+	(((type) & 0x000f) << 12))
 
 #define HostCmd_GET_SEQ_NO(seq)       \
 	((seq) & HostCmd_SEQ_NUM_MASK)
-- 
2.28.0

