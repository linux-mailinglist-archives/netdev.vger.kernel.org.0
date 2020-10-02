Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25A2281ECE
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 01:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725648AbgJBXD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 19:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBXD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 19:03:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F6AC0613D0;
        Fri,  2 Oct 2020 16:03:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D801111E4A59F;
        Fri,  2 Oct 2020 15:46:38 -0700 (PDT)
Date:   Fri, 02 Oct 2020 16:03:25 -0700 (PDT)
Message-Id: <20201002.160325.520066148052804695.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 00/23] rxrpc: Fixes and preparation for RxGK
From:   David Miller <davem@davemloft.net>
In-Reply-To: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
References: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 15:46:39 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 01 Oct 2020 15:56:43 +0100

> The patches are tagged here:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
> 	rxrpc-next-20201010

No, they aren't.

====================
git pull --no-ff git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git rxrpc-next-20201010
fatal: couldn't find remote ref rxrpc-next-20201010
====================

Also, you have to submit changes much much much earlier.  Don't let your
patch sets get into the 20+ patch range, it's much to large and a huge
burdon for patch reviewers.

Make this patch series smaller, fix the GIT stuff, and resubmit.

Thank you.
