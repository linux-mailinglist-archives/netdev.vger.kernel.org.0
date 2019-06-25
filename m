Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02AE655819
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 21:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbfFYTrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 15:47:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49918 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbfFYTrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 15:47:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B0852126A2067;
        Tue, 25 Jun 2019 12:47:38 -0700 (PDT)
Date:   Tue, 25 Jun 2019 12:47:38 -0700 (PDT)
Message-Id: <20190625.124738.1945131933038317898.davem@davemloft.net>
To:     ssuryaextr@gmail.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] ipv4: Use return value of inet_iif() for
 __raw_v4_lookup in the while loop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190625001406.6437-1-ssuryaextr@gmail.com>
References: <20190625001406.6437-1-ssuryaextr@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Jun 2019 12:47:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>
Date: Mon, 24 Jun 2019 20:14:06 -0400

> In commit 19e4e768064a8 ("ipv4: Fix raw socket lookup for local
> traffic"), the dif argument to __raw_v4_lookup() is coming from the
> returned value of inet_iif() but the change was done only for the first
> lookup. Subsequent lookups in the while loop still use skb->dev->ifIndex.
> 
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>

Applied and queued up for -stable.

I added the appropriate Fixes: tag, please do so next time.
