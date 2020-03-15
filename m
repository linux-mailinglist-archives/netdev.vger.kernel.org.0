Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF3B7185B14
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 08:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgCOHnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 03:43:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36166 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgCOHnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 03:43:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 68C2F1462FF3A;
        Sun, 15 Mar 2020 00:43:39 -0700 (PDT)
Date:   Sun, 15 Mar 2020 00:43:38 -0700 (PDT)
Message-Id: <20200315.004338.879638257748449065.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+68a8ed58e3d17c700de5@syzkaller.appspotmail.com,
        yanhaishuang@cmss.chinamobile.com
Subject: Re: [PATCH net] geneve: move debug check after netdev unregister
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200314071842.17832-1-fw@strlen.de>
References: <0000000000000ea4b4059fb33201@google.com>
        <20200314071842.17832-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Mar 2020 00:43:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Sat, 14 Mar 2020 08:18:42 +0100

> The debug check must be done after unregister_netdevice_many() call --
> the list_del() for this is done inside .ndo_stop.
> 
> Fixes: 2843a25348f8 ("geneve: speedup geneve tunnels dismantle")
> Reported-and-tested-by: <syzbot+68a8ed58e3d17c700de5@syzkaller.appspotmail.com>
> Cc: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied and queued up for -stable, thanks Florian.
