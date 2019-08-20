Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A73D9969B7
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 21:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbfHTTsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 15:48:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50338 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbfHTTsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 15:48:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CCE3F146F6EF7;
        Tue, 20 Aug 2019 12:48:54 -0700 (PDT)
Date:   Tue, 20 Aug 2019 12:48:54 -0700 (PDT)
Message-Id: <20190820.124854.118248329347074563.davem@davemloft.net>
To:     lirongqing@baidu.com
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com
Subject: Re: [PATCH][V2] net: fix __ip_mc_inc_group usage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566280367-8816-1-git-send-email-lirongqing@baidu.com>
References: <1566280367-8816-1-git-send-email-lirongqing@baidu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 20 Aug 2019 12:48:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>
Date: Tue, 20 Aug 2019 13:52:47 +0800

> in ip_mc_inc_group, memory allocation flag, not mcast mode, is expected
> by __ip_mc_inc_group
> 
> similar issue in __ip_mc_join_group, both mcase mode and gfp_t are needed
> here, so use ____ip_mc_inc_group(...)
> 
> Fixes: 9fb20801dab4 ("net: Fix ip_mc_{dec,inc}_group allocation context")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
> ---
> v1-->v2:
> fixes "Fixes tag"
> use ____ip_mc_inc_group in __ip_mc_join_group

Applied and queued up for -stable, thanks.
