Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A97735E448
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238016AbhDMQn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:43:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232225AbhDMQn0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 12:43:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9620161220;
        Tue, 13 Apr 2021 16:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618332187;
        bh=QntS6MZwyM28FnKNkD/ozfcWOoLMRW7u7VvAEFp3aIo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XJTzOvqgnzMYjpdP8e9cHhqvLOcKnDT5nJ7yduhJ0VUEZAvB+2QObDqzTunoa+AES
         gaJ88RO4dC4+VZEwaHH1C1n4I/iPTpv3wOyvmY6PA4KQ12TLbCX371eiG3keMKCpXT
         Bg/InHsYEpoWNBy4MBGtHKled6lGh6dro53yfad2NiyRYaJACdNtLm/Cx32tpc9hBM
         DDmCvlQpbvs0bcRHq4lFpMi8SIgBypIJh87fWc65d/BHgV716LvsoVHNcjgPkAVeMP
         HlCdYU/YlGrM+2+KmeUX6WWRdf4e8JPwTifNyLbsRQnzPlvuY21PKKyLvy6fpEF8o6
         c1WEuIbO7fKWg==
Date:   Tue, 13 Apr 2021 09:43:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
Message-ID: <20210413094305.008854c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YHXBj3rsEjf8Y+qn@orome.fritz.box>
References: <8e92b562-fa8f-0a2b-d8da-525ee52fc2d4@nvidia.com>
        <DB8PR04MB67959FC7AF5CFCF1A08D10B2E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
        <ac9f8a31-536e-ec75-c73f-14a0623c5d56@nvidia.com>
        <DB8PR04MB6795F4333BCA9CE83C288FEEE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
        <DB8PR04MB6795D4C733DC4938B1D62EBDE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
        <85f02fbc-6956-2b19-1779-cd51b2e71e3d@nvidia.com>
        <DB8PR04MB6795ECCB5E6E2091A45DADAEE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
        <563db756-ebef-6c8b-ce7c-9dcadaecfea1@nvidia.com>
        <e4864046-e52f-63b6-a490-74c3cd8045f4@nvidia.com>
        <DB8PR04MB6795C779FD47D5712DAE11CDE64F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
        <YHXBj3rsEjf8Y+qn@orome.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Apr 2021 18:06:39 +0200 Thierry Reding wrote:
> given where we are in the release cycle, I think it'd be best to revert
> commit 9c63faaa931e ("net: stmmac: re-init rx buffers when mac resume
> back") for now.
> 
> To summarize the discussion: the patch was meant as a workaround to fix
> an occasional suspend/resume failure on one board that was not fully
> root caused, and ends up causing fully reproducible suspend/resume
> failures on at least one other board.
> 
> Joakim is looking at an alternative solution and Jon and I can provide
> testing from the Tegra side for any fixes.
> 
> Do you want me to send a revert patch or can you revert directly on top
> of your tree?

Please send a revert with the justification in the commit log, and 
perhaps also:

Link: https://lore.kernel.org/r/708edb92-a5df-ecc4-3126-5ab36707e275@nvidia.com/

for those who want to dig deeper in the history. Make sure you 
CC relevant folks so they can review and express their opinions.

Thanks!
