Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71771B32CA
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 00:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgDUWwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 18:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725850AbgDUWwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 18:52:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2961C0610D5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 15:52:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C14C128E92A9;
        Tue, 21 Apr 2020 15:52:54 -0700 (PDT)
Date:   Tue, 21 Apr 2020 15:52:53 -0700 (PDT)
Message-Id: <20200421.155253.404301761880711135.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, dingtianhong@huawei.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] macvlan: fix null dereference in
 macvlan_device_event()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200420132940.21627-1-ap420073@gmail.com>
References: <20200420132940.21627-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Apr 2020 15:52:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Mon, 20 Apr 2020 13:29:40 +0000

> In the macvlan_device_event(), the list_first_entry_or_null() is used.
> This function could return null pointer if there is no node.
> But, the macvlan module doesn't check the null pointer.
> So, null-ptr-deref would occur.
> 
>       bond0
>         |
>    +----+-----+
>    |          |
> macvlan0   macvlan1
>    |          |
>  dummy0     dummy1
> 
> The problem scenario.
 ...
> Test commands:
 ...
> Splat looks like:
 ...
> Fixes: e289fd28176b ("macvlan: fix the problem when mac address changes for passthru mode")
> Reported-by: syzbot+5035b1f9dc7ea4558d5a@syzkaller.appspotmail.com
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for -stable, thank you.
