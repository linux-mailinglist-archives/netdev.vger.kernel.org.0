Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C14244F8A
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 23:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgHNV06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 17:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgHNV05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 17:26:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC73C061385
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 14:26:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 445AE1275190F;
        Fri, 14 Aug 2020 14:10:11 -0700 (PDT)
Date:   Fri, 14 Aug 2020 14:26:56 -0700 (PDT)
Message-Id: <20200814.142656.1061722366614948972.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, thomas@sockpuppet.org,
        adhipati@tuta.io, dsahern@gmail.com, toke@redhat.com,
        alexei.starovoitov@gmail.com
Subject: Re: [PATCH net v4] net: xdp: account for layer 3 packets in
 generic skb handler
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHmME9rt-8Z1FJo9YSEqQHyEd1178cfizNa08BiakZYr+FR=Wg@mail.gmail.com>
References: <CAHmME9rbRrdV0ePxT0DgurGdEKOWiEi5mH5Wtg=aJwSA6fxwMg@mail.gmail.com>
        <20200814083153.06b180b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAHmME9rt-8Z1FJo9YSEqQHyEd1178cfizNa08BiakZYr+FR=Wg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Aug 2020 14:10:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 14 Aug 2020 23:04:56 +0200

> What? No. It comes up repeatedly because people want to reuse their
> XDP processing logic with layer 3 devices.

XDP is a layer 2 packet processing technology.  It assumes an L2
ethernet and/or VLAN header is going to be there.

Putting a pretend ethernet header there doesn't really change that.

