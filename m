Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA413183CDE
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 23:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgCLW4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 18:56:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36206 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgCLW4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 18:56:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBECB15842957;
        Thu, 12 Mar 2020 15:56:50 -0700 (PDT)
Date:   Thu, 12 Mar 2020 15:56:50 -0700 (PDT)
Message-Id: <20200312.155650.605586477165565395.davem@davemloft.net>
To:     joe@perches.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 2/3 V2] inet: Use fallthrough;
From:   David Miller <davem@davemloft.net>
In-Reply-To: <68a79203af60110b3412155621cfc00381867c94.camel@perches.com>
References: <cover.1584040050.git.joe@perches.com>
        <68a79203af60110b3412155621cfc00381867c94.camel@perches.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 15:56:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 12 Mar 2020 15:50:22 -0700

> Convert the various uses of fallthrough comments to fallthrough;
> 
> Done via script
> Link: https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe@perches.com/
> 
> And by hand:
> 
> net/ipv6/ip6_fib.c has a fallthrough comment outside of an #ifdef block
> that causes gcc to emit a warning if converted in-place.
> 
> So move the new fallthrough; inside the containing #ifdef/#endif too.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied to net-next.
