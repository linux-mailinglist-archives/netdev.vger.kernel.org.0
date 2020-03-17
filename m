Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40D831876B8
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 01:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733106AbgCQAVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 20:21:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50024 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733005AbgCQAVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 20:21:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 97A5E1577F7FC;
        Mon, 16 Mar 2020 17:21:41 -0700 (PDT)
Date:   Mon, 16 Mar 2020 17:21:41 -0700 (PDT)
Message-Id: <20200316.172141.2249000423302633470.davem@davemloft.net>
To:     petrm@mellanox.com
Cc:     netdev@vger.kernel.org, u9012063@gmail.com, lucien.xin@gmail.com,
        kuznet@ms2.inr.ac.ru, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org,
        syzbot+1b4ebf4dae4e510dd219@syzkaller.appspotmail.com
Subject: Re: [PATCH net] net: ip_gre: Accept IFLA_INFO_DATA-less
 configuration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b7bc71aab99588a5b2c36c0338639fc5543f0f3a.1584381176.git.petrm@mellanox.com>
References: <b7bc71aab99588a5b2c36c0338639fc5543f0f3a.1584381176.git.petrm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 17:21:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>
Date: Mon, 16 Mar 2020 19:53:00 +0200

> The fix referenced below causes a crash when an ERSPAN tunnel is created
> without passing IFLA_INFO_DATA. Fix by validating passed-in data in the
> same way as ipgre does.
> 
> Fixes: e1f8f78ffe98 ("net: ip_gre: Separate ERSPAN newlink / changelink callbacks")
> Reported-by: syzbot+1b4ebf4dae4e510dd219@syzkaller.appspotmail.com
> Signed-off-by: Petr Machata <petrm@mellanox.com>

Applied and queued up for -stable, thanks.
