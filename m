Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04275B4068
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 22:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbiIIUQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 16:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbiIIUQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 16:16:45 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88B9122384;
        Fri,  9 Sep 2022 13:16:44 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id iw17so2837781plb.0;
        Fri, 09 Sep 2022 13:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=9VcEOS6tYLKIyOQMQW0PNupq+2esyo3BxlMVIMYy3Es=;
        b=goNX8ojnJkZ7wZ953PokHx25OK65eCiCsZEOFSuYyEvSNaASosD9UIFvl6jryTbyUn
         cHQ5Dt7TYgPGDrlwus3gAIrmxkxwUlIodi94Ioay9uOc8ny/3FxB0+klzXQnaaYEpYNx
         OQ+7S1Wp64x+ulKJ6J+JOgZtuchNr6mtnh7LkZG9Gsx4L0sIdYyG0guoPh4g/qw6eT43
         wtrNQ6o+Mdk9vEDsLmdhK5Rdgq2CnWj6dE60LvGIBft1s1IoeCiFCt14TaxEybdYl3qA
         twW6AefXXgN1g3i9p9rDPCzEx22RSZwOpKwYbSHuXw54D71vUqjjZTbvf43I7wUxpLxT
         QYtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=9VcEOS6tYLKIyOQMQW0PNupq+2esyo3BxlMVIMYy3Es=;
        b=hhqd+bIb/UVVc2iHKSi34rSF/T2B66e0Z2lwNSbs6YbR8ReTJkxadRS6W7hZrYoKq3
         w2YFdLrjg8/8cpesK7HIpHh2btWVZYUimLfCfmyx7Ns2K+pyUVo+yJsM273hNNEL3FxB
         nR5qz62bhJ5TpRvt2i+f9lR8ppKFUHBDhTabz0IYF/AbBBO8kOOR6dNUibyxmxULbjjH
         bfI2Gu8EK2AAz6p2GyZX4B6TQUaTmhTTsyZxWoMYHT/WJGzI5hRMg/ISyVX56fgNpaSJ
         k7s/+UJrRVnaX3E3KamNxumoU57+YMto4+x/6djtnwKL4cHI3Rb3t/uyPIN6Oc9UYypM
         AAwA==
X-Gm-Message-State: ACgBeo3Qz1OQpAs4JyLFgTviz0jQV/XyrK8TVcdH3Dl6s4cAUbpAk2XE
        RdTl/CvM2AYCcr1YF22wl0Hh7tgHW9XAqQ==
X-Google-Smtp-Source: AA6agR4OibZJpiqzs7z/LQj2JCypTsO+jgnlq788FbbcRxXqsfvD2fBwkwmKM90B0D1Ny1GJfETGcQ==
X-Received: by 2002:a17:90b:17c7:b0:202:95a2:e30f with SMTP id me7-20020a17090b17c700b0020295a2e30fmr2921283pjb.28.1662754604276;
        Fri, 09 Sep 2022 13:16:44 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id e12-20020a170902784c00b0016c78f9f024sm867987pln.104.2022.09.09.13.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 13:16:43 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2022-09-09
Date:   Fri,  9 Sep 2022 13:16:42 -0700
Message-Id: <20220909201642.3810565-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.37.2
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

The following changes since commit 64ae13ed478428135cddc2f1113dff162d8112d4:

  net: core: fix flow symmetric hash (2022-09-09 12:48:00 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-09-09

for you to fetch changes up to 35e60f1aadf6c02d77fdf42180fbf205aec7e8fc:

  Bluetooth: Fix HCIGETDEVINFO regression (2022-09-09 12:25:18 -0700)

----------------------------------------------------------------
bluetooth pull request for net:

 -Fix HCIGETDEVINFO regression

----------------------------------------------------------------
Luiz Augusto von Dentz (1):
      Bluetooth: Fix HCIGETDEVINFO regression

 include/net/bluetooth/hci_sock.h | 2 --
 1 file changed, 2 deletions(-)
