Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C563269D630
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 23:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbjBTWM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 17:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbjBTWMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 17:12:55 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E21C3583;
        Mon, 20 Feb 2023 14:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sHT69Pcxg42yL1CYvz0YQD+Q5YjZ9X6LjI+IheSRHKA=; b=OBP5jB/Ti491wRbqAdiq3B4+dw
        MYo8n185Qawan5IoHGFD+/8KntEpZjNOq5ViFut1p4bdyXlDuySmR8StvQk0dVKnQFHhgnXAQwT6P
        3I0kn7WFGCl1mKE8UwHXEF1Z89KtwXcNh68KaA4XFAQbXraLhM6GDX3s0mcYx3Zt7ODw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pUEOp-005XYT-F9; Mon, 20 Feb 2023 23:12:43 +0100
Date:   Mon, 20 Feb 2023 23:12:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: micrel: drop superfluous use of temp variable
Message-ID: <Y/PwWzO6HVkf/whr@lunn.ch>
References: <20230220203930.31989-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220203930.31989-1-wsa+renesas@sang-engineering.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 09:39:30PM +0100, Wolfram Sang wrote:
> 'temp' was used before commit c0c99d0cd107 ("net: phy: micrel: remove
> the use of .ack_interrupt()") refactored the code. Now, we can simplify
> it a little.
> 
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Hi Wolfram

netdev has a few process things which other subsystems do not
have. Take a look at

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html

This should be for net-next. It could be that tree is already closed
for the merge window.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
