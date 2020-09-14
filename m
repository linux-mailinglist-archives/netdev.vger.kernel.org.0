Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB5F269782
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgINVOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgINVOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 17:14:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7E3C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 14:14:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A71C6127F71C7;
        Mon, 14 Sep 2020 13:58:05 -0700 (PDT)
Date:   Mon, 14 Sep 2020 14:14:51 -0700 (PDT)
Message-Id: <20200914.141451.26557309568166924.davem@davemloft.net>
To:     W_Armin@gmx.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5 0/6] 8390: core cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200914210128.7741-1-W_Armin@gmx.de>
References: <20200914210128.7741-1-W_Armin@gmx.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 13:58:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>
Date: Mon, 14 Sep 2020 23:01:22 +0200

> The purpose of this patchset is to do some
> cleanups in lib8390.c and 8390.c

A lot of these changes are borderline beneficial, at best.

You are adding include files to foo.c files that are already included
by lib8390.c already (which the foo.c file includes).  This is
redundant and makes the compiler work harder.  lib8390.c is
designed to work like this.

Your first patch mixes comment formatting with actual code
changes (adding new curly braces and such).

And so on and so forth...

I honestly don't like this patch series at all.

If you were about to add a big new feature to the 8390 code
and wanted to clean it up first before doing so, maybe I'd
be ok with these changes.  But as a pure cleanup, sorry I'm
not going to apply this stuff.
