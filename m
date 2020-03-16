Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E28501869CB
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 12:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730734AbgCPLPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 07:15:47 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49732 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730560AbgCPLPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 07:15:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=htZxvhBOOCtQQilHGnlgGytNJvDCC5AIMcyzCkfXSn4=; b=wanAcuRe1DhZ7dgiLtVdIET/v
        n86QerCLgwANL+tWOLfIxMguYU2KvarqVUE0q32TwJ9hS/GqG6gNcagw6hbLMMuh9vfjp1l/mIpzI
        p8D1IBxnKOInk9EY4g1aHukiTYx1QPsdID3/FdBzBFgDsu/SgYdavI2sw3qdv50LKmgdiSzr/xMcd
        pD0LaX86mZV+YpkfdH06mFCGTAoVtXyRm9PDTz+hQA11mu0es9mxc59JGMEaaUb4NlcwIfKxcGQMp
        PwBRG1bKtVI9OLWAWKsVNGgwObXyY7mPrKfNjriozVtvAN1oyxDVrxdfyWoElm+cFKeIu+RoY6orJ
        wdQb9Em2Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37176)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jDniT-0000bi-Ru; Mon, 16 Mar 2020 11:15:30 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jDniO-0001lv-TO; Mon, 16 Mar 2020 11:15:24 +0000
Date:   Mon, 16 Mar 2020 11:15:24 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20200316111524.GE5827@shell.armlinux.org.uk>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <e2b53d14-7258-0137-79bc-b0a21ccc7b8f@gmail.com>
 <CA+h21hrjAT4yCh=UgJJDfv3=3OWkHUjMRB94WuAPDk-hkhOZ6w@mail.gmail.com>
 <15ce2fae-c2c8-4a36-c741-6fef58115604@gmail.com>
 <20200219231528.GS25745@shell.armlinux.org.uk>
 <e9b51f9e-4a8f-333d-5ba9-3fcf220ace7c@gmail.com>
 <20200221002110.GE25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221002110.GE25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 12:21:10AM +0000, Russell King - ARM Linux admin wrote:
> On Thu, Feb 20, 2020 at 10:56:17AM -0800, Florian Fainelli wrote:
> > Let's get your patch series merged. If you re-spin while addressing
> > Vivien's comment not to use the term "vtu", I think I would be fine with
> > the current approach of having to go after each driver and enabling them
> > where necessary.
> 
> The question then becomes what to call it.  "always_allow_vlans" or
> "always_allow_vlan_config" maybe?

Please note that I still have this patch pending (i.o.w., the problem
with vlans remains unfixed) as I haven't received a reply to this,
although the first two patches have been merged.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
