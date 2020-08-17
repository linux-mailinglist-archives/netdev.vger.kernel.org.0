Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2FA5247962
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 00:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgHQWAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 18:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729130AbgHQWAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 18:00:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058C1C061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 15:00:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBA5915D695B8;
        Mon, 17 Aug 2020 14:43:28 -0700 (PDT)
Date:   Mon, 17 Aug 2020 15:00:14 -0700 (PDT)
Message-Id: <20200817.150014.416333182139064133.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next] selftests: disable rp_filter for
 icmp_redirect.sh
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200817154333.99444-1-dsahern@kernel.org>
References: <20200817154333.99444-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Aug 2020 14:43:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Mon, 17 Aug 2020 09:43:33 -0600

> h1 is initially configured to reach h2 via r1 rather than the
> more direct path through r2. If rp_filter is set and inherited
> for r2, forwarding fails since the source address of h1 is
> reachable from eth0 vs the packet coming to it via r1 and eth1.
> Since rp_filter setting affects the test, explicitly reset it.
> 
> Signed-off-by: David Ahern <dsahern@kernel.org>

As a bug fix I've applied this to 'net', thanks David.
