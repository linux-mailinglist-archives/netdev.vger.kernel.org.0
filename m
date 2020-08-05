Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD56623CF82
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgHETVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728383AbgHETVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 15:21:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCE0C061575;
        Wed,  5 Aug 2020 12:21:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ED3B8152EF44E;
        Wed,  5 Aug 2020 12:04:52 -0700 (PDT)
Date:   Wed, 05 Aug 2020 12:21:37 -0700 (PDT)
Message-Id: <20200805.122137.947167509695194847.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     yuehaibing@huawei.com, herbert@gondor.apana.org.au,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        lucien.xin@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ip_vti: Fix unused variable warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200804055310.GK20687@gauss3.secunet.de>
References: <20200731064952.36900-1-yuehaibing@huawei.com>
        <20200803.151349.926022361234213749.davem@davemloft.net>
        <20200804055310.GK20687@gauss3.secunet.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Aug 2020 12:04:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Tue, 4 Aug 2020 07:53:10 +0200

> On Mon, Aug 03, 2020 at 03:13:49PM -0700, David Miller wrote:
>> From: YueHaibing <yuehaibing@huawei.com>
>> Date: Fri, 31 Jul 2020 14:49:52 +0800
>> 
>> > If CONFIG_INET_XFRM_TUNNEL is set but CONFIG_IPV6 is n,
>> > 
>> > net/ipv4/ip_vti.c:493:27: warning: 'vti_ipip6_handler' defined but not used [-Wunused-variable]
>> > 
>> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> 
>> Steffen, please pick this up if you haven't already.
> 
> I still have this one in my queue, it came in after
> I did the the ipsec-next pull request last week.
> Now the 5.8 release was inbetween, so it should go
> to the ipsec tree. I'm waiting until I can backmerge
> the offending patch into the ipsec tree and apply it
> then.

I can wait until you can get it to me via your tree, no problem.
