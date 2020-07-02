Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750F5211765
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 02:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgGBAsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 20:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbgGBAsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 20:48:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1833CC08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 17:48:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BCB3E14E52845;
        Wed,  1 Jul 2020 17:48:12 -0700 (PDT)
Date:   Wed, 01 Jul 2020 17:48:11 -0700 (PDT)
Message-Id: <20200701.174811.1709600582793325645.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net-next 0/2] mptcp: add receive buffer auto-tuning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200630192445.18333-1-fw@strlen.de>
References: <20200630192445.18333-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 17:48:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Tue, 30 Jun 2020 21:24:43 +0200

> First patch extends the test script to allow for reproducible results.
> Second patch adds receive auto-tuning.  Its based on what TCP is doing,
> only difference is that we use the largest RTT of any of the subflows
> and that we will update all subflows with the new value.
> 
> Else, we get spurious packet drops because the mptcp work queue might
> not be able to move packets from subflow socket to master socket
> fast enough.  Without the adjustment, TCP may drop the packets because
> the subflow socket is over its rcvbuffer limit.

Series applied, thanks Florian.
