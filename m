Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7D1484F2C
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 09:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238370AbiAEISh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 03:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiAEISh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 03:18:37 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F61C061761;
        Wed,  5 Jan 2022 00:18:36 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id s15so34565880pfk.6;
        Wed, 05 Jan 2022 00:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FFsJx+BDuRlyVeYwoEzaPa8mVFd69YYv6X2ZGS6nCzE=;
        b=qSR5zuKU2WZ7mlQGVNsYELhW60JXHddsp2rOjVncAxGBNSGnc0vd4e5jjcJEBaoATX
         aaPVhSGQObw6z6meYtFQ+UfvaJn0inxkUt3eurbhaXZ6iDLINz/t2GP0WFKXJpwV1tzS
         YNPybmVOSFoCXNuXkRMYHXfBl8pTpFxPK78rGtOrHinMGG4d1RL8pzVvs0YB7X/YBOF9
         Jh0pWCyvLlLYr6LiWaq1JXm4NyWA+Z6DspXXmK3KXSWojB3wspxN1BtSOfEiAhvZcy+j
         U3spg6bbbTqO7OFqEdJZOTi9r5PmsTuHNDUo0xB7p2ZlAV0nUIOCgTP9VmK+RkXsWV6K
         vInw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FFsJx+BDuRlyVeYwoEzaPa8mVFd69YYv6X2ZGS6nCzE=;
        b=dif2HwZ2vW02W+lNfOvJYqb/FzYxoxDHHh92+Fe5O+4OymK29mkCn49qwRw+wcdscT
         qp4tkh+Fxb+mG54WclOYs65tL4bowg59RTzJ0eP9pvpFvchuBMa5A4DI+jR/Pfk0YKg/
         oAPIciN3Grz860+i6XjcGU+qH3jQaU3s6IKjAXLClBbc0W4OsUtpyUfhCnOcVsj3CfXw
         FknZPljW7ZXADj5TdhXzfqSE0X8rfPWWrQ20Qdze1936OBCbFb/0ia++I5rsrF/vC3rz
         MyQ3EfZOP/iUFzIBDL71OqIwTgPsBlpBstGzshIqkRyv5NPWkCOv5B1jS/04/iEZFst6
         LC6Q==
X-Gm-Message-State: AOAM531OBo8fN1eozFUxjG4n2JcMMRIZQHMF4UzTZpzO2NLcDfXjurou
        r6XB7ypnlEEmSe41vug0e7c=
X-Google-Smtp-Source: ABdhPJyAPXf3vZ9IB8INOlsrKvyYJbaLIMxqOy7h5fPJ4nL6uEFEhMF2he/2mWLrpEyzS86oTUo0Pw==
X-Received: by 2002:a63:117:: with SMTP id 23mr6574679pgb.398.1641370715794;
        Wed, 05 Jan 2022 00:18:35 -0800 (PST)
Received: from localhost.localdomain (61-231-122-238.dynamic-ip.hinet.net. [61.231.122.238])
        by smtp.gmail.com with ESMTPSA id s7sm22115809pfu.133.2022.01.05.00.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 00:18:35 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v10, 0/2] ADD DM9051 ETHERNET DRIVER
Date:   Wed,  5 Jan 2022 16:17:26 +0800
Message-Id: <20220105081728.4289-1-josright123@gmail.com>
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
 drivers/net/ethernet/davicom/dm9051.c         | 1302 +++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         |  198 +++
 5 files changed, 1592 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: 9d922f5df53844228b9f7c62f2593f4f06c0b69b
-- 
2.20.1

