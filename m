Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315564719A8
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 11:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhLLKpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 05:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhLLKpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 05:45:03 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E27EC061714;
        Sun, 12 Dec 2021 02:45:03 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id b11so9211011pld.12;
        Sun, 12 Dec 2021 02:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rCn440tKtkzAwO1Bl/FgEJ2hmsU7YRbUmVeW5PxwasM=;
        b=GnavoKbhE7V4CZiF+ENSkwT29zXiV4bKjZYKvRwIx976Al67IttZvFhf+nB+bcpcBi
         XW2GTdmtqwETnrecyuhTURev8XPHr93nJvJwd9ml3ghjy9nhEHc9iZMXj/D0AnPb67hb
         s+GZLBD/ODokJZkHmY0sfZyS+hilLpm5HKTwiku+uJjDv8D85j8k+aPlNkR0PWsEbmJV
         gkzbbFNJ4Qngfd/1gayKkqFlnsj+NhPqZ9BLS1RZT1xbYdsnOJ/1WOOWgDRN0yc1krIw
         Fcfe9/PysVmXFcZiCfP419D8iR7ZHIfd6aMtFvoErp5hJnWjdx6QmQ4p2yP/hI/Mr08y
         UDIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rCn440tKtkzAwO1Bl/FgEJ2hmsU7YRbUmVeW5PxwasM=;
        b=ZUUdM6WIQiPSy8Qo8zSA8YMnGf5jHeZ48B9DFd3m3wKjqmgRP1pqRTel5dFc4Wpp76
         T8bcwX0FS/OpPr7rk70RZRvOV7P0zTj7LTyvYXrYVqYgRcBk5WWu+2yRkaK4ANUY/n8y
         m6xdpOooIE/NMiSHIWCfQ8zHTX68lFFeTxUovBrh79ciyWF3i954Y2hDtmWTtsQi5xCH
         WNq3GvDeejRt6ZYFJ6BZnmyBcQGE95AHQtcpPFpMa4EiD8pB3UPEwOrebGtlm90tsBIX
         kiP+67BUFAc5326gsIh1IQ0WX1g98v6hBzNeJ/RVy+xqel6j4dcEQydHKTnfQtmnvsvN
         tRkA==
X-Gm-Message-State: AOAM531sCF42DunjEzHHOG21062n8bh2F5li7WLWDjx6CQvNuLw/FFeP
        noDHklH6amxtv68PaNBQfRI//HjGfprrnA==
X-Google-Smtp-Source: ABdhPJyyQqs5e2hm4kAqpUZ7gKLzmgvaVmuj3KuTVJQTQfa8q5uuSTPSCYfqiZrILD/EnyswXruo0Q==
X-Received: by 2002:a17:90b:3ec2:: with SMTP id rm2mr37301920pjb.1.1639305902564;
        Sun, 12 Dec 2021 02:45:02 -0800 (PST)
Received: from LAPTOP-M5MOLEEC.localdomain (111-243-35-130.dynamic-ip.hinet.net. [111.243.35.130])
        by smtp.gmail.com with ESMTPSA id k19sm8291722pff.20.2021.12.12.02.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 02:45:02 -0800 (PST)
From:   Joseph CHANG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4, 0/2] ADD DM9051 ETHERNET DRIVER
Date:   Sun, 12 Dec 2021 18:46:02 +0800
Message-Id: <20211212104604.20334-1-josright123@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DM9051 is a spi interface ethernet controller chip
Fewer connect pins to CPU compare to DM9000

Joseph CHANG (2):
  yaml: Add dm9051 SPI network yaml file
  net: Add dm9051 driver

 .../bindings/net/davicom,dm9051.yaml          |  62 ++
 drivers/net/ethernet/davicom/Kconfig          |  30 +
 drivers/net/ethernet/davicom/Makefile         |   1 +
 drivers/net/ethernet/davicom/dm9051.c         | 865 ++++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         | 225 +++++
 5 files changed, 1183 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: 77ab714f00703c91d5a6e15d7445775c80358774
-- 
2.25.1

