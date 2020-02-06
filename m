Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 002E71544EC
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 14:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgBFNc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 08:32:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59606 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgBFNc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 08:32:58 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A9E3E14CCC9A7;
        Thu,  6 Feb 2020 05:32:55 -0800 (PST)
Date:   Thu, 06 Feb 2020 14:32:54 +0100 (CET)
Message-Id: <20200206.143254.1285608674662555598.davem@davemloft.net>
To:     zhengdejin5@gmail.com
Cc:     vkoul@kernel.org, peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: fix a possible endless loop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200206132147.22874-1-zhengdejin5@gmail.com>
References: <20200206132147.22874-1-zhengdejin5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Feb 2020 05:32:57 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>
Date: Thu,  6 Feb 2020 21:21:47 +0800

> It forgot to reduce the value of the variable retry in a while loop
> in the ethqos_configure() function. It may cause an endless loop and
> without timeout.
> 
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>

Please resubmit this with an appropriate Fixes: tag.

Thank you.
