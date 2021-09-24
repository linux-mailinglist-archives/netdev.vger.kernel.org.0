Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9696B416F15
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 11:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245232AbhIXJjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 05:39:00 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:57172 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S245054AbhIXJi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 05:38:59 -0400
X-UUID: 255e452eb7124b5c950a461d92c7af71-20210924
X-UUID: 255e452eb7124b5c950a461d92c7af71-20210924
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 97156409; Fri, 24 Sep 2021 17:37:21 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 24 Sep 2021 17:37:19 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Sep 2021 17:37:19 +0800
From:   Macpaul Lin <macpaul.lin@mediatek.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Miles Chen <miles.chen@mediatek.com>,
        Bear Wang <bear.wang@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>,
        Fabien Parent <fparent@baylibre.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: backport commit ("f421031e3ff0 net: stmmac: reset Tx desc base address before restarting") to linux-5.4-stable
Date:   Fri, 24 Sep 2021 17:37:19 +0800
Message-ID: <20210924093719.16510-1-macpaul.lin@mediatek.com>
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
commit "f421031e3ff0 net: stmmac: reset Tx desc base address before
restarting"
to linux-5.4 stable tree.

This patch reports a register usage correction for an address
inconsistency issue.
"If this register is not changed when the ST bit is set to 0, then
the DMA takes the descriptor address where it was stopped earlier."

commit: f421031e3ff0dd288a6e1bbde9aa41a25bb814e6
subject: net: stmmac: reset Tx desc base address before restarting
kernel version to apply to: Linux-5.4

Thanks.
Macpaul Lin
