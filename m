Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0C3204874
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 06:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732147AbgFWEH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 00:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgFWEH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 00:07:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E540DC061573;
        Mon, 22 Jun 2020 21:07:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CEEA1120F9409;
        Mon, 22 Jun 2020 21:07:24 -0700 (PDT)
Date:   Mon, 22 Jun 2020 21:07:24 -0700 (PDT)
Message-Id: <20200622.210724.1974696285872270248.davem@davemloft.net>
To:     geliangtang@gmail.com
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        kuba@kernel.org, netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] mptcp: drop sndr_key in mptcp_syn_options
From:   David Miller <davem@davemloft.net>
In-Reply-To: <60f8315d6ae7b62d175c573f75cee50f14ce988b.1592826171.git.geliangtang@gmail.com>
References: <60f8315d6ae7b62d175c573f75cee50f14ce988b.1592826171.git.geliangtang@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 21:07:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>
Date: Mon, 22 Jun 2020 19:45:58 +0800

> In RFC 8684, we don't need to send sndr_key in SYN package anymore, so drop
> it.
> 
> Fixes: cc7972ea1932 ("mptcp: parse and emit MP_CAPABLE option according to v1 spec")
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Applied and queued up for v5.6+ -stable, thanks.
