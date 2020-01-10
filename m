Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC38136C40
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 12:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgAJLqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 06:46:45 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40370 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727689AbgAJLqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 06:46:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XuazYJskOYtF4ny/izydyB+FbJlPEmbBI8uzGjQcfPE=; b=ZfSZLdlftJ6f1kdDpjXEF2/jf
        0eoxB1LEf80xQSh01/Z/cIWi6Wf7ays4DjxpQkL+uM298TOg1YwFZki6Eyq5dUaxequgjPB/EEFNI
        iADxeEJ6w8+RH3wASOOq/9KWK0mgCH2p23omFQ1J7aeGeqtYRNq2Q1tJaGlA13iZZwCMcB81N12G8
        m1nLpQNu2WC70/fmjQW+canEoIrjwDduLsAqZMo4C+gSggRRT1UH2etXD/17ZW/PVUD856y4CkRD3
        qDczAHaIEqoXmkXH1qU6suRBDrDtbvRsXnTUTFQcryGM1UWikfYFAzIlE3KdhwCAHEWVdDmwvPbWK
        6ncetay2g==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:60580)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ipskU-0002kj-6j; Fri, 10 Jan 2020 11:46:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ipskT-0001Tc-NH; Fri, 10 Jan 2020 11:46:41 +0000
Date:   Fri, 10 Jan 2020 11:46:41 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
Message-ID: <20200110114641.GA25745@shell.armlinux.org.uk>
References: <20200109174322.GR25745@shell.armlinux.org.uk>
 <acd4d7e4-7f8e-d578-c9c9-b45f062f4fe2@gmx.net>
 <7ebee7c5-4bf3-134d-bc57-ea71e0bdfc60@gmx.net>
 <20200109215903.GV25745@shell.armlinux.org.uk>
 <c7b4bec1-3f1f-8a34-cf22-8fb1f68914f3@gmx.net>
 <20200109231034.GW25745@shell.armlinux.org.uk>
 <727cea4e-9bff-efd2-3939-437038a322ad@gmx.net>
 <20200110092700.GX25745@shell.armlinux.org.uk>
 <18687669-e6f5-79f1-6cf9-d62d65f195db@gmx.net>
 <5c3aabb9-dae4-0ca2-72e9-50f8aa7b9ec4@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5c3aabb9-dae4-0ca2-72e9-50f8aa7b9ec4@gmx.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 10:19:47AM +0000, ѽ҉ᶬḳ℠ wrote:
> I just came across this
> http://edgemax5.rssing.com/chan-66822975/all_p1715.html#item34298
> 
> and albeit for a SFP g.fast module it indicates/implies that Metanoia
> provides own Linux drivers (supposedly GPL licensed), plus some bits
> pertaining to the EBM (Ethernet Boot Management protocol).
> 
> Has Metanoia submitted any SFP drivers to upstream kernel development?

Not that I'm aware of.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
