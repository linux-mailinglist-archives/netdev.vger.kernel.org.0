Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40EB046064B
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 13:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357556AbhK1NDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 08:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357505AbhK1NBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 08:01:01 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734B7C061746
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:55:33 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id u22so29001705lju.7
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rCnxjkj03WQhG+icohNjqv1KTlE76ti0N0rq+GLP0Ac=;
        b=TYO0x9b6VDUot+FBGmiRS9sdPF4F6vliNtgtDXxiJYXa1qjRPtvDmbUJxslIxVunOQ
         5MhruLkBi7xgmUasm2aVJohOxvaAOJeabmbO6ImmlorQ7vBWW00LuU6PGD2PGnh/HO18
         E+TyzxM3u8zMXr0ooVLOokoQj7jBQnCWIMLgLwMgkmEbAIBZAstiicwYj66WMwyeKtfM
         ChfwOG2u/NTJL5VRjKUOZu3z92pNqbVkJYiMfzuZvwUWy3XorIiMavpsgIKl33cc2qjV
         1P/GVBH6Lgr9HryrjU5NdX7jzBTBJjEb8J1ijguVBhhtWhZ1kcNFgo5TVaZ7b9uBFVDp
         3Tkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rCnxjkj03WQhG+icohNjqv1KTlE76ti0N0rq+GLP0Ac=;
        b=SYEk1UhqS8WvIexkTERCuxsaf4RaHilCoTe2nqA33Uovx2MJ+B1II6QOSo6gBPsbi3
         47n92eAe76MbdihKPrWkJFtYgYDdrMQv7jzK8BObP4XrqWJpOFBj2FnQM61Sjw3gkL58
         rN6+AgWkx/sesHbVzORyEzPr+knuKSt2ivWdoOEYMyZ6bD4560IJ2/Eyrmky6isSTrV7
         bjwUc99jbS00Y7awx2QInkbFnpBFNPgpwHlRfdv5qU+RUHnwjcUPMkUzevptcYTpRrVM
         Kvi3DW7hMLS7jcyzJtozSv5sOU1C4KId0PfWdLRmyoq1XPJyJ3hPrXEJf7hqijsZWXbd
         aacw==
X-Gm-Message-State: AOAM5307VYB0xUbdR51R4pC/A06zCh0K1GUGcJ2oY8RQyb31AQ+tBI8p
        67AgmSQXI0UExt9uVVdwCId7JQYWmpg=
X-Google-Smtp-Source: ABdhPJwFH0OFE0afSsZzQXwcDhf0Y/hPMLxGGjZgVGg/f0M67Y9+X1+tJc0PSzx0nuMgr/JPh/IOIQ==
X-Received: by 2002:a2e:9197:: with SMTP id f23mr42680344ljg.235.1638104131678;
        Sun, 28 Nov 2021 04:55:31 -0800 (PST)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id c1sm1066595ljr.111.2021.11.28.04.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 04:55:31 -0800 (PST)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH RESEND net-next 0/5] WWAN debugfs tweaks
Date:   Sun, 28 Nov 2021 15:55:17 +0300
Message-Id: <20211128125522.23357-1-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resend with proper target tree. Also I should mention that the series is
mostly compile-tested since I do not have IOSM supported device, so it
needs Ack from the IOSM developers.

This is a follow-up series to just applied IOSM (and WWAN) debugfs
interface support [1]. The series has two main goals:
1. move the driver-specific debugfs knobs to a subdirectory;
2. make the debugfs interface optional for both IOSM and for the WWAN
   core.

As for the first part, I must say that it was my mistake. I suggested to
place debugfs entries under a common per WWAN device directory. But I
missed the driver subdirectory in the example, so it become:

/sys/kernel/debugfs/wwan/wwan0/trace

Since the traces collection is a driver-specific feature, it is better
to keep it under the driver-specific subdirectory:

/sys/kernel/debugfs/wwan/wwan0/iosm/trace

It is desirable to be able to entirely disable the debugfs interface. It
can be disabled for several reasons, including security and consumed
storage space.

The changes themselves are relatively simple, but require a code
rearrangement. So to make changes clear, I chose to split them into
preparatory and main changes and properly describe each of them.

1. https://lore.kernel.org/netdev/20211120162155.1216081-1-m.chetan.kumar@linux.intel.com

Cc: M Chetan Kumar <m.chetan.kumar@intel.com>
Cc: Intel Corporation <linuxwwan@intel.com>
Cc: Loic Poulain <loic.poulain@linaro.org>
Cc: Johannes Berg <johannes@sipsolutions.net>

Sergey Ryazanov (5):
  net: wwan: iosm: consolidate trace port init code
  net: wwan: iosm: allow trace port be uninitialized
  net: wwan: iosm: move debugfs knobs into a subdir
  net: wwan: iosm: make debugfs optional
  net: wwan: core: make debugfs optional

 drivers/net/wwan/Kconfig                  | 17 +++++++++++++
 drivers/net/wwan/iosm/Makefile            |  5 +++-
 drivers/net/wwan/iosm/iosm_ipc_debugfs.c  | 29 +++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_debugfs.h  | 17 +++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_imem.c     | 13 ++++------
 drivers/net/wwan/iosm/iosm_ipc_imem.h     |  5 ++++
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 18 --------------
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h |  2 +-
 drivers/net/wwan/iosm/iosm_ipc_trace.c    | 23 ++++++++++++------
 drivers/net/wwan/iosm/iosm_ipc_trace.h    | 25 ++++++++++++++++++-
 drivers/net/wwan/wwan_core.c              |  8 +++++++
 include/linux/wwan.h                      |  7 ++++++
 12 files changed, 133 insertions(+), 36 deletions(-)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_debugfs.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_debugfs.h

-- 
2.32.0

