Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7850A244F75
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 23:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgHNVOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 17:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgHNVOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 17:14:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B867C061385
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 14:14:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5F32B12750CC8;
        Fri, 14 Aug 2020 13:57:35 -0700 (PDT)
Date:   Fri, 14 Aug 2020 14:14:20 -0700 (PDT)
Message-Id: <20200814.141420.112786533579828009.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     Jason@zx2c4.com, netdev@vger.kernel.org, thomas@sockpuppet.org,
        adhipati@tuta.io, dsahern@gmail.com, toke@redhat.com,
        alexei.starovoitov@gmail.com
Subject: Re: [PATCH net v4] net: xdp: account for layer 3 packets in
 generic skb handler
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200814083153.06b180b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200813140152.1aab6068@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAHmME9rbRrdV0ePxT0DgurGdEKOWiEi5mH5Wtg=aJwSA6fxwMg@mail.gmail.com>
        <20200814083153.06b180b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Aug 2020 13:57:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 14 Aug 2020 08:31:53 -0700

> I'm sure it comes up repeatedly because we don't return any errors,
> so people waste time investigating why it doesn't work.

+1
