Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C536D7B006
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 19:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730968AbfG3RcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 13:32:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52546 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729238AbfG3RcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 13:32:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6F2AD126598EB;
        Tue, 30 Jul 2019 10:32:00 -0700 (PDT)
Date:   Tue, 30 Jul 2019 10:31:59 -0700 (PDT)
Message-Id: <20190730.103159.316720747259208571.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] rxrpc: Fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <156449821120.9558.2821927090314866621.stgit@warthog.procyon.org.uk>
References: <156449821120.9558.2821927090314866621.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jul 2019 10:32:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Tue, 30 Jul 2019 15:50:11 +0100

> 
> Here are a couple of fixes for rxrpc:
> 
>  (1) Fix a potential deadlock in the peer keepalive dispatcher.
> 
>  (2) Fix a missing notification when a UDP sendmsg error occurs in rxrpc.
> 
> 
> The patches are tagged here:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
> 	rxrpc-fixes-20190730

Pulled, thanks David.
