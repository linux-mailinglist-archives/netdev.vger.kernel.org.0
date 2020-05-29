Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4031E8C62
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 01:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgE2X5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 19:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE2X5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 19:57:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCB2C03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 16:57:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A24371286D0DF;
        Fri, 29 May 2020 16:57:48 -0700 (PDT)
Date:   Fri, 29 May 2020 16:57:47 -0700 (PDT)
Message-Id: <20200529.165747.1274640204927282377.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, jiji@redhat.com
Subject: Re: [PATCH net] neigh: fix ARP retransmit timer guard
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528071513.3404686-1-liuhangbin@gmail.com>
References: <20200528071513.3404686-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 16:57:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Thu, 28 May 2020 15:15:13 +0800

> In commit 19e16d220f0a ("neigh: support smaller retrans_time settting")
> we add more accurate control for ARP and NS. But for ARP I forgot to
> update the latest guard in neigh_timer_handler(), then the next
> retransmit would be reset to jiffies + HZ/2 if we set the retrans_time
> less than 500ms. Fix it by setting the time_before() check to HZ/100.
> 
> IPv6 does not have this issue.
> 
> Reported-by: Jianwen Ji <jiji@redhat.com>
> Fixes: 19e16d220f0a ("neigh: support smaller retrans_time settting")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied, thank you.
