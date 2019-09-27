Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28B53C0B70
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 20:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbfI0SlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 14:41:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35396 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727447AbfI0SlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 14:41:02 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 062EB153F19C3;
        Fri, 27 Sep 2019 11:41:00 -0700 (PDT)
Date:   Fri, 27 Sep 2019 20:40:59 +0200 (CEST)
Message-Id: <20190927.204059.1317123662569262129.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, steffen.klassert@secunet.com,
        paulb@mellanox.com, vladbu@mellanox.com
Subject: Re: [PATCH v2 net] sk_buff: drop all skb extensions on free and
 skb scrubbing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190926183705.16951-1-fw@strlen.de>
References: <20190926183705.16951-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 11:41:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Thu, 26 Sep 2019 20:37:05 +0200

> Now that we have a 3rd extension, add a new helper that drops the
> extension space and use it when we need to scrub an sk_buff.
> 
> At this time, scrubbing clears secpath and bridge netfilter data, but
> retains the tc skb extension, after this patch all three get cleared.
> 
> NAPI reuse/free assumes we can only have a secpath attached to skb, but
> it seems better to clear all extensions there as well.
> 
> v2: add unlikely hint (Eric Dumazet)
> 
> Fixes: 95a7233c452a ("net: openvswitch: Set OvS recirc_id from tc chain index")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied.
