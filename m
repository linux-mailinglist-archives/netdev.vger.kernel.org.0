Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAFB259EFA
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 21:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731147AbgIATKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 15:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgIATKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 15:10:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC60C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 12:10:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B560F13635A13;
        Tue,  1 Sep 2020 11:53:37 -0700 (PDT)
Date:   Tue, 01 Sep 2020 12:10:23 -0700 (PDT)
Message-Id: <20200901.121023.1248767379279024696.davem@davemloft.net>
To:     weiwan@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, maheshb@google.com
Subject: Re: [PATCH net-next] ip: expose inet sockopts through inet_diag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAEA6p_C-H9QxGOMiYFWdGS-=tZ0U2=1=kxTT0BYhmCbDxJW9CQ@mail.gmail.com>
References: <20200818231356.1811759-1-weiwan@google.com>
        <CAEA6p_C-H9QxGOMiYFWdGS-=tZ0U2=1=kxTT0BYhmCbDxJW9CQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 01 Sep 2020 11:53:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>
Date: Tue, 1 Sep 2020 11:19:45 -0700

> This patch was sent ~2 weeks ago (after net-next opened) and I have
> not heard any feedback on this.
> In patchwork:
> https://patchwork.ozlabs.org/project/netdev/patch/20200818231356.1811759-1-weiwan@google.com/
> The status shows "Changes Requested", which I am not sure why.
> Could you please advise?

Sorry about that, please resubmit.
