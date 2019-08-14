Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 057888D2C5
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 14:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfHNMNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 08:13:23 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43097 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbfHNMNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 08:13:23 -0400
Received: by mail-lj1-f196.google.com with SMTP id h15so10894288ljg.10;
        Wed, 14 Aug 2019 05:13:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AcS5UBa0BogcF4iUmQclBkrtQ1rhpBtpwE+q05zZVvU=;
        b=V0BCLnGUBQvAlr2/IFEVlZFtQmgiy6w8CIbKo2gbn/6iQPEHv3Gp5TyduEI/tYKTMe
         BedWCUwVxaqQtj2bJdS8Rcfj5iR04geMsVLrE0N0NmwqZEqU1vASzcsEPpQ5jGXRE0Zo
         3iSAXHQ90pG0V5ysgRuLlbxf/T7+MfMcp5XIDGTN/tlFlouvQa7sQMqVgA+a8FlGSI4Q
         VahEFIAD8q/DKgZvvp1bg7VDxYGUKDcdwftFagxl9H3n1mgiBacGLTmSKLTvy8DRpY0U
         r1Q2unMnOjJZl7xgBGRMdy6ursMoMrtqtpd4135axtx9Nu0EDibVLaMRBkTzLFoTXvgo
         24QQ==
X-Gm-Message-State: APjAAAVSIx68ad7OlBK9/4I//2T9FAG/NdVTnCEkKIBu1Ue2UeFHasOo
        9P3A7+V+8BVMkzyd3fh9tok=
X-Google-Smtp-Source: APXvYqwB9fQ19P8V9McPgt33u/p/nPZieoPujMbKWlxdihamW+E8FRN7gisHPSCnzQXj/MsrftMu8A==
X-Received: by 2002:a2e:534e:: with SMTP id t14mr5208262ljd.218.1565784801763;
        Wed, 14 Aug 2019 05:13:21 -0700 (PDT)
Received: from green.intra.ispras.ru (bran.ispras.ru. [83.149.199.196])
        by smtp.googlemail.com with ESMTPSA id p21sm20128771lfc.41.2019.08.14.05.13.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 05:13:20 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Denis Efremov <efremov@linux.com>, joe@perches.com,
        linux-kernel@vger.kernel.org, nic_swsd@realtek.com,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] MAINTAINERS: r8169: Update path to the driver
Date:   Wed, 14 Aug 2019 15:12:09 +0300
Message-Id: <20190814121209.3364-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <69fac52e-8464-ea87-e2e5-422ae36a92c8@gmail.com>
References: <69fac52e-8464-ea87-e2e5-422ae36a92c8@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update MAINTAINERS record to reflect the filename change.
The file was moved in commit 25e992a4603c ("r8169: rename
r8169.c to r8169_main.c")

Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: nic_swsd@realtek.com
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a43a1f0be49f..905efeda56fb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -183,7 +183,7 @@ M:	Realtek linux nic maintainers <nic_swsd@realtek.com>
 M:	Heiner Kallweit <hkallweit1@gmail.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	drivers/net/ethernet/realtek/r8169.c
+F:	drivers/net/ethernet/realtek/r8169*
 
 8250/16?50 (AND CLONE UARTS) SERIAL DRIVER
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
-- 
2.21.0

