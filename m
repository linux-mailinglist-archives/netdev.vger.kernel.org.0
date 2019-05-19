Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE422259F
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 03:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfESBPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 21:15:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33726 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfESBPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 21:15:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9312714E7A6DC;
        Sat, 18 May 2019 18:15:35 -0700 (PDT)
Date:   Sat, 18 May 2019 18:15:33 -0700 (PDT)
Message-Id: <20190518.181533.210377687072041762.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net] kselftests: netfilter: fix leftover net/net-next
 merge conflict
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190518213335.8115-1-fw@strlen.de>
References: <20190518213335.8115-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 May 2019 18:15:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Sat, 18 May 2019 23:33:35 +0200

> In nf-next, I had extended this script to also cover NAT support for the
> inet family.
> 
> In nf, I extended it to cover a regression with 'fully-random' masquerade.
> 
> Make this script work again by resolving the conflicts as needed.
> 
> Fixes: 8b4483658364f0 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  David, could you please take this directly?

Done, thanks Florian.
