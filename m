Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F1B49D5AE
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 23:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiAZWuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 17:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiAZWuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 17:50:16 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51445C06161C;
        Wed, 26 Jan 2022 14:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bsJ43rsX9/xKUt0cosEyzB1KK8mU+O0sfDNz58+hwX4=; b=U7LrV54n5uf4VALn9huJ+bso/e
        KRX3bpf47wOmGOEb3C62aFOaU0Jp1FgZMZKb69n033moM9KSAq6srSHKgeJS/gk9Dsq5KbZYAMeRo
        LITrsuZoGuMhl1QvjNO8cw4ZVbMRSlO6QalvGYQfc/ZYT1BQET2fm3X14iobtG8UePiNkdWYMqhA/
        x0soNUKMEIfazHPHjHfEwYiWCwCj8zJL0ZNgl40CNy10weUbdmP3YJtZ+bQxH3RFum3UCGPv13O+F
        QHNc0V8pdhJpr2xRcyrS/w6Zl4ha/IlWpegmugxaKUdGz0UVzyjnffz36l4zInvmBl/QQ1faxVzL6
        pjdK0iWw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56894)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nCr7E-0003sT-2V; Wed, 26 Jan 2022 22:50:12 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nCr7B-0004qk-8t; Wed, 26 Jan 2022 22:50:09 +0000
Date:   Wed, 26 Jan 2022 22:50:09 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: Signed-off-by missing for commits in the net-next
 tree
Message-ID: <YfHQIZ07stBQTNqm@shell.armlinux.org.uk>
References: <20220127075702.1b0b73c2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127075702.1b0b73c2@canb.auug.org.au>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 07:57:02AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Commits
> 
>   04a0683f7db4 ("net: stmmac: convert to phylink_generic_validate()")
>   f4c296c90976 ("net: stmmac: remove phylink_config.pcs_poll usage")
>   d194923d51c9 ("net: stmmac: fill in supported_interfaces")
>   92c3807b9ac3 ("net: stmmac: convert to phylink_get_linkmodes()")
>   be6ec5b70266 ("net: xpcs: add support for retrieving supported interface modes")
> 
> are missing a Signed-off-by from their author.

Hi Stephen,

Sigh, this is more vim stupidity. The commits _look_ fine in vim and
look fine in git log on an 80 column display, but that is because the
"Tested-by" line somehow ended up with the perfect amount of space
characters to make it so.

This is not the first time this has happened - it keeps happening, and
I've no clue why it keeps happening, other than rediculous vi behaviour.
I'm sorry, but I don't see any solution to it at the moment. Maybe
someone can suggest something that (a) prevents it happening when I
paste in the Tested-by line, and (b) makes vim show when lines in a
commit message are longer than 80 characters?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
