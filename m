Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F396882F7
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbjBBPqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbjBBPqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:46:49 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84C67306C;
        Thu,  2 Feb 2023 07:46:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9+fymSbxhiLEc0P9K3B/Si7cNtPrW0w4+z9p60Rfe3E=; b=hi8V1AsbgGmnYAEa8QqEeZOJ1v
        5t24XU2o4D1I/o+xvGYREGy2uyc8tNY/oBohLqTkhlQ4m4ZZgEZNw3lo24UHLqO1Jx3rrhTSlpYZ4
        LssFUb3IfwoTzuggLYSitBhK2iskwCBU/6S6/Hx44NtwPyNkg+gdVgszBROmoZaxMuG8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNbSk-003uGu-D5; Thu, 02 Feb 2023 16:25:22 +0100
Date:   Thu, 2 Feb 2023 16:25:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk
Subject: Re: [RFC PATCH net-next 05/11] net: dsa: microchip: lan937x: add
 shared global interrupt
Message-ID: <Y9vV4vx1EVYgN57w@lunn.ch>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
 <20230202125930.271740-6-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202125930.271740-6-rakesh.sankaranarayanan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 06:29:24PM +0530, Rakesh Sankaranarayanan wrote:
> In cascade mode interrupt line is shared among both switches.

I assume this is specific to the board you are using. Other boards
could have two interrupts. It should not cause a problem marking it a
shared, but please update the commit message to indicate that the
interrupts don't need to be shared.

	Andrew
