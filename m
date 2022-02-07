Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9674AB797
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 10:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241476AbiBGJSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 04:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237688AbiBGJJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 04:09:36 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5669AC043189;
        Mon,  7 Feb 2022 01:09:35 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id d9-20020a17090a498900b001b8bb1d00e7so2102931pjh.3;
        Mon, 07 Feb 2022 01:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZQZhXFdp9tD0c0jU395inttU68UAXVyx1JvLcWnp9yk=;
        b=HByNIbTXkeLBMWlMVsGX3Ar2pC17mvgYsfavk5QlAl7gwkBwf56yZtMG5sSMCvC6dX
         AqrLpO6F2M5LbddCDqS/L2Djcs3icTMTlLWWj1OgQVCD7G1bfN6wUPiPSUPBDUAKEH+6
         6x42+rx4aFiGmKO3nUskZYaRd+UDTDxVwDrvQuQu/b/ekcrmJltB/zQ3v1VuN8NOUNAz
         rPXMDm+BgK1PyCIPlvQeRSA8yk08NFKNyfZld5cu2qxWLwPLG7A3eY3dhCWGUAM6Jtvg
         AI+1b3rgd4iP3AAlJodd6pACOEJso2TqXaJlO0B3s4Qv7QQTJJ0szNFAaNgPLAuSzTqG
         uHQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZQZhXFdp9tD0c0jU395inttU68UAXVyx1JvLcWnp9yk=;
        b=RjKmiYPr9P1SgR+si5QmOgMpn15WB1YomVNPbpcfu7y1bb7fj9QbwZB6Cvn/BBo4th
         LcpL9yS2DtR5+5oHBanWULOqpVbRLEcPh4muAWo9KUZgNyxv2kXBg3OsxwhqMF2QiixV
         PM18RKU1mRoOPq8gtus2j7Qsd5eY4QgZZJJwkoGzUQv0PEg77/ESTHRofDB9t6xbZu3m
         6uN451RZBWP1TgV/WXEAW0VNYdZhu441uoXXpL1hwnvXJOQQnbTdRf7SBPinbk+ipqYY
         yE1ZmxqbxjmfkYl/oMwk5NpvqiLotLJ5dggd69w+eA5t9nJLqMnwDoaRKNUT7TZYMhHi
         5lZA==
X-Gm-Message-State: AOAM532szU9HPAdj5cxE3vpTO23ZqmIojI3kWUrkxra5CEBRm5jU3WUD
        QNYc0SzyomHHyJVkKvpKIS4=
X-Google-Smtp-Source: ABdhPJzP8hxShwPPwZilsQyPlrVinXOBWypQfCA3vqAyXcJU6phRDDOBPpKaOoH4z4noDLWJyhwQYg==
X-Received: by 2002:a17:902:ac88:: with SMTP id h8mr2213536plr.128.1644224974625;
        Mon, 07 Feb 2022 01:09:34 -0800 (PST)
Received: from localhost.localdomain (61-231-109-204.dynamic-ip.hinet.net. [61.231.109.204])
        by smtp.gmail.com with ESMTPSA id x187sm7796724pgx.10.2022.02.07.01.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 01:09:34 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org
Subject: [PATCH v18, 0/2] ADD DM9051 ETHERNET DRIVER
Date:   Mon,  7 Feb 2022 17:09:04 +0800
Message-Id: <20220207090906.11156-1-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DM9051 is a spi interface chip,
need cs/mosi/miso/clock with an interrupt gpio pin

Joseph CHAMG (2):
  dt-bindings: net: Add Davicom dm9051 SPI ethernet controller
  net: Add dm9051 driver

 .../bindings/net/davicom,dm9051.yaml          |   62 +
 drivers/net/ethernet/davicom/Kconfig          |   31 +
 drivers/net/ethernet/davicom/Makefile         |    1 +
 drivers/net/ethernet/davicom/dm9051.c         | 1256 +++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         |  162 +++
 5 files changed, 1512 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: 9d922f5df53844228b9f7c62f2593f4f06c0b69b
-- 
2.20.1

