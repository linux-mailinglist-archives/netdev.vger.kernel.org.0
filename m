Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25DD567856
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 22:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiGEU1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 16:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiGEU1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 16:27:04 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DFB19C04;
        Tue,  5 Jul 2022 13:27:03 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id y14-20020a17090a644e00b001ef775f7118so9769022pjm.2;
        Tue, 05 Jul 2022 13:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4I/vTUX5/VX521F5N8ofDJR9PHwj5AGCwWWyLQBWNyU=;
        b=ok0BgEqQmI6FnWWvJQKvLaVsAC0SNtK+qdzMA8rmadg4we4PNa3OK6ZqUjEUJxebi1
         0OR0ufr1y+KJNh5Rs3Tr3DFQD06T+6vg74eAyZIMUUP3jXgvVBOl57EnbI1IxFDOTrqy
         bs//Qo4EXHP1D55KEMNWaFO/7oG6XMuEbJtQgFhrAFKatmsuAEDe4oceA2uHgiDpy2Vr
         mzgh8tyxGks8KcpZRQpM+XFE/QdIwugWDXpb71WtbudqJ/Uldq9Zi9uI5UujnetnokUP
         8Kw8QxCrE0tXPmlifsYfkQOjebolWD/N/cnJO41ebeccNqaYkcXc2zfMIxOZDGHANg3J
         gOcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4I/vTUX5/VX521F5N8ofDJR9PHwj5AGCwWWyLQBWNyU=;
        b=IAACA4uO+6dm75pytCkKDysAXA2vEnMGkBSJrkOw3CmCnRcs3SQD3VSa+9cS82zGRx
         rMv58rZVyehOWSlN6Z6o8piadDRcinGozKKV8ecrbjiM1liCdQyW6Nn+dvaUubJQ4y2i
         t62jHUc+syT15nJxsR3imIGLxTXbHsf8HVfRdmhZf5TlA4kewRBo/416IBKwhVRc/ePo
         PWfphdKLwk8sPV4gCi9tB4I9YfxSBhVBc/BCVGiBYf13vum+S6lCAROPBULdqFPGzl3U
         zXUAMZUM/GhzMg1lDnhHFHkDC1STu3Jo7r14WMuMURwpfDmMwKzlnmymAJdHyRmtnDzf
         6Jmw==
X-Gm-Message-State: AJIora+jXjZgKodLmf/39HVpQHVbR77QglPDwbil3H1tIp8sZ/0I/KrX
        PjYqi1p9DanA6QAJsaUgW7+0KuCWkagzog==
X-Google-Smtp-Source: AGRyM1uwDtLWN/wn3Mse1jNB9FnsmxRZcwVHH5moijxgBaZ2cQpFyw54PM3pS+MUGSmwkGoGXD2S1w==
X-Received: by 2002:a17:90b:390c:b0:1ec:ae13:c5aa with SMTP id ob12-20020a17090b390c00b001ecae13c5aamr45144367pjb.64.1657052822616;
        Tue, 05 Jul 2022 13:27:02 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id m10-20020a170902f64a00b0016bf01394e1sm2380879plg.124.2022.07.05.13.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 13:27:02 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2022-07-05
Date:   Tue,  5 Jul 2022 13:27:00 -0700
Message-Id: <20220705202700.1689796-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.35.3
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

The following changes since commit 029cc0963412c4f989d2731759ce4578f7e1a667:

  Merge branch 'fix-bridge_vlan_aware-sh-and-bridge_vlan_unaware-sh-with-iff_unicast_flt' (2022-07-05 11:52:35 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-07-05

for you to fetch changes up to e36bea6e78ab2b6c9c7396972fee231eae551cfc:

  Bluetooth: core: Fix deadlock on hci_power_on_sync. (2022-07-05 13:20:03 -0700)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fix deadlock when powering on.

----------------------------------------------------------------
Vasyl Vavrychuk (1):
      Bluetooth: core: Fix deadlock on hci_power_on_sync.

 net/bluetooth/hci_core.c | 3 +++
 net/bluetooth/hci_sync.c | 1 -
 2 files changed, 3 insertions(+), 1 deletion(-)
