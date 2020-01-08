Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 673EF133C42
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 08:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgAHH0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 02:26:24 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34704 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbgAHH0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 02:26:23 -0500
Received: by mail-pg1-f195.google.com with SMTP id r11so1138982pgf.1;
        Tue, 07 Jan 2020 23:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BGo10uJ7yfot4T+e9WxjVmggP6J1wCJOQgtZDEvps6k=;
        b=DZYTvdIW+43poxmXAWsnbKEMXfMgAYTNSNSjzrKvHcbxYUNT70lgy3dQKoQG768UuR
         y/4QnZ41Z2U3eHE/WyeZxE7goX74Z6fTViI2rtkRlsG1+kLZX9o56Nr8Hf5pbVnmR+Lq
         xO2XIfYh4WJYvL9FM8OKz27dOyW+woGROnWGCj+7ePioeXlCFJbDT3OrkIQzSWTxbwBK
         C7gNn+O/JZlSIUHDuES4e78GNWe0O+MJRMUqv2PTJJQJE3V0644vAgqpYYvGB1Uo8liZ
         etu8LY3BomXKXaUE1mhQnk/KJqmRstxgYvxUOI4+rjn8OSNRK6jpeax5YJoH6y8k6T0b
         PYog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BGo10uJ7yfot4T+e9WxjVmggP6J1wCJOQgtZDEvps6k=;
        b=CRZqDO//5bpavvXVCG/JHM4eWpMez9/c3pc01NdahU1pYB6bXcHR8ApFgHzarSsZqs
         DTuUK0qIjbVudIM9gybrvNZrBVJ8TI3L/OC5LS1+irRDyegY9qSS4NDisPIPRsR64Dlo
         RbAjgrtswY68Yf7qNJfUuWVSSTm5RGDkSdxfNWGvJC0WHXSQxaJqiUCS8pilTSBuq5Il
         Pg642SRCAPZNrvuiFG3sqKNzkzvoXoRKDC9+dwTQOGQj+A9dgcXzQOzbnkFL68OENQ/d
         V1VdgLcd6zsGHrRZB1BPAq9ula1Rt0iNTpMmwYSKaBO9ItrptbdWxdXoz840+yswWdQ6
         dwaw==
X-Gm-Message-State: APjAAAXkzX9EC3+sA5kO3qKR8rL5+tqthfsZC//eNeHoJ9xyHEp58OsM
        RWvH/4+b5dVX9SFICEfPy4E=
X-Google-Smtp-Source: APXvYqxghKJ14QjOwmxrl6htFh2WX6svt01e28xiCtneF71s3aUeytu3/ouF1j764HyGERYD9M/y4g==
X-Received: by 2002:a65:4587:: with SMTP id o7mr3730787pgq.303.1578468383088;
        Tue, 07 Jan 2020 23:26:23 -0800 (PST)
Received: from localhost (199.168.140.36.16clouds.com. [199.168.140.36])
        by smtp.gmail.com with ESMTPSA id o31sm2231827pgb.56.2020.01.07.23.26.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 Jan 2020 23:26:22 -0800 (PST)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, martin.blumenstingl@googlemail.com,
        treding@nvidia.com, andrew@lunn.ch, weifeng.voon@intel.com,
        tglx@linutronix.de
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH v2 0/2] net: stmmac: remove useless code of phy_mask
Date:   Wed,  8 Jan 2020 15:25:48 +0800
Message-Id: <20200108072550.28613-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches just for cleanup codes in stmmac driver.

Changes since v1:
	1, add a new commit for remove the useless member phy_mask.
	2, adjust some commit comments for the original commit.

Dejin Zheng (2):
  net: stmmac: pci: remove the duplicate code of set phy_mask
  net: stmmac: remove the useless member phy_mask

 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 1 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c  | 5 -----
 include/linux/stmmac.h                            | 1 -
 3 files changed, 7 deletions(-)

-- 
2.17.1

