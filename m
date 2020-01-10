Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62966136C34
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 12:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgAJLnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 06:43:12 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40731 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727717AbgAJLnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 06:43:11 -0500
Received: by mail-pl1-f196.google.com with SMTP id s21so765382plr.7
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 03:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nNt4HuCGWHT2Bkn0GogHGyrPDMuxETl2JoftRPjRMxg=;
        b=Y2ches/q5NCHfRex1j2Sqx86MzxSOqG1grsCA2G12E63N8DixopFIJahjR3QW4mCWr
         wIaN+zUpwMqO5FP2TmDvmWAs6Wh5DlWO+A0RYLOAVqQreuQfVbpNlvDRoVOX0mK+VNXW
         Su+2PrvPEkdcoFpLy3XOZchj/Sd4C2jZCIJ3EoWbxz2jfAMIVp0INle8MeIETxIQW/vB
         M1OZyyJG4DAPzp6UsG0Ieshyb2Gn0gxNHN6poawDIqK4nszDiwc8rJjvBexKsqVbjJ6V
         ND1tMjP9KF3pMU5d4mlXX4pVy5tiB42gYlPw0nIt7kNHKijdS7mWR+8O90eqYY4/Us0D
         2kOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nNt4HuCGWHT2Bkn0GogHGyrPDMuxETl2JoftRPjRMxg=;
        b=jC8IxTGSWKHCWbtUBsuVhH01cY6yYni5DmmSbv9N9ZVkGdAm2aR+na80/18Q7xh09t
         KAnU2DGHjWUex6TC/1tSNGgmVZ5ODWmEdcjq4POATFeZiOK+HziCw4m4lMyuMjC9EAnE
         tNICaPixJBvEYxUDQq94Csd5OTG+CtVFszXT6e8BBxV8QYoHpldYaASuFCUHQnrAbEqn
         5RpIaAED1R3Ggufki4YT5MaWOTtdpmCKvy3NFiFbC/B8r83RmzvfqqiZrVnh8kmBbtvN
         Ob/xq0mJlGcqoqOFRUH8n4qOo/5K5NRhbS5aM5SHa7Hd/UMmdtqYvujphdXQMzvWRgj8
         sGEQ==
X-Gm-Message-State: APjAAAUBgq6CWeXkobnKxWe7at1odFTojwM1kZ8VyCfxU5NeVebOycQB
        3q3+/6wQBX6F2P5ZxLOnhJgCeKWpZFY=
X-Google-Smtp-Source: APXvYqy16CT1ngzjEQ3nRvptIvBbf/sKpyUSUoA/OjAgMAkFopxwxEv4jVGG7w+tRb11WA1aIu8aZw==
X-Received: by 2002:a17:902:9048:: with SMTP id w8mr3718118plz.294.1578656590406;
        Fri, 10 Jan 2020 03:43:10 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id o19sm8848866pjr.2.2020.01.10.03.43.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 10 Jan 2020 03:43:09 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 17/17] MAINTAINERS: Add entry for Marvell OcteonTX2 Physical Function driver
Date:   Fri, 10 Jan 2020 17:12:01 +0530
Message-Id: <1578656521-14189-18-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578656521-14189-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1578656521-14189-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Added maintainers entry for Marvell OcteonTX2 SOC's physical
function NIC driver.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b4ebd44..5e6c03e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10001,6 +10001,15 @@ S:	Supported
 F:	drivers/net/ethernet/marvell/octeontx2/af/
 F:	Documentation/networking/device_drivers/marvell/octeontx2.rst
 
+MARVELL OCTEONTX2 PHYSICAL FUNCTION DRIVER
+M:	Sunil Goutham <sgoutham@marvell.com>
+M:	Geetha sowjanya <gakula@marvell.com>
+M:	Subbaraya Sundeep <sbhatta@marvell.com>
+M:	hariprasad <hkelam@marvell.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/net/ethernet/marvell/octeontx2/nic/
+
 MATROX FRAMEBUFFER DRIVER
 L:	linux-fbdev@vger.kernel.org
 S:	Orphan
-- 
2.7.4

