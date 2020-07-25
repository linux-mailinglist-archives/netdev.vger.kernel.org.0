Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC67A22D403
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 05:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgGYDAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 23:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgGYDAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 23:00:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEA0C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 20:00:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 42FDA1277AAA4;
        Fri, 24 Jul 2020 19:43:30 -0700 (PDT)
Date:   Fri, 24 Jul 2020 20:00:14 -0700 (PDT)
Message-Id: <20200724.200014.667890001467828475.davem@davemloft.net>
To:     subashab@codeaurora.org
Cc:     pabeni@redhat.com, stranche@codeaurora.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] dev: Defer free of skbs in flush_backlog
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595525508-1675-1-git-send-email-subashab@codeaurora.org>
References: <1595525508-1675-1-git-send-email-subashab@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 19:43:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Date: Thu, 23 Jul 2020 11:31:48 -0600

> IRQs are disabled when freeing skbs in input queue.
> Use the IRQ safe variant to free skbs here.
> 
> Fixes: 145dd5f9c88f ("net: flush the softnet backlog in process context")
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

Applied and queued up for -stable, thank you.
