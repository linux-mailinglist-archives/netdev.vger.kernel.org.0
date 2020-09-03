Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E601825C91D
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 21:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgICTLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 15:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgICTLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 15:11:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353F6C061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 12:11:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 796A115C8687B;
        Thu,  3 Sep 2020 11:54:27 -0700 (PDT)
Date:   Thu, 03 Sep 2020 12:11:13 -0700 (PDT)
Message-Id: <20200903.121113.1765709206599358636.davem@davemloft.net>
To:     w@uter.be
Cc:     penguin-kernel@i-love.sakura.ne.jp,
        syzbot+e36f41d207137b5d12f7@syzkaller.appspotmail.com,
        jmaloy@redhat.com, ying.xue@windriver.com,
        syzkaller-bugs@googlegroups.com, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH] tipc: fix shutdown() of connectionless socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200903120515.GC8553@pc181009.grep.be>
References: <20200903113141.GB8553@pc181009.grep.be>
        <74538f06-1f88-c484-7908-a16e5cac7614@i-love.sakura.ne.jp>
        <20200903120515.GC8553@pc181009.grep.be>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 03 Sep 2020 11:54:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wouter Verhelst <w@uter.be>
Date: Thu, 3 Sep 2020 14:05:15 +0200

> That's fine, because NBD doesn't deal with SOCK_DGRAM sockets anyway
> (i.e., passing a SOCK_DGRAM socket to the NBD device is undefined
> behavior).

Then why doesn't NBD simply reject such sockets?

