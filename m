Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7D58136B07
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 11:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbgAJK0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 05:26:11 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39454 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727168AbgAJK0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 05:26:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YIlXW7/5g1ETyYGbWR4L/mO1zapA9WeE+RHGDT6A3Ss=; b=SmA8To5tlGYzL7vawCUA1oGd9
        G9OLwhUz06IUKdTPEw1TZeJD/n+NJw5pKf1UytnAMyIJ6L9hiM+ICw7tB9njUTwxnvRxvENmvsnoy
        bq5sZgrbN/lctvL8KM3+vd4lbLUQhglS3jKmvEBVNygNWPWscKAAN1wyDuZ5/5YtWtjhIFhFnAmLx
        8Xn0kKgOKOYo+/0BtjzboWHwwxOdHz6I6ZEGdwVRkYFLHR44kuSCoZxZp0cQCNLXdoPelFKYRtfM4
        WCuBHisbkvVDAYniGZTUIiS9PjrF3178I/T49fE1ksw/idDlAsJWldsQOjTakd03JFP+i4nZtzL3Z
        v6oYdGTsg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:53038)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iprUW-0002PJ-0v; Fri, 10 Jan 2020 10:26:08 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iprUV-0001QE-Cd; Fri, 10 Jan 2020 10:26:07 +0000
Date:   Fri, 10 Jan 2020 10:26:07 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
Message-ID: <20200110102607.GY25745@shell.armlinux.org.uk>
References: <20200109155809.GQ25745@shell.armlinux.org.uk>
 <bb2c2eed-5efa-00f6-0e52-1326669c1b0d@gmx.net>
 <20200109174322.GR25745@shell.armlinux.org.uk>
 <acd4d7e4-7f8e-d578-c9c9-b45f062f4fe2@gmx.net>
 <7ebee7c5-4bf3-134d-bc57-ea71e0bdfc60@gmx.net>
 <20200109215903.GV25745@shell.armlinux.org.uk>
 <c7b4bec1-3f1f-8a34-cf22-8fb1f68914f3@gmx.net>
 <20200109231034.GW25745@shell.armlinux.org.uk>
 <727cea4e-9bff-efd2-3939-437038a322ad@gmx.net>
 <d10c8598-a3d2-3936-8713-0763b156938c@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d10c8598-a3d2-3936-8713-0763b156938c@gmx.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 12:18:41AM +0000, ѽ҉ᶬḳ℠ wrote:
> On 09/01/2020 23:50, ѽ҉ᶬḳ℠ wrote:
> > Maybe I should just try finding a module that is declared SPF MSA
> > conform...
> 
> Actually, the vendors declares
> (https://www.allnet.de/en/allnet-brand/produkte/neuheiten/p/-0c35cc9ea9/):
> 
> *ALLNET ALL4781-VDSL2-SFP* is a VDSL2 SFP modem that interconnects with
> Gateway Processor by using a MSA (MultiSource Agreement) compliant hot
> pluggable electrical interface.
> 
> Ok, "a MSA" does not explicitly state/imply SFP MSA but what other MSA could
> that be?
> If it is indeed SFP MSA conform the issue should not happen. Unless it is
> just marketing speak and does not hold true.

Everyone claims that their SFP is MSA compliant, even when the module:

1) takes 40-50 seconds after deasserting TX_DISABLE to initialise and
   deassert TX_FAULT, when the SFP MSA explicitly states a limit of
   300ms (t_init) for TX_FAULT to deassert.

2) EEPROM does not respond for 50 seconds after plugging in, where the
   SFP MSA explicitly states 300ms (t_serial) maximum.

3) EEPROM contains incorrect data, for example:
   - indicating the module has a LC connector, yet it has an RJ45, or
     vice versa.
   - indicating NRZ encoding for an ethernet SFP, where it should be
     8b10b or 64b66b encoding.
   - indicating a single data rate, or even the wrong data rate, when
     the module is documented as supporting other rates.
   - indicating an extended compliance technology that it doesn't
     support, presumably originally chosen when the number was
     unallocated by SFF-8024.
   - claiming to support 1000BASE-SX, a fiber standard, when the
     module is actually for VDSL2 over copper.

... etc ...

So, I tend to ignore "SFP MSA compliant" whenever I see it; it is
mostly meaningless.  Yes, there are modules out there which are
compliant, but those that claim compliance but aren't make the
claim meaningless for everyone.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
