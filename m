Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0304C4873F5
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 09:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345499AbiAGINS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 03:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345570AbiAGINR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 03:13:17 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281FBC06118C
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:13:16 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id r10so1886753wrc.3
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 00:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y5vv85VvwS9MS7JlafP+Njn1B1aPbUU7IaGWNQUgbis=;
        b=iL8oFfe43QgftfpgHnQgjVBubyyuLqUpSLqUuyf72+AdnVY5pkBhR2O1qtoN8yBp2K
         3A2ayZWo16ycvCobtZkcAr10oKUS3kiB3Syngs28BfMwZyba3NTBiaKqnrPZzd4sqmIV
         AMuNWq3z2ioyIpUNGZOSvSTEV8BKw82l+Ucr4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y5vv85VvwS9MS7JlafP+Njn1B1aPbUU7IaGWNQUgbis=;
        b=y3giQjA+K0XSCs1vjWsgZdd4m6EDNeK9KMpd/8UAjECf3CfZnnsoUE2ewWFHdPEn/n
         4lqs+HHoErr7FTuLUeBMj4VLcub4mAhjX8xsqW9QMZym+9U5kT6VZn7XKURNb10N230w
         XTL6j2EGcyr343JAGtSYaJQd1MOa3unk4ikt6HfABfp4bWgPLxxD9Dnrx3u4WpI2Wmi7
         BX8XEkVDuVnNcILhvldKMdcK+SrdjGRIET1B3kXJK1denAdPEpPH9NOiepg5Cd6HkN0c
         xLKuXLBUGSe9Z9Uojo1QGTfnUULzBiuseunKdKaiQPWK9IMXtHSQLkWBMFmhoG6JyVlL
         7nzg==
X-Gm-Message-State: AOAM5335Dmq3afE93KhunOjbfeYUSCP/gPyJV78eHX1wsLhKYJYB6uVw
        SNoo9lKBekeXMBQeh8oM17XDGQ==
X-Google-Smtp-Source: ABdhPJyPwaMZa0yQeRjywazx6ncmfSazFg4h+xLedFtfm2vQlCvyJNrBejHstFH3Rpo0cAI3CmiyTA==
X-Received: by 2002:a5d:4525:: with SMTP id j5mr9452235wra.519.1641543194804;
        Fri, 07 Jan 2022 00:13:14 -0800 (PST)
Received: from dario-ThinkPad-T14s-Gen-2i.amarulasolutions.com (mob-5-90-38-18.net.vodafone.it. [5.90.38.18])
        by smtp.gmail.com with ESMTPSA id w17sm4280633wmc.14.2022.01.07.00.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 00:13:14 -0800 (PST)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH 1/2] docs: networking: device drivers: add can sub-folder
Date:   Fri,  7 Jan 2022 09:13:05 +0100
Message-Id: <20220107081306.3681899-2-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220107081306.3681899-1-dario.binacchi@amarulasolutions.com>
References: <20220107081306.3681899-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the container for CAN drivers documentation.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
---

 .../networking/device_drivers/can/index.rst    | 18 ++++++++++++++++++
 .../networking/device_drivers/index.rst        |  1 +
 2 files changed, 19 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/can/index.rst

diff --git a/Documentation/networking/device_drivers/can/index.rst b/Documentation/networking/device_drivers/can/index.rst
new file mode 100644
index 000000000000..218276818968
--- /dev/null
+++ b/Documentation/networking/device_drivers/can/index.rst
@@ -0,0 +1,18 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
+Controller Area Network (CAN) Device Drivers
+============================================
+
+Device drivers for CAN devices.
+
+Contents:
+
+.. toctree::
+   :maxdepth: 2
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index 3a5a1d46e77e..5f5cfdb2a300 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -11,6 +11,7 @@ Contents:
    appletalk/index
    atm/index
    cable/index
+   can/index
    cellular/index
    ethernet/index
    fddi/index
-- 
2.32.0

