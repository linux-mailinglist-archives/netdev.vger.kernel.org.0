Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6CE26975B
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgINVE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgINVE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 17:04:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4953C06174A;
        Mon, 14 Sep 2020 14:04:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD4A3127DD440;
        Mon, 14 Sep 2020 13:47:36 -0700 (PDT)
Date:   Mon, 14 Sep 2020 14:04:22 -0700 (PDT)
Message-Id: <20200914.140422.1249552994072814160.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] rxrpc: Fixes for the connection manager
 rewrite
From:   David Miller <davem@davemloft.net>
In-Reply-To: <160009744625.1014072.11957943055200732444.stgit@warthog.procyon.org.uk>
References: <160009744625.1014072.11957943055200732444.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 13:47:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Mon, 14 Sep 2020 16:30:46 +0100

> 
> Here are some fixes for the connection manager rewrite:
> 
>  (1) Fix a goto to the wrong place in error handling.
> 
>  (2) Fix a missing NULL pointer check.
> 
>  (3) The stored allocation error needs to be stored signed.
> 
>  (4) Fix a leak of connection bundle when clearing connections due to
>      net namespace exit.
> 
>  (5) Fix an overget of the bundle when setting up a new client conn.
> 
> The patches are tagged here:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
> 	rxrpc-next-20200914

Pulled, thanks David.
