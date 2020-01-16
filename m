Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA5113D9B9
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 13:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgAPMOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 07:14:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37902 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgAPMOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 07:14:43 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B2AE215B52E9C;
        Thu, 16 Jan 2020 04:14:40 -0800 (PST)
Date:   Thu, 16 Jan 2020 04:14:02 -0800 (PST)
Message-Id: <20200116.041402.757321430890945981.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, juvanham@gmail.com
Subject: Re: [PATCH net] macvlan: use skb_reset_mac_header() in
 macvlan_queue_xmit()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200114210035.65042-1-edumazet@google.com>
References: <20200114210035.65042-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 Jan 2020 04:14:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 14 Jan 2020 13:00:35 -0800

> I missed the fact that macvlan_broadcast() can be used both
> in RX and TX.
> 
> skb_eth_hdr() makes only sense in TX paths, so we can not
> use it blindly in macvlan_broadcast()
> 
> Fixes: 96cc4b69581d ("macvlan: do not assume mac_header is set in macvlan_broadcast()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Jurgen Van Ham <juvanham@gmail.com>

Applied and queued up for -stable, thanks Eric.
