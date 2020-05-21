Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C901DC603
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 06:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgEUEAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 00:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgEUEAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 00:00:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D328C061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 21:00:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0CD2D11917F9D;
        Wed, 20 May 2020 21:00:13 -0700 (PDT)
Date:   Wed, 20 May 2020 21:00:12 -0700 (PDT)
Message-Id: <20200520.210012.1620040824637283139.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] ax24: fix setsockopt(SO_BINDTODEVICE)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200520012443.31913-1-edumazet@google.com>
References: <20200520012443.31913-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 May 2020 21:00:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 19 May 2020 18:24:43 -0700

> syzbot was able to trigger this trace [1], probably by using
> a zero optlen.
> 
> While we are at it, cap optlen to IFNAMSIZ - 1 instead of IFNAMSIZ.
> 
> [1]
 ...
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable with s/ax24/ax25/, thanks.
