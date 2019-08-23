Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92A279B846
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 23:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436986AbfHWVmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 17:42:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38242 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436967AbfHWVmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 17:42:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8E10B1543B407;
        Fri, 23 Aug 2019 14:42:50 -0700 (PDT)
Date:   Fri, 23 Aug 2019 14:42:50 -0700 (PDT)
Message-Id: <20190823.144250.2063544404229146484.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com,
        brouer@redhat.com, ecree@solarflare.com, dvyukov@google.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH net-next] net: ipv6: fix listify ip6_rcv_finish in case
 of forwarding
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e355527b374f6ce70fcc286457f87592cd8f3dcc.1566559983.git.lucien.xin@gmail.com>
References: <e355527b374f6ce70fcc286457f87592cd8f3dcc.1566559983.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 Aug 2019 14:42:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 23 Aug 2019 19:33:03 +0800

> We need a similar fix for ipv6 as Commit 0761680d5215 ("net: ipv4: fix
> listify ip_rcv_finish in case of forwarding") does for ipv4.
> 
> This issue can be reprocuded by syzbot since Commit 323ebb61e32b ("net:
> use listified RX for handling GRO_NORMAL skbs") on net-next. The call
> trace was:
 ...
> Fixes: d8269e2cbf90 ("net: ipv6: listify ipv6_rcv() and ip6_rcv_finish()")
> Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
> Reported-by: syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com
> Reported-by: syzbot+4a0643a653ac375612d1@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks.
