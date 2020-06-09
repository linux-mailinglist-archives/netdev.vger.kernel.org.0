Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0661F4721
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 21:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730869AbgFITen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 15:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgFITel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 15:34:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF3FC05BD1E;
        Tue,  9 Jun 2020 12:34:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D89E127693CE;
        Tue,  9 Jun 2020 12:34:39 -0700 (PDT)
Date:   Tue, 09 Jun 2020 12:34:37 -0700 (PDT)
Message-Id: <20200609.123437.1057990370119930723.davem@davemloft.net>
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
In-Reply-To: <202006091222.CB97F743AD@keescook>
References: <20200609101935.5716b3bd@hermes.lan>
        <20200609.113633.1866761141966326637.davem@davemloft.net>
        <202006091222.CB97F743AD@keescook>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jun 2020 12:34:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Tue, 9 Jun 2020 12:29:54 -0700

> Given what I've seen from other communities and what I know of the kernel
> community, I don't think we're going to get consensus on some massive
> global search/replace any time soon. However, I think we can get started
> on making this change with just stopping further introductions. (I view
> this like any other treewide change: stop new badness from getting
> added, and chip away as old ones as we can until it's all gone.)

The terminology being suggested by these changes matches what is used
in the standards and literature.

Inventing something creates confusion for those who are familiar with
these pieces of technology already, and those who are not who are
reading about it elsewhere.

Both groups will be terminally confused if we use different words.

For such pain, there should be agood reason.  I don't accept Stephen's
quoted standards bodies "efforts" as a legitimate reason, or evidence
of such, as it has a lot of holes in it as Edward pointed out.  I
found the Orwell references to be quite ironic actually.
