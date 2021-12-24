Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F339647EE33
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 11:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352407AbhLXKQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 05:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343878AbhLXKQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 05:16:37 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FA1C061401;
        Fri, 24 Dec 2021 02:16:32 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id k64so7429351pfd.11;
        Fri, 24 Dec 2021 02:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AQrqIKRcoq+pIAN06ce/j5X3vs6sK2L++mlFZ3PqMCI=;
        b=Glf5gNyj4mG1drwuQcfGq8vbOW+d0+MtXMlOwp9PSQ3Ggc+PKzFslt+2wEokVyaR2I
         /r9akxQFFjHs7jCa9Cg+ds91U65eYv/XN7wFCegmr/Jt9F0+Q3jBjTME2S6kIaN9a9Ew
         AiBAdpLs28Pnn2mg7OF6HlMnQK0t7wYs8A0fiIE6bgPsTUGpOvyemsAROEHw2Ou+kcSU
         uWH5CNVSd/cvcwWYlpYrCQCK1TgkkSZNvC3yCEKgabpYB/UGTeUnhdu2a/7rDYWeO3y6
         xA0gl545AryodPHFNMmrOaaw08OGQjWShVXd92tjD26z6vk5ym6qdoF24u/f3emyx8hc
         H2iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AQrqIKRcoq+pIAN06ce/j5X3vs6sK2L++mlFZ3PqMCI=;
        b=6Mm8qP0JpR0WH6VWTvji0qxpVSKCTFHm1VTv7jMXnFeUW2nKeCQEh0xCSdS/e3dk9U
         A3ufYufmX4IVgEUJXAjYJMsI8AcsNYIwpbhkrtMjKp4UBwArkdSMmwLcU+LvhfRpFGto
         TJt7fWBe5eupEHnYXWxmvpuls5w49VptD0Xv6d+HPfV3OKSkqmHu3Ub1OwH/fCY8GRq0
         uHIkRk3Fs1uR+QREY7TLaO4OUWpCJUy4bxdDTXkvAGGmB6u9nIMA0Sb3PcuqbqQ+kZfB
         St5wY/hEAZen8uhFU0vbQjliRF+1Xa1q0ib8EV9f6PIRiMRMxlUhOI/jO3BIZvUWbelh
         bJsg==
X-Gm-Message-State: AOAM5303/oL1ifTSsbdvRVEbIHupwlxw/GOFrVHMcg+iACM0RGLUqIw4
        usEvPJFWYTu9egQ1ZreSBwqZ+RFcAMY=
X-Google-Smtp-Source: ABdhPJzRKbgrJ31IleeSsHdGvwM6kZezDcSHXXqtj7SwoRRiNp42b4zuwRDUCSr3XY2sQRM3+4YjZg==
X-Received: by 2002:a63:8249:: with SMTP id w70mr5570970pgd.274.1640340991685;
        Fri, 24 Dec 2021 02:16:31 -0800 (PST)
Received: from localhost.localdomain (61-231-112-151.dynamic-ip.hinet.net. [61.231.112.151])
        by smtp.gmail.com with ESMTPSA id ot6sm9239296pjb.32.2021.12.24.02.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Dec 2021 02:16:31 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8, 0/2] ADD DM9051 ETHERNET DRIVER
Date:   Fri, 24 Dec 2021 18:16:04 +0800
Message-Id: <20211224101606.10125-1-josright123@gmail.com>
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
 drivers/net/ethernet/davicom/Kconfig          |   30 +
 drivers/net/ethernet/davicom/Makefile         |    1 +
 drivers/net/ethernet/davicom/dm9051.c         | 1011 +++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         |  190 ++++
 5 files changed, 1294 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: 9d922f5df53844228b9f7c62f2593f4f06c0b69b
-- 
2.20.1

