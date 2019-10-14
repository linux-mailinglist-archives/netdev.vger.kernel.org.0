Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31014D6C1E
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 01:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfJNXhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 19:37:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45390 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbfJNXhw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 19:37:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=d4mCYtvEPTzglZNeImUyIfxvfWzkPyFU8qYa2EzIa0Y=; b=W9rKbQjXFiJposmErGr1ODlbf1
        64rmRlwgvDXuCA+xwTWf/CDRYEV4SbPKok/jQU+5Ssbks859RZQlFIUEKMWqeWs4EMLEfs1Sdm0J1
        P9J3FRfpzFFZ1wrd1Rl9I4So5PdTh76P9UM1kkmaSmjN5kf4nTUCR9Y2M2sdYlMCX1HU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iK9uK-00077B-8O; Tue, 15 Oct 2019 01:37:44 +0200
Date:   Tue, 15 Oct 2019 01:37:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nishad Kamdar <nishadkamdar@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: sja1105: Use the correct style for SPDX
 License Identifier
Message-ID: <20191014233744.GE19861@lunn.ch>
References: <20191014162116.GA5024@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014162116.GA5024@nishad>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 09:51:20PM +0530, Nishad Kamdar wrote:
> This patch corrects the SPDX License Identifier style
> in header files related to Distributed Switch Architecture
> drivers for NXP SJA1105 series Ethernet switch support.
> It uses an expilict block comment for the SPDX License
> Identifier.
> 
> Changes made by using a script provided by Joe Perches here:
> https://lkml.org/lkml/2019/2/7/46.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
