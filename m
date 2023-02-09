Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65EF16914E6
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 00:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjBIXt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 18:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBIXtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 18:49:25 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9323B392BC;
        Thu,  9 Feb 2023 15:49:24 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id u9so4713383plr.9;
        Thu, 09 Feb 2023 15:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OTry8m2lgEYJMqD8o2IL6haCJmivlF+7KsiMT4rNYK8=;
        b=C5wXWaxBRNgT7M58w4SUH4jYhUucKLPjJEGq3ex+5TmZ+D6c4pQC1xpm6xkdbgHC/k
         BoAzzSZqG03Z8hHX6i08DYA34uHcLLBJ3DXJdJDzYAE+2KkiU0vNhw98hRSjrrjr5fnh
         IyK0Q9ZWQ2RJpezLuFtn6iduWdaRnTk3kCIDHrR+86S0jkWvvlefccJ59eNz8PoParMl
         QGG3AGGLyC+ir+Dw/eDcUsoCwtcHAfwfBEvqxcQY4T+HqkB5TmmNuhuDw2m27pdN88Do
         9UnlVrVfQ8zhWPiZuVN4WK9hRpJ0uyFGbinPI8AmhmgEyydnenMh0o0Ld5TjOShAf5Sl
         jsIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OTry8m2lgEYJMqD8o2IL6haCJmivlF+7KsiMT4rNYK8=;
        b=VE2gbH1iUZuCgbqLFqd90K2m6Qcz2KdAe/Ev8XS/UOs+fmO91aJoyMK+TKTk7YGlxq
         Dkl411WxLcGPbNSYArPCYJh307EKtKe+Vj4WbdxcdglJcMLzbwAvExpd2T6arQPyxeqX
         Orhvq41ch7/+lLD88LMC5Wcaj8Hv/1mESTT7ydvTRYrhJEahR9J9LtB+IRvptpCgMLnQ
         7l3+3s9IlS8J0jlz7wc6jvGqxgeGQs0WPAGer+R7+3p0wFY6uyMDdkNZEI4u0vci6wDw
         4/1aBEOJbkZ6lTYxkkqEBl7JeDDqOlznctBgqAkIkwhD6VdXDP+RfmdA023N9MOlfvmm
         PFDQ==
X-Gm-Message-State: AO0yUKXq3eTLowyE13VYk9xfCNOsu+p9/2Wx8/TJ/+LhbfxxuOBqAZ2C
        yGSNKCG2kO4Oc3lGBehf6j+8uAADjV4eiA==
X-Google-Smtp-Source: AK7set8S2RvgOIXOtxna+yzcD4OAOGO4liQ4FrUxyfl/F5WDxPSMK11CkD7Nu9W3az2otclrxcKmJw==
X-Received: by 2002:a17:903:110e:b0:19a:7217:32a9 with SMTP id n14-20020a170903110e00b0019a721732a9mr172252plh.26.1675986563905;
        Thu, 09 Feb 2023 15:49:23 -0800 (PST)
Received: from lvondent-mobl4.. (c-71-59-129-171.hsd1.or.comcast.net. [71.59.129.171])
        by smtp.gmail.com with ESMTPSA id jk23-20020a170903331700b001926392adf9sm2057507plb.271.2023.02.09.15.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 15:49:23 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2023-02-09
Date:   Thu,  9 Feb 2023 15:49:22 -0800
Message-Id: <20230209234922.3756173-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 8697a258ae24703267d2a37d91ab757c91ef027e:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-02-09 12:25:40 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2023-02-09

for you to fetch changes up to c585a92b2f9c624b0b62b2af1eb0ea6d11cb5cac:

  Bluetooth: btintel: Set Per Platform Antenna Gain(PPAG) (2023-02-09 14:20:04 -0800)

----------------------------------------------------------------
bluetooth-next pull request for net-next:

 - Add new PID/VID 0489:e0f2 for MT7921
 - Add VID:PID 13d3:3529 for Realtek RTL8821CE
 - Add CIS feature bits to controller information
 - Set Per Platform Antenna Gain(PPAG) for Intel controllers

----------------------------------------------------------------
Archie Pusaka (2):
      Bluetooth: Free potentially unfreed SCO connection
      Bluetooth: Make sure LE create conn cancel is sent when timeout

Gustavo A. R. Silva (1):
      Bluetooth: HCI: Replace zero-length arrays with flexible-array members

Kees Cook (1):
      Bluetooth: hci_conn: Refactor hci_bind_bis() since it always succeeds

Luiz Augusto von Dentz (2):
      Bluetooth: qca: Fix sparse warnings
      Bluetooth: L2CAP: Fix potential user-after-free

Marcel Holtmann (1):
      Bluetooth: Fix issue with Actions Semi ATS2851 based devices

Mario Limonciello (1):
      Bluetooth: btusb: Add new PID/VID 0489:e0f2 for MT7921

Moises Cardona (1):
      Bluetooth: btusb: Add VID:PID 13d3:3529 for Realtek RTL8821CE

Pauli Virtanen (1):
      Bluetooth: MGMT: add CIS feature bits to controller information

Seema Sreemantha (1):
      Bluetooth: btintel: Set Per Platform Antenna Gain(PPAG)

Zhengping Jiang (1):
      Bluetooth: hci_qca: get wakeup status from serdev device handle

 drivers/bluetooth/btintel.c  | 116 +++++++++++++++++++++++++++++++++++++++++++
 drivers/bluetooth/btintel.h  |  13 +++++
 drivers/bluetooth/btusb.c    |  16 ++++++
 drivers/bluetooth/hci_qca.c  |  11 ++--
 include/net/bluetooth/hci.h  |   4 +-
 include/net/bluetooth/mgmt.h |   2 +
 net/bluetooth/hci_conn.c     |  23 +++++----
 net/bluetooth/l2cap_core.c   |  24 ---------
 net/bluetooth/l2cap_sock.c   |   8 +++
 net/bluetooth/mgmt.c         |  12 +++++
 10 files changed, 188 insertions(+), 41 deletions(-)
