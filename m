Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F58154510
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 14:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgBFNh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 08:37:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59670 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbgBFNh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 08:37:57 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2B0AB14CCCAD3;
        Thu,  6 Feb 2020 05:37:54 -0800 (PST)
Date:   Thu, 06 Feb 2020 14:37:53 +0100 (CET)
Message-Id: <20200206.143753.1516354381077365451.davem@davemloft.net>
To:     vkoul@kernel.org
Cc:     zhengdejin5@gmail.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: fix a possible endless loop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200206133554.GO2618@vkoul-mobl>
References: <20200206132147.22874-1-zhengdejin5@gmail.com>
        <20200206133554.GO2618@vkoul-mobl>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Feb 2020 05:37:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>
Date: Thu, 6 Feb 2020 19:05:54 +0530

> On 06-02-20, 21:21, Dejin Zheng wrote:
>> It forgot to reduce the value of the variable retry in a while loop
>> in the ethqos_configure() function. It may cause an endless loop and
>> without timeout.
> 
> Thanks for the fix.
> 
> Acked-by: Vinod Koul <vkoul@kernel.org>
> 
> We should add:
> Fixes: a7c30e62d4b8 ("net: stmmac: Add driver for Qualcomm ethqos")
> 
> Also, I think this should be CCed stable

Networking patches do not CC: stable, I queued them up myself manually.

Please read the netdev FAQ under Documentation/ for details.
