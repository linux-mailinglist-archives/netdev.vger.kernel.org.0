Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D1E629C8
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731596AbfGHTl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:41:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57240 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729851AbfGHTl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:41:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 29EF5133E9BDB;
        Mon,  8 Jul 2019 12:41:26 -0700 (PDT)
Date:   Mon, 08 Jul 2019 12:41:25 -0700 (PDT)
Message-Id: <20190708.124125.1938757647213542470.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        ben@decadent.org.uk
Subject: Re: [PATCH net] net: stmmac: Re-work the queue selection for TSO
 packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <36018491f47206728e04d67a9e6263635e64f721.1562588640.git.joabreu@synopsys.com>
References: <36018491f47206728e04d67a9e6263635e64f721.1562588640.git.joabreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 12:41:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Mon,  8 Jul 2019 14:26:28 +0200

> Ben Hutchings says:
> 	"This is the wrong place to change the queue mapping.
> 	stmmac_xmit() is called with a specific TX queue locked,
> 	and accessing a different TX queue results in a data race
> 	for all of that queue's state.
> 
> 	I think this commit should be reverted upstream and in all
> 	stable branches.  Instead, the driver should implement the
> 	ndo_select_queue operation and override the queue mapping there."
> 
> Fixes: c5acdbee22a1 ("net: stmmac: Send TSO packets always from Queue 0")
> Suggested-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>

Applied and queued up for -stable.
