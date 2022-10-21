Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39947607C29
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 18:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJUQ02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 12:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiJUQ0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 12:26:24 -0400
Received: from vps0.lunn.ch (unknown [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E2226C19D
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 09:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4gXq/PA3e2I/yY35u5w1JXrs1defCkRq0gILS73ixbo=; b=1DcDWWy1IuX4fhLW2HoIj8KcR1
        YUTvQBsNoKYNCQgKKI37t2btV9ir1jR1x87fidlhc4eyqaf0P+WSgzfqA2OKFsppZaNu92hrYljmH
        UubsTP/KThdfngPWEvXr7DVMX6JDi989YqBwbWDZ8uV3CTM8Fv280+sGrvO1BKoOLAg4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oluBw-000FLP-JI; Fri, 21 Oct 2022 17:44:12 +0200
Date:   Fri, 21 Oct 2022 17:44:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/7] net: sfp: check firmware provided max power
Message-ID: <Y1K+TJ1BJ7CqC/Lb@lunn.ch>
References: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
 <E1ol97r-00EDSX-8Z@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ol97r-00EDSX-8Z@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NEUTRAL,SPF_NEUTRAL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 02:28:51PM +0100, Russell King (Oracle) wrote:
> Check that the firmware provided maximum power is at least 1W, which
> iis the minimum power level for any SFP module.

is

> 
> Now that we enforce the minimum of 1W, we can exit early from
> sfp_module_parse_power() if the module power is 1W or less.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
