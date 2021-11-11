Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FC444D3C3
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 10:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhKKJKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 04:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbhKKJKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 04:10:08 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0425C061766;
        Thu, 11 Nov 2021 01:07:19 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id n8so5285725plf.4;
        Thu, 11 Nov 2021 01:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6tQh7m9CUeENmbF3fMGGxqc/RSUJgVc93rGIOxU+OrI=;
        b=Qj7l6GMPo48D9KdVSZLmRsdv5Sy9vfmDfwiFu7iFaLtTHHyweRi649OcIvp/R6adc5
         JwHouP9RlHkPK/hY0vQDVVDB+9DPU/bw5sInaqpf1kfItHoqt43Yp8q7xujK/nUxnqrr
         9W/GCNlqvdYAPDORueMS7atLjpOC8gJWZVdHLd5RnpIHKX/jixwkNIsER6/9PTn/aEpn
         j+QoHnFT71FOLJnRNlWN8K5b60L0AMtJEXm2I2wECJyRm4DBzfsl7eyfTvA9saLJq+Br
         CahM3izsUhSZAWLSAaD4SUfO8SthKxXcIYBjvUZyxHsrb8jsiSSudLAHEzhfEeg4frXN
         thmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6tQh7m9CUeENmbF3fMGGxqc/RSUJgVc93rGIOxU+OrI=;
        b=5uImtUeiM4Yr/Tr20t6y+UINvr6zEyyhz4qwZvVzDRsLd5rkwLl6uQmi8pGkiWKhbD
         u0bgNFOCA45aS/6XwrH/mgh7duYDihVIzgT2i8KlYTU/WOttRFJBxNiflyxf2OtAEidS
         dj/c7EIUSbPHHYNsMvFLixm3GfNeaX2LXx3h7S3PJcqaCSAnl9vneTTr+Gwouf0Can3/
         UsHo98FS4QqQ+ureSvOmatF7adCnsaU3Fsha0yeeJuswZssoaT3Yx9aMXMEbnlKbJyfU
         GqXU1KbT33r9tpBfFYIcbVbqcUZFJrtCfRGaDTSJJNa/NuIuUUIYUlfrMZSYauI36bnB
         tElg==
X-Gm-Message-State: AOAM531nzJQ9V/uO6gJibfjbJMMBzEaF3Es4LT2a7KcQ8awmXvpXO6iH
        LhU7f7czRCCBPEE5D2AhmOg=
X-Google-Smtp-Source: ABdhPJxQqGX8kuHhJzN+8PQryU0wwT/0jPEfMR0AjotmoYG5i9API1mKERKHS58Y2r+Oh+9MSuvRmA==
X-Received: by 2002:a17:90a:a88e:: with SMTP id h14mr24345661pjq.41.1636621639398;
        Thu, 11 Nov 2021 01:07:19 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id v16sm1722731pgo.71.2021.11.11.01.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 01:07:19 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: luo.penghao@zte.com.cn
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] e1000e: Remove useless variables
Date:   Thu, 11 Nov 2021 09:07:12 +0000
Message-Id: <20211111090712.158901-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: luo penghao <luo.penghao@zte.com.cn>

This variable is not used in the function.

The clang_analyzer complains as follows:

drivers/net/ethernet/intel/e1000e/netdev.c:916:19 warning
drivers/net/ethernet/intel/e1000e/netdev.c:1310:19 warning

Value stored to 'hw' during its initialization is never read

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index ebcb2a3..8a79681 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -914,7 +914,6 @@ static bool e1000_clean_rx_irq(struct e1000_ring *rx_ring, int *work_done,
 	struct e1000_adapter *adapter = rx_ring->adapter;
 	struct net_device *netdev = adapter->netdev;
 	struct pci_dev *pdev = adapter->pdev;
-	struct e1000_hw *hw = &adapter->hw;
 	union e1000_rx_desc_extended *rx_desc, *next_rxd;
 	struct e1000_buffer *buffer_info, *next_buffer;
 	u32 length, staterr;
@@ -1308,7 +1307,6 @@ static bool e1000_clean_rx_irq_ps(struct e1000_ring *rx_ring, int *work_done,
 				  int work_to_do)
 {
 	struct e1000_adapter *adapter = rx_ring->adapter;
-	struct e1000_hw *hw = &adapter->hw;
 	union e1000_rx_desc_packet_split *rx_desc, *next_rxd;
 	struct net_device *netdev = adapter->netdev;
 	struct pci_dev *pdev = adapter->pdev;
-- 
2.15.2


