Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74BF12D2D7
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfE2A0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:26:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54474 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfE2A0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 20:26:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 108B51400F7AF;
        Tue, 28 May 2019 17:26:17 -0700 (PDT)
Date:   Tue, 28 May 2019 17:26:16 -0700 (PDT)
Message-Id: <20190528.172616.1230253591814538824.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] llc: fix skb leak in llc_build_and_send_ui_pkt()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190528003552.88258-1-edumazet@google.com>
References: <20190528003552.88258-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 17:26:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 27 May 2019 17:35:52 -0700

> If llc_mac_hdr_init() returns an error, we must drop the skb
> since no llc_build_and_send_ui_pkt() caller will take care of this.
 ...
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable.
