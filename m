Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2936C58D13E
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 02:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244450AbiHIAM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 20:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbiHIAM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 20:12:27 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA7512AFC;
        Mon,  8 Aug 2022 17:12:27 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id h28so9423868pfq.11;
        Mon, 08 Aug 2022 17:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wWVSWwBjUjhre+TPE3Gad01Q+7UOwhiBi4KtMcK9pqE=;
        b=VWid3e0Jq3IOssNjMVAGL4s3DYu8gO/IysbvXN4xo+92ikwKo+v7cScLS8TOy/C7u4
         lLQ777aZVuif9S4vcIXq5XItQ8N/HNK8DtxJJAkTa9McKOIxY6wFK9cLL3WLFtYkq5NL
         OV6Kj8xSZkevywVuqHS/Nb51UGoITnbLrsrVm2SJkSkbLjo3i4XqutTccMck2klxgp1D
         C2WQlG8al0agtuhrXTeYPgJAYARThigS1BqhyApuCeeK9ZlSJuQ6LEClr7drGOWEqOCU
         51xH3FrBanS48KMUJsppZbXJz6iytmMAaPWoy1pIHhLVgvDy8MoTF1A/ca14r8u2e7b1
         uKNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wWVSWwBjUjhre+TPE3Gad01Q+7UOwhiBi4KtMcK9pqE=;
        b=XI4y/lDj5RU5tz5408rWfV3teXk/Rh+oU3t8Thu5+cUAb+/K9vnA0wDxF3UQ+Unq86
         VMTbbLk1mswoXyDTekzgOxWO3Ir5y3e73aZ7i/EGBrCHwDyNNGrR2j1wF/fQcV/AUKt5
         bbFENAsRq79wjRF3fuiq4/pE1QkyPhzYwTVfLuIB19M7l/hJ2qsgACnOkCisJiWaYFoK
         nILK01Pe5QSKGZVPPE9rJP97crF9gtbVx7Pg7W8gxAWVPtNKqv5FWgNRCFlYqCm9xK7c
         RPFfpaBxZ5m7ErrKTZKiSA/0Be6oeOh/vjPzhguyV7n0lyNK0U+DTuW6pNWuUcuCdKs1
         mqdg==
X-Gm-Message-State: ACgBeo19kVS8hj8zztmkPEHmKkaTVbrmVNTtw47ha6m4FpptE52L2qnA
        IH8nBocH+U6jCDXnjY+tf2NlM2dRWNM97w==
X-Google-Smtp-Source: AA6agR4hG+U/cpehPdz44GuaSY2eAbaf+5G4VCMVkfPfEu6I6gLgEk1TZOqkKVFK3jxIRKi4+AT8BA==
X-Received: by 2002:a63:7847:0:b0:41c:9e74:21e2 with SMTP id t68-20020a637847000000b0041c9e7421e2mr17696573pgc.455.1660003946502;
        Mon, 08 Aug 2022 17:12:26 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id g6-20020a63fa46000000b0041c35462316sm6972177pgk.26.2022.08.08.17.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 17:12:25 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2022-08-08
Date:   Mon,  8 Aug 2022 17:12:24 -0700
Message-Id: <20220809001224.412807-1-luiz.dentz@gmail.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-08-08

for you to fetch changes up to 1d1ab5d39be7590bb2400418877bff43da9e75ec:

  Bluetooth: ISO: Fix not using the correct QoS (2022-08-08 17:06:36 -0700)

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
