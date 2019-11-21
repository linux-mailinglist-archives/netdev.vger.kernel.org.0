Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F10104755
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 01:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfKUAOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 19:14:46 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45702 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbfKUAOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 19:14:45 -0500
Received: by mail-lj1-f194.google.com with SMTP id n21so1094065ljg.12
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 16:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=1QyTg1nySvRrmN9zkwRKEq+e8ZhflapTIw/Tqx9+bn4=;
        b=sOTAuPt8yVhD1c8TbwQ4b7k349pJ7b0I6Vt7IqU/9mANOCEwn7Ef4WveNHvCPlnUSz
         x9PNEB0psFuovEVpIvpqDoNcAEt3Om61k5347lQbdu629zyDcBRxoVp9D5D5Mm/UB7O7
         pHjkc5T8UJHtGx0piy+Xw1+3SK8ybGDNov/lY/1GNC0qSZre11U8Z/0hEMKOFeQMd9m0
         RMsbdbmGRunSuPMtfT9Jl+HtxdUteMhbl0glukAJZb2sAQ+TZhs/H2TVqS4L81iBkMee
         Bw2d5peOPb8w/YhEwtELjILc+kKHxU7CXQVE96ybRJT60UnkLsMwymb1etRUiSoYLagS
         hKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=1QyTg1nySvRrmN9zkwRKEq+e8ZhflapTIw/Tqx9+bn4=;
        b=Fg8JrAFkhUgnGJ5HhVwIqpl0I85Cauxbrc8VlWrXd6Jc+NNtBNjYRhdtE+1YShQQxz
         ffTDlJJ7hN9LTRM0sADnLSL+2nzwxHwv+vSMTUZ3lsFz86ZsyPIPcdkXLJUGf6z1leue
         88yseHKjDPRTLu8C8g0uczBoXJVTA+6YUqyhdaE46oFrack7A/41Uzcn/RpA3Wwxv3dc
         S2R8CyfHrdyGQGDvK2qdjx9xmF6A9N6ATQAuiYA0HbhfGpi7G5EH9/QMh0Chz2vyYa9t
         zAAOJ3smlrB+B5mvHFSD6urEh3h+yffcPnlkZDRJicvnsvIVXPjZCnRfOtV9EBokfSeZ
         l2jQ==
X-Gm-Message-State: APjAAAUTIyS0h9zdt/FaSi4RnzYtBwALNsnbIHaPRe/aGiZggZ6T74TU
        e78elNJ/Eka/hwAXV/TxjxfrlQ==
X-Google-Smtp-Source: APXvYqzqx9hIHtwAQ4JxJolzSmfnklBRhK3LR/zW8S0ktmfMosBO/I+6l5WhcYi1N+IgBGmq2EIKew==
X-Received: by 2002:a2e:7319:: with SMTP id o25mr4481897ljc.207.1574295283883;
        Wed, 20 Nov 2019 16:14:43 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r22sm293156ljk.31.2019.11.20.16.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 16:14:43 -0800 (PST)
Date:   Wed, 20 Nov 2019 16:14:27 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: sfp: add some quirks for GPON modules
Message-ID: <20191120161427.2921e210@cakuba.netronome.com>
In-Reply-To: <20191121000328.GX25745@shell.armlinux.org.uk>
References: <20191120113900.GP25745@shell.armlinux.org.uk>
        <E1iXONj-0005ev-NC@rmk-PC.armlinux.org.uk>
        <20191120144632.0658d920@cakuba.netronome.com>
        <20191121000328.GX25745@shell.armlinux.org.uk>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Nov 2019 00:03:28 +0000, Russell King - ARM Linux admin
wrote:
> On Wed, Nov 20, 2019 at 02:46:32PM -0800, Jakub Kicinski wrote:
> > On Wed, 20 Nov 2019 11:42:47 +0000, Russell King wrote:  
> > >  static const struct sfp_quirk sfp_quirks[] = {
> > > +	{
> > > +		// Alcatel Lucent G-010S-P can operate at 2500base-X, but
> > > +		// incorrectly report 2500MBd NRZ in their EEPROM
> > > +		.vendor = "ALCATELLUCENT",
> > > +		.part = "G010SP",
> > > +		.modes = sfp_quirk_2500basex,
> > > +	}, {
> > > +		// Alcatel Lucent G-010S-A can operate at 2500base-X, but
> > > +		// report 3.2GBd NRZ in their EEPROM
> > > +		.vendor = "ALCATELLUCENT",
> > > +		.part = "3FE46541AA",
> > > +		.modes = sfp_quirk_2500basex,
> > > +	}, {
> > > +		// Huawei MA5671A can operate at 2500base-X, but report 1.2GBd
> > > +		// NRZ in their EEPROM
> > > +		.vendor = "HUAWEI",
> > > +		.part = "MA5671A",
> > > +		.modes = sfp_quirk_2500basex,
> > > +	},
> > >  };  
> > 
> > nit: no C++ comment style?  
> 
> Did you read Linus' opinions on commentry style during the discussion
> over the SPDX tags?
> 
> https://lkml.org/lkml/2017/11/2/715
> https://lkml.org/lkml/2017/11/25/133
> 
> It seems that Linus has decided to prefer // over /* */

Yeah, I remember that, I did:

$ git grep '// ' drivers/net/phy/ | grep -v SPDX
drivers/net/phy/microchip_t1.c:// Copyright (C) 2018 Microchip Technology

before I asked, and assumed since for the last two years they didn't
gain much popularity in this corner of the kernel it's worth asking if
this is intentional :)
