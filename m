Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEE56DD83F
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 12:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjDKKsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 06:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDKKsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 06:48:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1830A1FF3
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 03:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OGrVQoBjXuEW2/DrJf0WZkJMUYv4cbdKzAw7t5Wbhgo=; b=U9DBkAlnNFYaWy9qwMYzNT5Au3
        YKx9X7dBexcRGL2nMCrOu8p75HtiXKH1oiNmbsTYeqq22Zi2U/+gT+ZRl+6og4Z+pF7ltljpjkfa+
        WJdrYZgk8MzKZXJdJVFPRVzGqlHgtkoLSzBb7K9vKvyOGYn6dJN5hemCDGI+F3WWmrdhxWrMTvu9Q
        67JyXWgx+YvVnzH6TSu/bDwR0QLxk2RW/71/eIvB1b0yJJQU6Ky3ZClOBiwwrN3PCXmzaJ2VBpfBc
        SfFHtKvwwIlmoSwVYb6RJzWSp39hQkG/vssu1PFz11rdKMXIkLX81w50yqAd+9EoocdtW47U/s1DJ
        jDgxJaRQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34404)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pmBXm-0005nx-PI; Tue, 11 Apr 2023 11:48:10 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pmBXj-00042v-9I; Tue, 11 Apr 2023 11:48:07 +0100
Date:   Tue, 11 Apr 2023 11:48:07 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Correct cmode to
 PHY_INTERFACE_
Message-ID: <ZDU653sHJGUX1+Pr@shell.armlinux.org.uk>
References: <20230411023541.2372609-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411023541.2372609-1-andrew@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 04:35:41AM +0200, Andrew Lunn wrote:
> The switch can either take the MAC or the PHY role in an MII or RMII
> link. There are distinct PHY_INTERFACE_ macros for these two roles.
> Correct the mapping so that the `REV` version is used for the PHY
> role.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

> Since this has not caused any known issues so far, i decided to not
> add a Fixes: tag and submit for net.

I concur.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
