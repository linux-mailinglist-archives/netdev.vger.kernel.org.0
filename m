Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E6623F8F4
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 23:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgHHVH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 17:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgHHVH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 17:07:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6851DC061756;
        Sat,  8 Aug 2020 14:07:56 -0700 (PDT)
Received: from localhost (50-47-102-2.evrt.wa.frontiernet.net [50.47.102.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D7A33127275C4;
        Sat,  8 Aug 2020 13:51:05 -0700 (PDT)
Date:   Sat, 08 Aug 2020 14:07:50 -0700 (PDT)
Message-Id: <20200808.140750.1862486660155161038.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC 0/4] netlink: binary attribute range validation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200805140324.72855-1-johannes@sipsolutions.net>
References: <20200805140324.72855-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 08 Aug 2020 13:51:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed,  5 Aug 2020 16:03:20 +0200

> This is something I'd been thinking about for a while; we already
> have NLA_MIN_LEN, NLA_BINARY (with a max len), and NLA_EXACT_LEN,
> but in quite a few places (as you can see in the last patch here)
> we need a range, and we already have a way to encode ranges for
> integer ranges, so it's pretty easy to use that for binary length
> ranges as well.
> 
> So at least for wireless this seems useful to save some code, and
> to (mostly) expose the actual limits to userspace via the policy
> export that we have now.
> 
> What do you think?

This looks great to me.
