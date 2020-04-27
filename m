Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25C21BACE1
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 20:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgD0SgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 14:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726223AbgD0SgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 14:36:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4D5C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 11:36:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 418EA15D55343;
        Mon, 27 Apr 2020 11:36:15 -0700 (PDT)
Date:   Mon, 27 Apr 2020 11:36:14 -0700 (PDT)
Message-Id: <20200427.113614.2000975919126986631.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, xiyou.wangcong@gmail.com
Subject: Re: [PATCH net] sch_choke: avoid potential panic in choke_reset()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200425221951.151564-1-edumazet@google.com>
References: <20200425221951.151564-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 11:36:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sat, 25 Apr 2020 15:19:51 -0700

> If choke_init() could not allocate q->tab, we would crash later
> in choke_reset().
 ...
> Fixes: 77e62da6e60c ("sch_choke: drop all packets in queue during reset")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thank you.
