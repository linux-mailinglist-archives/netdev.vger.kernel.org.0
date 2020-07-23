Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E23722B947
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 00:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgGWWRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 18:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgGWWRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 18:17:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41061C0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 15:17:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A482F11E48C62;
        Thu, 23 Jul 2020 15:01:09 -0700 (PDT)
Date:   Thu, 23 Jul 2020 15:17:53 -0700 (PDT)
Message-Id: <20200723.151753.1717783995744079017.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+bbc3a11c4da63c1b74d6@syzkaller.appspotmail.com,
        bgalvani@redhat.com, ap420073@gmail.com, j.vosburgh@gmail.com
Subject: Re: [Patch net] bonding: check return value of
 register_netdevice() in bond_newlink()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722233154.13105-1-xiyou.wangcong@gmail.com>
References: <20200722233154.13105-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 15:01:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed, 22 Jul 2020 16:31:54 -0700

> Very similar to commit 544f287b8495
> ("bonding: check error value of register_netdevice() immediately"),
> we should immediately check the return value of register_netdevice()
> before doing anything else.
> 
> Fixes: 005db31d5f5f ("bonding: set carrier off for devices created through netlink")
> Reported-and-tested-by: syzbot+bbc3a11c4da63c1b74d6@syzkaller.appspotmail.com
> Cc: Beniamino Galvani <bgalvani@redhat.com>
> Cc: Taehee Yoo <ap420073@gmail.com>
> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks.
