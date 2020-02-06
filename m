Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22E1A1546BF
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 15:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgBFOvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 09:51:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60342 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727178AbgBFOvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 09:51:22 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ADC3514E226FC;
        Thu,  6 Feb 2020 06:51:20 -0800 (PST)
Date:   Thu, 06 Feb 2020 15:51:19 +0100 (CET)
Message-Id: <20200206.155119.1859518790111659504.davem@davemloft.net>
To:     zhengdejin5@gmail.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] use readl_poll_timeout() function
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200206142404.24980-1-zhengdejin5@gmail.com>
References: <20200206142404.24980-1-zhengdejin5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Feb 2020 06:51:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>
Date: Thu,  6 Feb 2020 22:24:02 +0800

> This patch series just for use readl_poll_timeout() function
> to replace the open coded handling of use readl_poll_timeout()
> in the stmmac driver. There are two modification positions,
> the one in the init_systime() function and the other in the
> dwmac4_dma_reset() function.

This is a cleanup and thus appropriate only for net-next, which
is closed right now.

When you submit networking patches you must indicate the tree
you are targetting in the Subject line, for example:

	Subject: [PATCH net-next 0/2] ...

Thank you.
