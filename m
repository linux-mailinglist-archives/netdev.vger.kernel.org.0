Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44072419271
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 12:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbhI0Kqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 06:46:42 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:59568 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S233827AbhI0Kql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 06:46:41 -0400
X-UUID: 86040e8969d94873a66d43041b5bc807-20210927
X-UUID: 86040e8969d94873a66d43041b5bc807-20210927
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1256122782; Mon, 27 Sep 2021 18:45:02 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 27 Sep 2021 18:45:01 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 27 Sep 2021 18:45:00 +0800
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
        <linux-kernel@vger.kernel.org>
CC:     Miles Chen <miles.chen@mediatek.com>,
        Bear Wang <bear.wang@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>,
        Fabien Parent <fparent@baylibre.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>,
        <linux-mediatek@lists.infradead.org>, <stable@vger.kernel.org>
Subject: backport commit ("c739b17a715c net: stmmac: don't attach interface until resume finishes") to linux-5.4-stable
Date:   Mon, 27 Sep 2021 18:45:00 +0800
Message-ID: <20210927104500.1505-1-macpaul.lin@mediatek.com>
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
commit "c739b17a715c net: stmmac: don't attach interface until resume finishes"
to linux-5.4 stable tree.

This patch fix resume issue by deferring netif_device_attach().

However, the patch cannot be cherry-pick directly on to stable-5.4.
A slightly change to the origin patch is required.
I'd like to provide the modification to stable-5.4 if it is needed.

commit: c739b17a715c6a850477189fb7c5f9a6af74f4bb
subject: net: stmmac: don't attach interface until resume finishes
kernel version to apply to: Linux-5.4

Thanks.
Macpaul Lin
