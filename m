Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4434753BA
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 08:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240583AbhLOHfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 02:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240552AbhLOHfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 02:35:37 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D862C061574;
        Tue, 14 Dec 2021 23:35:37 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v16so3411587pjn.1;
        Tue, 14 Dec 2021 23:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yDBTh+/iy1ACeR6yRVlfP9eUeFDRJKMiV372ymhPVIg=;
        b=VWUruLTbn2cYcDTOJKgFSuaYtbZ22If0oIDo/mmXg3stulr36ltYTg3iWxTuSPjYpR
         xLys1oU38VC14RxGVCT4mUlqCfQbM89l//Yx+SLtnqXoPI/p+FARqZSdbn+JSc9P8f5S
         RUis3XcFFm/b96ZIRvsRBbmDxi/lGPu+2qxIjSydl3Ioge/iPILCHfmil2W2+Y3o2i4B
         38RmBbbn0pedlN4MUisZ7QTWvIJziUssS1nWtwcLHMYqXqgBKnE0kkW+NH7NaylQjvi3
         bQ9z57k1UEpPYaBEByLut+UUQKoI6r4uBwIeRb0q6aGU4D9VgeG9Kvo6CFTB6r/Hg9zE
         tWGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yDBTh+/iy1ACeR6yRVlfP9eUeFDRJKMiV372ymhPVIg=;
        b=15hYuQ817Nj9m2wjpOWb66gJ5U6Jeqt/EimghJBi0eA5pufDc7i/iJz9riir+GYt6g
         qQCGrtgzyKUSAmaHWxqUhCuuOOB5mATgJV89LAaE7w6B0+x80B4+rB6qLwA/E/4/UOYQ
         KznLluw8+QZJ8r2huB8nlYuAS9H6UdH8bONI5amT5j8YCCQbIN0NZMytbs7ragi7oyUe
         UnuweQ6pYKfLhxkBZPImIPCkfvmf0z9EnsZGo+GbRIQSEeu5Uc2+oFLaQIdkvH/6zpTh
         2Bsj+kwTlMBfGIrM/ooJ7JiQAg9+cwOux2TE0oXITHdTQV1E0wAQnJVWvWNF8k0yD5zC
         mibQ==
X-Gm-Message-State: AOAM531gNbmUOa7ynbBeliLO9Dgz/nh5yS3j9oZs3yDGiECtIoaq50xP
        tq8g43P2REI6xgiqCznx/zw=
X-Google-Smtp-Source: ABdhPJyRgl9iyoCjntgNZvdPTLXeixdPz7m3F20kKMLd2IFeLiZGhvPmBfF2ihXudN63ZSKYBn1rkQ==
X-Received: by 2002:a17:902:d2c8:b0:148:a2e7:fb22 with SMTP id n8-20020a170902d2c800b00148a2e7fb22mr3111664plc.99.1639553736297;
        Tue, 14 Dec 2021 23:35:36 -0800 (PST)
Received: from localhost.localdomain (61-231-67-10.dynamic-ip.hinet.net. [61.231.67.10])
        by smtp.gmail.com with ESMTPSA id y37sm1264160pga.78.2021.12.14.23.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 23:35:35 -0800 (PST)
From:   JosephCHANG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5, 0/2] ADD DM9051 ETHERNET DRIVER
Date:   Wed, 15 Dec 2021 15:35:05 +0800
Message-Id: <20211215073507.16776-1-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adjust Kconfig for reasonable dependence, make dm9051.c better
by remove the wrappers, and swap to phylib

DM9051 is a spi interface chip,
need only cs/mosi/miso/clock with an interrupt gpio pin

JosephCHANG (2):
  yaml: Add dm9051 SPI network yaml file
  net: Add dm9051 driver

 .../bindings/net/davicom,dm9051.yaml          |  62 ++
 drivers/net/ethernet/davicom/Kconfig          |  30 +
 drivers/net/ethernet/davicom/Makefile         |   1 +
 drivers/net/ethernet/davicom/dm9051.c         | 913 ++++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         | 187 ++++
 5 files changed, 1193 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: 9d922f5df53844228b9f7c62f2593f4f06c0b69b
-- 
2.20.1

