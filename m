Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4441136567
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 03:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730877AbgAJCfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 21:35:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60728 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730764AbgAJCfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 21:35:05 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1BB40157363F6;
        Thu,  9 Jan 2020 18:35:04 -0800 (PST)
Date:   Thu, 09 Jan 2020 18:35:03 -0800 (PST)
Message-Id: <20200109.183503.1012921424196803099.davem@davemloft.net>
To:     zhengdejin5@gmail.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: stmmac: pci: remove the duplicate code of set
 phy_mask
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200108135649.6091-1-zhengdejin5@gmail.com>
References: <20200108135649.6091-1-zhengdejin5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jan 2020 18:35:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>
Date: Wed,  8 Jan 2020 21:56:49 +0800

> All members of mdio_bus_data are cleared to 0 when it was obtained
> by devm_kzalloc(). so It doesn't need to set phy_mask as 0 again.
> 
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> ---
> 
> Changes since v2:
>     Abandoned the other commits, now only this one commit is
>     in the patch set.
> 
> Changes since v1:
>     adjust some commit comments.

Applied to net-next, thanks.
