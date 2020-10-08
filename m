Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE16287978
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731717AbgJHPzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730353AbgJHPzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A52C0613D2;
        Thu,  8 Oct 2020 08:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YKTYv3JPQKTL1/nqMolBL2yUsaSBMs/1PQ3E4SOKSQc=; b=s7GXUsHZfsfMO0j2b20S5Iwmf
        qqQKbJL1kYZKdFehlP4+5Vzqx06eSUE4MdfFGU5cH53GhE+bYtM/3UFf7yHb+s48Xc6C76Zf58M46
        7vMBDzNpCLZABZzyOfKXvs6h3krAhoY1+SCCyglssOzq79767aMB7sPh+X0Iq2Rf8v0YQK8s7GmCF
        112Ge71g+0ZQpw7lJr9CsZcgqLjTjeB3QaOhOkjTd8P9FGUOE40Y6v9XgH3eKdTmjgx4fnpGUiqqF
        RipIpa9walKqAEK8YkyITGtkdZXeSi2NYMO4HvXzSMGNkgZzsxms3lWjhnzuJuCcof5cyVM5BwTJ8
        jvoKrQHvg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43526)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kQYG7-0006oB-Ux; Thu, 08 Oct 2020 16:55:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kQYG4-0001nV-FJ; Thu, 08 Oct 2020 16:55:08 +0100
Date:   Thu, 8 Oct 2020 16:55:08 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] ARM, timers: ebsa110 cleanup
Message-ID: <20201008155508.GL1551@shell.armlinux.org.uk>
References: <20201008154601.1901004-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008154601.1901004-1-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 05:45:58PM +0200, Arnd Bergmann wrote:
> The ebsa110 platform is the last thing that uses
> CONFIG_ARCH_USES_GETTIMEOFFSET, and Russell has previously said that he
> thinks the platform can be retired now.
> 
> Removing it allows us clean up the timer code by throwing out all of
> the references to arch_gettimeoffset().
> 
> The am79c961a network driver can presumably also go, as no other platform
> references it.

As far as I know, that is correct; it's rather specific to the
platform.

> I don't expect these to make it into the coming merge window, posting here
> as an RFC, and as a reference for the mildly related timer tick series.

For the ebsa110 and am79c961a patches:

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
