Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC2F4A30C5
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 17:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352803AbiA2QoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 11:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243327AbiA2QoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 11:44:17 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B255C061714;
        Sat, 29 Jan 2022 08:44:17 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id z5so8857353plg.8;
        Sat, 29 Jan 2022 08:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rc8EcuHrpVK/y37fKO3dTVt7uQivqrB0dxVBiWrZE24=;
        b=cozgJuef4hZxJaExMhIiuTHhdnTWr3Eu0eW7x6yX3gUhv6ZPPJ8saSkpQug5Y6F3Vd
         lGjdRoSqyqYonMkss4uzmHreRX6xQVvJ7rCegZlDbMqH5zBi/kjLdJa/drcAIXiE0hrI
         6t++53V7dMfLQZr1QMrEe3dthzeLW+2NjHfA1IPNGJTf41+P+F6ySpGy0Gh8NFa5IfXR
         Oq+8lS1PPqs4ZAbBcJoIQWQCbtfRnzZAiNACmlXqsDf1h38zPGIdM58EB33Mv5NDQakJ
         AtWoifRLJEgpgLcSvKcEplrw5Hl2t3twGyphWOkLAkVNE6fjshOzgrQ2VelHnPSGF4zO
         J4Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rc8EcuHrpVK/y37fKO3dTVt7uQivqrB0dxVBiWrZE24=;
        b=FMU4na8ce2Q2QHeMWpm556XVn1ZJnmTeghHzdKGgB3QuUl3EPA7L+XuxI7iHHOKZmW
         yxRUZTOHfZKyNo2G6Ylxk1ZNL3kIzp7wWLSviPGCuinRZMFl3Ut8J9Q6nLo1052anMED
         95bnJi1JCM83XyreOZ+94ysp+mWb524bMAf3XgPgDpszwa7uMMsyzAA62W2da1c3SSwP
         361/c2cJmnx56AztTxGq024I/B/wDb0waxd/hP0rIObFtOUVwCxAHoKMJR3B2aDEoczD
         wglZKViO7Sziqih+44d0zqJBmLKHSr+WgICRifCePTQ50uwjsqC6imk9TrLs7VePLZ12
         qDCQ==
X-Gm-Message-State: AOAM532cOlvg6ncItyq4xGFRzGGRNmrsQETpCoN7Ex8eKZhAmO7faX4y
        S4jXQLhAZMOrT0SeS7BwFwqYjaLBYEL2qQ==
X-Google-Smtp-Source: ABdhPJyotzLeBHZ5BE3ny/lal0L2utOhWu1/HR9jc9Gp2DV9JjVevqoPDC6VKQpzqyjP2saNxUDiMQ==
X-Received: by 2002:a17:902:d483:: with SMTP id c3mr13821273plg.141.1643474656674;
        Sat, 29 Jan 2022 08:44:16 -0800 (PST)
Received: from localhost.localdomain (111-243-37-162.dynamic-ip.hinet.net. [111.243.37.162])
        by smtp.gmail.com with ESMTPSA id y193sm13770337pfb.7.2022.01.29.08.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 08:44:16 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org
Subject: [PATCH v16, 0/2] ADD DM9051 ETHERNET DRIVER
Date:   Sun, 30 Jan 2022 00:43:44 +0800
Message-Id: <20220129164346.5535-1-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DM9051 is a spi interface chip,
need cs/mosi/miso/clock with an interrupt gpio pin

Joseph CHAMG (1):
  net: Add dm9051 driver

JosephCHANG (1):
  yaml: Add dm9051 SPI network yaml file

 .../bindings/net/davicom,dm9051.yaml          |   62 +
 drivers/net/ethernet/davicom/Kconfig          |   31 +
 drivers/net/ethernet/davicom/Makefile         |    1 +
 drivers/net/ethernet/davicom/dm9051.c         | 1165 +++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         |  159 +++
 5 files changed, 1418 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: 9d922f5df53844228b9f7c62f2593f4f06c0b69b
-- 
2.20.1

