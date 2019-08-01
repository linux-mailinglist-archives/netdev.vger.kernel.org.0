Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E24227E086
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 18:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732294AbfHAQtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 12:49:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56958 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfHAQtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 12:49:01 -0400
Received: from localhost (unknown [IPv6:2603:3004:624:eb00::2d06])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 489AD153F102B;
        Thu,  1 Aug 2019 09:48:59 -0700 (PDT)
Date:   Thu, 01 Aug 2019 12:48:51 -0400 (EDT)
Message-Id: <20190801.124851.1301999897687804145.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     roid@mellanox.com, saeedm@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5e: Allow dropping specific tunnel
 packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564648859-17369-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1564648859-17369-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 01 Aug 2019 09:49:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Thu,  1 Aug 2019 16:40:59 +0800

> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> In some case, we don't want to allow specific tunnel packets
> to host that can avoid to take up high CPU (e.g network attacks).
> But other tunnel packets which not matched in hardware will be
> sent to host too.
> 
>     $ tc filter add dev vxlan_sys_4789 \
> 	    protocol ip chain 0 parent ffff: prio 1 handle 1 \
> 	    flower dst_ip 1.1.1.100 ip_proto tcp dst_port 80 \
> 	    enc_dst_ip 2.2.2.100 enc_key_id 100 enc_dst_port 4789 \
> 	    action tunnel_key unset pipe action drop
> 
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Saeed, please pick this up.

Thank you.
