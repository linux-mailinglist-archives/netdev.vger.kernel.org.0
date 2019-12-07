Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24595115E4D
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 20:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfLGTyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 14:54:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42776 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbfLGTyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 14:54:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9882615421AC6;
        Sat,  7 Dec 2019 11:54:21 -0800 (PST)
Date:   Sat, 07 Dec 2019 11:54:20 -0800 (PST)
Message-Id: <20191207.115420.167629527884039167.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: Re: [Patch net] gre: refetch erspan header from skb->data after
 pskb_may_pull()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191206033902.19638-1-xiyou.wangcong@gmail.com>
References: <20191206033902.19638-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Dec 2019 11:54:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Thu,  5 Dec 2019 19:39:02 -0800

> After pskb_may_pull() we should always refetch the header
> pointers from the skb->data in case it got reallocated.
> 
> In gre_parse_header(), the erspan header is still fetched
> from the 'options' pointer which is fetched before
> pskb_may_pull().
> 
> Found this during code review of a KMSAN bug report.
> 
> Fixes: cb73ee40b1b3 ("net: ip_gre: use erspan key field for tunnel lookup")
> Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks.
