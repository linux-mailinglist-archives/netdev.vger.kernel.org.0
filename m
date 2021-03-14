Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A811033A7D2
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 21:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbhCNUS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 16:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbhCNUS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 16:18:28 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D123C061574;
        Sun, 14 Mar 2021 13:18:28 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id r16so3987621pfh.10;
        Sun, 14 Mar 2021 13:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2KWRxAevKiF/nnG0NBxKJ90p3c03jicsIIQLN81D4+4=;
        b=dlSZJM5E6KEIz/mQPWyAmpVaYyjY3Rvy8gwGV7saPomtCAC9wAxu23SSOTxQM+POld
         ApylWsy7XPCz/TjtLEzCQv9zfE9jW1h/lTmg/uIErdsFFSy2YpnQd8u+mkdYtpS4wACw
         0wMYw4qwMosyOfd3IGfJNYdLTrEdOZ3c3EDofPW8xb8VkyFpreYce8+qX8JENLEV9qp7
         hqkQDfZUABRmzYeUiIcSWaRs3ro97zRhkuFP3iDFS7oyiEtO9UIFW6+eFCm/MPPIP4ig
         mDiCcMq4XJJ9ybVwuOlPMGYhLj/tPjwInHbp+6mIVJ8pWp7zw8RQlvk55VfZkkOY8/cx
         uQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2KWRxAevKiF/nnG0NBxKJ90p3c03jicsIIQLN81D4+4=;
        b=rcQ8hvBNAjZ9TQUx4MNCltMCAsIvOz04lV8RjGM2XQwEFq1DhOTKAljiO2APAS1Idk
         UVsXS/s9DxfWrQ5oIPHDlXKc8Z8lV4J/IYmat4PfZhn9TZYV99idZpSzd505NbfzCK6L
         GrWkt/IeI2O1c6+W6QiEXe0SC4+nywoJ+15dOX/Ij6V9sDiO67U06RK2zBMRhS/hGibv
         s/EY4dk24olNdzWmj91NKRmYgIy7b4kYqFsXWC3jIBoohjwNLpfkim0Hif4p3/46njml
         pwuzZetH7btYfd5k3Yfs3u7zYhbDJh976HQlMNVNvh6Dtk5XKbM9qXGTWseVHcbLmEYx
         JJMw==
X-Gm-Message-State: AOAM533OPnBcl9jyOS3jQSyAov1zlgocETlKH9JKzcDaITymyqUSqb/2
        HiRiupMOATswYN87F8JC9SJS930DqZ3gfg==
X-Google-Smtp-Source: ABdhPJy4ATZPIIwNAbFc1z03hT4a4prxYKmXxZ6RJ/mIp0hm+z5kHuivT2nYjXm2XQv/addtA2M5KQ==
X-Received: by 2002:a63:2c8f:: with SMTP id s137mr4061238pgs.51.1615753108099;
        Sun, 14 Mar 2021 13:18:28 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a089:acdc:a5a5:c438:c1e3])
        by smtp.googlemail.com with ESMTPSA id n10sm10943793pgk.91.2021.03.14.13.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 13:18:27 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     siva8118@gmail.com
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        amitkarwar@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/10] rsi: fix comment syntax in file headers
Date:   Mon, 15 Mar 2021 01:48:08 +0530
Message-Id: <20210314201818.27380-1-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.
There are files in drivers/net/wireless/rsi which follow this syntax in
their file headers, i.e. start with '/**' like comments, which causes
unexpected warnings from kernel-doc.

E.g., running scripts/kernel-doc -none on drivers/net/wireless/rsi/rsi_coex.h
causes this warning:
"warning: wrong kernel-doc identifier on line:
 * Copyright (c) 2018 Redpine Signals Inc."

Similarly for other files too.

Provide a simple fix by replacing the kernel-doc like comment syntax with
general format, i.e. "/*", to prevent kernel-doc from parsing it.

* The patch series applies perfectly on next-20210312

Aditya Srivastava (10):
  rsi: rsi_boot_params: fix file header comment syntax
  rsi: rsi_coex: fix file header comment syntax
  rsi: rsi_ps: fix file header comment syntax
  rsi: rsi_common: fix file header comment syntax
  rsi: rsi_mgmt: fix file header comment syntax
  rsi: rsi_main: fix file header comment syntax
  rsi: rsi_hal: fix file header comment syntax
  rsi: rsi_debugfs: fix file header comment syntax
  rsi: rsi_sdio: fix file header comment syntax
  rsi: rsi_usb: fix file header comment syntax

 drivers/net/wireless/rsi/rsi_boot_params.h | 2 +-
 drivers/net/wireless/rsi/rsi_coex.h        | 2 +-
 drivers/net/wireless/rsi/rsi_common.h      | 2 +-
 drivers/net/wireless/rsi/rsi_debugfs.h     | 2 +-
 drivers/net/wireless/rsi/rsi_hal.h         | 2 +-
 drivers/net/wireless/rsi/rsi_main.h        | 2 +-
 drivers/net/wireless/rsi/rsi_mgmt.h        | 2 +-
 drivers/net/wireless/rsi/rsi_ps.h          | 2 +-
 drivers/net/wireless/rsi/rsi_sdio.h        | 2 +-
 drivers/net/wireless/rsi/rsi_usb.h         | 2 +-
 10 files changed, 10 insertions(+), 10 deletions(-)

-- 
2.17.1

