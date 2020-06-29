Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C9620E034
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731621AbgF2Un6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731619AbgF2TOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A731EC08C5DC
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 21:00:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 58C3211939C24;
        Sun, 28 Jun 2020 21:00:12 -0700 (PDT)
Date:   Sun, 28 Jun 2020 21:00:11 -0700 (PDT)
Message-Id: <20200628.210011.572459086884874043.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     colton.w.lewis@protonmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v3] net: phylink: correct trivial kernel-doc
 inconsistencies
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200628222036.GR1551@shell.armlinux.org.uk>
References: <20200628093634.GQ1551@shell.armlinux.org.uk>
        <6541539.18pcnM708K@laptop.coltonlewis.name>
        <20200628222036.GR1551@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 28 Jun 2020 21:00:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Sun, 28 Jun 2020 23:20:36 +0100

> On Sun, Jun 28, 2020 at 09:36:35PM +0000, Colton Lewis wrote:
>> > We seem to be having a communication breakdown.  In review to your
>> > version 2 patch set, I said:
>> > 
>> >    However, please drop all your changes for everything but the
>> >    "struct phylink_config" documentation change; I'm intending to change
>> >    all these method signatures, which means your changes will conflict.
>> > 
>> > But the changes still exist in version 3.  What gives?
>> 
>> You said *drop all your changes* for *everything but* the struct phylink_config change. I interpreted this to mean you wanted *only* struct phylink_config. In context of your previous comments, I might have guessed you meant the opposite.
> 
> It seems we're using different versions of English, because your v4 is
> still wrong.

Aha, ok I'll revert then, thanks.
