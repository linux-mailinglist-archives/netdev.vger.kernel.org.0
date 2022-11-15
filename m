Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA16F62A07A
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 18:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbiKORhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 12:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbiKORhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 12:37:09 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A360A2F3AE;
        Tue, 15 Nov 2022 09:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=rMk4+gHnHkTirntfcZ/oelMVsKIitCeDuk0dIUdBwjU=; b=FXApykP3BafnKZP2liKXqpyq9w
        krOhtejmysRYJUQypobOfTMFh/30QrzljYFpZmORJxxREsj3FJXLKbLvZ9PALthyGtGP+yjYn41ti
        +ClfCpBERpX1EK0ft2yH7bY8MCH4d7Kc4UUVY5weZ1JCSEUAyMC3mAK6c4mMqDljto3Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ouzrY-002TwZ-5A; Tue, 15 Nov 2022 18:36:44 +0100
Date:   Tue, 15 Nov 2022 18:36:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next][PATCH v2 2/2] dsa: lan9303: Add 2 ethtool stats
Message-ID: <Y3POLKvNwPMA+GYk@lunn.ch>
References: <20221115165131.11467-1-jerry.ray@microchip.com>
 <20221115165131.11467-2-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115165131.11467-2-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 10:51:31AM -0600, Jerry Ray wrote:
> Adding RxDropped and TxDropped counters to the reported statistics.
> As these stats are kept by the switch rather than the port instance,
> they are indexed differently.
> 
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>

Hi Jerry

Your Subject line is not as we would like. For your next patchset,
please take a look at the netdev FAQ. You should also have a patch 0/X
explaining the big picture.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
	   
