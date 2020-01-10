Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9ED13656B
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 03:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730915AbgAJCfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 21:35:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60740 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730764AbgAJCfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 21:35:53 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0BE1F1573658A;
        Thu,  9 Jan 2020 18:35:53 -0800 (PST)
Date:   Thu, 09 Jan 2020 18:35:52 -0800 (PST)
Message-Id: <20200109.183552.1973904363091394974.davem@davemloft.net>
To:     sergei.shtylyov@cogentembedded.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH net] sh_eth: check sh_eth_cpu_data::dual_port when
 dumping registers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5f03e777-6838-f70d-31bc-2046d253c11a@cogentembedded.com>
References: <5f03e777-6838-f70d-31bc-2046d253c11a@cogentembedded.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jan 2020 18:35:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Wed, 8 Jan 2020 23:42:42 +0300

> When adding the sh_eth_cpu_data::dual_port flag I forgot to add the flag
> checks to __sh_eth_get_regs(), causing the non-existing TSU registers to
> be dumped by 'ethtool' on the single port Ether controllers having TSU...
> 
> Fixes: a94cf2a614f8 ("sh_eth: fix TSU init on SH7734/R8A7740")
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

Applied, thanks.
