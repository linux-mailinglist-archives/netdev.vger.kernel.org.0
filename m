Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59FB317DCA0
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 10:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgCIJsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 05:48:41 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46130 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgCIJsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 05:48:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nSJNGXFyVDQ2itUaKXiFjGJN5YfrTxvZ56JJEF7tJy4=; b=rJ9lPRs6LbaOJ2ZVQZKOZTGeB
        hwBpBnUKLaueLCDHaZAR3tv1sm8W9dd+cZVGkWBZmQHn7/GJhv2A9RXam7qlkoLFQzCVM6XqjYksk
        fVV8Z7Duj8pPyT6MECIUcLeKWIgvlufmu6frwxNQLjCFLX7jSTBlM0nMh3VRQNF1YyskG1b/OutYJ
        P+q9pNERxvnBn44SLiMm62i78YC0f4fhxJrEsasBtSZH5MbQ5vVVQph3K6zfVkMTB8RbbL4WZTco8
        Ys33kCxiwYQ2auGlM22AoIb8DWyd1ITZKhMOPoCIvbMtk3opNozpB5loGMTL6mNAknsUdNnf5y3u4
        Iy1JJUJfA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:50664)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jBF1U-0005ju-7p; Mon, 09 Mar 2020 09:48:32 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jBF1Q-0003Hs-Uk; Mon, 09 Mar 2020 09:48:28 +0000
Date:   Mon, 9 Mar 2020 09:48:28 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH net-next 0/10] net: dsa: improve serdes integration
Message-ID: <20200309094828.GJ25745@shell.armlinux.org.uk>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
 <20200308.220447.1610295462041711848.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200308.220447.1610295462041711848.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 08, 2020 at 10:04:47PM -0700, David Miller wrote:
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Date: Thu, 5 Mar 2020 12:41:39 +0000
> 
> > Andrew Lunn mentioned that the Serdes PCS found in Marvell DSA switches
> > does not automatically update the switch MACs with the link parameters.
> > Currently, the DSA code implements a work-around for this.
> > 
> > This series improves the Serdes integration, making use of the recent
> > phylink changes to support split MAC/PCS setups.  One noticable
> > improvement for userspace is that ethtool can now report the link
> > partner's advertisement.
> 
> It looks like Andrew's regression has to be sorted out, so I'm deferring
> this.

Yep - it comes from the poor integration of phylink into DSA for CPU
and inter-DSA ports which is already causing regressions in today's
kernels. That needs resolving somehow before this patch series can
be merged, but it isn't something that can be fixed from the phylink
side of things.

I'll postpone these patches until that issue is resolved.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
