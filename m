Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58BFB1A6124
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 01:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgDLXvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 19:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgDLXvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 19:51:13 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C66C0A3BE0
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 16:51:13 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id y24so8479013wma.4
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 16:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I41dNbK6K+49b1sUE81Si1nI/MeU5FSsOdLawwGvSxs=;
        b=YuBCgrrRuOzkpxsEn5lnK9XuJ3os9x8iqXaqilxhg0tvs/JDaVwc8p4cIHNDxK68dU
         xJ7lYvXb0AFZ7TPd+MnuDJTdT/2kT5nm9h5YOhXLi0VONIy8h8F6umyQL+8TYHAW2eW9
         TCPzCb6uPdQiICLCj23HqwhlERKJyl8MC0ylWNSZ0S5dRhVL1v9446UReiJhfcHxtPdV
         4c+D4djbjXhss6WmOIWcopUMVEInNs2saiAEHDYFpA7hsoQekshsZarCBJz/GXIsdWdO
         C/wM01kl9r311fg6YG0LLX+HA7ZZH6B4fkduD38a1OFA9Y77APTKW6+QqqZS8m3y35yh
         cRyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I41dNbK6K+49b1sUE81Si1nI/MeU5FSsOdLawwGvSxs=;
        b=VdIuKSpVaS+N3rO2wMCmVB6hp6rJnAShfpAuZIIWWF8ojwGvyHjdPA82qpNWOAnVHD
         ko6bYDTRgCxKjZMmhX8fVEChmTJ0ZFJIADV3D91ra14n+Qr464HPqJek9MPk+9QHcQJJ
         9WhKPR+TsTqo0oJB0xdz7fmy/Ju4vrBtNPKy5BakXR9EylRfn5pvaKgEi2/qeEINa3uq
         WK3AHwJ3L5kce8+86u3J7wgI5pkAeYVUUrEaTUYQ+ai9EYKW9J3MYLTt7Bv06iwMg2X3
         1QKHrX3p6qYsJKiGoVJXo46jW61v7HgpFSaYDRUjVJ3ZxZ8yVaPxpcruTSzFhrOWq6kc
         9gNA==
X-Gm-Message-State: AGi0PuYnPBzwBv9jq6Rue/MxCQBhHubWi83DTLsqS6pNj08gjAILLpVU
        9d0ckaDEKmM0ZQDnlOfLmBLTrUGv
X-Google-Smtp-Source: APiQypLdpKPTtup5s9AEPTpe4j+kqCIxlZoScViNS5Lr4fSLz24nra40spgCkvpJnezaifID2PCeOg==
X-Received: by 2002:a1c:b356:: with SMTP id c83mr16972112wmf.10.1586735471456;
        Sun, 12 Apr 2020 16:51:11 -0700 (PDT)
Received: from localhost ([2a01:e35:2f01:a61:fc49:14b:88c:2a9c])
        by smtp.gmail.com with ESMTPSA id k3sm2684683wru.90.2020.04.12.16.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2020 16:51:10 -0700 (PDT)
From:   roucaries.bastien@gmail.com
X-Google-Original-From: rouca@debian.org
To:     netdev@vger.kernel.org
Cc:     sergei.shtylyov@cogentembedded.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>
Subject: [PATCH 3/6] Document BPDU filter option
Date:   Mon, 13 Apr 2020 01:50:35 +0200
Message-Id: <20200412235038.377692-4-rouca@debian.org>
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

Disabled state is also BPDU filter
---
 man/man8/bridge.8 | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 584324b5..bd33635a 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -293,32 +293,45 @@ droot port selectio algorithms.
 
 .TP
 .BI state " STATE "
-the operation state of the port. This is primarily used by user space STP/RSTP
+the operation state of the port. Except state 0 (disabled),
+this is primarily used by user space STP/RSTP
 implementation. One may enter a lowercased port state name, or one of the
 numbers below. Negative inputs are ignored, and unrecognized names return an
 error.
 
 .B 0
-- port is DISABLED. Make this port completely inactive.
+- port is in
+.B DISABLED
+state. Make this port completely inactive. This is also called
+BPDU filter and could be used to disable STP on an untrusted port, like
+a leaf virtual devices.
 .sp
 
 .B 1
-- STP LISTENING state. Only valid if STP is enabled on the bridge. In this
+- STP
+.B LISTENING
+state. Only valid if STP is enabled on the bridge. In this
 state the port listens for STP BPDUs and drops all other traffic frames.
 .sp
 
 .B 2
-- STP LEARNING state. Only valid if STP is enabled on the bridge. In this
+- STP
+.B LEARNING
+state. Only valid if STP is enabled on the bridge. In this
 state the port will accept traffic only for the purpose of updating MAC
 address tables.
 .sp
 
 .B 3
-- STP FORWARDING state. Port is fully active.
+- STP
+.B FORWARDING
+state. Port is fully active.
 .sp
 
 .B 4
-- STP BLOCKING state. Only valid if STP is enabled on the bridge. This state
+- STP
+.B BLOCKING
+state. Only valid if STP is enabled on the bridge. This state
 is used during the STP election process. In this state, port will only process
 STP BPDUs.
 .sp
-- 
2.25.1

