Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3040282C5
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731679AbfEWQTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:19:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48336 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731254AbfEWQTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:19:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 12E461509B033;
        Thu, 23 May 2019 09:19:49 -0700 (PDT)
Date:   Thu, 23 May 2019 09:19:48 -0700 (PDT)
Message-Id: <20190523.091948.2094790534090543013.davem@davemloft.net>
To:     christophe.leroy@c-s.fr
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: phy: lxt: Add suspend/resume support
 to LXT971 and LXT973.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <eb206b659fcae041be38d583ff139ca73e9e03c3.1558601485.git.christophe.leroy@c-s.fr>
References: <eb206b659fcae041be38d583ff139ca73e9e03c3.1558601485.git.christophe.leroy@c-s.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 May 2019 09:19:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>
Date: Thu, 23 May 2019 08:55:32 +0000 (UTC)

> All LXT PHYs implement the standard "power down" bit 11 of
> BMCR, so this patch adds support using the generic
> genphy_{suspend,resume} functions added by
> commit 0f0ca340e57b ("phy: power management support").
> 
> LXT970 is left aside because all registers get cleared upon
> "power down" exit.
> 
> Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> ---
>  I'd be happy if you could also merge that into 4.19
> 
>  v2: revised commit log without the Fixes: tag.

Applied, thanks.
