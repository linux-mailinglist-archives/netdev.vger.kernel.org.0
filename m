Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 677A81B127
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 09:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbfEMH3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 03:29:17 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36574 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727462AbfEMH3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 03:29:16 -0400
Received: by mail-lf1-f65.google.com with SMTP id y10so8237128lfl.3;
        Mon, 13 May 2019 00:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ANO0xXt34tqA+PC94Xi+g11/uy5YRgvNnUqPc1rWV1I=;
        b=VZRyLpmzKnZG6EsvA2UZxgEYUc+G6nSBCAkhL6gCFeFmPqi6KnE+6ZVxO9HlhnvQd6
         EjsDXQA/9rLECwZk6DGV6oDUo3a6u7/2nQfByi1Aicw7k/Al6/xYusC/vFkoraN59Dou
         WuC/YfJrSWzukZFXNKJG4nv81eHXDJ6ig4TxM4OqDBCha3E+HWjDEkT/CZuZ0ZdRndcW
         2lMk099OqhW4lvcL7Ec6GRPR1kwSnerOX1E8H+aQnLnKvPDGjH2KSPvmBJxdCIfcV85k
         VzGRYDKoiQ537JeySD5pvAhDCERIRrqNZX3aLwuXulnR0xijZD/fUBVh8qeTocEeu6cA
         iitg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ANO0xXt34tqA+PC94Xi+g11/uy5YRgvNnUqPc1rWV1I=;
        b=cijKIXxk42DT9Y+R26XRdoqymAWLkY9FRTW1L7JXFrnLezb9LMd8UYxiWpIRcykniT
         ReHeeyOUCIBqGKbPJPc6DLBwk94D+9dRCoLWt86xdl7o1mpqbv0lYt0iHiPBOujSL/Ug
         j5PCRzTd3iWoDyIfm1Sd+4aurCMZAXup9i6GCwi22lE2N6sniE57kaBwphANdXmnhzLV
         o6+jMzv4gd2Ffp6H04mqORLCoonObuse4xpsfTq83M5AMgiiGMxhQA6WqQCWsnl+/PJE
         1VCPPV+Lh2eTy86SUMTVeqOFxycD0Xy11uA1bUmc2jqf0AmqEC3XJCShkuSdfNezb3Rx
         Hzug==
X-Gm-Message-State: APjAAAUQlLM+NSt4lJZ7ow8jM6Ps35eI5Qi3mo5ee5Yjzf2kOJFlFuaQ
        SFLC90+kdUCbH8nEV6cALHI=
X-Google-Smtp-Source: APXvYqxAPS2YNy9oUsYW8yeuuGGTIJp5tmtOJUBhMiJQhfu9QTP/3KsRjsvSFCh79P5VphfigYY94w==
X-Received: by 2002:ac2:4857:: with SMTP id 23mr9993431lfy.158.1557732553706;
        Mon, 13 May 2019 00:29:13 -0700 (PDT)
Received: from mobilestation ([5.164.217.122])
        by smtp.gmail.com with ESMTPSA id y24sm3063412lfg.33.2019.05.13.00.29.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 13 May 2019 00:29:12 -0700 (PDT)
Date:   Mon, 13 May 2019 10:29:10 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Vicente Bergas <vicencb@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: realtek: regression, kernel null pointer dereference
Message-ID: <20190513072909.behzxeisc7l3nprq@mobilestation>
References: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
 <742a2235-4571-aa7d-af90-14c708205c6f@gmail.com>
 <11446b0b-c8a4-4e5f-bfa0-0892b500f467@gmail.com>
 <61831f43-3b24-47d9-ec6f-15be6a4568c5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <61831f43-3b24-47d9-ec6f-15be6a4568c5@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Heiner and net-folks,

On Sat, May 11, 2019 at 04:56:56PM +0200, Heiner Kallweit wrote:
> On 11.05.2019 16:46, Vicente Bergas wrote:
> > On Friday, May 10, 2019 10:28:06 PM CEST, Heiner Kallweit wrote:
> >> On 10.05.2019 17:05, Vicente Bergas wrote:
> >>> Hello,
> >>> there is a regression on linux v5.1-9573-gb970afcfcabd with a kernel null
> >>> pointer dereference.
> >>> The issue is the commit f81dadbcf7fd067baf184b63c179fc392bdb226e
> >>>  net: phy: realtek: Add rtl8211e rx/tx delays config ...
> >> The page operation callbacks are missing in the RTL8211E driver.
> >> I just submitted a fix adding these callbacks to few Realtek PHY drivers
> >> including RTl8211E. This should fix the issue.
> > 
> > Hello Heiner,
> > just tried your patch and indeed the NPE is gone. But still no network...
> > The MAC <-> PHY link was working before, so, maybe the rgmii delays are not
> > correctly configured.
> 
> That's a question to the author of the original patch. My patch was just
> meant to fix the NPE. In which configuration are you using the RTL8211E?
> As a standalone PHY (with which MAC/driver?) or is it the integrated PHY
> in a member of the RTL8168 family?
> 
> Serge: The issue with the NPE gave a hint already that you didn't test your
> patch. Was your patch based on an actual issue on some board and did you
> test it? We may have to consider reverting the patch.
> 

I'm sorry for the problems the patch caused. My fault I couldn't predict the
paged-operations weren't defined for the E-revision of the PHY.

Regarding the patch tests. As I mention in the patchset discussions, the patch
was ported from earlier versions of the kernel. In particular I created it for
kernels 4.4 and 4.9, where paged-operations weren't introduced. So when I moved
it to the modern kernel I found the paged operations availability and decided to
use them, which simplified the code providing a ready-to-use interface to access
the PHY' extension pages. I also found they were defined in the driver with
"rtl821x_" prefix and mistakenly decided, that they were also used for any
rtl-like device. That's where I let the bug to creep in.

Regarding the MAC-PHY link. Without this functionality our custom board of
MAC and rtl8211e PHY doesn't provide a fully supported network, because the
RXDLY and TXDLY pins are grounded so there is no a simple way to set the
RGMII delays on the PHY side.

Concerning the MAC-PHY link problem Vincente found I'll respond to the
corresponding email in three hours.

-Sergey

> > With this change it is back to working:
> > --- a/drivers/net/phy/realtek.c
> > +++ b/drivers/net/phy/realtek.c
> > @@ -300,7 +300,6 @@
> >     }, {
> >         PHY_ID_MATCH_EXACT(0x001cc915),
> >         .name        = "RTL8211E Gigabit Ethernet",
> > -        .config_init    = &rtl8211e_config_init,
> >         .ack_interrupt    = &rtl821x_ack_interrupt,
> >         .config_intr    = &rtl8211e_config_intr,
> >         .suspend    = genphy_suspend,
> > That is basically reverting the patch.
> > 
> > Regards,
> >  Vicenç.
> > 
> >> Nevertheless your proposed patch looks good to me, just one small change
> >> would be needed and it should be splitted.
> >>
> >> The change to phy-core I would consider a fix and it should be fine to
> >> submit it to net (net-next is closed currently).
> >>
> >> Adding the warning to the Realtek driver is fine, but this would be
> >> something for net-next once it's open again.
> >>
> >>> Regards,
> >>>  Vicenç.
> >>>
> >> Heiner
> >>
> >>> --- a/drivers/net/phy/phy-core.c
> >>> +++ b/drivers/net/phy/phy-core.c
> >>> @@ -648,11 +648,17 @@
> >>>
> >>> static int __phy_read_page(struct phy_device *phydev)
> >>> { ...
> >>
> >> Here phydev_warn() should be used.
> >>
> >>> +        return 0;
> >>> +    }
> >>>
> >>>     ret = phy_write(phydev, RTL821x_EXT_PAGE_SELECT, 0xa4);
> >>>     if (ret)
> > 
> > 
> 
