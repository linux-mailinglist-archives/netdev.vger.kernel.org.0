Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250DF1C62FD
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 23:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgEEVXf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 May 2020 17:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726350AbgEEVXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 17:23:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66C4C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 14:23:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 477E71281606D;
        Tue,  5 May 2020 14:23:33 -0700 (PDT)
Date:   Tue, 05 May 2020 14:23:22 -0700 (PDT)
Message-Id: <20200505.142322.2185521151586528997.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, netdev@vger.kernel.org, edumazet@google.com,
        willemb@google.com, lucien.xin@gmail.com,
        hannes@stressinduktion.org
Subject: Re: [PATCH] Revert "ipv6: add mtu lock check in
 __ip6_rt_update_pmtu"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505185723.191944-1-zenczykowski@gmail.com>
References: <20200505185723.191944-1-zenczykowski@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 May 2020 14:23:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Tue,  5 May 2020 11:57:23 -0700

> The above reasoning is incorrect.  IPv6 *requires* icmp based pmtu to work.
> There's already a comment to this effect elsewhere in the kernel:

How can an internet standard specify a system local policy decision
on this level?

If I want to lock the MTU value on my ipv6 routes, I have a reason
and I should be able to do it.
