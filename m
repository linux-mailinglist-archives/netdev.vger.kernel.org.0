Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44D11FA0E0
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 22:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730845AbgFOUBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 16:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728773AbgFOUBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 16:01:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7745DC061A0E;
        Mon, 15 Jun 2020 13:01:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6E93D120ED49A;
        Mon, 15 Jun 2020 13:01:39 -0700 (PDT)
Date:   Mon, 15 Jun 2020 13:01:38 -0700 (PDT)
Message-Id: <20200615.130138.1884447953526283666.davem@davemloft.net>
To:     geliangtang@gmail.com
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        kuba@kernel.org, netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] mptcp: drop MPTCP_PM_MAX_ADDR
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8d8984e8f73e37c87e69459fdef12fe9bab80949.1592209282.git.geliangtang@gmail.com>
References: <8d8984e8f73e37c87e69459fdef12fe9bab80949.1592209282.git.geliangtang@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 13:01:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>
Date: Mon, 15 Jun 2020 16:28:03 +0800

> We have defined MPTCP_PM_ADDR_MAX in pm_netlink.c, so drop this duplicate macro.
> 
> Fixes: 1b1c7a0ef7f3 ("mptcp: Add path manager interface")
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
>  Changes in v2:
>   - change Subject from "mptcp: unify MPTCP_PM_MAX_ADDR and MPTCP_PM_ADDR_MAX"

Applied, thank you.
