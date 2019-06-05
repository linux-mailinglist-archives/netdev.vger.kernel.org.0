Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6E735597
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 05:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfFEDQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 23:16:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56438 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfFEDQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 23:16:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D2DD21504780F;
        Tue,  4 Jun 2019 20:16:49 -0700 (PDT)
Date:   Tue, 04 Jun 2019 20:16:49 -0700 (PDT)
Message-Id: <20190604.201649.1043642315375439258.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, ecree@solarflare.com, edumazet@google.com
Subject: Re: [PATCH net v2] net: fix indirect calls helpers for ptype list
 hooks.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <678856f4fc73bbcd0de07a97c9d59996b6b8b585.1559641396.git.pabeni@redhat.com>
References: <678856f4fc73bbcd0de07a97c9d59996b6b8b585.1559641396.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 20:16:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Tue,  4 Jun 2019 11:44:06 +0200

> As Eric noted, the current wrapper for ptype func hook inside
> __netif_receive_skb_list_ptype() has no chance of avoiding the indirect
> call: we enter such code path only for protocols other than ipv4 and
> ipv6.
> 
> Instead we can wrap the list_func invocation.
> 
> v1 -> v2:
>  - use the correct fix tag
> 
> Fixes: f5737cbadb7d ("net: use indirect calls helpers for ptype hook")
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Acked-by: Edward Cree <ecree@solarflare.com>

Applied.
