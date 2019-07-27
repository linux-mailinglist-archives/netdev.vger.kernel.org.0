Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF4A77BE5
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 22:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388341AbfG0Uws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 16:52:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40110 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387841AbfG0Uws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 16:52:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B24B41534D12A;
        Sat, 27 Jul 2019 13:52:47 -0700 (PDT)
Date:   Sat, 27 Jul 2019 13:52:45 -0700 (PDT)
Message-Id: <20190727.135245.191991967753814130.davem@davemloft.net>
To:     thierry.reding@gmail.com
Cc:     joabreu@synopsys.com, alexandre.torgue@st.com,
        peppe.cavallaro@st.com, jonathanh@nvidia.com,
        netdev@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 2/2] net: stmmac: Do not request stmmaceth
 clock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190726102741.27872-2-thierry.reding@gmail.com>
References: <20190726102741.27872-1-thierry.reding@gmail.com>
        <20190726102741.27872-2-thierry.reding@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 13:52:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <thierry.reding@gmail.com>
Date: Fri, 26 Jul 2019 12:27:41 +0200

> From: Thierry Reding <treding@nvidia.com>
> 
> The stmmaceth clock is specified by the slave_bus and apb_pclk clocks in
> the device tree bindings for snps,dwc-qos-ethernet-4.10 compatible nodes
> of this IP.
> 
> The subdrivers for these bindings will be requesting the stmmac clock
> correctly at a later point, so there is no need to request it here and
> cause an error message to be printed to the kernel log.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Applied.
