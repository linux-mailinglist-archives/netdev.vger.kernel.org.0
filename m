Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82F42186786
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 10:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbgCPJK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 05:10:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41408 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730110AbgCPJK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 05:10:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D89EA14706AC7;
        Mon, 16 Mar 2020 02:10:27 -0700 (PDT)
Date:   Mon, 16 Mar 2020 02:10:27 -0700 (PDT)
Message-Id: <20200316.021027.1748414593839565698.davem@davemloft.net>
To:     zhengdejin5@gmail.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        andrew@lunn.ch, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/2] net: stmmac: Use readl_poll_timeout()
 to simplify the code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200316023254.13201-1-zhengdejin5@gmail.com>
References: <20200316023254.13201-1-zhengdejin5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 02:10:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>
Date: Mon, 16 Mar 2020 10:32:52 +0800

> This patch sets just for replace the open-coded loop to the
> readl_poll_timeout() helper macro for simplify the code in
> stmmac driver.
> 
> v2 -> v3:
> 	- return whatever error code by readl_poll_timeout() returned.
> v1 -> v2:
> 	- no changed. I am a newbie and sent this patch a month
> 	  ago (February 6th). So far, I have not received any comments or
> 	  suggestion. I think it may be lost somewhere in the world, so
> 	  resend it.

Looks good, series applied, thank you.
