Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FC1641014
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 22:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbiLBVhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 16:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234591AbiLBVha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 16:37:30 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCF9EF8B7;
        Fri,  2 Dec 2022 13:37:28 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so6269711pjm.2;
        Fri, 02 Dec 2022 13:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4UOloO9pDz4FtFNPAh4XXQoSepf9fUAyOv9HOH5L6WY=;
        b=bYC1Lt29qeIQP5kiSMsjIQU2a00Tnc/b3hLSM/Cf5xhl4523GeKTMvATrdjUoS2sMH
         QmnfnuW7g/Nc1lgogkoikjzENdsuXMwvpT8QJOylyhwXE3M9SU8oB0+nKv4WgcCmsQ2T
         5trTVrQFDRmACQcFfCavn7OJPAHK8E08DYxHOQOdj8NgDnACfnN8Q2p1gljbFsSwwag/
         6Z5cvhfa4Yiloyj6NEVfd0G20qTBH8xqCvQdgBmRLTagDtGoN4HyzY/dZXuOC7kwCHqD
         qqLF7NYLzXlWVLkPI45fj/NZKbhrMQNKbGcXFe715s39OPW7ebqinskoQkcOFIznc1sz
         Mn+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4UOloO9pDz4FtFNPAh4XXQoSepf9fUAyOv9HOH5L6WY=;
        b=N2FmV8qqE5WAk1J0T4Hxho3ixvW5HVu4pzQNexwjMFsT3b03TZ9FDF/LESQo+BOtqm
         u0H8tXWdkGDR+KEAvSRGM++eLh1BqOHhDvADKEna1NEnePdcoRT4nphvd2mGxJUOoxjU
         0D8J1kxFgfBOhVFpCO8vzCzZGeQbMzpr+ko0Y1q9a39SSn/UiuxgPIuZjkzXXgFKJE9n
         9Kf8lwNvyV4DDSfapZNPsVhfjiaxXemtYVcofrz+7BuWFaYNsJNbBgtzAi+d4Dlx1wXF
         +b6EeShHt6RD6LMFrrQMVAlnXpbOzf7wb6uldP0X+xtKY5nQLGpVUR5ijKtJo1Go4Ncf
         UNnw==
X-Gm-Message-State: ANoB5pnwydZ3juspqUr1y1PumaQ3wRCoLx3gmDTaS8TmHPrNqyIyKEEK
        ZTk5j1jcSubm23hmd2QxwpE+TrfcJTvVHIQZ
X-Google-Smtp-Source: AA0mqf6Dtsu+YQfwTveh56W5hlGVRGotWytljPsWTvRuitoNAjmPyhck/w8ra08ymRmFhackd+yA8A==
X-Received: by 2002:a17:902:9a87:b0:189:af68:472f with SMTP id w7-20020a1709029a8700b00189af68472fmr12071873plp.134.1670017048260;
        Fri, 02 Dec 2022 13:37:28 -0800 (PST)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id x8-20020a170902ec8800b001895d87225csm6028779plg.182.2022.12.02.13.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 13:37:27 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull-request: bluetooth 2022-12-02
Date:   Fri,  2 Dec 2022 13:37:26 -0800
Message-Id: <20221202213726.2801581-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

The following changes since commit e931a173a685fe213127ae5aa6b7f2196c1d875d:

  Merge branch 'vmxnet3-fixes' (2022-12-02 10:30:07 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-12-02

for you to fetch changes up to b5ca338751ad4783ec8d37b5d99c3e37b7813e59:

  Bluetooth: Fix crash when replugging CSR fake controllers (2022-12-02 13:22:56 -0800)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fix regressions with CSR controller clones
 - Fix support for Read Local Supported Codecs V2
 - Fix overflow on L2CAP code
 - Fix missing hci_dev_put on ISO and L2CAP code

----------------------------------------------------------------
Chen Zhongjin (1):
      Bluetooth: Fix not cleanup led when bt_init fails

Chethan T N (2):
      Bluetooth: Remove codec id field in vendor codec definition
      Bluetooth: Fix support for Read Local Supported Codecs V2

Ismael Ferreras Morezuelas (2):
      Bluetooth: btusb: Fix CSR clones again by re-adding ERR_DATA_REPORTING quirk
      Bluetooth: btusb: Add debug message for CSR controllers

Luiz Augusto von Dentz (1):
      Bluetooth: Fix crash when replugging CSR fake controllers

Mateusz Jończyk (1):
      Bluetooth: silence a dmesg error message in hci_request.c

Sungwoo Kim (1):
      Bluetooth: L2CAP: Fix u8 overflow

Wang ShaoBo (2):
      Bluetooth: 6LoWPAN: add missing hci_dev_put() in get_l2cap_conn()
      Bluetooth: hci_conn: add missing hci_dev_put() in iso_listen_bis()

 drivers/bluetooth/btusb.c    |  6 ++++++
 include/net/bluetooth/hci.h  | 12 +++++++++++-
 net/bluetooth/6lowpan.c      |  1 +
 net/bluetooth/af_bluetooth.c |  4 +++-
 net/bluetooth/hci_codec.c    | 19 ++++++++++---------
 net/bluetooth/hci_core.c     |  8 ++++++--
 net/bluetooth/hci_request.c  |  2 +-
 net/bluetooth/hci_sync.c     | 19 +++++++++++++------
 net/bluetooth/iso.c          |  1 +
 net/bluetooth/l2cap_core.c   |  3 ++-
 10 files changed, 54 insertions(+), 21 deletions(-)
