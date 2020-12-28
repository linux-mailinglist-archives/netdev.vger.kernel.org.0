Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71A32E6B43
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgL1XBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 18:01:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44800 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727799AbgL1XBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 18:01:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 93C5D4CE686E0;
        Mon, 28 Dec 2020 15:01:03 -0800 (PST)
Date:   Mon, 28 Dec 2020 15:01:03 -0800 (PST)
Message-Id: <20201228.150103.7398661656696572.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        syzbot+f583ce3d4ddf9836b27a@syzkaller.appspotmail.com,
        u9012063@gmail.com, lorenzo.bianconi@redhat.com
Subject: Re: [Patch net] erspan: fix version 1 check in gre_parse_header()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201226234453.905884-1-xiyou.wangcong@gmail.com>
References: <20201226234453.905884-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 28 Dec 2020 15:01:03 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sat, 26 Dec 2020 15:44:53 -0800

> From: Cong Wang <cong.wang@bytedance.com>
> 
> Both version 0 and version 1 use ETH_P_ERSPAN, but version 0 does not
> have an erspan header. So the check in gre_parse_header() is wrong,
> we have to distinguish version 1 from version 0.
> 
> We can just check the gre header length like is_erspan_type1().
> 
> Fixes: cb73ee40b1b3 ("net: ip_gre: use erspan key field for tunnel lookup")
> Reported-by: syzbot+f583ce3d4ddf9836b27a@syzkaller.appspotmail.com
> Cc: William Tu <u9012063@gmail.com>
> Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

Applied and queued up for -stable, thanks.
