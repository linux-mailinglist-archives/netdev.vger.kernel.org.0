Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C7648D324
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 08:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbiAMHq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 02:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbiAMHq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 02:46:26 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992E7C06173F;
        Wed, 12 Jan 2022 23:46:26 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id p14so8459651plf.3;
        Wed, 12 Jan 2022 23:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gsDpZO2eSBO5vB4C+Ee93IE1Uh37uNXx2ALiI/rHI7A=;
        b=NpzumxFKlXJGOCmDcgYMEwdFZrUPaX20NGeuTinlv5AfWl0EdF8XREyNgUKRljJFd5
         ekAoKGrAh5g2w93DdcACJzb0ttATY9PU/LWpUq09ucSXDVOLyJ8QahiAnH9+194ig8GW
         fY/wt6tFc8Zd3rzxH1WRHm57hEtsNFA51KVUSgotfgmmN2zHStc3oIK6sS4iP+XyceRi
         VGtExBJAB8m6OTMKN4JX8t0yGdIkqPrfwNppz8x69T9w+jtTmAxenm7S9d5uBVpovZN2
         NEUPf9Ez+4lnWBRuZKo3aS1Xzl+WWcYc2USNoMY9LuNZznzxGZQ70vAtwL0StxqQpCza
         xWMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gsDpZO2eSBO5vB4C+Ee93IE1Uh37uNXx2ALiI/rHI7A=;
        b=DgeFVyqU8WBujYLhIUf2Hps6K+OX/rYe/hzy/sI96/ASMf1AAXhORAun/YRFfkWJWs
         R+T3YfcK0P5zqnsUZaElmeVSVfNrsWzt6mYGEskBv7X7nSPD4buLsxZ3jXSM6aTRei5p
         HWZXG8cC4+49Uzh+/HU7G3HQhcsY9nuLb5fLLvUWl9bf/c4Mnl21zjrbB8a4DKhUnMHr
         /TKoPS4LvYIXpSlv9fpvl8wumQ2ohivToNdUay9SPUU2YyI/YF2tyUREyPO369eqFvsd
         QdxOJ3xQ5tK76DO1DcA9Ekxc/whJLauVP9hEEb1UIvCHHbyB53tRM1ZE2SooN6NYOK8y
         NS6Q==
X-Gm-Message-State: AOAM533fH+ZkxTtRg4vjWtSpqoRJ3hKIFa/SpI42yRKoExVaqZoIes3i
        deI5+lsHgHeRt6VorIohM0I=
X-Google-Smtp-Source: ABdhPJx4RQVOqcJN2/8dckTvs3XQJPBPjvg77NsuhM69I0yfoLYSgXtIz3ZTnTHdPH5P/WXmSs0C1w==
X-Received: by 2002:a17:90b:3906:: with SMTP id ob6mr13331953pjb.170.1642059985924;
        Wed, 12 Jan 2022 23:46:25 -0800 (PST)
Received: from localhost.localdomain (61-231-99-230.dynamic-ip.hinet.net. [61.231.99.230])
        by smtp.gmail.com with ESMTPSA id d2sm1864602pfu.76.2022.01.12.23.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 23:46:25 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v11, 0/2] ADD DM9051 ETHERNET DRIVER
Date:   Thu, 13 Jan 2022 15:46:12 +0800
Message-Id: <20220113074614.407-1-josright123@gmail.com>
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

JosephCHANG (2):
  yaml: Add dm9051 SPI network yaml file
  net: Add dm9051 driver

 .../bindings/net/davicom,dm9051.yaml          |   62 +
 drivers/net/ethernet/davicom/Kconfig          |   29 +
 drivers/net/ethernet/davicom/Makefile         |    1 +
 drivers/net/ethernet/davicom/dm9051.c         | 1169 +++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         |  198 +++
 5 files changed, 1459 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: 9d922f5df53844228b9f7c62f2593f4f06c0b69b
-- 
2.20.1

