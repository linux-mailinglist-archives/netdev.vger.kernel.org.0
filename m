Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94E5713D9EE
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 13:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgAPM11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 07:27:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38050 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgAPM10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 07:27:26 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6FAC815B52F09;
        Thu, 16 Jan 2020 04:27:24 -0800 (PST)
Date:   Thu, 16 Jan 2020 04:27:22 -0800 (PST)
Message-Id: <20200116.042722.153124126288244814.davem@davemloft.net>
To:     zhangshaokun@hisilicon.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jinyuqi@huawei.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        edumazet@google.com, guoyang2@huawei.com
Subject: Re: [PATCH] net: optimize cmpxchg in ip_idents_reserve
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1579058620-26684-1-git-send-email-zhangshaokun@hisilicon.com>
References: <1579058620-26684-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 Jan 2020 04:27:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shaokun Zhang <zhangshaokun@hisilicon.com>
Date: Wed, 15 Jan 2020 11:23:40 +0800

> From: Yuqi Jin <jinyuqi@huawei.com>
> 
> atomic_try_cmpxchg is called instead of atomic_cmpxchg that can reduce
> the access number of the global variable @p_id in the loop. Let's
> optimize it for performance.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Yang Guo <guoyang2@huawei.com>
> Signed-off-by: Yuqi Jin <jinyuqi@huawei.com>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>

I doubt this makes any measurable improvement in performance.

If you can document a specific measurable improvement under
a useful set of circumstances for real usage, then put those
details into the commit message and resubmit.

Otherwise, I'm not applying this, sorry.
