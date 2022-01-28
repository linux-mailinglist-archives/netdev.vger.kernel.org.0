Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B565149F3CD
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 07:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346571AbiA1Gpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 01:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbiA1Gpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 01:45:52 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1ABC061714;
        Thu, 27 Jan 2022 22:45:52 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id e16so4422679pgn.4;
        Thu, 27 Jan 2022 22:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nAT0rA7FuN5R5gzA7OzYDlUSNocIbJl3rW+ZNBQo+cs=;
        b=Q+WJHrqm0dxKubz8iQtDX0jja7JPSO/PUnLBb674+lFtSPX1SlBaTYA4TrKjqhEaBE
         clsRcx+EMkyl7GknBmZWV/xLFBi2zeXaQV2lIapQjWz2+7PwH1PCUjhdebOo0IwDbXn6
         QKEvyeBHac8WrsMA1Wc7NNxXerm5FnpZKyiVZ3FTQplVlp1ZIQVi1B/VCmYQsXRnXLXb
         tK7DO4njYc7xOp9IcAPPwYhmnoEhOC3VDCSu8BB8ffci/+UjGEX1Wyv2l8+tqPhX+qBc
         xrhl9Gpss1IenOE4ukc8DqTWJNIY6+kSyHo4wnto8TDdNA4tNEVrYlENvy1+tDmSouKp
         K+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nAT0rA7FuN5R5gzA7OzYDlUSNocIbJl3rW+ZNBQo+cs=;
        b=hbklTjOqCXan8t8oLWOoIwggtpD7hPras67SiAoZ2GNVuPamah+LqEDfxRoL4a//pl
         a0T6NPWYInGiMvpOJNauXbQ9OZz9gKouvdS/9IvNhldjvzP2rQxJaZaIF9Pspk3KFS46
         YdgyzRyTyNDLz/wMNicBcBJPsp7aKGBt3M/d8wAMKgF4t8WncsRtxgp+9/EtbAyi09IL
         g6FTvCG+b3Qjm1mDi7ztcVuqLAjoEyjriwpZQAM487JC2+9ny6c5MA7OGIdgWEsCAo/u
         h8WzpxC9Nj23Syjj3/ZDjYWczg6cQXrmTOyuGOHkkwW2YgbjO49lySm+m5r4YRCZCjdL
         MSFw==
X-Gm-Message-State: AOAM531zQEGtvhC5tmUNNjvpBWNrhOmHYnm6LUzq+phwsH0I6LICy27o
        iC6INNt+IMsx1uV/JH1mMv0=
X-Google-Smtp-Source: ABdhPJzTjTxfGbqgUKCfPOMF7mIZ9h2+EjKi+mD8oMuJNw1SztmhFDWEY61eMSa7OWHuvFJYlrU7fA==
X-Received: by 2002:a62:e304:: with SMTP id g4mr6984551pfh.61.1643352351965;
        Thu, 27 Jan 2022 22:45:51 -0800 (PST)
Received: from localhost.localdomain (61-231-106-36.dynamic-ip.hinet.net. [61.231.106.36])
        by smtp.gmail.com with ESMTPSA id f8sm5460009pfv.24.2022.01.27.22.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 22:45:51 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org
Subject: [PATCH v15, 0/2] ADD DM9051 ETHERNET DRIVER
Date:   Fri, 28 Jan 2022 14:45:30 +0800
Message-Id: <20220128064532.2654-1-josright123@gmail.com>
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
 drivers/net/ethernet/davicom/dm9051.c         | 1162 +++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         |  159 +++
 5 files changed, 1415 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: 9d922f5df53844228b9f7c62f2593f4f06c0b69b
-- 
2.20.1

