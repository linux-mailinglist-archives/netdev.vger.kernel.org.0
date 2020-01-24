Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8BD148D3C
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 18:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390965AbgAXRq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 12:46:57 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41931 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390505AbgAXRq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 12:46:56 -0500
Received: by mail-pl1-f193.google.com with SMTP id t14so1084564plr.8
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 09:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MLuG3Y55v+vLsOndvlTs3I5/hCTyINnOiS0PcGvmDpE=;
        b=fMulxzVUPss7HrisJWLwrnmsQM5mC4pjrL0iAbsX7Kiokx0DC/NGwhESXtqz5JJdDS
         OnqXgbWl5ZO6XNs7r62BiQNPjzecRi3UxiDgCNFpJICsyWYooDr8iM2enQK5rbqse518
         BUn3wSDWnLv8aPejYvcbDGFSGarTNeGdDn3PsIwHJqH5DuwNd7lBUoCIfvbbzVxnr1So
         vaGx5an1/GA01Ui6WC78w51LQfXW5zKLM4LcIrUyDYK4MBXKiXmNrjq5Wm7RjCmqO+Lw
         h9ir2MIXOQYofwg3tgBYRSFK41dVuThtdwXTETnxF+KwHqG9ssvrnwWMtBPJ71t0X2G4
         Xqnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MLuG3Y55v+vLsOndvlTs3I5/hCTyINnOiS0PcGvmDpE=;
        b=IE47vvC6YtC9LZnUH23GFDMDTYJYmmLymdfwhz7uUj4hCR33+wunNTe23Bj++qVPpo
         HcLJJXznwyqA+bp+wGQCHkTs06kUa2RNmRIvMLkR6U7bNOPpWkMuQfEEiOPJQB4ryxRw
         IOkSaKEKxAWQogeO2fisGMqkK2mGThItNvA+mZJM7+6bJpESVF30vD29DQGTsLUZy6F2
         3Hd3V3VqFQsyK4eSAWRHYDJDzAH4IdGkYbolRqDIO/H3AEC1e+s1YE4bcXVumsKDsAQR
         sVWudR0IR5G/Ky762LIPkuUXMr9g5ynAMfAIk3iePxhUx9Nm15qte74rXC42kgLXvscq
         r8vw==
X-Gm-Message-State: APjAAAUNGXshM3WjEWrQ8qC3NScF8JyBnQc3aHbYuf6LzWy+EO63Pb2o
        GKDiEFm9jy98COzdEkdJdbzkD3wdg0k=
X-Google-Smtp-Source: APXvYqytkRTRbVfR4AZmvuOQ7+wbBAUBY76Qne0zMh2E8soJ3umxFWINFoqM/5Dg4L9GAixrwgzjOg==
X-Received: by 2002:a17:90a:e389:: with SMTP id b9mr398124pjz.7.1579888015609;
        Fri, 24 Jan 2020 09:46:55 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id w11sm7310849pgs.60.2020.01.24.09.46.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 Jan 2020 09:46:55 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v5 17/17] MAINTAINERS: Add entry for Marvell OcteonTX2 Physical Function driver
Date:   Fri, 24 Jan 2020 23:15:55 +0530
Message-Id: <1579887955-22172-18-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
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
index 5b7ee14..c9467ac 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10002,6 +10002,15 @@ S:	Supported
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

