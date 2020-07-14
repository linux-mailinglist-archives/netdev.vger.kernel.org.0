Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9D621E495
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgGNAds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbgGNAds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:33:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A2BC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 17:33:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 41CA812984903;
        Mon, 13 Jul 2020 17:33:47 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:33:46 -0700 (PDT)
Message-Id: <20200713.173346.220977851123381348.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     hulkci@huawei.com, eric.dumazet@gmail.com, ap420073@gmail.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ip6_gre: fix null-ptr-deref in ip6gre_init_net()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200713155950.71793-1-weiyongjun1@huawei.com>
References: <20200713155950.71793-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Jul 2020 17:33:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Mon, 13 Jul 2020 23:59:50 +0800

> KASAN report null-ptr-deref error when register_netdev() failed:
 ...
> ip6gre_tunnel_uninit() has set 'ign->fb_tunnel_dev' to NULL, later
> access to ign->fb_tunnel_dev cause null-ptr-deref. Fix it by saving
> 'ign->fb_tunnel_dev' to local variable ndev.
> 
> Fixes: dafabb6590cb ("ip6_gre: fix use-after-free in ip6gre_tunnel_lookup()")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied and queued up for -stable.
