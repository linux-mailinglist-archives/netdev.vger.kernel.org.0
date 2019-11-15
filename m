Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1232AFE68A
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfKOUnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:43:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40902 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfKOUnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:43:45 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1042A14E14FC3;
        Fri, 15 Nov 2019 12:43:45 -0800 (PST)
Date:   Fri, 15 Nov 2019 12:43:44 -0800 (PST)
Message-Id: <20191115.124344.295228162013300379.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     pshelar@ovn.org, gvrose8192@gmail.com, netdev@vger.kernel.org,
        dev@openvswitch.org, joe@ovn.org, u9012063@gmail.com
Subject: Re: [PATCH net-next] net: openvswitch: don't call pad_packet if
 not necessary
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573746668-6920-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1573746668-6920-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 Nov 2019 12:43:45 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Thu, 14 Nov 2019 23:51:08 +0800

> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> The nla_put_u16/nla_put_u32 makes sure that
> *attrlen is align. The call tree is that:
> 
> nla_put_u16/nla_put_u32
>   -> nla_put		attrlen = sizeof(u16) or sizeof(u32)
>   -> __nla_put		attrlen
>   -> __nla_reserve	attrlen
>   -> skb_put(skb, nla_total_size(attrlen))
> 
> nla_total_size returns the total length of attribute
> including padding.
> 
> Cc: Joe Stringer <joe@ovn.org>
> Cc: William Tu <u9012063@gmail.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Applied, thanks.
