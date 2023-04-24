Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821866ED27C
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 18:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbjDXQa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 12:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbjDXQa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 12:30:58 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DF82722
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 09:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QjstpK/tKEKE271cbJrHn3L4jUMI/n7Qgpg6VGkYPwg=; b=0Iz9LvEMfeTysQVfJkf43S430P
        dCxdGki44UVqTFDLvVL0hox3wKvuOwYaG4Qk+RhhXa42Aa6smih/IcGlIpQX5XW6vf0uEoCSXe5R0
        +y6mxIgMe4LW/z28s4Jf/msvoOPFeQxL0cpD0w2aUypqQlOYqA1eMtnfT2W4V45/anw0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pqz5R-00B6hh-R9; Mon, 24 Apr 2023 18:30:45 +0200
Date:   Mon, 24 Apr 2023 18:30:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/1] net: phy: Fix reading LED reg property
Message-ID: <d2a02004-7d81-4b8b-8c54-312c7aa66315@lunn.ch>
References: <20230424141648.317944-1-alexander.stein@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424141648.317944-1-alexander.stein@ew.tq-group.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 04:16:48PM +0200, Alexander Stein wrote:
> 'reg' is always encoded in 32 bits, thus it has to be read using the
> function with the corresponding bit width.
> 
> Fixes: 01e5b728e9e4 ("net: phy: Add a binding for PHY LEDs")
> Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
