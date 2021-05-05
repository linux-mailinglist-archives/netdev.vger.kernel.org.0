Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0977737342E
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 06:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbhEEESQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 00:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbhEEESP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 00:18:15 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DF5C061574;
        Tue,  4 May 2021 21:17:18 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id r18so440837vso.12;
        Tue, 04 May 2021 21:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yWX4oJR4tsVyMxcW0RBqF75Bbh7IX1sBST4dlvOh10c=;
        b=BU15yE000ZMck7FNXICtJ8wCfvnd/OqEMt2y7fs0fgXB8jz6BMI9XncK8Wm/vA24hM
         Soo22Kl2m1o3f+upRMDBPSQHybt+vqYeO9O/0zk/ACLiaMQMGk6A9GN3bJu6n2dz+yLd
         Z/104QxKWbFDgVuwSNqIdfUnuT5N31x5zb+E17SXd4TjkDdxTdCDk+2JT94LrOOanasW
         jnpyntDjnbun4D/cAmeeJDZ8JRtiMnnycyQdkG1e09PT8vp6mzi/y9MQXtTTXHQBY7i/
         LQ2+v5ZHwGuD8oXkNNyJf+IplJ2Y+3huT+smNNupNX5GJSHAbroY4delkfRhym3Nm02a
         8o8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yWX4oJR4tsVyMxcW0RBqF75Bbh7IX1sBST4dlvOh10c=;
        b=rdzkbGNJpmOVbF4EB0ikhBbPQrK8rlRaKseKBMJ+oFGb2QgeG4nDJ0aq+1M4u0V3Tx
         aBifhnE7YsyGRZAY8gGLqBNxp3DWxIXGGzZP6tHC5Z4KPYLf5gAjr+i+tPNuitQZ3Pwt
         cA4B7SZPP/yveChF8Y752YT2QBBOkDBFSc0WRwJ8PS2oCEz7bnxYCrY8lTWBuNDh4hAz
         qepPK0ulTirq7Xo376N6zpjzZH9YWG7z06WMOpbnQLvRhOvVXLIlhWcCITeiMGHoLGan
         lZ5bwfaMwtD2HTIj2886RQMJx0svSiRZLnhK6royWP+OKczk6Fsupi6gk0XLoRAg0XdG
         G7TA==
X-Gm-Message-State: AOAM533ZdTvebSLAw2qeVctVQqGvteLmBn3pJOg2wbezTCVMmek/W1m0
        1fweT+wIj8KmnQrm8l4Kg6E=
X-Google-Smtp-Source: ABdhPJzAO4Suv/5mO4UkLcEyRpoSuJrEA15sGU511QPNtZLmxb5ZLx27qzPkXhqP3OK3EQYSgvZnZA==
X-Received: by 2002:a67:8008:: with SMTP id b8mr1139349vsd.13.1620188238228;
        Tue, 04 May 2021 21:17:18 -0700 (PDT)
Received: from localhost.localdomain ([65.48.163.91])
        by smtp.gmail.com with ESMTPSA id o35sm594070uae.3.2021.05.04.21.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 21:17:17 -0700 (PDT)
From:   Sean Gloumeau <sajgloumeau@gmail.com>
To:     Jiri Kosina <trivial@kernel.org>
Cc:     kbingham@kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org, Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Gloumeau <sajgloumeau@protonmail.com>,
        Sean Gloumeau <sajgloumeau@gmail.com>
Subject: [PATCH 3/3] Add entries for words with stem "eleminat"
Date:   Wed,  5 May 2021 00:17:08 -0400
Message-Id: <6a526dbf75f6445f3711df0a201a48f8ac3149cd.1620185393.git.sajgloumeau@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1620185393.git.sajgloumeau@gmail.com>
References: <cover.1620185393.git.sajgloumeau@gmail.com>
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
index 7b6a01291598..e657be5aa2a9 100644
--- a/scripts/spelling.txt
+++ b/scripts/spelling.txt
@@ -548,6 +548,9 @@ ehther||ether
 eigth||eight
 elementry||elementary
 eletronic||electronic
+eleminate||eliminate
+eleminating||eliminating
+elemination||elimination
 embeded||embedded
 enabledi||enabled
 enbale||enable
-- 
2.31.1

