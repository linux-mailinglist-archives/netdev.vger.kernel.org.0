Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6293F5ABA9E
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 00:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiIBWE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 18:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbiIBWEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 18:04:35 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C6AFCA06;
        Fri,  2 Sep 2022 15:04:08 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id fa2so3225089pjb.2;
        Fri, 02 Sep 2022 15:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=bRGWcmrLWTN0iCYEgWIMpsWdyoVsz6juOIhN3krZLjU=;
        b=m5ScyHtrwMLj69oD++9ubbS3xEaOJJvuMKpdDPaztEq/KAahi1gmsj83Re8Irw1dkF
         4AmREaYYDqPCOztoQbND8+ptk1uQDNBLwJvEYoHmU4jLbs9ST4+gDo77EUhlTLDSvssA
         zWRMEOrZyMrwv6xVfOQ88T7hPHZkxmWsOWl8H+XnFK7QnM3uIkr7SjiRvWKkfeKKCGHa
         cZukNGWWQpBPT9zZde2CM8oTnUvvEUWE1PYYPTFm0cBj/G4ehXqd6KvAdMH7lKHYhQtt
         LJ2I+ESvymmmnVWWHXVK2mtSLfEZa0uLSVoRW9VqI8AkWbbVis+HKDUUhHo6C0yRyXvH
         Ar9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=bRGWcmrLWTN0iCYEgWIMpsWdyoVsz6juOIhN3krZLjU=;
        b=hXgxcbJtRnvsncoZkFU1j9z5Pv5YlROWmatHSuE4gBZmaDFHTEUqBdE7OmKxZrIZMi
         zOIhn9uLBq5TL1+Ez+2QoQCg6OFrElBqp4HWGRreHtaLv4ppuSmP8fAy0dcUvJuRBNUT
         xw3F5UP1e4lGDJF4OSae3cxcHhXK4KpTNnO8cd/FhpdPfPopmhEwvvlgfHXXgzooWQuQ
         ID5W9z2TwgCy5QrKq2AN5iIzu+QJY02R3znCCziy5/KwtTciMKUHRTImQZr6uYrfmoil
         GsJHBtNA57JcCRZ0RUbOidfiv1kKxd0WdQ4/EWe8dw2Ftq9c4wzRiuEqKWgQk0PI+329
         lj2w==
X-Gm-Message-State: ACgBeo2hz28QWghszE7KrqyGbPPgh8ugaXP9XKN91ho+NwvqagzZ2E+m
        8EDHE2tFL0b5LcxKuS5LOVOHTr5AIeE=
X-Google-Smtp-Source: AA6agR4+NXZELVUfiRUYyyp28L0V4rwpw4Ncg63iqrpTR7gvEH0mLkF4UjTUCD+ePNc3oXO85MaO7w==
X-Received: by 2002:a17:903:124e:b0:172:7d49:b843 with SMTP id u14-20020a170903124e00b001727d49b843mr36961948plh.52.1662156246584;
        Fri, 02 Sep 2022 15:04:06 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id c3-20020aa79523000000b0053813de1fdasm2340282pfp.28.2022.09.02.15.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 15:04:05 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2022-09-02
Date:   Fri,  2 Sep 2022 15:04:04 -0700
Message-Id: <20220902220404.2013285-1-luiz.dentz@gmail.com>
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

The following changes since commit e7506d344bf180096a86ec393515861fb5245915:

  Merge tag 'rxrpc-fixes-20220901' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs (2022-09-02 12:45:32 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-09-02

for you to fetch changes up to be318363daa2939453b4d80981de3e9c28b66135:

  Bluetooth: hci_sync: Fix hci_read_buffer_size_sync (2022-09-02 14:01:28 -0700)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fix regression preventing ACL packet transmission

----------------------------------------------------------------
Luiz Augusto von Dentz (1):
      Bluetooth: hci_sync: Fix hci_read_buffer_size_sync

 net/bluetooth/hci_sync.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)
