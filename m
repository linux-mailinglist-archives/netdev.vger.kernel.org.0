Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C745127A3
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 01:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiD0Xnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 19:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbiD0Xnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 19:43:49 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3293D6161F;
        Wed, 27 Apr 2022 16:40:35 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id iq10so2795219pjb.0;
        Wed, 27 Apr 2022 16:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pA7N5oM5U7ZFZAud2ceA5aBZ7HfbRjldpjtLGGTMl9M=;
        b=KRstV8sVbdRXrJDYbQQAbE4hSSSSqIetxqnPUoR5VcRKvTYr3nLanKjjGTCdcDyxad
         pc/T3XpJk7zDtiwva7YMoSiuyOdXPTR7J5n/U6cthpJe64hcT+A4V1ZB5aJy9HMtarGV
         MUJN1B1Q2G/VT5KwpE7RnN2XlD6TAFTHZX2/tAbQ+XZZlVFSFxJ+dGM0VsQXEhF9/ReW
         uf9tFtOhT8Eh7WalJ4IktHDfneOVPv/zvCkhCodoZkJq6vCUScMW7o5KxJax3XpdlZa2
         ziZUCO4OxZWi0YP2jHODU9zfV9Bge3K1dQg0+CMlgsKT89aujLsY1c7cqx//aNPOcWTV
         BNWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pA7N5oM5U7ZFZAud2ceA5aBZ7HfbRjldpjtLGGTMl9M=;
        b=qINAb+wgAtOclzKnjQHKlAseQWKgnMMn5K4XuGcDdeQkmjyE2Bgg5rAq6OCZtuLRuV
         XH3eLhrPF0A3X4kU1AWsibtbOj8ECdHAcfXIuVcq9peTwts+g5u5MhGQhvwqZYyTK8Fq
         WQJBd66lrYGJx8hudb2L2mVeEGuuOnoXXzdI/JO/OOeo6+1qeJjdYOu7YPurdJzZGbNL
         40qmzyHLjhwOVJMhnwALnZqC/RcUUw9bl+efFH8iC2g65JXbhWTayCknL9Jlk5BybGbH
         AmDoLEP0zIRp/SK/zoerQBEfxgP+M7netM8W4PMhbmhm+RN86tHO9IrLCihY4o2I6L2/
         Tong==
X-Gm-Message-State: AOAM531Dng34HwcxM8OTyaCWM+i+QTbgTvXAMpJTBRazeeytPJvGqLer
        zgLZb2UorUAb2unP7KYciWr9lT0cb7M=
X-Google-Smtp-Source: ABdhPJxAR6SmLlCJV+Nx/EguglOhP0iM1PmcnG+nibMxg5KDRBbAFTlK2brnGzY8RNgwg8MDNMYDGA==
X-Received: by 2002:a17:902:e791:b0:151:dbbd:aeae with SMTP id cp17-20020a170902e79100b00151dbbdaeaemr30702018plb.171.1651102832890;
        Wed, 27 Apr 2022 16:40:32 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id g11-20020a63110b000000b003c14af50614sm406747pgl.44.2022.04.27.16.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 16:40:32 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2022-04-27
Date:   Wed, 27 Apr 2022 16:40:31 -0700
Message-Id: <20220427234031.1257281-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.35.1
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

The following changes since commit acb16b395c3f3d7502443e0c799c2b42df645642:

  virtio_net: fix wrong buf address calculation when using xdp (2022-04-26 13:24:44 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-04-27

for you to fetch changes up to 9b3628d79b46f06157affc56fdb218fdd4988321:

  Bluetooth: hci_sync: Cleanup hci_conn if it cannot be aborted (2022-04-26 20:10:51 +0200)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fix regression causing some HCI events to be discarded when they
   shouldn't.

----------------------------------------------------------------
Luiz Augusto von Dentz (3):
      Bluetooth: hci_event: Fix checking for invalid handle on error status
      Bluetooth: hci_event: Fix creating hci_conn object on error status
      Bluetooth: hci_sync: Cleanup hci_conn if it cannot be aborted

 include/net/bluetooth/hci.h      |  1 +
 include/net/bluetooth/hci_core.h |  2 +-
 net/bluetooth/hci_conn.c         | 32 ++++++++++++----
 net/bluetooth/hci_event.c        | 80 +++++++++++++++++++++++-----------------
 net/bluetooth/hci_sync.c         | 11 +++++-
 5 files changed, 83 insertions(+), 43 deletions(-)
