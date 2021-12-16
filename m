Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2CE476D78
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 10:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbhLPJdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 04:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbhLPJdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 04:33:09 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9124FC061574;
        Thu, 16 Dec 2021 01:33:09 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id d11so13919050pgl.1;
        Thu, 16 Dec 2021 01:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zzf+LfImVidU5lTY4sFCzZF8SK63x8wA2LLDGZX7C/E=;
        b=aIjvfWxLgGFEf3ii7PO5NC2ZnOXYnklepEMWQ0Veq+gaxMFI/vVcC1LQtsUtV3g8Ci
         NjmXlSe+v1kQigTGj1h1gcqgsWLTRngGEZFIOMXLoopXwLONjpjaSSKqp2hCTGFuyIUB
         dR5F14gvlVxLJeVlJqCNDbWqk1ZIkQWAND4lq0nMjvIu3kJ4/LPcvyKMgaRXAomNLauw
         yOPHWqNpf/QkCzKF+shhrB0DvzRbtDa4bE/A/c7V5zrlo0rMzRqtNNU3Bs7qllVXt5jD
         5xgtSvqCitRK4o6+BB2rEkRr+klPkspNQXJT503cW77gt4aqV/M6lSRrCfl5xwEJS7z5
         E4Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zzf+LfImVidU5lTY4sFCzZF8SK63x8wA2LLDGZX7C/E=;
        b=z7yPhSE8d0etUxasrDK+FieH01NGbf/SB6VR+GpkA//8R4A6SEcNvbyyWngXKaM7jT
         T4E0GeUMRaOIW7XrAMno27I5htUham9XU5eyhI2g5Qoxp2a1wV9KM4xfmBL31LQkfH/P
         lcmEWnHLOEF4TqeY3GydOeXPYU4mCKBKWZKUjNyNGMLjrVkiCGeJSzBO3yHO+0WZ5pew
         pE+rlaynMIhgraQ2tAVxAUUhMfaR+zVovMxJ+fa8SJuBw/eQc+3FeSN38Mn+CvLGqyRD
         AhqsnrTZt8y9u54WjSBtB0lXzcndOXJKx9SLzYxx+QVJYmNKF1e6Hk0X3qKpnpdf6k3w
         luMQ==
X-Gm-Message-State: AOAM530dJqhn2pbxr9nZQkYLVR2rBaIduzWH7xrzeiYtflQc4m0YvegU
        CYfaQ5HARLBniuyb0OoFgiU=
X-Google-Smtp-Source: ABdhPJxj4ce5VZekWBXbcmtExKg1Q6y2JNq+fMqK1yabopOjvbUQD4AyPtK3tPj7EbQvYXfbZV1pIg==
X-Received: by 2002:a63:1b02:: with SMTP id b2mr11296997pgb.263.1639647188950;
        Thu, 16 Dec 2021 01:33:08 -0800 (PST)
Received: from localhost.localdomain (61-231-67-10.dynamic-ip.hinet.net. [61.231.67.10])
        by smtp.gmail.com with ESMTPSA id d9sm7033181pjs.2.2021.12.16.01.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 01:33:08 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6, 0/2] ADD DM9051 ETHERNET DRIVER
Date:   Thu, 16 Dec 2021 17:32:44 +0800
Message-Id: <20211216093246.23738-1-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

remove the redundant code that phylib has support,
adjust to be the reasonable sequence for init operations in
dm9051_probe and phy_start

DM9051 is a spi interface chip,
need only cs/mosi/miso/clock with an interrupt gpio pin

Joseph CHAMG (1):
  net: Add dm9051 driver

JosephCHANG (1):
  yaml: Add dm9051 SPI network yaml file

 .../bindings/net/davicom,dm9051.yaml          |  62 ++
 drivers/net/ethernet/davicom/Kconfig          |  30 +
 drivers/net/ethernet/davicom/Makefile         |   1 +
 drivers/net/ethernet/davicom/dm9051.c         | 898 ++++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         | 188 ++++
 5 files changed, 1179 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: 9d922f5df53844228b9f7c62f2593f4f06c0b69b
-- 
2.20.1

