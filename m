Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAC98826C
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407120AbfHIS1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:27:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36114 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfHIS1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:27:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 188771264D00D;
        Fri,  9 Aug 2019 11:27:36 -0700 (PDT)
Date:   Fri, 09 Aug 2019 11:27:35 -0700 (PDT)
Message-Id: <20190809.112735.75303405300623184.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] rxrpc: Fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <156536674651.17478.15139844428920800280.stgit@warthog.procyon.org.uk>
References: <156536674651.17478.15139844428920800280.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 11:27:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Fri, 09 Aug 2019 17:05:46 +0100

> Here's a couple of fixes for rxrpc:
> 
>  (1) Fix refcounting of the local endpoint.
> 
>  (2) Don't calculate or report packet skew information.  This has been
>      obsolete since AFS 3.1 and so is a waste of resources.
> 
> The patches are tagged here:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
> 	rxrpc-fixes-20190809

Pulled, thanks David.
