Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B380646E63B
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbhLIKLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:11:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhLIKLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 05:11:03 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1362C061746;
        Thu,  9 Dec 2021 02:07:30 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v23so4052351pjr.5;
        Thu, 09 Dec 2021 02:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ni5T9E4TprjhhFMc3GBBC90jn+XTBuYnSGPdqSNDaYk=;
        b=bVIt5FGBrYdyjf7VrM9V9SaU3ZVE8o3+ICu/7lMA1lykjDIf3AXiuLJAVngA3wgReT
         l+XWQd/T/x21nqHvBrsiCbXP4GCqPdBJ6ASGLdnUu6mR6sf20m5Dstwi5IZSb6R1NE11
         pA/t6lT66lyPbJbfbXu+YY8cT9jYwBjIkyqbZmr0KeFTDU6ft8X+j+544okS8jI45fGM
         dMExfxRKGDPwa3owVKyX3R8GObf1y8vmG3QQcHJogftfvJPwO4zFFHoDVqbvNsHXFKT6
         Heg1qtQs89xIyzmc72nq5zthqFL1RD+96NWDVymlfYcQK+HkkhWDQx28+Cy2zy0v79BA
         7yGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ni5T9E4TprjhhFMc3GBBC90jn+XTBuYnSGPdqSNDaYk=;
        b=TWokzAToepKLY/930WEmyESB+CinIPpb2bEQOZVxfw8Idqfl1fEmUAJMB9gyBWzC75
         aX9KVuOXe2KViDLn+gBAjzATgdqieR49aedr2PfNdL41DbpBq0CypWmnBsGRPoMufeQ/
         VpNiCQHo3hkkll2778ik0sJ1g6vbKwGXiuXZDDhq7HwEGqedX3e7ACotSTDaSAnEu2Cs
         x0qELvhhTxqS0isoxAbtanTtFs7ZsN3zvKnv+Mwm7zfIx/EKB8UjLOzNR+FlyUjPYNdy
         Y8ZVBMP6C7jWADymRAq+qWqNNFUkno9VHyvHAZBrNla4UFPsC4NeSkL1SpTQdijfs86c
         nxmA==
X-Gm-Message-State: AOAM530z5f0N7yHCcTLtBg/obZE33DBNDdl7WAVG8S0VtXkSglk2HG0a
        SzG6dnTmpUgsc2P23GHOpFc=
X-Google-Smtp-Source: ABdhPJyl8yOopQO1/nOGwT3sYA9h4OuVMqCJjkVFeWjgtigfCVSn5zKPA3V7mKlO7rZX2w44eoeHYw==
X-Received: by 2002:a17:90b:1d09:: with SMTP id on9mr14011375pjb.191.1639044450165;
        Thu, 09 Dec 2021 02:07:30 -0800 (PST)
Received: from localhost.localdomain (61-231-106-143.dynamic-ip.hinet.net. [61.231.106.143])
        by smtp.gmail.com with ESMTPSA id i2sm6932409pfg.90.2021.12.09.02.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 02:07:29 -0800 (PST)
From:   JosephCHANG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2, 0/2] ADD DM9051 ETHERNET DRIVER
Date:   Thu,  9 Dec 2021 18:07:00 +0800
Message-Id: <20211209100702.5609-1-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DM9051 is a spi interface ethernet controller chip
Fewer connect pins to CPU compare to DM9000.
It need only cs/mosi/miso/clock and an interrupt gpio pin 

JosephCHANG (2):
  yaml: Add dm9051 SPI network yaml file
  net: Add DM9051 driver

 .../bindings/net/davicom,dm9051.yaml          |  62 ++
 drivers/net/ethernet/davicom/Kconfig          |  30 +
 drivers/net/ethernet/davicom/Makefile         |   1 +
 drivers/net/ethernet/davicom/dm9051.c         | 967 ++++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         | 248 +++++
 5 files changed, 1308 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: 9d922f5df53844228b9f7c62f2593f4f06c0b69b
-- 
2.20.1

