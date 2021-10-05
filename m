Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B92422E73
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbhJEQ4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235238AbhJEQz7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 12:55:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3A40611C5;
        Tue,  5 Oct 2021 16:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633452848;
        bh=EU4i46Iv81JxEqXo49bpEWSTRMwOPurDSU/8ru7L3aM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ax4wzZ+4oeyeFvXuGkok1j702SR7Zd2HW/DOcZgiuRQJ+ASjPpG3dkaBzeC1LAl6O
         c2Dc+p0oFrLhdGyzaJyoY5OFALaIQ8f44kQjs+lW4SBvVK7MSOew2lJWFg0CSQRox4
         nEa0J+LZjqrq4GDHmHVMpER0c17OCXUeLbtH1uGoF9o/yG9SusLol6Bw/LOS+r67Zm
         gq4PqPbxXPQK/gJndh8Rb9ZjRDGA/+m8QSks4BnInIdmC4USqSt315gWOWd2+clK3g
         VApdE+uEjwpExHAdOr59yIrNuuch0K4r9D4j9hfZXJ3LRxjQNYIiQWRuxtweD2+i5N
         sLwoOOo+W7yuQ==
Date:   Tue, 5 Oct 2021 09:54:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] of: net: add a helper for loading
 netdev->dev_addr
Message-ID: <20211005095408.2adcb2e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAL_JsqLGtfQgpVqSGN-HsTmeRQnbZ0vrOv2y6PprPx373-tVfg@mail.gmail.com>
References: <20211005155321.2966828-1-kuba@kernel.org>
        <20211005155321.2966828-2-kuba@kernel.org>
        <CAL_Jsq+HsW-dpUxC2Sz-FhgHgRonhanX2LgUVHiNZYfZS81iBQ@mail.gmail.com>
        <20211005092956.44eb4d3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAL_JsqLGtfQgpVqSGN-HsTmeRQnbZ0vrOv2y6PprPx373-tVfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 11:39:39 -0500 Rob Herring wrote:
> On Tue, Oct 5, 2021 at 11:29 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 5 Oct 2021 11:15:48 -0500 Rob Herring wrote:  
> > > Can we move this file to drivers/net/ given it's always merged via the
> > > net tree? It's also the only thing left not part of the driver
> > > subsystems.  
> >
> > Hm, our driver core historically lives under net/core, not drivers/net,
> > how about drivers/of/of_net.c -> net/core/of_net.c ?  
> 
> Sure.

I'll send out the rename as soon as this gets merged. If anyone has 
a different idea on where to move this code please chime in.
