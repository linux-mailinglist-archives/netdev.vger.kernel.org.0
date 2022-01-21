Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5854A4958D5
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 05:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbiAUEO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 23:14:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233558AbiAUEO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 23:14:56 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69274C061574;
        Thu, 20 Jan 2022 20:14:56 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 192so4311599pfz.3;
        Thu, 20 Jan 2022 20:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iQh9CCwQQvy+j464wyDTaEtQukQ4TaLa+hgGvMMJpEw=;
        b=HVOmxLd2VXRBpzlKRBa1rYtaeMqGz34cPV0Di1CYPcOKrV40hjVk5m09AJpItSilY/
         R7ZnBh/4GSGzS3j0LFvVkmyTnI5aBsEp+dzw6WoBKDg6C3zwqoHbJN8tZqRXXqN3aVUX
         v7D7oHmKUgw+4VJ3RJgP4nBBEaH9NrQ3Jhcedl/7ifuEgO6Sye2uD5GR5ehTZ9/uHDW1
         J85em8SptsPJrpoQ72WrkQPnHytRGuMPezqVeCLVw0SVo0JFTnwka1bDNiIp4W9SMGcI
         qPgWG/ZwQgfVZBNbTi+cPUhEb6Cu6ah1dkCnkvFh9EX7vqsewZTT152tGsUOO3In+Ftg
         hDcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iQh9CCwQQvy+j464wyDTaEtQukQ4TaLa+hgGvMMJpEw=;
        b=f5APFoke9U8D4dITxFDmetydxFvZTV2cmpwJin/XWVNp1Ns8rvMY3KmeGqhe/NG71L
         kPh6YfOmZ3gcikZb8aXd4t3xEmwtOc3B5SHtoAVKDjZY+d4VFglYmNxBSgVA+sfhv4eX
         4codlaxrcFuLvyP3DWBkbOIg9PjmRLXEcZB16uGvnS339NpABfwrN6Pg53olnjq/p3vR
         dZ+BOchitLsPYEMTzXjHJUC4mFjIpgZbU386FtRs5HOKJCtX7QUdARlUijEw4ZzaoCBV
         nn08wIdnudiMvM8cARlD5uxgVuCTea8uH9dpXocZ27d+cKko5F26HG/Xzg9iQ+nlwE18
         t0wg==
X-Gm-Message-State: AOAM531QcEyRXcA1r8dOPDf3WfBrmZ1JdGTtPF+VWB22OQdqgOUvqS0o
        26GDbJDisFrzbEeyYbBkfQI=
X-Google-Smtp-Source: ABdhPJzkkaRpd+rbmnNelMpAg09Y8Un55h7zpPpbc53w5yr4gpLbI3OsQi4v3HE8aJk4Vfs3FVtktQ==
X-Received: by 2002:a62:c186:0:b0:4c1:232c:819d with SMTP id i128-20020a62c186000000b004c1232c819dmr2325414pfg.28.1642738495722;
        Thu, 20 Jan 2022 20:14:55 -0800 (PST)
Received: from localhost.localdomain (61-231-118-42.dynamic-ip.hinet.net. [61.231.118.42])
        by smtp.gmail.com with ESMTPSA id j1sm4937614pfu.4.2022.01.20.20.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 20:14:55 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch
Subject: [PATCH v12, 0/2] ADD DM9051 ETHERNET DRIVER
Date:   Fri, 21 Jan 2022 12:14:26 +0800
Message-Id: <20220121041428.6437-1-josright123@gmail.com>
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
 drivers/net/ethernet/davicom/dm9051.c         | 1180 +++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         |  159 +++
 5 files changed, 1433 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: 9d922f5df53844228b9f7c62f2593f4f06c0b69b
-- 
2.20.1

