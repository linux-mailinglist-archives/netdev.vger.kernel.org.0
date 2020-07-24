Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2B022D1B7
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 00:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgGXWSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 18:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgGXWSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 18:18:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26065C0619D3;
        Fri, 24 Jul 2020 15:18:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9A9F01195421E;
        Fri, 24 Jul 2020 15:02:08 -0700 (PDT)
Date:   Fri, 24 Jul 2020 15:18:53 -0700 (PDT)
Message-Id: <20200724.151853.1338329532264832068.davem@davemloft.net>
To:     chisong@linux.microsoft.com
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, kuba@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 net-next] net: hyperv: dump TX indirection table to
 ethtool regs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200724041426.GB25409@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <alpine.LRH.2.23.451.2007222356070.2641@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
        <20200724041426.GB25409@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 15:02:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chi Song <chisong@linux.microsoft.com>
Date: Thu, 23 Jul 2020 21:14:26 -0700

> An imbalanced TX indirection table causes netvsc to have low
> performance. This table is created and managed during runtime. To help
> better diagnose performance issues caused by imbalanced tables, it needs
> make TX indirection tables visible.
> 
> Because TX indirection table is driver specified information, so
> display it via ethtool register dump.
> 
> Signed-off-by: Chi Song <chisong@microsoft.com>

Applied, thank you.
