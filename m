Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9BC416F81
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 11:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245368AbhIXJvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 05:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245340AbhIXJvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 05:51:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F047461076;
        Fri, 24 Sep 2021 09:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632476984;
        bh=q3ICXikkwH5UtUHIuBaYtEaF6KNhkxjPlvfIZGiRwA8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cgH+5Q7PyPTUuMVaLzy7qMzzJGLDRCEHN356hOwH/tQ1nlMVTG6fdN9KLCnWYx2Ks
         9wyvcf2JZFPvkPsAVYM9dW0fxcV1nLQdNsRpN9XCmEcCkX3cy8aYcVauvXkoPlSKTN
         CZ78TJw4um1DP+kM6L8mj9/fxQs/3TlRdiaWDchE=
Date:   Fri, 24 Sep 2021 11:49:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Macpaul Lin <macpaul.lin@mediatek.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        stable@vger.kernel.org, Miles Chen <miles.chen@mediatek.com>,
        Bear Wang <bear.wang@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>,
        Fabien Parent <fparent@baylibre.com>,
        Macpaul Lin <macpaul@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: backport commit ("f421031e3ff0 net: stmmac: reset Tx desc base
 address before restarting") to linux-5.4-stable
Message-ID: <YU2fNiQh5or41pzT@kroah.com>
References: <20210924093719.16510-1-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924093719.16510-1-macpaul.lin@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 05:37:19PM +0800, Macpaul Lin wrote:
> Hi reviewers,
> 
> I suggest to backport 
> commit "f421031e3ff0 net: stmmac: reset Tx desc base address before
> restarting"
> to linux-5.4 stable tree.
> 
> This patch reports a register usage correction for an address
> inconsistency issue.
> "If this register is not changed when the ST bit is set to 0, then
> the DMA takes the descriptor address where it was stopped earlier."
> 
> commit: f421031e3ff0dd288a6e1bbde9aa41a25bb814e6
> subject: net: stmmac: reset Tx desc base address before restarting
> kernel version to apply to: Linux-5.4

Now queued up, thanks.

greg k-h
