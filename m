Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C8A4F91C
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 01:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfFVXyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 19:54:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32916 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfFVXyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 19:54:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87A6F1540C17D;
        Sat, 22 Jun 2019 16:54:51 -0700 (PDT)
Date:   Sat, 22 Jun 2019 16:54:51 -0700 (PDT)
Message-Id: <20190622.165451.1834907805634183167.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, jon.maloy@ericsson.com,
        ying.xue@windriver.com, tipc-discussion@lists.sourceforge.net,
        pabeni@redhat.com
Subject: Re: [PATCH net] tipc: add dst_cache support for udp media
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0ea2e8519f14d5c9e7bb7ba82a5be371bd4cb9ab.1561028621.git.lucien.xin@gmail.com>
References: <0ea2e8519f14d5c9e7bb7ba82a5be371bd4cb9ab.1561028621.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Jun 2019 16:54:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 20 Jun 2019 19:03:41 +0800

> As other udp/ip tunnels do, tipc udp media should also have a
> lockless dst_cache supported on its tx path.
> 
> Here we add dst_cache into udp_replicast to support dst cache
> for both rmcast and rcast, and rmcast uses ub->rcast and each
> rcast uses its own node in ub->rcast.list.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

I'll apply this to net-next after the next net --> net-next
marge since it depends upon the register_pernet_device change.
