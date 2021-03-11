Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74CE337949
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbhCKQ0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:26:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52164 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234236AbhCKQ0o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 11:26:44 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lKO8w-00ANdX-Vz; Thu, 11 Mar 2021 17:26:34 +0100
Date:   Thu, 11 Mar 2021 17:26:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: of_mdio: Checking build dependencies
Message-ID: <YEpEuoRGh0KoWoGa@lunn.ch>
References: <a1a749e7-48be-d0ab-8fb5-914daf512ae9@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a1a749e7-48be-d0ab-8fb5-914daf512ae9@web.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 09:31:07PM +0100, Markus Elfring wrote:
> Hello,
> 
> I would like to build the Linux version “5.11.5” for my needs.
> But I stumbled on the following information.
> 
> …
>   AR      drivers/built-in.a
>   LD [M]  drivers/visorbus/visorbus.o
>   GEN     .version
>   CHK     include/generated/compile.h
> error: the following would cause module name conflict:
>   drivers/net/mdio/of_mdio.ko
>   drivers/of/of_mdio.ko

Hi Markus

Something wrong here. There should not be any of_mdio.ko in
drivers/of. That was the whole point of the patch you referenced, it
moved this file to drivers/net/mdio/. Please check where your
drivers/of/of_mdio.ko comes from. Has there been a bad merge conflict
resolution? Or is it left over from an older build?

   Andrew
