Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4168598E0A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346007AbiHRU2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346053AbiHRU2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:28:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3B4AE5B;
        Thu, 18 Aug 2022 13:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jKpiB6JnnQIbIJhy62ACwjoGB+7ke5cmHK3Hvr3hZaE=; b=onVTb+EVSOtgVMmBagauhRhcQe
        jT4+Jbdvz+a3KFnwuV/tgPD7EVKfHeeZD7H5vUu1ECQz15PIxKcGzZQ+Zwd8acvs9R+qNqWbKVDn6
        kbZMJOhQT/7YVHNzzRVOoqb5OKDWqBAL9Hhr6DK1Qfzb/rGW/F7uO32dDz0xB/9k9sLE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOm85-00DqEp-Bu; Thu, 18 Aug 2022 22:28:37 +0200
Date:   Thu, 18 Aug 2022 22:28:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     wei.fang@nxp.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 net 2/2] net: phy: at803x: add disable hibernation
 mode support
Message-ID: <Yv6g9c0AcPEJO0h+@lunn.ch>
References: <20220818030054.1010660-1-wei.fang@nxp.com>
 <20220818030054.1010660-3-wei.fang@nxp.com>
 <Yv6TA9xfx4m2+YrH@lunn.ch>
 <20220818125801.54472864@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818125801.54472864@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 12:58:01PM -0700, Jakub Kicinski wrote:
> On Thu, 18 Aug 2022 21:29:07 +0200 Andrew Lunn wrote:
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> Any guidance on net / net-next and Fixes, Andrew?
> 
> Seems like a "this never worked" / "we haven't supported such platforms"
> case, perhaps?

That was what i was thinking, which is why i did not question a
missing Fixes tag. So net-next.

	Andrew
