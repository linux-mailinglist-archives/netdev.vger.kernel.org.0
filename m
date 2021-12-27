Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9907047FBB2
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 11:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbhL0KDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 05:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhL0KDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 05:03:00 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB79C06173E;
        Mon, 27 Dec 2021 02:03:00 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id c7so11080371plg.5;
        Mon, 27 Dec 2021 02:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=spiBO7RcelBoWJsHJgjaqtJZ8AewlTURu3j1x2nh8H4=;
        b=SyPvt54EEXcW8cbIgAkzTA2wYhE4xwq4gpA4edkaYa27dcmyJNecQEURMcMnUCt9w8
         yXrTaaqzoz1LDdqfrQFuzbm0nyOxLx1Rft4zlB0sgOP8NP2aA1UNT5jF9kYyxT+hXTZE
         Ue7nzvVtZekADn144w51hJ0XJWHthLNGA0ifVxkML3hJgvDgG4hBmBdd6q5Dvv4ctuKr
         erQ0YXQg4FOjGarx9XygOAHp5wwm2idUYy1pEzrmrCvpuejJGBNi6QgqZlEnICK2ebeU
         tZ+PLr14azABfQZUO03Hn0P2YmHxWOVom6Qk5gkSfNrWo/50z2tiasKq2LGEPzoICx1L
         8zqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=spiBO7RcelBoWJsHJgjaqtJZ8AewlTURu3j1x2nh8H4=;
        b=2r6IPQfVkvOOujU/bWHApUy71IXRZRrAouo9842Pd3adyNZPuZULMEl/npkCW2bXBI
         ihxjXIF71LEZfUwdeN/GVJPf3ziC+5SDP6Ej55ZipDECqH/Xx/eAIqnFs/5dSnwaT4FR
         aYypSd/UShRNNP4aXdwVN+hM7N0WQNEXX8zoWH4Dk6zcar2cspHwO80R6tpnqBZ7CfCr
         CoC0ESRwqWzlt/4ooFmmYwZeEr8ainA7kHcSyHGFPDi0R80kd4SmVmLaj61IdyeoDtxb
         z1rwk5csGgCb8eVP0eqOpPyELxRQoFHoUOvjDtiqEykEW+pXNjvz2gax+GtLD/OgorJM
         Nuig==
X-Gm-Message-State: AOAM532sxYC740B1ULnPEpeuFF60exp5WabM9Ms2PXAdMGQaGUXA0/PP
        NmI2MMmk7vCqsr+Sj4w/CPQ=
X-Google-Smtp-Source: ABdhPJyJ0SYYOd8MPDHZyOKXN5Lt7VlHkMj2r33h696SFRVl7km1IF+SymVmy8tXE8/rohaCTWibDg==
X-Received: by 2002:a17:90b:1c07:: with SMTP id oc7mr19961024pjb.127.1640599379320;
        Mon, 27 Dec 2021 02:02:59 -0800 (PST)
Received: from localhost.localdomain (61-231-124-66.dynamic-ip.hinet.net. [61.231.124.66])
        by smtp.gmail.com with ESMTPSA id k6sm17533671pff.106.2021.12.27.02.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 02:02:58 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v9, 0/2] ADD DM9051 ETHERNET DRIVER
Date:   Mon, 27 Dec 2021 18:02:31 +0800
Message-Id: <20211227100233.8037-1-josright123@gmail.com>
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
  net: Add dm9051 driver

 .../bindings/net/davicom,dm9051.yaml          |   62 +
 drivers/net/ethernet/davicom/Kconfig          |   29 +
 drivers/net/ethernet/davicom/Makefile         |    1 +
 drivers/net/ethernet/davicom/dm9051.c         | 1019 +++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         |  189 +++
 5 files changed, 1300 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: 9d922f5df53844228b9f7c62f2593f4f06c0b69b
-- 
2.20.1

