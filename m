Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D40601A6125
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 01:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgDLXvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 19:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:43028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgDLXvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 19:51:15 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B72C0A3BE0
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 16:51:15 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id d17so1725754wrg.11
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 16:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yaLr1yP8C/WXC2RwVyBx679zMV/LTHtgltT2xi28Rdc=;
        b=GsL5JEjpcm1NRQ/qqZ3G14XhIRFkXEWMYh3B5oedVjkdGPvPNfI+QduGqSc6pQxHDF
         TfNfxMITTQ6nUYjHXXv9VhZFiEyUSBL9DbKkunWC/nYMdC5uCIFUEYM43gsUoGqC1bfQ
         888toQX6hKwMXSmOb5zhw/yH7EEI+9weoVjMeZXmPHu7wZ4o7wMAsbhqelBFfzybzSxl
         7zAxTx5Bi0lJenC6d1cV6uUMz77pSfoZe3hb7RArCLpHfALg8bwktG5yNn/FlKsIsJrw
         PzsZQ5AZaT+XbMiCOHRlLLpmzMfGqipTGJWKAbGhfYbZ58D2ueeBabMD7Y7K0veXii4x
         EzYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yaLr1yP8C/WXC2RwVyBx679zMV/LTHtgltT2xi28Rdc=;
        b=rqpDC31Y6PZCT1IRPTtIIscFB6x0VRcdydzwJ+iHtavHDooNfAA/JxUTugPBao3xLC
         7yDPIHV7Zi7weQK/Tr6eM4v4iVjYUAqfg3nKX3Mq0aHLHC8nOkA7cHV4aKoVUhRzWVVt
         TpSsG270D8dtJ4g7ZWDS1VnH+4zkqfAiLEHRRBbfIlqK89RePLQTg9KDSJ8q9gd7bWO1
         geHZq12HqDsSWjoYKB/F08uusEe9HWJ8DXwE8VmWbc5XxF0jeyfRjvsYf41P6bVu7iif
         yA5kH4QNyJyv1NZ42fEKbf8/4K3AacKQAO9DJuRnoJFaFieAmlNqQJVB+DJvNFxZJk77
         MZ9g==
X-Gm-Message-State: AGi0PuYWvJXTnuOKkP9BBCh6+h9y5PT+S/yPtF4EZUsoDHPvXTCJfmsT
        PG9Vm+GvAnFvW+xc6dA6hb8hd9SB
X-Google-Smtp-Source: APiQypL2tQmb9g7CxnBxuDu6tCMhQtIZa8p9mnyqS+1SO5KEXzJfsidrASim+6L6/qMw6eyVfkHAHg==
X-Received: by 2002:adf:efc2:: with SMTP id i2mr15773685wrp.420.1586735473643;
        Sun, 12 Apr 2020 16:51:13 -0700 (PDT)
Received: from localhost ([2a01:e35:2f01:a61:fc49:14b:88c:2a9c])
        by smtp.gmail.com with ESMTPSA id m13sm13261404wrx.40.2020.04.12.16.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2020 16:51:12 -0700 (PDT)
From:   roucaries.bastien@gmail.com
X-Google-Original-From: rouca@debian.org
To:     netdev@vger.kernel.org
Cc:     sergei.shtylyov@cogentembedded.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>
Subject: [PATCH 4/6] Better documentation of BDPU guard
Date:   Mon, 13 Apr 2020 01:50:36 +0200
Message-Id: <20200412235038.377692-5-rouca@debian.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200412235038.377692-1-rouca@debian.org>
References: <20200405134859.57232-1-rouca@debian.org>
 <20200412235038.377692-1-rouca@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bastien Roucariès <rouca@debian.org>

Document that guard disable the port and how to reenable it

Signed-off-by: Bastien Roucariès <rouca@debian.org>
---
 man/man8/bridge.8 | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index bd33635a..9bfd942f 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -340,7 +340,18 @@ STP BPDUs.
 .BR "guard on " or " guard off "
 Controls whether STP BPDUs will be processed by the bridge port. By default,
 the flag is turned off allowed BPDU processing. Turning this flag on will
-cause the port to stop processing STP BPDUs.
+disables
+the bridge port if a STP BPDU packet is received.
+
+If running Spanning Tree on bridge, hostile devices on the network
+may send BPDU on a port and cause network failure. Setting
+.B guard on
+will detect and stop this by disabling the port.
+The port will be restarted if link is brought down, or
+removed and reattached.  For example if guard is enable on
+eth0:
+
+.B ip link set dev eth0 down; ip link set dev eth0 up
 
 .TP
 .BR "hairpin on " or " hairpin off "
-- 
2.25.1

