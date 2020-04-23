Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDAE1B66E8
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 00:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgDWWih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 18:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgDWWig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 18:38:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C43C09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 15:38:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0378E127DB805;
        Thu, 23 Apr 2020 15:38:33 -0700 (PDT)
Date:   Thu, 23 Apr 2020 15:38:32 -0700 (PDT)
Message-Id: <20200423.153832.2215576235773303096.davem@davemloft.net>
To:     tsu.yubo@gmail.com
Cc:     matthieu.baerts@tessares.net, kuba@kernel.org, pabeni@redhat.com,
        mathew.j.martineau@linux.intel.com, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: Re: [PATCH V3 -next] mptcp/pm_netlink.c : add check for
 nla_put_in/6_addr
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200423020957.g5ovpymbbp4nykbr@debian.debian-2>
References: <20200423020957.g5ovpymbbp4nykbr@debian.debian-2>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Apr 2020 15:38:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bo YU <tsu.yubo@gmail.com>
Date: Thu, 23 Apr 2020 10:10:03 +0800

> Normal there should be checked for nla_put_in6_addr like other
> usage in net.
> 
> Detected by CoverityScan, CID# 1461639
> 
> Fixes: 01cacb00b35c("mptcp: add netlink-based PM")
> Signed-off-by: Bo YU <tsu.yubo@gmail.com>
> ---
> V3: fix code style, thanks for Paolo
> 
> V2: Add check for nla_put_in_addr suggested by Paolo Abeni

Applied, thank you.
