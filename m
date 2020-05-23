Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E621DFBCF
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 01:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388118AbgEWX0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 19:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388010AbgEWX0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 19:26:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61434C061A0E;
        Sat, 23 May 2020 16:26:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3DB4D1285C6B5;
        Sat, 23 May 2020 16:26:46 -0700 (PDT)
Date:   Sat, 23 May 2020 16:26:12 -0700 (PDT)
Message-Id: <20200523.162612.1919894290900733612.davem@davemloft.net>
To:     michael@walle.cc
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, ujhelyi.m@gmail.com
Subject: Re: [PATCH net-next] net: phy: at803x: fix PHY ID masks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200522095331.21448-1-michael@walle.cc>
References: <20200522095331.21448-1-michael@walle.cc>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 23 May 2020 16:26:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>
Date: Fri, 22 May 2020 11:53:31 +0200

> Ever since its first commit 0ca7111a38f05 ("phy: add AT803x driver") the
> PHY ID mask was set to 0xffffffef. It is unclear to me why this mask was
> chosen in the first place. Both the AR8031/AR8033 and the AR8035
> datasheets mention it is always the given value:
>  - for AR8031/AR8033 its 0x004d/0xd074
>  - for AR8035 its 0x004d/0xd072
> 
> Unfortunately, I don't have a datasheet for the AR8030. Therefore, we
> leave its PHY ID mask untouched. For the PHYs mentioned before use the
> handy PHY_ID_MATCH_EXACT() macro.
> 
> I've tried to contact the author of the initial commit, but received no
> answer so far.
> 
> Cc: Matus Ujhelyi <ujhelyi.m@gmail.com>
> Signed-off-by: Michael Walle <michael@walle.cc>

Applied, thank you.
