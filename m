Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7221C7CD9
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbgEFVxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728621AbgEFVxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:53:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0EEC061A0F;
        Wed,  6 May 2020 14:53:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 524E71273D974;
        Wed,  6 May 2020 14:53:50 -0700 (PDT)
Date:   Wed, 06 May 2020 14:53:50 -0700 (PDT)
Message-Id: <20200506.145350.728374693225810455.davem@davemloft.net>
To:     michael@walle.cc
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, vladimir.oltean@nxp.com,
        antoine.tenart@bootlin.com
Subject: Re: [PATCH net-next v3 0/3] add phy shared storage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200506145315.13967-1-michael@walle.cc>
References: <20200506145315.13967-1-michael@walle.cc>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 14:53:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>
Date: Wed,  6 May 2020 16:53:12 +0200

> Introduce the concept of a shared PHY storage which can be used by some
> QSGMII PHYs to ease initialization and access to global per-package
> registers.
> 
> Changes since v2:
>  - restore page to standard after reading the base address in the mscc
>    driver, thanks Antoine.
> 
> Changes since v1:
>  - fix typos and add a comment, thanks Florian.
>  - check for "addr < 0" in phy_package_join()
>  - remove multiple blank lines and make "checkpatch.pl --strict" happy
> 
> Changes since RFC:
>  - check return code of kzalloc()
>  - fix local variable ordering (reverse christmas tree)
>  - add priv_size argument to phy_package_join()
>  - add Tested-by tag, thanks Vladimir.

Series applied, thank you.
