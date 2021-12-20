Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFDDE47A8C8
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 12:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhLTLeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 06:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbhLTLeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 06:34:11 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7465FC061574;
        Mon, 20 Dec 2021 03:34:11 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso12625249pji.0;
        Mon, 20 Dec 2021 03:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4Y60QO7rqLiN4h5yN+WKQNMkIqYNHIuW9x8bPi58DNo=;
        b=LbeqF7wwSKDibul8FVgX5K2uk3fnQmTwOUYLLkhjIeOjv/pvn6mss7+jaSK3DH33Ed
         BSrmTcKFtbJ5Ric+EYTkm6k/0Jp6NsnEeBa1z3X8+DM/Ckft7KL1xu5slF6i1w5s0j2q
         hLjMYyrrK9RlgbXdvVr7UUSYDyscSaOatUXoEuUORaTzxDJTl6u30lrkKg73eHMVmidq
         atwOn54scOp1/ZrmwaE8q/HKpZ2j03wqVqKj9ZjCiWUdXjzQyjIrFYqgs7bS5xUVkTOG
         hLHFjfE3/V5kVY2vRDu4Tgo0XsTf8S8ZtrmGRtiRobCEC2+mzW/ra6MLjggcr/ptF81G
         oq3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4Y60QO7rqLiN4h5yN+WKQNMkIqYNHIuW9x8bPi58DNo=;
        b=2VT6kVDkHZ0ZIctBIpi9dyl+Zt9JpYBWyFsowLLDv0R7X6kh6/Q8o5DK/yykDH7Ab3
         w/YpQ+TZ8O4GbZSCd5tWLIjxIfg/unOI6aXWAmbMh31F9JXNSW1JGNhWMsz5Gddso8MO
         eSjrSlOWahBEFl0SJ8cNAXOQflRuE2/uoIkXQYrIO5q0lv4+2UytqIGnU7xBlmmJAXHZ
         vIEMPuUYRZehXvFG5Nh99S9np5iu+Xrv4tKKHnPbov4IheVDJazBS/ckowfF/zx36JsI
         PNNZJOjiKLQndCfyE8R6oWxwP+Sv92yJRkMM+MwsZq6CSoPvJosjscUieuEtv62ltUyy
         wObw==
X-Gm-Message-State: AOAM532BaEQpOt9m9qPGw3WtZE99E6IFuEFB2lJCzTehchilvL1U8lxS
        xXk5s85iHMpu5MdoAsVQpo0=
X-Google-Smtp-Source: ABdhPJyq3v2CF8Bvp/A+w6/slLlP4qI2gC86XTlf5Rxdur6B5QzxgySAt3oFFdZ/QwMLKmW1mdpkFg==
X-Received: by 2002:a17:902:e751:b0:148:fb86:410a with SMTP id p17-20020a170902e75100b00148fb86410amr9028017plf.96.1640000050821;
        Mon, 20 Dec 2021 03:34:10 -0800 (PST)
Received: from localhost.localdomain (61-231-108-100.dynamic-ip.hinet.net. [61.231.108.100])
        by smtp.gmail.com with ESMTPSA id 78sm16088152pgg.85.2021.12.20.03.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 03:34:10 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7, 0/2] ADD DM9051 ETHERNET DRIVER
Date:   Mon, 20 Dec 2021 19:33:40 +0800
Message-Id: <20211220113342.11437-1-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DM9051 is a spi interface chip,
need only cs/mosi/miso/clock with an interrupt gpio pin

Joseph CHAMG (1):
  net: Add dm9051 driver

JosephCHANG (1):
  yaml: Add dm9051 SPI network yaml file

 .../bindings/net/davicom,dm9051.yaml          |  62 ++
 drivers/net/ethernet/davicom/Kconfig          |  30 +
 drivers/net/ethernet/davicom/Makefile         |   1 +
 drivers/net/ethernet/davicom/dm9051.c         | 998 ++++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         | 194 ++++
 5 files changed, 1285 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: 9d922f5df53844228b9f7c62f2593f4f06c0b69b
-- 
2.20.1

