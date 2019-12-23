Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2150C12980A
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 16:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfLWPYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 10:24:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38378 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726733AbfLWPYL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 10:24:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WxhSTHErLYeR2xHJjtvGbHdEpZYHP8nE7fCcMzqkLxw=; b=EC+KEDyXA5qigr0fOio5UOp5Lj
        twfjpAZPPSiycoFg8GkflmX7znEdhgICR4BW/s/jxO9ubwzBVbfczcYeZ452vpiAnJ6Cud0QLnLh2
        hV7ApBEbu3LTvDngxxWipuMZDsxYrGkKob0GK9UfWJdFv+vYbziuId7TZ3kOqu2jZ+1I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ijPZ1-0005HR-KC; Mon, 23 Dec 2019 16:24:07 +0100
Date:   Mon, 23 Dec 2019 16:24:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, Antoine Tenart <antoine.tenart@bootlin.com>
Subject: Re: [PATCH net] of: mdio: mark stub of_mdiobus_child_is_phy as inline
Message-ID: <20191223152407.GM32356@lunn.ch>
References: <20191223132443.115540-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191223132443.115540-1-Jason@zx2c4.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 02:24:43PM +0100, Jason A. Donenfeld wrote:
> The of_mdiobus_child_is_phy function was recently exported, with a stub
> fallback added to simply return false as a static function. The inline
> specifier was left out, leading to build time errors:
> 
> In file included from linux/include/linux/fs_enet_pd.h:21,
>                  from linux/arch/powerpc/sysdev/fsl_soc.c:26:
> linux/include/linux/of_mdio.h:58:13: error: ‘of_mdiobus_child_is_phy’ defined but not used [-Werror=unused-function]
>    58 | static bool of_mdiobus_child_is_phy(struct device_node *child)
>       |             ^~~~~~~~~~
> 
> This commit simply adds the missing inline keyboard.

Hi Jason

It is a good idea to search the netdev list before fixing things like
this:

https://lkml.org/lkml/2019/12/23/128

	Andrew
