Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 827AB8D82D
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfHNQg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:36:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55810 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbfHNQg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:36:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::202])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BC240154B6C0D;
        Wed, 14 Aug 2019 09:36:25 -0700 (PDT)
Date:   Wed, 14 Aug 2019 12:36:25 -0400 (EDT)
Message-Id: <20190814.123625.170482147366456100.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc
Subject: Re: [PATCH net] batman-adv: fix uninit-value in
 batadv_netlink_get_ifindex()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190812115727.72149-1-edumazet@google.com>
References: <20190812115727.72149-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 Aug 2019 09:36:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 12 Aug 2019 04:57:27 -0700

> batadv_netlink_get_ifindex() needs to make sure user passed
> a correct u32 attribute.
 ...
> Fixes: b60620cf567b ("batman-adv: netlink: hardif query")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Simon, I assume I will get this ultimately from you.

Thanks.
