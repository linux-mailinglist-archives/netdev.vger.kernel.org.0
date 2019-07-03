Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC335ED78
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 22:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfGCU04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 16:26:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34376 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfGCU04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 16:26:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A94DF142E9E5F;
        Wed,  3 Jul 2019 13:26:55 -0700 (PDT)
Date:   Wed, 03 Jul 2019 13:26:55 -0700 (PDT)
Message-Id: <20190703.132655.1832823550319483737.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+e5be16aa39ad6e755391@syzkaller.appspotmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net
Subject: Re: [Patch net] bonding: validate ip header before check
 IPPROTO_IGMP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190702034024.25962-1-xiyou.wangcong@gmail.com>
References: <20190702034024.25962-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 03 Jul 2019 13:26:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Mon,  1 Jul 2019 20:40:24 -0700

> bond_xmit_roundrobin() checks for IGMP packets but it parses
> the IP header even before checking skb->protocol.
> 
> We should validate the IP header with pskb_may_pull() before
> using iph->protocol.
> 
> Reported-and-tested-by: syzbot+e5be16aa39ad6e755391@syzkaller.appspotmail.com
> Fixes: a2fd940f4cff ("bonding: fix broken multicast with round-robin mode")
> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> Cc: Veaceslav Falico <vfalico@gmail.com>
> Cc: Andy Gospodarek <andy@greyhouse.net>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks.
