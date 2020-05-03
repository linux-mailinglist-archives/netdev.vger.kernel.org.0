Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5731C3033
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 00:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgECWwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 18:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726661AbgECWwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 18:52:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A030AC061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 15:52:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5CDD81211C987;
        Sun,  3 May 2020 15:52:53 -0700 (PDT)
Date:   Sun, 03 May 2020 15:52:52 -0700 (PDT)
Message-Id: <20200503.155252.496222877536231675.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] net_sched: sch_skbprio: add message validation to
 skbprio_change()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200503030925.33060-1-edumazet@google.com>
References: <20200503030925.33060-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 03 May 2020 15:52:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sat,  2 May 2020 20:09:25 -0700

> Do not assume the attribute has the right size.
> 
> Fixes: aea5f654e6b7 ("net/sched: add skbprio scheduler")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks Eric.
