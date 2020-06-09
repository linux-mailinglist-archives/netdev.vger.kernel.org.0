Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BEA1F47B8
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 22:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732808AbgFIUFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 16:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbgFIUFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 16:05:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD3FC05BD1E;
        Tue,  9 Jun 2020 13:05:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4BE4B1277496E;
        Tue,  9 Jun 2020 13:05:18 -0700 (PDT)
Date:   Tue, 09 Jun 2020 13:05:17 -0700 (PDT)
Message-Id: <20200609.130517.1373472507830142138.davem@davemloft.net>
To:     keescook@chromium.org
Cc:     stephen@networkplumber.org, o.rempel@pengutronix.de,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, corbet@lwn.net, mkubecek@suse.cz,
        linville@tuxdriver.com, david@protonic.nl, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux@armlinux.org.uk, mkl@pengutronix.de, marex@denx.de,
        christian.herber@nxp.com, amitc@mellanox.com, petrm@mellanox.com
Subject: Re: [PATCH ethtool v1] netlink: add master/slave configuration
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <202006091244.C8B5F9525@keescook>
References: <202006091222.CB97F743AD@keescook>
        <20200609.123437.1057990370119930723.davem@davemloft.net>
        <202006091244.C8B5F9525@keescook>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jun 2020 13:05:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Tue, 9 Jun 2020 12:49:48 -0700

> Okay, for now, how about:
> 
> - If we're dealing with an existing spec, match the language.

Yes.

> - If we're dealing with a new spec, ask the authors to fix their language.

Please be more specific about "new", if it's a passed and ratified standard
then to me it is "existing".

> - If a new version of a spec has updated its language, adjust the kernel's.

Unless you're willing to break UAPI, which I'm not, I don't see how this is
tenable.

> - If we're doing with something "internal" to the kernel (including UAPI),
>   stop adding new instances.

Even if it is part of supporting a technology where the standard uses
those terms?  So we'll use inconsitent terms internally?

This is why I'm saying, just make sure new specs use language that is
less controversial.  Then we just use what the specs use.

Then you don't have to figure out what to do about established UAPIs
and such, it's a non-issue.

