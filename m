Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B77BDB789
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 21:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393743AbfJQTbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 15:31:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41016 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387844AbfJQTbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 15:31:52 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8CD2614049CCB;
        Thu, 17 Oct 2019 12:31:51 -0700 (PDT)
Date:   Thu, 17 Oct 2019 15:31:50 -0400 (EDT)
Message-Id: <20191017.153150.1433354673381849692.davem@davemloft.net>
To:     ben.dooks@codethink.co.uk
Cc:     linux-kernel@lists.codethink.co.uk, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: fix argument to stmmac_pcs_ctrl_ane()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191016082205.26899-1-ben.dooks@codethink.co.uk>
References: <20191016082205.26899-1-ben.dooks@codethink.co.uk>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 12:31:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
Date: Wed, 16 Oct 2019 09:22:05 +0100

> The stmmac_pcs_ctrl_ane() expects a register address as
> argument 1, but for some reason the mac_device_info is
> being passed.
> 
> Fix the warning (and possible bug) from sparse:
> 
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2613:17: warning: incorrect type in argument 1 (different address spaces)
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2613:17:    expected void [noderef] <asn:2> *ioaddr
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2613:17:    got struct mac_device_info *hw
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

Applied, thanks.
