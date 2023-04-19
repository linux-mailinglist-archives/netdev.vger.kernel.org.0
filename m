Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2651B6E7DB1
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbjDSPL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjDSPL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:11:26 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B911446A8;
        Wed, 19 Apr 2023 08:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CLsGyhHaCztZiXY6HAX/Re51HeJ1+96UypASmTbOUbU=; b=MxFnUin+SwfbnkUk42BfXLEkR8
        Via3deom1gYYcKyCxEUZ2tQdPzgtrT6UJJAb/HmOwGUM7h8oilB8payqtfBAi4GZnmOOOl5cTkMh/
        3oeP8YtuQGWzKgPy3s0genBmdkO+vdRUdkOW8bQTQfcfWHori0ghAn+N+8ZKtnR9ODtk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pp9Su-00Ahwk-6R; Wed, 19 Apr 2023 17:11:24 +0200
Date:   Wed, 19 Apr 2023 17:11:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next] net: micrel: Update the list of supported phys
Message-ID: <dbb81161-107c-42bd-afde-5474387b6495@lunn.ch>
References: <20230418124713.2221451-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418124713.2221451-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 02:47:13PM +0200, Horatiu Vultur wrote:
> At the beginning of the file micrel.c there is list of supported PHYs.
> Extend this list with the following PHYs lan8841, lan8814 and lan8804,
> as these PHYs were added but the list was not updated.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

I have to wonder how useful the text is, but:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
