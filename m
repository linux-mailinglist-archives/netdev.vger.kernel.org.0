Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD36058B2C0
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 01:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241616AbiHEX2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 19:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238141AbiHEX2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 19:28:38 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E845175BA;
        Fri,  5 Aug 2022 16:28:37 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id q9-20020a17090a2dc900b001f58bcaca95so2755564pjm.3;
        Fri, 05 Aug 2022 16:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lX56W+vf9zyDi6j+4csF/9/BmLcJVTV+VtL7UwiF1kU=;
        b=kSYAoigWbys1J8x42COsIgNq0tj0TDFGrIxsxbOpW89BiNIxYK2CaschD3KPfcrPXR
         J51wWi3xlYgvhC5m3YMn8+m4uqVysssMVuTlT/LXrp8yCmxfS1T7cm5vJlvbLCC/Pr9b
         Qb+jJi4JIFkF+rVr+yTy6n+CyLK7L/pAj+EGsmQnEdEYp4AsN6M+DbID6qh3HW/Vw6sl
         rxZfEdTdeJ8Hay7556tcvm1vXJPiofktxsqxi87s8qi3Ik+OkAgjoijVbG/hqdAIGpPG
         lShaAxfqglwHhpeNk9wfk6tiTfMFz4LsgnEy/JEVEmN8JS5mZYsPBCd6b+E6sHglUUxu
         WKFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lX56W+vf9zyDi6j+4csF/9/BmLcJVTV+VtL7UwiF1kU=;
        b=dMfXkZXrfNlHeUi32p9ukZazsBct0Ast2BVOSqW+BXtYk1JXN9/RW25qbhQxYIXUcj
         xrNusSMDuxXgl72eSXbtt1WLaTHtMmB+SymUGFmxoCNly1PLsji5u/mfi8rnnNhubB86
         AXLOS7w2q6Uu8m8bQFhZNy5ZSLORNK/4gEHg/xyNfTmF4aE5uJ7dHCdofWaorurW6Y0u
         D37sdznR/0Wb1I/T/VoK4kyrK218htZrel8OUv03P4zo7V7lI5QAjfGXm8MoZkNKxgYW
         a6dNl3eJCwwhbl4loosHoaAbLAtusaS1SHlOa69us7VO6VQj1CVdp/8ibxu16S5EVsIy
         svhg==
X-Gm-Message-State: ACgBeo24mhD7l3RZeUwRQHrd1+vsbbAgtZ/zuzRaPQMnaIaxv/n04fwU
        99APVFpX+QTkwyo4W/L5q1uLuWr0HUGMCA==
X-Google-Smtp-Source: AA6agR65pIa56/i9mU3EnoLdfy9Ftgghi768bf6UA5fai+49ld34Y8ildj4dGfEinMUUWx/ndeibDg==
X-Received: by 2002:a17:902:f788:b0:16c:f48b:905e with SMTP id q8-20020a170902f78800b0016cf48b905emr8921616pln.60.1659742116392;
        Fri, 05 Aug 2022 16:28:36 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id u17-20020a170902e5d100b0016c78aaae7fsm3716200plf.23.2022.08.05.16.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 16:28:35 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2022-08-05
Date:   Fri,  5 Aug 2022 16:28:34 -0700
Message-Id: <20220805232834.4024091-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 2e64fe4624d19bc71212aae434c54874e5c49c5a:

  selftests: add few test cases for tap driver (2022-08-05 08:59:15 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-08-05

for you to fetch changes up to 118862122fcb298548ddadf4a3b6c8511b3345b7:

  Bluetooth: ISO: Fix not using the correct QoS (2022-08-05 16:16:54 -0700)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fixes various issues related to ISO channel/socket support
 - Fixes issues when building with C=1
 - Fix cancel uninitilized work which blocks syzbot to run

----------------------------------------------------------------
Dan Carpenter (1):
      Bluetooth: ISO: unlock on error path in iso_sock_setsockopt()

Luiz Augusto von Dentz (8):
      Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression
      Bluetooth: hci_conn: Fix updating ISO QoS PHY
      Bluetooth: ISO: Fix info leak in iso_sock_getsockopt()
      Bluetooth: ISO: Fix memory corruption
      Bluetooth: hci_event: Fix build warning with C=1
      Bluetooth: MGMT: Fixes build warnings with C=1
      Bluetooth: ISO: Fix iso_sock_getsockopt for BT_DEFER_SETUP
      Bluetooth: ISO: Fix not using the correct QoS

Soenke Huster (1):
      Bluetooth: Fix null pointer deref on unexpected status event

Tetsuo Handa (1):
      Bluetooth: don't try to cancel uninitialized works at mgmt_index_removed()

 net/bluetooth/aosp.c       | 15 ++++++++++++---
 net/bluetooth/hci_conn.c   | 11 ++---------
 net/bluetooth/hci_event.c  |  7 +++++--
 net/bluetooth/iso.c        | 35 +++++++++++++++++++++++------------
 net/bluetooth/l2cap_core.c | 13 ++++++-------
 net/bluetooth/mgmt.c       |  7 ++++---
 net/bluetooth/msft.c       | 15 ++++++++++++---
 7 files changed, 64 insertions(+), 39 deletions(-)
