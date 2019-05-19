Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F35227FB
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 19:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbfESRr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 13:47:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39363 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726739AbfESRr6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 May 2019 13:47:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nGfJ2GuiWeyt9rdjobbqK26MJz6zWpxPp9VLVvLGkgg=; b=slfu0BFzLQZn1MmTp8hvrsCDeP
        n2F9RinHqlueAn0CJbdWP+F9UROtNCunHcWodts0o01XtaINKnv04y3eAUwf39bsJpe5iPFvWzywb
        ik0VOfEmH09QalAOH1lWpLPzll0uyscXaV+v12FeXr0ykAQtOae7BXuaeuEBdzHAOrU8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hSMOl-0005Vi-PL; Sun, 19 May 2019 16:02:47 +0200
Date:   Sun, 19 May 2019 16:02:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of_net: fix of_get_mac_address retval if compiled
 without CONFIG_OF
Message-ID: <20190519140247.GB30854@lunn.ch>
References: <1558268324-5596-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1558268324-5596-1-git-send-email-ynezz@true.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 19, 2019 at 02:18:44PM +0200, Petr Štetiar wrote:
> of_get_mac_address prior to commit d01f449c008a ("of_net: add NVMEM
> support to of_get_mac_address") could return only valid pointer or NULL,
> after this change it could return only valid pointer or ERR_PTR encoded
> error value, but I've forget to change the return value of
> of_get_mac_address in case where the kernel is compiled without
> CONFIG_OF, so I'm doing so now.
> 
> Cc: Mirko Lindner <mlindner@marvell.com>
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Fixes: d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
> Reported-by: Octavio Alvarez <octallk1@alvarezp.org>
> Signed-off-by: Petr Štetiar <ynezz@true.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
