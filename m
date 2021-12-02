Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD4146D24F
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 12:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhLHLlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 06:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhLHLlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 06:41:09 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C90C061746;
        Wed,  8 Dec 2021 03:37:37 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id g16so1853930pgi.1;
        Wed, 08 Dec 2021 03:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xO2rDUNr4dM0DivbOJCUEO9EGtz1DZV/xU/rC001g6E=;
        b=WYE5MWlsxeXmu8ATLr6u4QlVazvcfGd7VX2fp+hVfeZqie7bP9OA63JRkj/yR9BBeW
         DxN+UG0gCLXxP74DD9OMxv5edMIpMzuQczGyVKtbBDFMC2NU97l51qs+EqA5rSLjdBeM
         j6lHPYMKycagWGG/O6QLCypFHIk0ZQ4TgXM0DhNYqjrD8dE35EgYMdrKuf03a5b0VBUX
         DCWpQJCw6jEdK+CmqtOmw9IW8Or4Mhs+sWY1xl7IKDqyX2n5O11LartJhTEhuMBR7USS
         oy3xdGiUc3siLC5mj34So6U3PDQ5/l2DwHDdaGMJxaTD58WzghDJbkOeIYGAmPbLd0R1
         yc4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xO2rDUNr4dM0DivbOJCUEO9EGtz1DZV/xU/rC001g6E=;
        b=UcB8m2bsLiyDXOXJIsEzusxqpaXnQ4fv0lwjV+1LQLa1qSJusFCCcfVbCMzc90wCIe
         yEG8nAw6DXVrJMM8Sti5IoOlNdeJsNiZZ9biOAC5cJmN23zHD9Kv1rqQUOHhZafiECcX
         7noMkNsQARcl+xsflA0p1k2k317Ske3l+k4uhFDN8ZUl723VNZ3uwon7JGfBao8Xqju0
         YP+PyaAzT+tbnIQ3O8nAFQpeqnU9bMqxKKRtbGEb4n9me2L1JYEi54OnbdhqlrexJHLk
         FYG/4JxE210NhnKjuNOH/S/YHf9ozqKMc0OG/hIgnRsqr7cTxsemECQu0F54efRxeC1O
         m19g==
X-Gm-Message-State: AOAM532CIV7DCxR90fe9I4U1C9w3DUsTLz62/8KIUTXqadjn0d7kVv9r
        s4dYfjS5tPI/bpXQgdf9jg0=
X-Google-Smtp-Source: ABdhPJx7ebaiUkfmrjz5qdBzKzazxl3asV2HWm8kgDXFZvJivPvGA4qTJapF8QPKc5HewZHsAncm6A==
X-Received: by 2002:a05:6a00:24cd:b0:49f:a4d8:3d43 with SMTP id d13-20020a056a0024cd00b0049fa4d83d43mr5112051pfv.49.1638963457170;
        Wed, 08 Dec 2021 03:37:37 -0800 (PST)
Received: from LAPTOP-M5MOLEEC.localdomain (61-231-106-143.dynamic-ip.hinet.net. [61.231.106.143])
        by smtp.gmail.com with ESMTPSA id h1sm3270813pfh.219.2021.12.08.03.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 03:37:36 -0800 (PST)
From:   Joseph CHANG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] *** ADD DM9051 NET DEVICE ***
Date:   Fri,  3 Dec 2021 04:46:54 +0800
Message-Id: <20211202204656.4411-1-josright123@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

*** DM9051 is a SPI interface ethernet controller chip ***
*** For a embedded Linux device to construct an ethernet port ***
*** Fewer CPU interface pins is its advantage comapre to DM9000 ***
*** It need only cs / mosi / miso / clock and an interrupt pin ***

Joseph CHANG (2):
  yaml: Add dm9051 SPI network yaml file
  net: Add DM9051 driver

 .../bindings/net/davicom,dm9051.yaml          |  62 ++
 drivers/net/ethernet/davicom/Kconfig          |  30 +
 drivers/net/ethernet/davicom/Makefile         |   1 +
 drivers/net/ethernet/davicom/dm9051.c         | 987 ++++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         | 259 +++++
 5 files changed, 1339 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: ce83278f313ce65a9bbd780a3e07fa3f62d82525
-- 
2.25.1

