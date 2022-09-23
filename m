Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317735E81EA
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 20:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiIWSnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 14:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiIWSnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 14:43:35 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FB3A99FA;
        Fri, 23 Sep 2022 11:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5XVJhTPnv/t+6fNWcKxu2IRDvTLKyajV1YnmX0URcS0=; b=rUF601aHsv9XJmACsc7heUMnrC
        1uuGcdlc+2kBlVghvUiy48asWBYi+0u51WZOHivT6XVoLutNxPmtLmQ2v2woOqh5diAvyvqipM2VZ
        TGG48BpdwVPuFlQqbQBqbKB09Dib/WCxFth29uzzRFK3HKijZMFisfA6Zf8v4NPJVyDA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obne8-0003LR-TQ; Fri, 23 Sep 2022 20:43:32 +0200
Date:   Fri, 23 Sep 2022 20:43:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, prasanna.vengateshan@microchip.com,
        hkallweit1@gmail.com
Subject: Re: [Patch net-next v4 4/6] net: dsa: microchip: move interrupt
 handling logic from lan937x to ksz_common
Message-ID: <Yy3+VEbg7r1VRwMK@lunn.ch>
References: <20220922071028.18012-1-arun.ramadoss@microchip.com>
 <20220922071028.18012-5-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922071028.18012-5-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 12:40:26PM +0530, Arun Ramadoss wrote:
> To support the phy link detection through interrupt method for ksz9477
> based switch, the interrupt handling routines are moved from
> lan937x_main.c to ksz_common.c. The only changes made are functions
> names are prefixed with ksz_ instead of lan937x_.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
