Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CA14A778C
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 19:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241666AbiBBSNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 13:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiBBSNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 13:13:12 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F34C061714;
        Wed,  2 Feb 2022 10:13:12 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id j16so19053944plx.4;
        Wed, 02 Feb 2022 10:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eb0u774bHSkXJu94buoS80i00AJ4S7aloQ/yxQgzmVA=;
        b=JG1yv0BSnKp5Bg3Dj6E3UYOxQXqdA/YG99oINcE94IhSvuF4xNyzPupM5wmXLKtuPp
         jnblEPcupKrH4kAVgvi2eh5pFuNTDbMmnT6vGZQf29DqUU2aukS7TNPH4H48qPDh7flq
         xsV6PH3+io4Q6INsVo9daY1cZfNTL6BpKXJdmzH6GgEaHLZ4rBHwpw2zSeukXSD/YPMq
         CCefDVih7ehZ0RaHtZyJl+coNhBXIofk1Z8Z/C3xEXuMX3JMEOllnsXzHnIWtmylLj04
         d8PQsm81rz4pDaq8t0z2I0fwkcAN3CjGef1///vXsJZL3Qsykglq78zEiOsVe5vUWX4M
         UKGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eb0u774bHSkXJu94buoS80i00AJ4S7aloQ/yxQgzmVA=;
        b=Y6vooxMQySnj4KDSBzKD0SFwKCRpnq+S788bygc+CMmdPHYgknSFfmIv+QujT7YQVt
         riKroVz++R8lP+g7zUZvi8n0lJYhuYyBXPchUCOGBx4EnjE399WsoTkYd/V6s07w2pNN
         5oGkBAvXUKEvbH0QsfUT1WOOG3Rpwr7K+BDRtCzCjvFTHE0/2u+dqywSOjaoCc4F+XtG
         DKRNpX1VUOoDZhiKTkWNe2gmG4+N+q69QCMo+bq0tARkazeXDb5nqmd2r6++KhxL9dJL
         4/3CWSVcKr3+jspjdX8VvBQTdhdtdGFFCofJkWeV++pwiTvDC8lN5KOHZQpb6hSImAEv
         /g6A==
X-Gm-Message-State: AOAM530yTwODJxPYWxRF6rULSooFF6KZjv45ZSAVUTMtdNur7EjVRgPG
        DywVf2HqQvq9CiqW81Vhyx+Q/PMXZuE=
X-Google-Smtp-Source: ABdhPJzaZUS904IRZsOXQXPRYfM1cF3YkNio9lJx1V5Y95UP3A8YTHHsduYCg7KXsf1j6tcg/Y8O5Q==
X-Received: by 2002:a17:902:c102:: with SMTP id 2mr31478416pli.92.1643825591593;
        Wed, 02 Feb 2022 10:13:11 -0800 (PST)
Received: from localhost.localdomain (101-137-118-25.mobile.dynamic.aptg.com.tw. [101.137.118.25])
        by smtp.gmail.com with ESMTPSA id 22sm9803716pgf.11.2022.02.02.10.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 10:13:11 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org
Subject: [PATCH v17, 0/2] ADD DM9051 ETHERNET DRIVER
Date:   Thu,  3 Feb 2022 02:12:46 +0800
Message-Id: <20220202181248.18344-1-josright123@gmail.com>
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
 drivers/net/ethernet/davicom/dm9051.c         | 1181 +++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         |  159 +++
 5 files changed, 1434 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: 9d922f5df53844228b9f7c62f2593f4f06c0b69b
-- 
2.20.1

