Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F289284C66
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgJFNTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJFNTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:19:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F05C061755;
        Tue,  6 Oct 2020 06:19:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 56D9B127C790E;
        Tue,  6 Oct 2020 06:02:24 -0700 (PDT)
Date:   Tue, 06 Oct 2020 06:19:10 -0700 (PDT)
Message-Id: <20201006.061910.2028674026807610400.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, marc.dionne@auristor.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/6] rxrpc: Miscellaneous fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <160191472433.3050642.12600839710302704718.stgit@warthog.procyon.org.uk>
References: <160191472433.3050642.12600839710302704718.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 06 Oct 2020 06:02:24 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Mon, 05 Oct 2020 17:18:44 +0100

> The patches are tagged here:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
> 	rxrpc-fixes-20201005.txt

I think the ".txt" at the end of the branch name is a mistake.

It's really hard to send a clean working pull request isn't it? :-)

Pulled, thanks David.
