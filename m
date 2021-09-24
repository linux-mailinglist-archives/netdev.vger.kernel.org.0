Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1A5416E9B
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 11:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245146AbhIXJL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 05:11:58 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:51958 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S244764AbhIXJL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 05:11:57 -0400
X-UUID: bfe5af9379c04e3b88048a443c2c8f27-20210924
X-UUID: bfe5af9379c04e3b88048a443c2c8f27-20210924
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 454771349; Fri, 24 Sep 2021 17:10:21 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Fri, 24 Sep 2021 17:10:20 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Sep 2021 17:10:20 +0800
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Petr Oros <poros@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Jose Abreu" <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Miles Chen <miles.chen@mediatek.com>,
        Bear Wang <bear.wang@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>,
        Fabien Parent <fparent@baylibre.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>,
        <linux-mediatek@lists.infradead.org>
Subject: backport commit ("e96bd2d3b1f8 phy: avoid unnecessary link-up delay in polling mode") to linux-5.4-stable
Date:   Fri, 24 Sep 2021 17:10:20 +0800
Message-ID: <20210924091020.32695-1-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi reviewers,

I suggest to backport 
commit "e96bd2d3b1f8 phy: avoid unnecessary link-up delay in polling mode"
to linux-5.4 stable tree.

This patch reports a solution to an incorrect phy link detection issue.
"With this solution we don't miss a link-down event in polling mode and
link-up is faster."

commit: e96bd2d3b1f83170d1d5c1a99e439b39a22a5b58
subject: phy: avoid unnecessary link-up delay in polling mode
kernel version to apply to: Linux-5.4

Thanks.
Macpaul Lin
