Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEC841AA06
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 09:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239418AbhI1Hpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 03:45:33 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:51304 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S239369AbhI1Hpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 03:45:32 -0400
X-UUID: 83cac08256f941a6bd1d3a154a0a2aa2-20210928
X-UUID: 83cac08256f941a6bd1d3a154a0a2aa2-20210928
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1761110263; Tue, 28 Sep 2021 15:43:50 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Tue, 28 Sep 2021 15:43:49 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by mtkcas07.mediatek.inc
 (172.21.101.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 28 Sep
 2021 15:43:49 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 28 Sep 2021 15:43:49 +0800
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Leon Yu <leoyu@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Fabien Parent <fparent@baylibre.com>
CC:     Miles Chen <miles.chen@mediatek.com>,
        Bear Wang <bear.wang@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>,
        <linux-mediatek@lists.infradead.org>, <stable@vger.kernel.org>
Subject: backport commit ("31096c3e8b11 net: stmmac: don't attach interface until resume finishes") to linux-5.4-stable
Date:   Tue, 28 Sep 2021 15:43:49 +0800
Message-ID: <20210928074349.24622-1-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20210927104500.1505-1-macpaul.lin@mediatek.com>
References: <20210927104500.1505-1-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi reviewers,

I suggest to backport 
commit "31096c3e8b11 net: stmmac: don't attach interface until resume finishes"
to linux-5.4 stable tree.

This patch fix resume issue by deferring netif_device_attach().

However, the patch cannot be cherry-pick directly on to stable-5.4.
A slightly change to the origin patch is required.
I'd like to provide the modification to stable-5.4 if it is needed.

commit: 31096c3e8b1163c6e966bf4d1f36d8b699008f84
subject: net: stmmac: don't attach interface until resume finishes
kernel version to apply to: Linux-5.4

Sorry for that I've send a wrong commit hash which is in my working tree
previously.

Thanks.
Macpaul Lin
