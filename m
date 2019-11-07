Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D1DF3C27
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbfKGX0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:26:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49920 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727480AbfKGX0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:26:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 47C9015371C3C;
        Thu,  7 Nov 2019 15:26:41 -0800 (PST)
Date:   Thu, 07 Nov 2019 15:26:40 -0800 (PST)
Message-Id: <20191107.152640.1457462659040029467.davem@davemloft.net>
To:     christophe.roullier@st.com
Cc:     robh@kernel.org, joabreu@synopsys.com, mark.rutland@arm.com,
        mcoquelin.stm32@gmail.com, alexandre.torgue@st.com,
        peppe.cavallaro@st.com, linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        andrew@lunn.ch
Subject: Re: [PATCH V4 net-next 0/4] net: ethernet: stmmac: cleanup clock
 and optimization
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107084757.17910-1-christophe.roullier@st.com>
References: <20191107084757.17910-1-christophe.roullier@st.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 15:26:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe Roullier <christophe.roullier@st.com>
Date: Thu, 7 Nov 2019 09:47:53 +0100

> Some improvements: 
>  - manage syscfg as optional clock, 
>  - update slew rate of ETH_MDIO pin, 
>  - Enable gating of the MAC TX clock during TX low-power mode
> 
> V4: Update with Andrew Lunn remark

This is mostly ARM DT updates, which tree should this go through?

I don't want to step on toes this time :-)
