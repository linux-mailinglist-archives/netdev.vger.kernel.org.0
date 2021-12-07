Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4BE46BE08
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238153AbhLGOrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbhLGOrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 09:47:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1187C061574;
        Tue,  7 Dec 2021 06:43:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 19EF4CE1B19;
        Tue,  7 Dec 2021 14:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E8CC341C1;
        Tue,  7 Dec 2021 14:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638888226;
        bh=5MrplqICp5ANCWUEGpUqpG9gDk7l+o1aiuGOgg7OwLM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MNgEtovjWw1rD8htPyN6EHRDRcWb11cI/DCkMpYfFiiMgpppPLre1wTb0FR4a9rAh
         QPgPplm1d1YAA9ZSspKTf3WI5aNuBmqMz5fZK2WsUgqMqNUPWz4vnX2CveZMDQzP0K
         ZjeA72R/viKPgd7+kTan4fK0xUQfR1rG4QxY0zGKFJKeZzqaPV22qaElgEemaEjqv1
         OaZIzech2Ujzn6pEuR0EwSDcjobwOWJkiIYskAZm0YpWsZyzcntB1xJgiwfg2nA0Wh
         WHiIyqnsY+ODFMdJ7cazVOG4hQY6gkYTEm9t6jYXHRIf5rhXfujWbzD9kKUHlMyEO4
         Nnonhwe4p1bSQ==
Date:   Tue, 7 Dec 2021 06:43:45 -0800
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
Subject: Re: [PATCH v5 0/7] MediaTek Ethernet Patches on MT8195
Message-ID: <20211207064345.2c6427a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211207015505.16746-1-biao.huang@mediatek.com>
References: <20211207015505.16746-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Dec 2021 09:54:58 +0800 Biao Huang wrote:
> Changes in v5:
> 1. remove useless inclusion in dwmac-mediatek.c as Angelo's comments.
> 2. add acked-by in "net-next: stmmac: dwmac-mediatek: add support for
>    mt8195" patch

Which tree is this series based on? It doesn't seem to apply to
net-next. Also the net-next in the subjects is misplaced. If the series
is supposed to be merged to net-next the subject should be like:

[PATCH net-next v5 1/7] stmmac: dwmac-mediatek: add platform level clocks management

You can use --subject-prefix="PATCH net-next v6" in git-format-patch to
add the prefix.
