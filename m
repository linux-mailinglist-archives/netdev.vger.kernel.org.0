Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3689110666
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 22:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfLCVSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 16:18:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52868 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbfLCVSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 16:18:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D895D151218B0;
        Tue,  3 Dec 2019 13:18:46 -0800 (PST)
Date:   Tue, 03 Dec 2019 13:18:44 -0800 (PST)
Message-Id: <20191203.131844.1288568107728597971.davem@davemloft.net>
To:     gregkh@linuxfoundation.org
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, soheil@google.com, ncardwell@google.com,
        ycheng@google.com, willemb@google.com
Subject: Re: [PATCH net] tcp: refactor tcp_retransmit_timer()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191203202358.GB3183510@kroah.com>
References: <20191203160552.31071-1-edumazet@google.com>
        <20191203.115311.1412019727224973630.davem@davemloft.net>
        <20191203202358.GB3183510@kroah.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Dec 2019 13:18:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Tue, 3 Dec 2019 21:23:58 +0100

> On Tue, Dec 03, 2019 at 11:53:11AM -0800, David Miller wrote:
>> From: Eric Dumazet <edumazet@google.com>
>> Date: Tue,  3 Dec 2019 08:05:52 -0800
>> 
>> > It appears linux-4.14 stable needs a backport of commit
>> > 88f8598d0a30 ("tcp: exit if nothing to retransmit on RTO timeout")
>> > 
>> > Since tcp_rtx_queue_empty() is not in pre 4.15 kernels,
>> > let's refactor tcp_retransmit_timer() to only use tcp_rtx_queue_head()
>> > 
>> > I will provide to stable teams the squashed patches.
>> > 
>> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>> 
>> Applied, thanks Eric.
> 
> Applied where, do you have a 4.14-stable queue too?  :)

Applied to my net GIT tree, I do not have a 4.14 -stable queue :-)

> I can just take this directly to my 4.14.y tree now if you don't object.

Please integrate all of the -stable parts, yes.

Thanks.
