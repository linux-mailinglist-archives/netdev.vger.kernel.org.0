Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9975646FCDA
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 09:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238585AbhLJIoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 03:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238574AbhLJIoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 03:44:11 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995E8C061746;
        Fri, 10 Dec 2021 00:40:36 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id h24so6351418pjq.2;
        Fri, 10 Dec 2021 00:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y5YbVEPTpb99j93yfRcN7ZYcmYybP+aZsMk5qWqZFlU=;
        b=G672X/uZIUk9u06F1NoMUlxhVissk6wZ6kb7pMTvlZc9O8VArp7PwhqjvG2QOX1Cwo
         pKde3WJM0R87NPEFWk2f2vnfANFT9txtQQ1Zd4w0XgBExwfc2nRQmwYn43t54NM5kW2f
         m80ofbF6Wo5EYR136+jb8XnwNyBuJhpfejKHQKbo9ByZLA/PhkNWzMNvjNUMCHsGGu2D
         K3FRwWz6dij4yAkbXDFuXzeven5vHpOfUEW3eUI0dMR3wrZxsvfcpU4ZTsaGteOETByV
         sv5xS6KN+YfwHCvmJwIa9T9qDu6ZfAXxHoE6YeT14Z8/aY2HbTMUbhQ3aapdxGSF2Um9
         7juA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y5YbVEPTpb99j93yfRcN7ZYcmYybP+aZsMk5qWqZFlU=;
        b=LGSU52K9iabf/UIcjfpKYnPURuFg7n+X5iob9QMk9hWk3h/aqG9lZI3+qTn9cDhsJx
         gLOdndWNhobykUdNxMlfQL8f8l2wApAPAJ/bneXNX8pHrWXNlB+Q3+JxbQA+j7b/o3qD
         EF7qY+DfJYU5u9x5H08R4U46ERSaU8Kb2TMtSlJ2cMY3/jyWjBJwPYB1e4unFaV689FQ
         m8Cl0qrpbwhdjAadALJY6K1uMTIJwI28srQWZAqgpozlFqNcUGNArRK/fypm7XqkVH2F
         /OVVeKx1Bi8u6FXQWhfrPMeFYdSjP5TVnjicAKw8zRZ0iIQr7pJEBbQnH6SK1a6Pc92c
         75PQ==
X-Gm-Message-State: AOAM532L1XcX7F76UXpVqz9TIFjWJemuo0r1XI4uDD1F2UavVjJpKUNp
        tXS7Ul1EjE9IWsbjOq/H9qY=
X-Google-Smtp-Source: ABdhPJyBx8fFL1G//x+tghng5SbUeBu9AFGVXobvKOI4KvSwh+OoMJ1Z2ROrsBzhW0OZ866pAJSZuw==
X-Received: by 2002:a17:90b:4b4e:: with SMTP id mi14mr22429685pjb.122.1639125635944;
        Fri, 10 Dec 2021 00:40:35 -0800 (PST)
Received: from localhost.localdomain (61-231-106-143.dynamic-ip.hinet.net. [61.231.106.143])
        by smtp.gmail.com with ESMTPSA id w142sm2230004pfc.115.2021.12.10.00.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 00:40:35 -0800 (PST)
From:   JosephCHANG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3, 0/2] ADD DM9051 ETHERNET DRIVER
Date:   Fri, 10 Dec 2021 16:40:19 +0800
Message-Id: <20211210084021.13993-1-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DM9051 is a spi interface ethernet controller chip
Fewer connect pins to CPU compare to DM9000.

JosephCHANG (2):
  yaml: Add dm9051 SPI network yaml file
  net: Add dm9051 driver

 .../bindings/net/davicom,dm9051.yaml          |  71 ++
 drivers/net/ethernet/davicom/Kconfig          |  30 +
 drivers/net/ethernet/davicom/Makefile         |   1 +
 drivers/net/ethernet/davicom/dm9051.c         | 861 ++++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         | 225 +++++
 5 files changed, 1188 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: 9d922f5df53844228b9f7c62f2593f4f06c0b69b
-- 
2.20.1

