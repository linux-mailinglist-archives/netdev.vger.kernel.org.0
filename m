Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7B46BD9C7
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 21:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjCPUDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 16:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjCPUDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 16:03:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BFDBCFC6;
        Thu, 16 Mar 2023 13:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9u+MxKyUpdzghNYI5jl8H878EOVIcBNhQCQTydCUx7Q=; b=Q0Y9n5DflaL6R0hE39z+H/OPR8
        bU95vQxwGNERx9UcJ9oc1y9pLiMLFq6Zi/sTIyjuTyTqGPu5F01U5/RPtuLzNchVtFvXjbbejNKeA
        QLtmZHCDWb7Z7xtZwB7FRrJMediSePgSZ8bmfvzDcnOosHuRmXGdF+FI1ceBc/AkK4Zc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pctoX-007XXA-93; Thu, 16 Mar 2023 21:03:05 +0100
Date:   Thu, 16 Mar 2023 21:03:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v1 1/1] net: phy: at803x: Replace of_gpio.h with
 what indeed is used
Message-ID: <04e7d5e1-f5a7-4b21-b357-9ee9dc8bbc9a@lunn.ch>
References: <20230316120826.14242-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316120826.14242-1-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 02:08:26PM +0200, Andy Shevchenko wrote:
> of_gpio.h in this driver is solely used as a proxy to other headers.
> This is incorrect usage of the of_gpio.h. Replace it .h with what
> indeed is used in the code.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
