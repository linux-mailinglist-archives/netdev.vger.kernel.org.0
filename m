Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD4892BDA0
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 05:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbfE1DWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 23:22:15 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40028 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727597AbfE1DWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 23:22:15 -0400
Received: by mail-pl1-f194.google.com with SMTP id g69so7721831plb.7
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 20:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=babayev.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=txkPYx4kl/dbr2peXVzI1JFIF8M0v7UB6YuZExmYRSc=;
        b=RPgmgTE070YVO9U/nSaukvceq0z2LI7bXy7zOuS7TU8p0LInnNih5j7BECvhrURzaA
         mxTWhkNYa0Z3IJYe8lRswb0XVbKZ1NPbn9sPGi4X3Xyox5YK5GvS7Co/yvOtqoxfx/4h
         k+xL8PEz2ZonoAumksNuC7eI6sg2A3y13B01I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=txkPYx4kl/dbr2peXVzI1JFIF8M0v7UB6YuZExmYRSc=;
        b=GlBoXq30FAw7vOLmKxL/LY0Yy3ReIU99LisNdTEzuDXjQRg+caHe2uTkr13at+CGeU
         hJ7jVo9ITOsE8PRU3idkIEL7hIa7ZmVz/BNuRr0N9A6403Q835dqXAk/reQ3sMr/V4M6
         rZm2WlSyX4EIpY5kbF7TxV7qlh1dlflqOYklq8/oAhrUSuOnJLMBFdnwMel9HFXS7Ype
         Y81nMy5rTSaH9L37K9ibI4C+1VD2U2aj06wQYdtL/9r5kX7NH8cx5iN7d6FrwI/raNRC
         xu+nG/U4MomD0jWAhSXaABxOomtoxwiWr9R8hDs2jnO4bSX5DDv1JYeKDvvC6oJjlrq/
         Dh9g==
X-Gm-Message-State: APjAAAVjfAsnPlQ6ziP3k2/dYrxsXaVQr3+4F9xlzpJJEMO+X6Wy6jbW
        M+/5yEst9XoXUDSsQB9nGm1PCw==
X-Google-Smtp-Source: APXvYqxZ6q0wb4tst0o7iW9zQi1zpzrRqJ4aOJnY2Q1Qy1NYBL2UVXh9DmnyYdL6fagHbkPJ7Ew49w==
X-Received: by 2002:a17:902:121:: with SMTP id 30mr2837278plb.314.1559013734376;
        Mon, 27 May 2019 20:22:14 -0700 (PDT)
Received: from p50.cisco.com ([128.107.241.177])
        by smtp.gmail.com with ESMTPSA id h71sm933042pje.11.2019.05.27.20.22.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 20:22:13 -0700 (PDT)
From:   Ruslan Babayev <ruslan@babayev.com>
To:     mika.westerberg@linux.intel.com, wsa@the-dreams.de,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [net-next,v3 0/2] Enable SFP on ACPI based systems
Date:   Mon, 27 May 2019 20:22:11 -0700
Message-Id: <20190528032213.19839-1-ruslan@babayev.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes:
v2: more descriptive commit body
v3: made 'i2c_acpi_find_adapter_by_handle' static inline

Ruslan Babayev (2):
  i2c: acpi: export i2c_acpi_find_adapter_by_handle
  net: phy: sfp: enable i2c-bus detection on ACPI based systems

 drivers/i2c/i2c-core-acpi.c |  3 ++-
 drivers/net/phy/sfp.c       | 33 +++++++++++++++++++++++++--------
 include/linux/i2c.h         |  6 ++++++
 3 files changed, 33 insertions(+), 9 deletions(-)

-- 
2.19.2

