Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622C14C3763
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbiBXVJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiBXVJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:09:11 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A1418FADB;
        Thu, 24 Feb 2022 13:08:41 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 139so2812733pge.1;
        Thu, 24 Feb 2022 13:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uNNVpYnl5NeHmsHUsPYhXiEQ1unwNmX9rkyX1tNf004=;
        b=HGc7nRconlemZZuBiPtvYGCFXvU3023svoGJifQL+qs2PjCU7P5zc0B90whqnlV/l+
         ib6len95/yEQHpLQ4sy57Z0ipHP8uZTfz6veiVkMJXYe72upBmAK3zp0yCnCwPtVBBEr
         mpe9VUUf6KfBPEh9RTHtpiWBS0JIfG3jm2JgCBpu94EJp1nEVKUnA1i/QaVc2jduA5X7
         K95Drcn5lqV1W6R03X8oJTQgIPeuhqE08VnrI+tQjtArsFH3WfVsKFAu8H04ISvp/d3Z
         Rv5N3N5OsOEhG/MnoGohlLWTsB6TZEHWnXruhzfzENPRu23N/wlgUN/dg4NID50mECiZ
         yJUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uNNVpYnl5NeHmsHUsPYhXiEQ1unwNmX9rkyX1tNf004=;
        b=CbQPYecBtUTbiANTaBwJbMrhPcmr5JOae7JFWdbsmtVSLZO6iGK1IHOvH37dKACn0W
         N+EDveeXpnvvM2L8SlIfxRXSjoE9Ey/6UzRJ35foLMmRWXfvdk1w2iO3WsNm7rCasbpH
         hVzqppTGbxspUPOg1CUW8G4kms9Ny2vT1rJuaEw4obzmu40lVSAQQ7bm6kksZpTSHupS
         /u7U94NzCO0uXMSB1fhRyITg+Ds7JTBawfa33cph2SjapI6Gio0EGvqkZcz/WDpFbvMt
         2sRx0gjNB7T+Jl+2Ywo7l24Tn6ocK7KlQcaPYdnoTMIHAsAnnJz7wksPbOnYS7XBPsA6
         2S5w==
X-Gm-Message-State: AOAM532/g2sK9Q+gElGj8PYrJcR0y41SGnqnwBg3eurEyAt7l7iBmseN
        au7wRTYjQ5lB1jAS1Szlgm0=
X-Google-Smtp-Source: ABdhPJx/Q4jXLuqN2ZEPJbAez3to9adYUK6EjKrcGocaEclj0h4c/NA9FpW9S942mLfpmxFksuQYZQ==
X-Received: by 2002:a63:221f:0:b0:374:7286:446a with SMTP id i31-20020a63221f000000b003747286446amr3612717pgi.538.1645736920602;
        Thu, 24 Feb 2022 13:08:40 -0800 (PST)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id d7-20020a056a0024c700b004bd03c5045asm382060pfv.138.2022.02.24.13.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 13:08:40 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2021-06-14
Date:   Thu, 24 Feb 2022 13:08:38 -0800
Message-Id: <20220224210838.197787-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.35.1
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

The following changes since commit 42404d8f1c01861b22ccfa1d70f950242720ae57:

  net: mv643xx_eth: process retval from of_get_mac_address (2022-02-24 10:05:08 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-02-24

for you to fetch changes up to a56a1138cbd85e4d565356199d60e1cb94e5a77a:

  Bluetooth: hci_sync: Fix not using conn_timeout (2022-02-24 21:34:28 +0100)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fix regression with RFCOMM
 - Fix regression with LE devices using Privacy (RPA)
 - Fix regression with LE devices not waiting proper timeout to
   establish connections
 - Fix race in smp

----------------------------------------------------------------
Lin Ma (1):
      Bluetooth: fix data races in smp_unregister(), smp_del_chan()

Luiz Augusto von Dentz (4):
      Bluetooth: hci_core: Fix leaking sent_cmd skb
      Bluetooth: Fix bt_skb_sendmmsg not allocating partial chunks
      Bluetooth: hci_sync: Fix hci_update_accept_list_sync
      Bluetooth: hci_sync: Fix not using conn_timeout

Wang Qing (1):
      Bluetooth: assign len after null check

 include/net/bluetooth/bluetooth.h |  3 +--
 include/net/bluetooth/hci_core.h  |  8 ++++++++
 net/bluetooth/hci_core.c          |  1 +
 net/bluetooth/hci_sync.c          | 30 +++++++++++++++++++++---------
 net/bluetooth/mgmt_util.c         |  3 ++-
 5 files changed, 33 insertions(+), 12 deletions(-)
