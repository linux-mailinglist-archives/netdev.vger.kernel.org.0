Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB2823CFE4
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgHET0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728874AbgHET0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 15:26:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD5EC061575
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 12:26:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7A78B152F10CE;
        Wed,  5 Aug 2020 12:09:22 -0700 (PDT)
Date:   Wed, 05 Aug 2020 12:26:07 -0700 (PDT)
Message-Id: <20200805.122607.752014846797470762.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, willemb@google.com,
        colin.king@canonical.com
Subject: Re: [PATCH net] selftests/net: relax cpu affinity requirement in
 msg_zerocopy test
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200805084045.1549492-1-willemdebruijn.kernel@gmail.com>
References: <20200805084045.1549492-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Aug 2020 12:09:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Wed,  5 Aug 2020 04:40:45 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> The msg_zerocopy test pins the sender and receiver threads to separate
> cores to reduce variance between runs.
> 
> But it hardcodes the cores and skips core 0, so it fails on machines
> with the selected cores offline, or simply fewer cores.
> 
> The test mainly gives code coverage in automated runs. The throughput
> of zerocopy ('-z') and non-zerocopy runs is logged for manual
> inspection.
> 
> Continue even when sched_setaffinity fails. Just log to warn anyone
> interpreting the data.
> 
> Fixes: 07b65c5b31ce ("test: add msg_zerocopy test")
> Reported-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied and queued up for -stable, thanks.
