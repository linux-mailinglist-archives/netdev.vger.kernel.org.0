Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E3546D5E5
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbhLHOl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:41:59 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:33546 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhLHOl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:41:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6C2E7CE2193;
        Wed,  8 Dec 2021 14:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B87CC00446;
        Wed,  8 Dec 2021 14:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638974302;
        bh=yXfh7LEnE2SBFeZnbDCRhoa2fYrDl431va9ASGoK3xc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ePG6a3u+RKIuDqJvkYwSIhSrvLzAwk4R95Pz004tE+MKwsjneRc5qYZ1ctrybVWOx
         8OvzKebSMPv5AfTSRecr9VYHmJ5hom8mKWPiK9FnmH7VfkC4ixVpbOGT5skIyoPUbQ
         6X/FaLA+Cj3RbknoaO8q1u8ejxdobhWnoj77nH8Z2V2cJmdT6K+LG0ZHWjiJDUakDu
         jDXyyJ1/5leDAVknYJWaR288T5WP0UUwWDa5HNTtHk7VyVQRNVdBZHgBBxOL/J+t8F
         j3oPmxrCA9IppRlr3Yrc5DOkm9tmQJvJY0GHT6+MYvjbAnyRUIzxrM798ub7keO9rN
         Jxz4n1SQ5XnZQ==
Date:   Wed, 8 Dec 2021 06:38:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>,
        <angelogioacchino.delregno@collabora.com>, <dkirjanov@suse.de>
Subject: Re: [PATCH net-next v7 5/6] stmmac: dwmac-mediatek: add support for
 mt8195
Message-ID: <20211208063820.264df62d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211208054716.603-6-biao.huang@mediatek.com>
References: <20211208054716.603-1-biao.huang@mediatek.com>
        <20211208054716.603-6-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 13:47:15 +0800 Biao Huang wrote:
> Add Ethernet support for MediaTek SoCs from the mt8195 family.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> Acked-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

sparse reports whole bunch of warnings like this:

drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:213:30: warning: dubious: x & !y
drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:217:30: warning: dubious: x & !y
drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:228:38: warning: dubious: x & !y
drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:232:38: warning: dubious: x & !y
drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:247:46: warning: dubious: x & !y
drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:255:46: warning: dubious: x & !y
drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:273:30: warning: dubious: x & !y
drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:277:30: warning: dubious: x & !y
drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:375:30: warning: dubious: x & !y
drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:379:30: warning: dubious: x & !y
drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:390:43: warning: dubious: x & !y
drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:397:43: warning: dubious: x & !y
drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:415:46: warning: dubious: x & !y
drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:426:46: warning: dubious: x & !y
drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:439:35: warning: dubious: x & !y
drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:443:30: warning: dubious: x & !y

Any idea on where these come from?
