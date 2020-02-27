Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADA4170FCE
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 05:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgB0EuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 23:50:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37106 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728284AbgB0EuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 23:50:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D92FF15B47C9D;
        Wed, 26 Feb 2020 20:50:10 -0800 (PST)
Date:   Wed, 26 Feb 2020 20:50:10 -0800 (PST)
Message-Id: <20200226.205010.187250062705880561.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, paul@paul-moore.com,
        syzkaller-bugs@googlegroups.com, matthieu.baerts@tessares.net,
        mathew.j.martineau@linux.intel.com
Subject: Re: [PATCH net] mptcp: add dummy icsk_sync_mss()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3b06c9fdc9d0e00a8a6eaef4dc08eeb9322be4a0.1582715453.git.pabeni@redhat.com>
References: <3b06c9fdc9d0e00a8a6eaef4dc08eeb9322be4a0.1582715453.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 20:50:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Wed, 26 Feb 2020 12:19:03 +0100

> syzbot noted that the master MPTCP socket lacks the icsk_sync_mss
> callback, and was able to trigger a null pointer dereference:
 ...
> Address the issue adding a dummy icsk_sync_mss callback.
> To properly sync the subflows mss and options list we need some
> additional infrastructure, which will land to net-next.
> 
> Reported-by: syzbot+f4dfece964792d80b139@syzkaller.appspotmail.com
> Fixes: 2303f994b3e1 ("mptcp: Associate MPTCP context with TCP socket")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied, thanks.
