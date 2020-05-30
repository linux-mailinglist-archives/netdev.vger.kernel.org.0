Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA681E8C7B
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 02:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbgE3APY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 20:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE3APY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 20:15:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2890C03E969;
        Fri, 29 May 2020 17:15:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AA5AC12875128;
        Fri, 29 May 2020 17:15:22 -0700 (PDT)
Date:   Fri, 29 May 2020 17:15:21 -0700 (PDT)
Message-Id: <20200529.171521.699478164991447623.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     dsahern@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][net-next] nexthop: fix incorrect allocation failure on
 nhg->spare
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528145114.420100-1-colin.king@canonical.com>
References: <20200528145114.420100-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 17:15:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Thu, 28 May 2020 15:51:14 +0100

> @@ -1185,7 +1185,7 @@ static struct nexthop *nexthop_create_group(struct net *net,
>  
>  	/* spare group used for removals */
>  	nhg->spare = nexthop_grp_alloc(num_nh);

I don't even see this line in the current net-next tree nor any references
to ->spare.

What am I missing?
