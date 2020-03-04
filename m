Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1659A178710
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 01:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgCDAev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 19:34:51 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43794 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727725AbgCDAev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 19:34:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WG3iPdftyaxe4JF5JBknRpB8gUrE1SSRMPAlrPJsmAw=; b=WtNevm5+K2WjRRR67Ed0jVpB6
        2oJaPGiNNJmApUlAltjHdWr9W/NretAGPe9Z6tevcgzgRk9L2yAT0tUbHxpOwAaek/kj+oBUg2DMe
        JyaA7k+NBSgfftFwLQGsOsS2Q0MpVXffr86yMK07g1Ig/U+ImfanNGrozJLMbwFJNcU9jmwFCB4h1
        sgd7H/znFf3SbrihoxKv1/LajzEzRX9qYpazbzDB//g1fE+iCmm7cKKvnfIVCV/itV6RmsQF5gvP6
        iGrgNxkcuKyFcnpfeGomwtjYtDu/0/koB1HvTX+Y3fBfsYWqE17Z1P80Tv0ZMyRI5HNBe9zsAQ1Eq
        lXxz6ZIWA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60064)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j9Hzo-00039p-FC; Wed, 04 Mar 2020 00:34:44 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j9Hzm-0006Mf-W2; Wed, 04 Mar 2020 00:34:43 +0000
Date:   Wed, 4 Mar 2020 00:34:42 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] doc: sfp-phylink: correct code indentation
Message-ID: <20200304003442.GW25745@shell.armlinux.org.uk>
References: <E1j97cE-0004aW-Ur@rmk-PC.armlinux.org.uk>
 <20200303.153546.1011655145785464830.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303.153546.1011655145785464830.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 03:35:46PM -0800, David Miller wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> Date: Tue, 03 Mar 2020 13:29:42 +0000
> 
> > Using vim to edit the phylink documentation reveals some mistakes due
> > to the "invisible" pythonesque white space indentation that can't be
> > seen with other editors. Fix it.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> I applied this, but you do know that GIT is going to warn about the
> trailing whitespace to me:
> 
> .git/rebase-apply/patch:29: trailing whitespace.
> 	
> .git/rebase-apply/patch:39: trailing whitespace.
> 	
> warning: 2 lines add whitespace errors.
> 
> Do the empty lines really need that leading TAB?

If vim's syntax colouring is correct, then it does need the tab for
the code sequence to be recognised as a block of code.

As kerneldoc is based on python, and white-space indentation defining
a block of code is a very (annoying) pythonesque thing, it seems that
vim's probably correct.  But... unless someone knows how the .rst
format really works...

It could be that vim's syntax colouring for .rst files is broken.
I was hoping that the documentation people would've spoken up about
that though, as I explicitly stated in the commit message that the
patch was based on vim's behaviour.

Not having the tabs causes vim to reverse-bold a lot of the file,
making it basically uneditable without sunglasses.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
