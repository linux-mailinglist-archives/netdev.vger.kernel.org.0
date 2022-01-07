Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCAEF4873FA
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 09:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345740AbiAGINX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 03:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345627AbiAGINS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 03:13:18 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFC1C0611FD
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:13:18 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id c126-20020a1c9a84000000b00346f9ebee43so2421232wme.4
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 00:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aNFvFjfPzdhSbUOj3hcvdY5IUVIwY9ysmaaDPH4hqEw=;
        b=HUJvC2rBCYnYMrPsMuDGh5OBNDPyw9iliDH6ctc4PaORQ0/4CSBi69707k3xI1vEOU
         DO/gPV3PusSvyCYUT7bwBx20/VWRSsiJJdeKi36YIPRDn4Jbgjo5x8IAH38qndXNOK4M
         kTUx/TVrhRIkhXWRQ/ZrVd7al9tAT1+PIpX/8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aNFvFjfPzdhSbUOj3hcvdY5IUVIwY9ysmaaDPH4hqEw=;
        b=YzAs9J0IeuaHARbgo6dohf3Ez8Fi563nk/mWdzEFqW/Bssq13FeJz7AON75hZerbdq
         oggQIH95WYp6OlTuIH1sVB2NEY3TK1alEvBJKF9pJgWgqM9FWdPgYLe5vljLrNND8Ndi
         ANtwOqvB4jjx4pqomaJpCUFd7+uuCeoojBKc4c5Tk/MIezIs6mxyQq6z8eqLcQVbsC+D
         y1sh7PapHklHNkeMj6ECSszA/OHGirrzkX8T5bNtnjuihc955/NhCzhx/dif/b7dAPfh
         iSwTC1VvgIuZQE/kxIaUWrsDPxVowlMJw8pUDAS36W62GvtRsa9p+JXNLxnDNb5VfLRf
         0fHw==
X-Gm-Message-State: AOAM532jgxIQwt7Eh3H8RijvL7quKeqzRGuuga4Mqsb8r4oUlbvv0vH3
        /jA4iAxm4N/tfqnaTycSS23MLA==
X-Google-Smtp-Source: ABdhPJwjkacrYJEH7D3L5LAfAOudyDPO3yGwNl/aaJB4R6tP6IVdM2JWpRn8ogz65SxvbkbCOD2rTA==
X-Received: by 2002:a05:600c:a0a:: with SMTP id z10mr10025256wmp.126.1641543196271;
        Fri, 07 Jan 2022 00:13:16 -0800 (PST)
Received: from dario-ThinkPad-T14s-Gen-2i.amarulasolutions.com (mob-5-90-38-18.net.vodafone.it. [5.90.38.18])
        by smtp.gmail.com with ESMTPSA id w17sm4280633wmc.14.2022.01.07.00.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 00:13:15 -0800 (PST)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC PATCH 2/2] docs: networking: device drivers: can: add flexcan
Date:   Fri,  7 Jan 2022 09:13:06 +0100
Message-Id: <20220107081306.3681899-3-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220107081306.3681899-1-dario.binacchi@amarulasolutions.com>
References: <20220107081306.3681899-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add initial documentation for Flexcan driver.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

 .../device_drivers/can/freescale/flexcan.rst  | 25 +++++++++++++++++++
 .../networking/device_drivers/can/index.rst   |  2 ++
 2 files changed, 27 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/can/freescale/flexcan.rst

diff --git a/Documentation/networking/device_drivers/can/freescale/flexcan.rst b/Documentation/networking/device_drivers/can/freescale/flexcan.rst
new file mode 100644
index 000000000000..1a5bb2ed08a3
--- /dev/null
+++ b/Documentation/networking/device_drivers/can/freescale/flexcan.rst
@@ -0,0 +1,25 @@
+.. SPDX-License-Identifier: GPL-2.0+
+
+=============================
+Flexcan CAN Controller driver
+=============================
+
+Authors: Marc Kleine-Budde <mkl@pengutronix.de>,
+Dario Binacchi <dario.binacchi@amarula.solutions.com>
+
+On/off RTR frames reception
+===========================
+
+ 1. interface down::
+
+      ethtool --set-priv-flags can0 rx-rtr {off|on}
+
+ 2. interface up::
+
+      ip link set dev can0 down
+      ethtool --set-priv-flags can0 rx-rtr {off|on}
+      ip link set dev can0 up
+
+Note. For the Flexcan on i.MX25, i.Mx28, i.MX35 and i.Mx53 SOCs, the reception
+of RTR frames is possible only if the controller is configured in RxFIFO mode.
+In this mode only 6 of the 64 message buffers are used for reception.
diff --git a/Documentation/networking/device_drivers/can/index.rst b/Documentation/networking/device_drivers/can/index.rst
index 218276818968..58b6e0ad3030 100644
--- a/Documentation/networking/device_drivers/can/index.rst
+++ b/Documentation/networking/device_drivers/can/index.rst
@@ -10,6 +10,8 @@ Contents:
 .. toctree::
    :maxdepth: 2
 
+   freescale/flexcan
+
 .. only::  subproject and html
 
    Indices
-- 
2.32.0

