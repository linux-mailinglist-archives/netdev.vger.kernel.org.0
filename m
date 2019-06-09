Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 201643ABBB
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 22:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbfFIUIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 16:08:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44776 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfFIUIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 16:08:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0BCF314DEFBC4;
        Sun,  9 Jun 2019 13:08:09 -0700 (PDT)
Date:   Sun, 09 Jun 2019 13:08:08 -0700 (PDT)
Message-Id: <20190609.130808.145089119500423309.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, willemb@google.com
Subject: Re: [PATCH v2 net] ipv6: flowlabel: fl6_sock_lookup() must use
 atomic_inc_not_zero
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190606213234.162732-1-edumazet@google.com>
References: <20190606213234.162732-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 13:08:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu,  6 Jun 2019 14:32:34 -0700

> Before taking a refcount, make sure the object is not already
> scheduled for deletion.
> 
> Same fix is needed in ipv6_flowlabel_opt()
> 
> Fixes: 18367681a10b ("ipv6 flowlabel: Convert np->ipv6_fl_list to RCU.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable.
