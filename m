Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2381F323A
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 04:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgFICN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 22:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgFICNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 22:13:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD12C03E969;
        Mon,  8 Jun 2020 19:13:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E6AF128A6AEC;
        Mon,  8 Jun 2020 19:13:54 -0700 (PDT)
Date:   Mon, 08 Jun 2020 19:13:53 -0700 (PDT)
Message-Id: <20200608.191353.1433508565956506007.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, gerry@auristor.com,
        marc.dionne@auristor.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] rxrpc: Fix hang due to missing notification
From:   David Miller <davem@davemloft.net>
In-Reply-To: <159164218727.2758133.1046957228494479308.stgit@warthog.procyon.org.uk>
References: <159164218727.2758133.1046957228494479308.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jun 2020 19:13:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Mon, 08 Jun 2020 19:49:47 +0100

> Here's a fix for AF_RXRPC.  Occasionally calls hang because there are
> circumstances in which rxrpc generate a notification when a call is
> completed - primarily because initial packet transmission failed and the
> call was killed off and an error returned.  But the AFS filesystem driver
> doesn't check this under all circumstances, expecting failure to be
> delivered by asynchronous notification.
> 
> There are two patches: the first moves the problematic bits out-of-line and
> the second contains the fix.
> 
> The patches are tagged here:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
> 	rxrpc-fixes-20200605

Pulled, thanks David.
