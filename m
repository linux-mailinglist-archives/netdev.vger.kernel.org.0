Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C25D1EAD24
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731513AbgFASm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728857AbgFASmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:42:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF31AC00863E;
        Mon,  1 Jun 2020 11:34:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 477B111D53F8B;
        Mon,  1 Jun 2020 11:34:15 -0700 (PDT)
Date:   Mon, 01 Jun 2020 11:34:13 -0700 (PDT)
Message-Id: <20200601.113413.1506796443678765558.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, kuba@kernel.org,
        tuong.t.lien@dektech.com.au, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] tipc: Fix NULL pointer dereference in
 __tipc_sendstream()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528143407.56196-1-yuehaibing@huawei.com>
References: <20200528143407.56196-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 11:34:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 28 May 2020 22:34:07 +0800

> tipc_sendstream() may send zero length packet, then tipc_msg_append()
> do not alloc skb, skb_peek_tail() will get NULL, msg_set_ack_required
> will trigger NULL pointer dereference.
> 
> Reported-by: syzbot+8eac6d030e7807c21d32@syzkaller.appspotmail.com
> Fixes: 0a3e060f340d ("tipc: add test for Nagle algorithm effectiveness")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Can a TIPC expert please review this?

Thank you.
