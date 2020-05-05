Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531C51C63AC
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 00:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgEEWJz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 May 2020 18:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbgEEWJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 18:09:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE5DC061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 15:09:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 940891281C39F;
        Tue,  5 May 2020 15:09:54 -0700 (PDT)
Date:   Tue, 05 May 2020 15:09:51 -0700 (PDT)
Message-Id: <20200505.150951.1869532656064502918.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, willemb@google.com,
        lucien.xin@gmail.com, hannes@stressinduktion.org
Subject: Re: [PATCH] Revert "ipv6: add mtu lock check in
 __ip6_rt_update_pmtu"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CANP3RGfVbvSRath6Ajd6_xzVrcK1dci=fFLMAGEogrT54fuudw@mail.gmail.com>
References: <20200505185723.191944-1-zenczykowski@gmail.com>
        <20200505.142322.2185521151586528997.davem@davemloft.net>
        <CANP3RGfVbvSRath6Ajd6_xzVrcK1dci=fFLMAGEogrT54fuudw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 May 2020 15:09:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Tue, 5 May 2020 14:56:03 -0700

> There's *lots* of places where internet standards prevent Linux from
> doing various things.

"Linux" generally speaking?

That's true only if "rm -rf net/netfilter/ net/ipv4/netfilter net/ipv6/netfilter"

Also, insert an XDP program... --> "non compliant"

And so on and so forth. :-)

It's local system policy, how do I react to packets.  If it doesn't
violate the min/max limits for ipv6 packets it emits onto the internet
I don't see this as something that can be seen as mandatory.
