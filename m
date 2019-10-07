Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A02CE2D5
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 15:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbfJGNN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 09:13:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52530 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbfJGNN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 09:13:28 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CADFE14047968;
        Mon,  7 Oct 2019 06:13:27 -0700 (PDT)
Date:   Mon, 07 Oct 2019 15:13:26 +0200 (CEST)
Message-Id: <20191007.151326.1436550597950881500.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/6] rxrpc: Syzbot-inspired fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <157044333551.32635.10133219357337058780.stgit@warthog.procyon.org.uk>
References: <157044333551.32635.10133219357337058780.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Oct 2019 06:13:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Mon, 07 Oct 2019 11:15:35 +0100

> 
> Here's a series of patches that fix a number of issues found by syzbot:
> 
>  (1) A reference leak on rxrpc_call structs in a sendmsg error path.
> 
>  (2) A tracepoint that looked in the rxrpc_peer record after putting it.
> 
>      Analogous with this, though not presently detected, the same bug is
>      also fixed in relation to rxrpc_connection and rxrpc_call records.
> 
>  (3) Peer records don't pin local endpoint records, despite accessing them.
> 
>  (4) Access to connection crypto ops to clean up a call after the call's
>      ref on that connection has been put.
> 
> The patches are tagged here:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
> 	rxrpc-fixes-20191007

Pulled, thanks David.
