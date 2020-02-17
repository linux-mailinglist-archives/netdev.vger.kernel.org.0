Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C49DD160871
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgBQDFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:05:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48082 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgBQDFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:05:19 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3BDC41554C651;
        Sun, 16 Feb 2020 19:05:19 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:05:18 -0800 (PST)
Message-Id: <20200216.190518.584096983278979522.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, jiri@mellanox.com
Subject: Re: [PATCH net] net: add strict checks in
 netdev_name_node_alt_destroy()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200214155353.71062-1-edumazet@google.com>
References: <20200214155353.71062-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:05:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 14 Feb 2020 07:53:53 -0800

> netdev_name_node_alt_destroy() does a lookup over all
> device names of a namespace.
> 
> We need to make sure the name belongs to the device
> of interest, and that we do not destroy its primary
> name, since we rely on it being not deleted :
> dev->name_node would indeed point to freed memory.
> 
> syzbot report was the following :
 ...
> Fixes: 36fbf1e52bd3 ("net: rtnetlink: add linkprop commands to add and delete alternative ifnames")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable.
