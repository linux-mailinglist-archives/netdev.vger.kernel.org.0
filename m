Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB2F51378B
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 06:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbfEDEvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 00:51:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56354 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfEDEvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 00:51:22 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EDACC14D97248;
        Fri,  3 May 2019 21:51:17 -0700 (PDT)
Date:   Sat, 04 May 2019 00:51:12 -0400 (EDT)
Message-Id: <20190504.005112.1264102313169100175.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: improve resuming from hibernation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1b6fc016-b4cd-a27a-216b-d17441072809@gmail.com>
References: <1b6fc016-b4cd-a27a-216b-d17441072809@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 21:51:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 1 May 2019 22:14:21 +0200

> I got an interesting report [0] that after resuming from hibernation
> the link has 100Mbps instead of 1Gbps. Reason is that another OS has
> been used whilst Linux was hibernated. And this OS speeds down the link
> due to WoL. Therefore, when resuming, we shouldn't expect that what
> the PHY advertises is what it did when hibernating.
> Easiest way to do this is removing state PHY_RESUMING. Instead always
> go via PHY_UP that configures PHY advertisement.
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=202851
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
