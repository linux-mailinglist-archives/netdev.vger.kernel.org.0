Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39EA81CC19C
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 15:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgEINKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 09:10:31 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:58383 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgEINKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 09:10:31 -0400
Received: from windsurf.home (lfbn-tou-1-915-109.w86-210.abo.wanadoo.fr [86.210.146.109])
        (Authenticated sender: thomas.petazzoni@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 837EE20000B;
        Sat,  9 May 2020 13:10:27 +0000 (UTC)
Date:   Sat, 9 May 2020 15:10:26 +0200
From:   Thomas Petazzoni <thomas.petazzoni@bootlin.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Stefan Chulski <stefanc@marvell.com>,
        Matteo Croce <mcroce@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS
 contexts to handle RSS tables
Message-ID: <20200509151026.30abcb6f@windsurf.home>
In-Reply-To: <20200509124843.GC1551@shell.armlinux.org.uk>
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
        <20190524100554.8606-4-maxime.chevallier@bootlin.com>
        <CAGnkfhzsx_uEPkZQC-_-_NamTigD8J0WgcDioqMLSHVFa3V6GQ@mail.gmail.com>
        <20200423170003.GT25745@shell.armlinux.org.uk>
        <CAGnkfhwOavaeUjcm4_+TG-xLxQA519o+fR8hxBCCfSy3qpcYhQ@mail.gmail.com>
        <DM5PR18MB1146686527DE66495F75D0DAB0A30@DM5PR18MB1146.namprd18.prod.outlook.com>
        <20200509114518.GB1551@shell.armlinux.org.uk>
        <20200509141644.29861e96@windsurf.home>
        <20200509124843.GC1551@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 May 2020 13:48:43 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> > Unfortunately, we are no longer actively working on Marvell platform
> > support at the moment. We might have a look on a best effort basis, but
> > this is potentially a non-trivial issue, so I'm not sure when we will
> > have the chance to investigate and fix this.  
> 
> That may be the case, but that doesn't excuse the fact that we have a
> regression and we need to do something.

Absolutely.

> Please can you suggest how we resolve this regression prior to
> 5.7-final?

Since 5.7 is really close, I would suggest to disable the functionality.

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
