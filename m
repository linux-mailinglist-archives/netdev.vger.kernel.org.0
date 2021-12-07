Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B259446BE13
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238186AbhLGOuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:50:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47642 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238192AbhLGOuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 09:50:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DAA6B817EB;
        Tue,  7 Dec 2021 14:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D30C341C8;
        Tue,  7 Dec 2021 14:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638888388;
        bh=/HDJF3gWZSfW6o+OZuu99jpPVn8cK4i2nf6FoOUbTxM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EeusCp48Gk375XhLK6HOShNAaNpMwlDhUQp7iOCwJIgCPcXVI5mENIdcbolrKwDYk
         9fE79z0n9kC5vVZKp+zf+iDOwuNpvj1cktBeNQw+fyZxjDksmWKFDXI5N9rAr2NGpy
         za+5qz+/5ejxtvP3teSw4pDtMFH8xng4Q7eO0ziFXwHZtB9oYZMTCZq7fCMIeEyieo
         Wvf9W+UD06uCq12MtQXzr/M6XPJS7DY+DUBYZm2NiVlwW4xVou8VbJNXxWjMeoZvSd
         DzUp1G2/WTqd15GTDwK/vX/23ak+3UjdopLvGFYJ+Y/Tt4n3bA9E1hGMG2b+IZwFcE
         /WDS9J+blHjtw==
Date:   Tue, 7 Dec 2021 06:46:27 -0800
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
Message-ID: <20211207064627.5623f3bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211207064345.2c6427a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211207015505.16746-1-biao.huang@mediatek.com>
        <20211207064345.2c6427a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Dec 2021 06:43:45 -0800 Jakub Kicinski wrote:
> On Tue, 7 Dec 2021 09:54:58 +0800 Biao Huang wrote:
> > Changes in v5:
> > 1. remove useless inclusion in dwmac-mediatek.c as Angelo's comments.
> > 2. add acked-by in "net-next: stmmac: dwmac-mediatek: add support for
> >    mt8195" patch  
> 
> Which tree is this series based on? It doesn't seem to apply to
> net-next. Also the net-next in the subjects is misplaced. If the series
> is supposed to be merged to net-next the subject should be like:
> 
> [PATCH net-next v5 1/7] stmmac: dwmac-mediatek: add platform level clocks management
> 
> You can use --subject-prefix="PATCH net-next v6" in git-format-patch to
> add the prefix.

FWIW patch 6 is the one with the conflict: "arm64: dts: mt8195: add
ethernet device node"
