Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692793DD15A
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 09:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbhHBHk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 03:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232623AbhHBHk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 03:40:56 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94404C0613D5
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 00:40:47 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id l4-20020a05600c1d04b02902506f89ad2dso11018819wms.1
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 00:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=LQCoZj4nUTe1FLvp5O7rprBx8ufeBQm/FjsSn1lIrsw=;
        b=kzjY5IRa5fbIrlEWwtbqQto0CC3SKK2NRDW3gZqTdfyYfxr9Si5roxWC2GbsGxuvMD
         tmr+70EEQcX2CXEeQ6Z5PSmgLtxdIWtlCXxjQ0c1shdGF8ArZoQnBeZ01eyintAwsptw
         eFpi5pXeC4P+oT+Au/j7GtIgoEQ81l1QQBiD87SR2bEKdVNhvovpenW0xoNgc3mLJTwS
         LIAU/Eoy3UZrx4W36DMPQWzaCy4qKT/qe2D+TsGFxN//tjEEzxz4wLZ00IQzmKbGvzPE
         Svq2wd+vdDRiUv58luT5pvh06hL9Lkjw/W9GDEiwe4XqBGKmIFP6b+vkmKzZdKayH5rX
         lrEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LQCoZj4nUTe1FLvp5O7rprBx8ufeBQm/FjsSn1lIrsw=;
        b=Hi7QFqB0ge8IvKIAoMSBVRwVo+jwCb5Rrxzsiu5TMOauiAj3lnFAigRC71RfMCoj+d
         aBzFW8WTiJxyVqSfyV1wExB9EvKoYR3RtTMGEZc2ojIFR1gQbAFjjQXqJTHh2OFKB1UR
         dVmDDeRyY9d6H/5ZTLOltXiCqokUsNHJMuioVWlJcm33NDJoyCYlAIIkkVowI0PlJGIr
         IH3R95b8JzShRY9MO/nCkwuDvCy/a+CoNYLt5HYTktNvG95h5eu8qhVaI/9yy2pcXcoj
         7mB06z6yQsdAjuwldAMkCbgMw5sA1ReR+UJq+w8VRt/n/x5mWn08y6326I5hqHBY5Inq
         wTeg==
X-Gm-Message-State: AOAM532+U3t6MOOPX70gn8oOKq+jTLmO4Hg2Y/Y0Iz+6Kf+ZE1rkjCpN
        a+diDBs0QN7qZ1+zvyOWzMmjVSji2gUSm0Ur
X-Google-Smtp-Source: ABdhPJxurtJJ2FZ1tzW/s8d/bhp4qEl55waS0BC8lXRLpYzJcR3/uLuZZsNWmBc/MqahIFv1AfAmbw==
X-Received: by 2002:a05:600c:1c13:: with SMTP id j19mr13418586wms.164.1627890045748;
        Mon, 02 Aug 2021 00:40:45 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:69b5:b274:5cfc:ef2])
        by smtp.gmail.com with ESMTPSA id c190sm1616216wma.21.2021.08.02.00.40.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Aug 2021 00:40:45 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, johannes@sipsolutions.net,
        richard.laing@alliedtelesis.co.nz,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next RESEND 0/2] net: mhi: move MBIM to WWAN
Date:   Mon,  2 Aug 2021 09:51:01 +0200
Message-Id: <1627890663-5851-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement a proper WWAN driver for MBIM network protocol, with multi link
management supported through the WWAN framework (wwan rtnetlink).

Until now, MBIM over MHI was supported directly in the mhi_net driver, via
some protocol rx/tx fixup callbacks, but with only one session supported
(no multilink muxing). We can then remove that part from mhi_net and restore
the driver to a simpler version for 'raw' ip transfer (or QMAP via rmnet link).

Note that a wwan0 link is created by default for session-id 0. Additional links
can be managed via ip tool:

    $ ip link add dev wwan0mms parentdev wwan0 type wwan linkid 1

Loic Poulain (2):
  net: wwan: Add MHI MBIM network driver
  net: mhi: Remove MBIM protocol

 drivers/net/Kconfig              |   4 +-
 drivers/net/Makefile             |   2 +-
 drivers/net/mhi/Makefile         |   3 -
 drivers/net/mhi/mhi.h            |  41 ---
 drivers/net/mhi/net.c            | 487 -----------------------------
 drivers/net/mhi/proto_mbim.c     | 310 -------------------
 drivers/net/mhi_net.c            | 418 +++++++++++++++++++++++++
 drivers/net/wwan/Kconfig         |  12 +
 drivers/net/wwan/Makefile        |   1 +
 drivers/net/wwan/mhi_wwan_mbim.c | 648 +++++++++++++++++++++++++++++++++++++++
 10 files changed, 1082 insertions(+), 844 deletions(-)
 delete mode 100644 drivers/net/mhi/Makefile
 delete mode 100644 drivers/net/mhi/mhi.h
 delete mode 100644 drivers/net/mhi/net.c
 delete mode 100644 drivers/net/mhi/proto_mbim.c
 create mode 100644 drivers/net/mhi_net.c
 create mode 100644 drivers/net/wwan/mhi_wwan_mbim.c

-- 
2.7.4

