Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACE6213A149
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 08:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbgANHDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 02:03:35 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35769 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728998AbgANHDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 02:03:33 -0500
Received: by mail-pg1-f193.google.com with SMTP id l24so5956352pgk.2
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 23:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7JA7OaAwygRJhFE5OhJzasHdhSSViUU13KIg0q1FSec=;
        b=KQSRTbaO01EOdiu5Y64UwbOxVIgRXKfkLOnjOHc8ylFSjF+NV2sulWmkSCbLnQbuh1
         7VMI5Vj86AeuqGFHjE6i/fPbTGrwKFuN4dSr5IVoSD5ORgeGTSN6/Ahq3W9RXRbmYvA/
         Uz5K3M5CFjfe03sjRNziKOZ3vHgwdNUr9lZ7NCjvnysYFMXgMsI0fzLSMTaRrRhBJ1T3
         gjMDEChus6Dz0MnpkwuJTTLzbzUHh7bCHkMzCTJCFBcWsl7oc1PKAZoPHRYlEv+yY+iT
         HM4yBl6241EnrIs78ij2W8kTjSmBBNbVTC3WdsuJII1m2RV0CuMSkKgh0klmtsbxT7/P
         UFUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7JA7OaAwygRJhFE5OhJzasHdhSSViUU13KIg0q1FSec=;
        b=tCa4ukmKLZyBfTGRWc9L+PRg/wy/MQ+R1IrZHChd0E0ahUgs33vsnhZoklmmxjmjtq
         PJIIOpSgxCIsP9HYnOUgXYVcz0/Sz+QALkRy35XpKXTdFxCIIP2ZblOPAup8eIpWiPXM
         FiGCtord8z6d8T/gENOIN7DID92C9/ZKdQH78S+4PHW3xja6WUBgL32FaIDraBQYnkEX
         fO5jDiOn519avRh80ltof1wNFKI4z7XnbX9y7VMVBdqMlw6yfK67kyst46CAe90wgfhI
         aMGJxNXkhqsLpMKcVLbRXNmWj1gHcKpVuXGKoCnG+F1+ei0NbDU4U3jlQbML3ant1uCt
         i/tw==
X-Gm-Message-State: APjAAAVKFu1G4OYxRNIWmzBrEy1PAn+Vz8ANc7s+aRShO2b7zcNxQgEi
        PSaznCIET7/lzYTjOGV5zcp0k6qGqVQ=
X-Google-Smtp-Source: APXvYqycSdiSdjJqei+t11tFAb11VUjDDXzA/T/7s4VSXAn5TApHu+s0OEpOJH0FTU35BelBcxDGHw==
X-Received: by 2002:a65:6216:: with SMTP id d22mr25308539pgv.437.1578985412611;
        Mon, 13 Jan 2020 23:03:32 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id o19sm2241014pjr.2.2020.01.13.23.03.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 13 Jan 2020 23:03:32 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 17/17] MAINTAINERS: Add entry for Marvell OcteonTX2 Physical Function driver
Date:   Tue, 14 Jan 2020 12:32:20 +0530
Message-Id: <1578985340-28775-18-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578985340-28775-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1578985340-28775-1-git-send-email-sunil.kovvuri@gmail.com>
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
index 6659dd5..73b510b 100644
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

