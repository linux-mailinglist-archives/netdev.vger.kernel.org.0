Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7297B2D7D6
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbfE2Ial (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:30:41 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:41644 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725936AbfE2Ial (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 04:30:41 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D29C4C2638;
        Wed, 29 May 2019 08:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1559118623; bh=rInhU8MnwkeLaie1bXq7wmLepGsEHuCTeR1Qz68mYgg=;
        h=From:To:Cc:Subject:Date:From;
        b=jHTCFQW5RMWHbUMlHoAcr2S5w1r/0tv2YdVD4QXe/qefQ2yeKc0e6TLY4PxL1LOZu
         5u/sYcj8UEiU2VLy/VQzX3EPxjqUS7fFfAerqIaNeMO7tSCXwc8Jw6WehNAe0hs2Uo
         +vMPrDWUc+CXTbwo63NC+aTXa88y0REJaEwQWQOL47WaQ8jfGqm6hXTPqaoO8tzh/K
         ou5rpFLGDzmLqTTIF+ETadz0mMfwQNnyuosq38urwZ0AhvwSZr1lVo6u1ezqB3mF7B
         NmPzyKpzViN1nx1mNY6mLGhFULHMkagdlZ2nQc36hVdD4l2KB7/IVYYnk6Py1zshw1
         3urd56RihyyNA==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 3ADFDA00A0;
        Wed, 29 May 2019 08:30:40 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 3FDEC3E88A;
        Wed, 29 May 2019 10:30:39 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 0/2] net: stmmac: selftests: Two fixes
Date:   Wed, 29 May 2019 10:30:24 +0200
Message-Id: <cover.1559118521.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two fixes reported by kbuild.

Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>

Jose Abreu (2):
  net: stmmac: selftests: Fix sparse warning
  net: stmmac: selftests: Use kfree_skb() instead of kfree()

 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.7.4

