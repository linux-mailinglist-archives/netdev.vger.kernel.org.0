Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93E4431283
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 10:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhJRIzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 04:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbhJRIzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 04:55:22 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B9EC06161C;
        Mon, 18 Oct 2021 01:53:11 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id t11so10723334plq.11;
        Mon, 18 Oct 2021 01:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cPf45+NYCUPDMuwaEZJIrIqOd+hU213p3bQGW7tfWgI=;
        b=DnsZxBko6KRjJ4qGpDxe8AP1yryGfAXgP6xKgu6PLG7A02Jb+/sOnSqUxr8GTnmshO
         n/n59LMDH/YN18qifJmzZGRyTV1WZaeAZXGyhtf0AQp+9vIvDpifzjefoxUliowHpsdQ
         WL8wEW6S21bLFwomSeIHoMR/ctnfolRHwSNeDelI0dtzJpAEABV9sKxbn9tTKLeE3QEI
         FnJ02ADce3cXxlcc+O+1yIkcNpBRsSbLvt7POOvqw4MLmjJjVbnadoJJ6aFjXHEdn3GV
         Avz8sZA8Jmus7Q3lOa3EqsGjZR3TToHjzANH2hjjPpA+vfcUvlM2w8VGJk465cDrQVX0
         g5Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cPf45+NYCUPDMuwaEZJIrIqOd+hU213p3bQGW7tfWgI=;
        b=INNQdUcEvQLpC6NsryVThyI60Ex7v91nJWRoya39AAHmDXF+peMvZModPkDFrtxNMu
         ytmDkWLK0k9QyJvAUKO4tlIFWIhusmUJvPYLBFNw50iT3W/NbrKDLsP0w2Jiu9YLS9Ut
         IfHdp2+sPVf4hkAo04rsjjpE/AUmR48q+NnmluwFPZ5fuR3GKYioaNOXuKlHjqT5B+o6
         mRXFWU5YWkx2WiU4FiAxtM5xQhoz3yBjr4praYwRDPiUE34Lp2jNlxzKI+7JvtIHkJLO
         kDoAh6W1eObu5aN7x5C1UVJU514ZoK2LF1GECLYqeUx+9RBWD+unIvgBzvDUgAFZf6Nh
         WqoA==
X-Gm-Message-State: AOAM530mDIp/844Vzm+t+gfcpNVZkf0SDB+wp2pf4OqtV79Gbsa97R8E
        uLBYLE7YDGnLMvl8oxbaAUg=
X-Google-Smtp-Source: ABdhPJzmi8zYbKJrqmC2j9SNW+6i+RPB91H/iwhaR57kHmLYRD8vjG77lr18TDTbS2PmxK49IwNONw==
X-Received: by 2002:a17:902:778a:b0:13f:672c:103a with SMTP id o10-20020a170902778a00b0013f672c103amr26408547pll.55.1634547191078;
        Mon, 18 Oct 2021 01:53:11 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id u24sm12084921pfm.85.2021.10.18.01.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 01:53:10 -0700 (PDT)
From:   luo penghao <cgel.zte@gmail.com>
X-Google-Original-From: luo penghao <luo.penghao@zte.com.cn>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] e1000: Remove redundant statement
Date:   Mon, 18 Oct 2021 08:53:05 +0000
Message-Id: <20211018085305.853996-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This statement is redundant in the context, because there will be
an identical statement next. otherwise, the variable initialization
is actually unnecessary.

The clang_analyzer complains as follows:

drivers/net/ethernet/intel/e1000/e1000_ethtool.c:1218:2 warning:

Value stored to 'ctrl_reg' is never read.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
index 0a57172..8951f2a 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -1215,8 +1215,6 @@ static int e1000_integrated_phy_loopback(struct e1000_adapter *adapter)
 		e1000_write_phy_reg(hw, PHY_CTRL, 0x8140);
 	}
 
-	ctrl_reg = er32(CTRL);
-
 	/* force 1000, set loopback */
 	e1000_write_phy_reg(hw, PHY_CTRL, 0x4140);
 
-- 
2.15.2


