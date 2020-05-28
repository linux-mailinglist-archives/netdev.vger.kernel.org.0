Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5B91E61B9
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 15:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390164AbgE1NIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 09:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390031AbgE1NH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 09:07:57 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2EEC05BD1E;
        Thu, 28 May 2020 06:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=AgMZqRxoCy8rqfWHTToRmSRQg8xj5R1Vkp6Ow/licx4=; b=ZyPL7jsaUCBkamHr9S2fjPIhE
        vSvABh6xa8JkUaP8do07SNACxsHAeVn4RUSEr0VDUKlLRfLJL86JAtARqgyZz6snVBirVZNe301cc
        icm8k0sPqxQ29+/HwaqAkrVDYE1E1/l3jnrtJEvY5hByHNBMjUZN0izco9Q1JaRzWduqbkgEOawLZ
        bICmBrFEFIWUQK11KDTMQCPrUlzd5igxilOklClfI8nJwHLbJWQZKk6MWJAptmOvR/ljVZn9HU24w
        tpVSQCtoAo0OQSvhKO+WNnMMvDbF8BIuUtBYE5Y235A38zOQUL64gW6m+9M9wqspUBJ1TAr6XfQkA
        IGmlVViAQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:35686)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jeIG6-0005PA-R4; Thu, 28 May 2020 14:07:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jeIG2-0007Ud-L2; Thu, 28 May 2020 14:07:38 +0100
Date:   Thu, 28 May 2020 14:07:38 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Enable autoneg bypass for
 1000BaseX/2500BaseX ports
Message-ID: <20200528130738.GT1551@shell.armlinux.org.uk>
References: <20200528121121.125189-1-tbogendoerfer@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528121121.125189-1-tbogendoerfer@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 02:11:21PM +0200, Thomas Bogendoerfer wrote:
> Commit d14e078f23cc ("net: marvell: mvpp2: only reprogram what is necessary
>  on mac_config") disabled auto negotiation bypass completely, which breaks
> platforms enabling bypass via firmware (not the best option, but it worked).
> Since 1000BaseX/2500BaseX ports neither negotiate speed nor duplex mode
> we could enable auto negotiation bypass to get back information about link
> state.

Thanks, but your commit is missing some useful information.

Which platforms have broken?

Can you describe the situation where you require this bit to be set?

We should not be enabling bypass mode as a matter of course, it exists
to work around broken setups which do not send the control word.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
