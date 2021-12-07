Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1F446B6F1
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbhLGJZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbhLGJZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:25:21 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE8DC061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 01:21:51 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id b1so31982857lfs.13
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 01:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N8zRNS+0bagiOqEAx08vLmFoYl+7mqunj65BGnPwsDU=;
        b=FsNmss3uMbD3rp9Y+oT+IFMR+lhnNn+rqCVYU1foewzUgtcbg1hvO4eeCritaY6VcB
         y7/RJjzUL8U8RXsWa5u3+Zimlz2SCPPDLydKacTWXiUDhP0u8MhKgXlsAE2eCUg6JmgA
         T/cYCvMS7n116hpoIPpJdBrKxUnWi4YG/aZnxt0tY0u7hv4DKJ4dFyJoWleg7VwmbwkS
         9M+EvBLcIlTQ4sVGJ8XCxyzSfbyG2D1HmExwIKuNEdppEGu3fGX+y97WknrC8EBOIyfG
         pCSYHwoGEkl5DUkChE/nxVL3rTwFPWen1EDEJMt+rcWUCGczbUqwH+hjt3B0cIZoNQks
         /lDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N8zRNS+0bagiOqEAx08vLmFoYl+7mqunj65BGnPwsDU=;
        b=C6VIye+1QvxxHD+S1uPtWsrmlE2KLmwX1+iRBeBtvfGjlUy+Sh1Fg224KFHhcNW8+Y
         G2F5/tELWLZEWz7A8lQTLIlTDmZ0aBaa5EZMjS9lT8p0P4kW9qUcS2SyrrzeUVYHanhx
         og+2qbPtUyYIOIOJesQBpBX15BRVb56OX4RPP1I/2ThvPp4vJ+iREtjiQHIJnBZeEak4
         oecSoRhFD5kWCopc69CVNBRMniG7u+VkUyK/Yn+9xEQlrNXZzOGBqHrquzhlMBNpTny2
         ff6q/5+NHgSDSUAP6KMbn9T0+/Y9pF2G3zMvLd94D6c/qfMJBVvtMTs1fq9EgVMXRq1s
         DKfw==
X-Gm-Message-State: AOAM530UJ7RClJTxNKQ8J1swWjysApty+Fj0mIgiLItYij57FXkPpnF3
        pP9+UCAghde0CubNljdtzFM=
X-Google-Smtp-Source: ABdhPJzpp8NsgtWao7BN/89WKb7tLB8heiKQhS27ZSmlkQ3h1e4126tzTVeigFtMCopitFdecw83dQ==
X-Received: by 2002:ac2:4e83:: with SMTP id o3mr38880723lfr.451.1638868909826;
        Tue, 07 Dec 2021 01:21:49 -0800 (PST)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id k11sm1620497lfo.111.2021.12.07.01.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 01:21:49 -0800 (PST)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH RESEND net-next v2 0/4] WWAN debugfs tweaks
Date:   Tue,  7 Dec 2021 12:21:36 +0300
Message-Id: <20211207092140.19142-1-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resent after dependency [2] was merged to the net-next tree. Added
Leon's reviewed-by tag from the first V2 submission.

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
storage space. See detailed rationale with usage example in the 4th
patch.

The changes themselves are relatively simple, but require a code
rearrangement. So to make changes clear, I chose to split them into
preparatory and main changes and properly describe each of them.

IOSM part is compile-tested only since I do not have IOSM supported
device, so it needs Ack from the driver developers.

I would like to thank Johannes Berg and Leon Romanovsky. Their
suggestions and comments helped a lot to rework the initial
over-engineered solution to something less confusing and much more
simple. Thanks!

Changes since v1:
* 1st and 2nd patches were not changed
* add missed field description in the 3rd patch
* 4th and 5th patches have been merged into a single one with rework of
  the configuration options and and a few other fixes (see detailed
  changelog in the patch)

1. https://lore.kernel.org/netdev/20211120162155.1216081-1-m.chetan.kumar@linux.intel.com
2. https://patchwork.kernel.org/project/netdevbpf/patch/20211204174033.950528-1-arnd@kernel.org/

Cc: M Chetan Kumar <m.chetan.kumar@intel.com>
Cc: Intel Corporation <linuxwwan@intel.com>
Cc: Loic Poulain <loic.poulain@linaro.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Leon Romanovsky <leon@kernel.org>

Sergey Ryazanov (4):
  net: wwan: iosm: consolidate trace port init code
  net: wwan: iosm: allow trace port be uninitialized
  net: wwan: iosm: move debugfs knobs into a subdir
  net: wwan: make debugfs optional

 drivers/net/wwan/Kconfig                  | 13 +++++++++-
 drivers/net/wwan/iosm/Makefile            |  5 +++-
 drivers/net/wwan/iosm/iosm_ipc_debugfs.c  | 29 +++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_debugfs.h  | 17 +++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_imem.c     | 13 ++++------
 drivers/net/wwan/iosm/iosm_ipc_imem.h     |  6 +++++
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 18 --------------
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h |  2 +-
 drivers/net/wwan/iosm/iosm_ipc_trace.c    | 23 ++++++++++++------
 drivers/net/wwan/iosm/iosm_ipc_trace.h    | 25 ++++++++++++++++++-
 drivers/net/wwan/wwan_core.c              | 17 +++++++++----
 include/linux/wwan.h                      |  7 ++++++
 12 files changed, 134 insertions(+), 41 deletions(-)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_debugfs.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_debugfs.h

-- 
2.32.0

