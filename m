Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A03201C63
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 22:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389257AbgFSUaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 16:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387641AbgFSUaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 16:30:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E834DC06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 13:30:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B0BBE11D69C3E;
        Fri, 19 Jun 2020 13:30:06 -0700 (PDT)
Date:   Fri, 19 Jun 2020 13:30:05 -0700 (PDT)
Message-Id: <20200619.133005.1594645427872162132.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, kuba@kernel.org
Subject: Re: [PATCH net-next] ipv6: icmp6: avoid indirect call for
 icmpv6_send()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200619172748.15279-1-edumazet@google.com>
References: <20200619172748.15279-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 13:30:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 19 Jun 2020 10:27:48 -0700

> If IPv6 is builtin, we do not need an expensive indirect call
> to reach cmp6_send().
           ^^^^^^^^^

'icmp6_send', I fixed this up for you.

> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks.
