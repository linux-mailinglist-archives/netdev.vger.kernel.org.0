Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A888A12D727
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 09:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbfLaIv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 03:51:26 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51470 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfLaIvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 03:51:25 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EAFE11518AA73;
        Tue, 31 Dec 2019 00:51:24 -0800 (PST)
Date:   Tue, 31 Dec 2019 00:51:22 -0800 (PST)
Message-Id: <20191231.005122.573539968032058973.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] hsr: fix slab-out-of-bounds Read in
 hsr_debugfs_rename()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191228162809.21370-1-ap420073@gmail.com>
References: <20191228162809.21370-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 31 Dec 2019 00:51:25 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Sat, 28 Dec 2019 16:28:09 +0000

> hsr slave interfaces don't have debugfs directory.
> So, hsr_debugfs_rename() shouldn't be called when hsr slave interface name
> is changed.
> 
> Test commands:
>     ip link add dummy0 type dummy
>     ip link add dummy1 type dummy
>     ip link add hsr0 type hsr slave1 dummy0 slave2 dummy1
>     ip link set dummy0 name ap
> 
> Splat looks like:
 ...
> Reported-by: syzbot+9328206518f08318a5fd@syzkaller.appspotmail.com
> Fixes: 4c2d5e33dcd3 ("hsr: rename debugfs file when interface name is changed")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied, thank you.
