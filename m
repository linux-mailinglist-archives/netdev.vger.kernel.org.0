Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E84977BE3
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 22:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388313AbfG0Uwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 16:52:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40096 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388075AbfG0Uwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 16:52:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9F9361534D12A;
        Sat, 27 Jul 2019 13:52:39 -0700 (PDT)
Date:   Sat, 27 Jul 2019 13:52:39 -0700 (PDT)
Message-Id: <20190727.135239.1789409094437500386.davem@davemloft.net>
To:     thierry.reding@gmail.com
Cc:     joabreu@synopsys.com, alexandre.torgue@st.com,
        peppe.cavallaro@st.com, jonathanh@nvidia.com,
        netdev@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 1/2] net: stmmac: Make MDIO bus reset optional
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190726102741.27872-1-thierry.reding@gmail.com>
References: <20190726102741.27872-1-thierry.reding@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 13:52:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <thierry.reding@gmail.com>
Date: Fri, 26 Jul 2019 12:27:40 +0200

> From: Thierry Reding <treding@nvidia.com>
> 
> The Tegra EQOS driver already resets the MDIO bus at probe time via the
> reset GPIO specified in the phy-reset-gpios device tree property. There
> is no need to reset the bus again later on.
> 
> This avoids the need to query the device tree for the snps,reset GPIO,
> which is not part of the Tegra EQOS device tree bindings. This quiesces
> an error message from the generic bus reset code if it doesn't find the
> snps,reset related delays.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Applied.
