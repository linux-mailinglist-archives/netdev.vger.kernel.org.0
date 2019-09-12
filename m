Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7299AB0CC5
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 12:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731001AbfILKVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 06:21:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55488 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730470AbfILKVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 06:21:43 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 48418120477BA;
        Thu, 12 Sep 2019 03:21:42 -0700 (PDT)
Date:   Thu, 12 Sep 2019 12:21:40 +0200 (CEST)
Message-Id: <20190912.122140.1024775651317943407.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ipv6: Fix the link time qualifier of
 'ping_v6_proc_exit_net()'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190910112959.9222-1-christophe.jaillet@wanadoo.fr>
References: <20190910112959.9222-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Sep 2019 03:21:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Tue, 10 Sep 2019 13:29:59 +0200

> The '.exit' functions from 'pernet_operations' structure should be marked
> as __net_exit, not __net_init.
> 
> Fixes: d862e5461423 ("net: ipv6: Implement /proc/net/icmp6.")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Untested, but using __net_exit looks consistent with other
> pernet_operations.exit use case.

Looks good, applied.
