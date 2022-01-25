Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79E949AFFC
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357771AbiAYJV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454329AbiAYJLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:11:42 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E4DC05A18C;
        Tue, 25 Jan 2022 00:59:13 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d7so18584799plr.12;
        Tue, 25 Jan 2022 00:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BAFYbH2/cFRyjRw+hyoheTLpA8euMsXCERp6j4j4WxY=;
        b=DZCKi3tOlTTg1TIvj3i97WNbwIRB4xs6ELVC1NIqXFaG3sLRe3cizesqZKbCHM0GOY
         SK+FPjH0vawALEqCyTuFlrKHtyyZoJK98kpj9Sc3lIWjaMFSbIxxTQhob5LOqfz/y5a3
         azP98pthg6lZpkgglq6aWHlo024ZBD2wdDETn+nYtP2yVxNrCUQM2cmCCJfy9C6PQnSb
         MTcvD+/WrQ4owy9qvbuX2zzp3UiNoJtqNvRyX17FqHaIcqL4WgBI+Q6uWxgfpTfRN+y2
         J8c9KeoPNIYiu6MJkOVbHLomhmV9cNdVlzzFRdK+UOgn1RggAVQq4kADqAQI2q9W7Rpw
         YG/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BAFYbH2/cFRyjRw+hyoheTLpA8euMsXCERp6j4j4WxY=;
        b=HIoTCP/oIZQZ+Io6TIN79Xnj3rtZSukYbjmaiLg3RW/TlVoBmewZJYBVfNL0NPIVc7
         2DMX8KG388gEdEsqCeRueRcx35cRbgn8Mpe62G48QqDoK5glqffk8/0HWjT0myk8+P1U
         qj+SChqOvjBhKkv0r44JqVeMfdNvz35tlonLaiWnOMDKFB1mFo0Cpda6VSMu9fcwYSwD
         VbmbgI0bJBeWRK6m+VlI5pWAvEmLBLeBYio8s7IPAr4s3UvB8U7eh85Rv/qEVjElaZnv
         Dar7IdV/IXpaHhafa3Ix3S3uiJwSuD4ceyBK/uEevkG+csPtXLJa+9i+acOwaXK7RRWP
         bjmw==
X-Gm-Message-State: AOAM530iatTbHJUJxJmYMesiufW7QjupNGcBHbTYLGxgKmZK6Lxlw4MA
        kh1C8YjqNopXX6Y1Mc8PL1Q=
X-Google-Smtp-Source: ABdhPJz3x4/IZmKVZSGgjgd3mBVoEExuCcO2ki/HJ6G1ci3UjA30iuVYTv1HGcJMARA86FmWyaDhaA==
X-Received: by 2002:a17:903:1c8:b0:14b:6b63:b3fa with SMTP id e8-20020a17090301c800b0014b6b63b3famr3885163plh.156.1643101152803;
        Tue, 25 Jan 2022 00:59:12 -0800 (PST)
Received: from localhost.localdomain (61-231-119-59.dynamic-ip.hinet.net. [61.231.119.59])
        by smtp.gmail.com with ESMTPSA id lr7sm2154905pjb.42.2022.01.25.00.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 00:59:12 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org
Subject: [PATCH v13, 0/2] ADD DM9051 ETHERNET DRIVER
Date:   Tue, 25 Jan 2022 16:58:35 +0800
Message-Id: <20220125085837.10357-1-josright123@gmail.com>
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
 drivers/net/ethernet/davicom/dm9051.c         | 1182 +++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         |  159 +++
 5 files changed, 1435 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: 9d922f5df53844228b9f7c62f2593f4f06c0b69b
-- 
2.20.1

