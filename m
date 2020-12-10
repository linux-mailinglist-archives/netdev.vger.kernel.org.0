Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03172D4F3A
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 01:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgLJALp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 19:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgLJALo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 19:11:44 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA20FC0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 16:11:04 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 539B84D259C15;
        Wed,  9 Dec 2020 16:11:02 -0800 (PST)
Date:   Wed, 09 Dec 2020 16:10:41 -0800 (PST)
Message-Id: <20201209.161041.1128905467938677328.davem@davemloft.net>
To:     cmi@nvidia.com
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, kuba@kernel.org,
        roid@nvidia.com
Subject: Re: [PATCH net v2] net: flow_offload: Fix memory leak for indirect
 flow block
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201208024835.63253-1-cmi@nvidia.com>
References: <20201208024835.63253-1-cmi@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 16:11:02 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>
Date: Tue,  8 Dec 2020 10:48:35 +0800

> The offending commit introduces a cleanup callback that is invoked
> when the driver module is removed to clean up the tunnel device
> flow block. But it returns on the first iteration of the for loop.
> The remaining indirect flow blocks will never be freed.
> 
> Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
> CC: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Chris Mi <cmi@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> ---
> v2: - CC relevant people.
Applied, trhanks.
