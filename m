Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C27E1DF324
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731331AbgEVXoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731169AbgEVXoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:44:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB72C061A0E;
        Fri, 22 May 2020 16:44:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5782D12758B4E;
        Fri, 22 May 2020 16:44:14 -0700 (PDT)
Date:   Fri, 22 May 2020 16:44:13 -0700 (PDT)
Message-Id: <20200522.164413.927439877039263502.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, wu000273@umn.edu, Markus.Elfring@web.de,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] rxrpc: Fix a warning and a leak [ver #2]
From:   David Miller <davem@davemloft.net>
In-Reply-To: <159019095229.999797.5088700147400532632.stgit@warthog.procyon.org.uk>
References: <159019095229.999797.5088700147400532632.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 16:44:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Sat, 23 May 2020 00:42:32 +0100

> 
> Here are a couple of fixes for AF_RXRPC:
> 
>  (1) Fix an uninitialised variable warning.
> 
>  (2) Fix a leak of the ticket on error in rxkad.
> 
> The patches are tagged here:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
> 	rxrpc-fixes-20200523-v2

Pulled, thanks.
