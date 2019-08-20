Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 200D9952C4
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 02:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbfHTAc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 20:32:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38712 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbfHTAc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 20:32:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 58E2014A8CAD7;
        Mon, 19 Aug 2019 17:32:28 -0700 (PDT)
Date:   Mon, 19 Aug 2019 17:32:27 -0700 (PDT)
Message-Id: <20190819.173227.816238311420289865.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, challa@noironetworks.com,
        dsahern@gmail.com, jishi@redhat.com
Subject: Re: [PATCH net] ipv6/addrconf: allow adding multicast addr if
 IFA_F_MCAUTOJOIN is set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190813135232.27146-1-liuhangbin@gmail.com>
References: <20190813135232.27146-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Aug 2019 17:32:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Tue, 13 Aug 2019 21:52:32 +0800

> The ip address autojoin is not working for IPv6 as ipv6_add_addr()
> will return -EADDRNOTAVAIL when adding a multicast address.
> 
> Reported-by: Jianlin Shi <jishi@redhat.com>
> Fixes: 93a714d6b53d ("multicast: Extend ip address command to enable multicast group join/leave on")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

I don't understand how all of this works and why ipv6_add_addr(), which
seems designed explicitly to exclude multicast addresses, should accept
them and what all of the possible fallout might be from such a change.

Your commit message is way too terse and makes it impossible to evaluate
your change.  Really, a change of this nature should have a couple paragraphs
of text explaining the existing situation, what is wrong with it, how you
are fixing it, and why you are fixing it that way.

Thanks.
