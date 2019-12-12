Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C34D11D4B7
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 18:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730254AbfLLR7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 12:59:24 -0500
Received: from mail-qk1-f180.google.com ([209.85.222.180]:38901 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730033AbfLLR7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 12:59:23 -0500
Received: by mail-qk1-f180.google.com with SMTP id k6so2346922qki.5;
        Thu, 12 Dec 2019 09:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CbaD0cZrdTWE2/HMYdJPs3JGTAc0XDZM1g5dQvZGfY0=;
        b=RnTDDbfjvRmDe063ONyHn7VNtFjkaqBAuqFLT9DCtKNKx6K27xlAW5cFwhn5brSiyE
         FJ6mGRMEF6u8/wHOq7ciuXHKfHeM0qKppo3ibAgu1UR9MHwsn63bmFuHp9zuX5GY7RbJ
         VfleL2g9rneo86pJgFt4fvoF7WbPeXp8gaeqI39lf8ND3f/qp3+h0uLGPoAedxVY2KDX
         QVKAFh6RlUbSjBuf6oL/4W53pOD6/yCbyruL9T+PEm77y5cZ3CB1n56foJ4XsT8k5OnL
         QxHCdjZ4dqKwguGxEjNNj0SIlFZkOe/hO4jzFnOLhJa9o9EJiguOMMG94h7sim/S32aD
         bvyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CbaD0cZrdTWE2/HMYdJPs3JGTAc0XDZM1g5dQvZGfY0=;
        b=mrzmxW42mdPYNhIoyIqhHRSbaS9QSNW7o9jmzsxMyad6Qs0nf+54CoN9XkRdd5G12k
         2LCZxWfBlCNexIFpERCHkFWbpR1ToUWFmNoPlJaxQ4Fu0W5Y/YxHgmyLgf2WYolJDBEr
         29VM1rkWAgj2nUWmeXMIYf+RxU+VVneYo30I0QnQJhMP8U/ErsbG1h2K8l0m6tzG1zYr
         61ULU4oXaNTSwUJ2iilT97VJt6CPNcNjt8vlOhKrhrA8cJM9aLObkHIcdlxL86FtueMm
         SyS9/jTy/r1H79SxuDCPm5t+p4Vfy0xDwLq6kP+dUayxEufezUXPVUPakO8yNxqHA9NT
         uTPw==
X-Gm-Message-State: APjAAAWxo/HPDGepoB119r6cbMyBAUbnLbsTSLrwpIfrdu54YEXEToT8
        P7KCTNeF+IJAQGQydX7E0SRPJQ1L
X-Google-Smtp-Source: APXvYqzBXqOP/3L3Ge9RbFdGnu2kGGp1cJNpC+Bo6mhbc/PitGc75B2YPMXcR06seI+WKTgIl6gYQw==
X-Received: by 2002:a37:4f8e:: with SMTP id d136mr9306792qkb.495.1576173562720;
        Thu, 12 Dec 2019 09:59:22 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id x27sm1943409qkx.81.2019.12.12.09.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 09:59:22 -0800 (PST)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH] mailmap: add entry for myself
Date:   Thu, 12 Dec 2019 12:59:08 -0500
Message-Id: <20191212175908.1727259-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I no longer work at Savoir-faire Linux but even though MAINTAINERS is
up-to-date, some emails are still sent to my old email address.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 .mailmap | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.mailmap b/.mailmap
index fd6219293057..e9d6d1636ca3 100644
--- a/.mailmap
+++ b/.mailmap
@@ -260,6 +260,7 @@ Vinod Koul <vkoul@kernel.org> <vkoul@infradead.org>
 Viresh Kumar <vireshk@kernel.org> <viresh.kumar@st.com>
 Viresh Kumar <vireshk@kernel.org> <viresh.linux@gmail.com>
 Viresh Kumar <vireshk@kernel.org> <viresh.kumar2@arm.com>
+Vivien Didelot <vivien.didelot@gmail.com> <vivien.didelot@savoirfairelinux.com>
 Vlad Dogaru <ddvlad@gmail.com> <vlad.dogaru@intel.com>
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@virtuozzo.com>
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@parallels.com>
-- 
2.24.0

