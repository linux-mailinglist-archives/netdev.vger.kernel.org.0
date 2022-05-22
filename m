Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855AA5305DB
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 22:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240992AbiEVUcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 16:32:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51472 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbiEVUcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 16:32:16 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id D5072841F18A;
        Sun, 22 May 2022 13:32:13 -0700 (PDT)
Date:   Sun, 22 May 2022 21:32:05 +0100 (BST)
Message-Id: <20220522.213205.93451349395812405.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        jaltman@auristor.com, marc.dionne@auristor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/5] rxrpc: Miscellaneous fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <165312017819.246773.14440495192028707532.stgit@warthog.procyon.org.uk>
References: <165312017819.246773.14440495192028707532.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Sun, 22 May 2022 13:32:15 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Sat, 21 May 2022 09:02:58 +0100

> 
> Here are some fixes for AF_RXRPC:
> 
>  (1) Fix listen() allowing preallocation to overrun the prealloc buffer.
> 
>  (2) Prevent resending the request if we've seen the reply starting to
>      arrive.
> 
>  (3) Fix accidental sharing of ACK state between transmission and
>      reception.
> 
>  (4) Ignore ACKs in which ack.previousPacket regresses.  This indicates the
>      highest DATA number so far seen, so should not be seen to go
>      backwards.
> 
>  (5) Fix the determination of when to generate an IDLE-type ACK,
>      simplifying it so that we generate one if we have more than two DATA
>      packets that aren't hard-acked (consumed) or soft-acked (in the rx
>      buffer, but could be discarded and re-requested).
> 
> The patches are tagged here:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
> 	rxrpc-fixes-20220521
> 
> and can also be found on the following branch:
> 
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

I tried to pull from this url and it does not work, just fyi...

So I applied the series instead.

> Tested-by: kafs-testing+fedora34_64checkkafs-build-495@auristor.com

Thank you.
