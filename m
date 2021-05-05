Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75113746FD
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236122AbhEERgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237443AbhEEReS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 13:34:18 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E91DC0612F0;
        Wed,  5 May 2021 10:04:59 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id o192so1461504vsd.7;
        Wed, 05 May 2021 10:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sYEeOLVMdJz3if+0nTi25SGNzwSnRfdV3Io7PzqsWAY=;
        b=igcImynuA/M1TcZ0veapxdQTiMFWzZpPDNGijnqz53FHtrk+RhzQg/KD+3pS94sV03
         3u9cW7hVGJOEH4684M2VPAGDCc9l0mDuRVB686o0tRkjzJtjislOCjxCUXITCPRCs0mQ
         NJq4VIHhxtSpVbUn46731dHY/JGMm2KTuJXhB8DwvuYCzyXvSLx6Ml2tjyGYYOHhJNdW
         x/nx4luIpOWWA+oQzZCi4yCZSIO8RKVgsk+u5zNFi2s5si8e2JZigPtwOcAMWeKKffMs
         Ft8LQdrmOrjDVAX/+qeLjqVTcVsptF7C52S7WIE39qvLCylWvvHRmBPIQZIoAw54fKgs
         FUxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sYEeOLVMdJz3if+0nTi25SGNzwSnRfdV3Io7PzqsWAY=;
        b=C4h3V6bFw2KJhSEBhh9Fla6CyKtwZ2hnCyV9OKlBhXw5LLQRdJMftOjKcp5Ioimxqn
         OqYs6tlCJQ5r3Oz8erXNRoT/0q+fFUTGDfOov3QOFjECRZbm9R3g5OF3jbuQwbR7d8JF
         +Zxkxz62v4ktwYVPc5h0FlIAo67xzMNNJtLvSJ06bfUHdIsEQt5e2nu+2RK8Genp4SiQ
         gv1dJk/1b8l/HQgC/lifh7uM5Zrx3HgdhB401heDJrDNMUCVl2cHTYzCFlmzNDIFBK83
         Vo1pD4r+PHAG21oiPUEJkRXIklQ9q6eKPOUKnikyP06ez+peu06jBt8wm2YscGMhIlOD
         /Jow==
X-Gm-Message-State: AOAM531MaE2WqO0SnTGMZglX6W4VpJZNfRjKpcVMkYs6vL0N1VSJP0Q7
        Z/h/7qtsnzUKDsx0Y63ggpw=
X-Google-Smtp-Source: ABdhPJwuXxIGNqXTCgID7QEFwCSKqjed/v4wtKtvUbJildsk5rUhoLuZWOxxHZaE0snfuWxSWyGkhg==
X-Received: by 2002:a67:f5cc:: with SMTP id t12mr33833vso.9.1620234298716;
        Wed, 05 May 2021 10:04:58 -0700 (PDT)
Received: from localhost.localdomain ([65.48.163.91])
        by smtp.gmail.com with ESMTPSA id r12sm2224099vsf.2.2021.05.05.10.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 10:04:58 -0700 (PDT)
From:   Sean Gloumeau <sajgloumeau@gmail.com>
To:     Jiri Kosina <trivial@kernel.org>
Cc:     Sean Gloumeau <sajgloumeau@gmail.com>, kbingham@kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org, Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Gloumeau <sajgloumeau@protonmail.com>
Subject: [PATCH v2] Add entries for words with stem "eleminat"
Date:   Wed,  5 May 2021 13:04:50 -0400
Message-Id: <b636dedea2c2ed230bb3d53f45a523eb0f5dfbc0.1620233954.git.sajgloumeau@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <6a526dbf75f6445f3711df0a201a48f8ac3149cd.1620185393.git.sajgloumeau@gmail.com>
References: <6a526dbf75f6445f3711df0a201a48f8ac3149cd.1620185393.git.sajgloumeau@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Entries are added to spelling.txt in order to prevent spelling mistakes
involving words with stem "eliminat" from occurring again.

Signed-off-by: Sean Gloumeau <sajgloumeau@gmail.com>
---
 scripts/spelling.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/spelling.txt b/scripts/spelling.txt
index 7b6a01291598..4400f71a100c 100644
--- a/scripts/spelling.txt
+++ b/scripts/spelling.txt
@@ -547,6 +547,9 @@ efficently||efficiently
 ehther||ether
 eigth||eight
 elementry||elementary
+eleminate||eliminate
+eleminating||eliminating
+elemination||elimination
 eletronic||electronic
 embeded||embedded
 enabledi||enabled
-- 
2.31.1

