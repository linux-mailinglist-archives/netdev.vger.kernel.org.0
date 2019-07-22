Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3D56FB78
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 10:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbfGVIjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 04:39:53 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:45694 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728120AbfGVIjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 04:39:52 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id EA265C1227;
        Mon, 22 Jul 2019 08:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563784792; bh=gAQ84Z8uQYEqLwe3t0dAiOmw/qC87vcNk5Wf+7zF7eY=;
        h=From:To:Cc:Subject:Date:From;
        b=Tw0NjjLDtWP8eBnJ6Xt4QyVdruzgB9/y/J+RuQynTViyqlcHCEiVQDEA0qu2HSXEv
         YacB3+0odjiXogl/oj8vkMpzHN0Xb17sALqOGPbxvQT0NzMugg5Fq2pFUkgi0E+1C9
         ZUz3L4pKY8S7S/OuTysc5hdUycHpUFRg/T4DhZ+52yfym8VeZkes4+4sFikIrnNiya
         bee1H9EZhI8BiNJK2rnUAE+hoOwo9EhJHsxANi6lp9rJLsRJEOMjwhWzvh2BVu0aGR
         jwUq7yfvUijBi+RnXZfY6hMJ1r/LXxCeoLwsw7sUY+eVGGNY5WCZ+m843HTrUcIr2o
         0m3X94RXrr7yA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 9FD1AA0057;
        Mon, 22 Jul 2019 08:39:44 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] net: stmmac: Two fixes
Date:   Mon, 22 Jul 2019 10:39:29 +0200
Message-Id: <cover.1563784666.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two fixes targeting -net.

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---

Jose Abreu (2):
  net: stmmac: RX Descriptors need to be clean before setting buffers
  net: stmmac: Use kcalloc() instead of kmalloc_array()

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

-- 
2.7.4

