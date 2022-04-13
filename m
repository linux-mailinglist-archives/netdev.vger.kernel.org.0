Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02F24FFE20
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 20:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237802AbiDMStV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 14:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237808AbiDMStU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 14:49:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C26B5A15C
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 11:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wx7Irgvpprq5MFw97jaorfDDTWM52CW6minngIUch9A=; b=GavrZ8xe9VYbENyfUmd4OiPyUG
        ufqD8s0n4LsAMZgJGm2/8TfrqbZRloNp0E9jHH4McDMprRwzXKLQn/dhF9UN2Wa05l1DuAGCjg816
        v/YCC/7pesG9eASuwqpWh2ZNjWGP0FF0wVr0AvGX9Uo6X3NhnyBM8GzHgxVrDP/yoCb0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nei0y-00FiEk-Ah; Wed, 13 Apr 2022 20:46:52 +0200
Date:   Wed, 13 Apr 2022 20:46:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 2/3] net: dsa: mv88e6xxx: fix BMSR error to be
 consistent with others
Message-ID: <YlcanGGBkxrKXvpD@lunn.ch>
References: <Ylb/vEWXHOmQ7sFd@shell.armlinux.org.uk>
 <E1negFh-005tSw-HG@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1negFh-005tSw-HG@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 05:53:57PM +0100, Russell King (Oracle) wrote:
> Other errors accessing the registers in mv88e6352_serdes_pcs_get_state()
> print "PHY " before the register name, except for the BMSR. Make this
> consistent with the other error messages.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
