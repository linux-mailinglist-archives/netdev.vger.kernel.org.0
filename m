Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E866A302645
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 15:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbhAYOYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 09:24:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729417AbhAYOXp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 09:23:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 280C02228A;
        Mon, 25 Jan 2021 14:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611584584;
        bh=GSvbFh9yLMmeOSArIC9+zfkCQFF93u9JBkIRUtRfJSY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LANZJ8bDfMiUn+PIcRhbEKElgd6MWsg4pYEVBbB1178gEdITBYSg84XaDLtol4Niw
         /fUlGG1G3P4YCKWc/Tt9dwuZoFCbnK6Zf0r4dBX3ZEUWZh1jmky9qAlth1v0XUXydG
         gXGbWxeS0Gxy14uYUW74J6gqSyeKPuYkzV7NO5YuBMyTYBJf7nuDtuJqQf0vC8XRXv
         bfMn3QmzF+xzkymRpyLHTf/aHlDxugjr2dF7gGDnOzPnt5gabMHnMXEJdLwQv/N7yR
         LH3IrmCHk+A/B2bFt7AKdrw5KrMfDUzbkc0j9LybSvLg8IZ9mMNoMJ6P8TGcaNpyIH
         z7O8p38+ZSyLQ==
Received: by pali.im (Postfix)
        id 0D033768; Mon, 25 Jan 2021 15:23:01 +0100 (CET)
Date:   Mon, 25 Jan 2021 15:23:01 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] net: sfp: add support for GPON RTL8672/RTL9601C
 and Ubiquiti U-Fiber
Message-ID: <20210125142301.qkvjyzrm3efkkikn@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210111113909.31702-1-pali@kernel.org>
 <20210118093435.coy3rnchbmlkinpe@pali>
 <20210125140957.4afiqlfprm65jcr5@pali>
 <20210125141643.GD1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210125141643.GD1551@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 25 January 2021 14:16:44 Russell King - ARM Linux admin wrote:
> On Mon, Jan 25, 2021 at 03:09:57PM +0100, Pali Rohár wrote:
> > On Monday 18 January 2021 10:34:35 Pali Rohár wrote:
> > > On Monday 11 January 2021 12:39:07 Pali Rohár wrote:
> > > > This is a third version of patches which add workarounds for
> > > > RTL8672/RTL9601C EEPROMs and Ubiquiti U-Fiber Instant SFP.
> > > > 
> > > > Russel's PATCH v2 2/3 was dropped from this patch series as
> > > > it is being handled separately.
> > > 
> > > Andrew and Russel, are you fine with this third iteration of patches?
> > > Or are there still some issues which needs to be fixed?
> > 
> > PING!
> 
> What about the commit message suggestions from Marek?

I have already wrote that I'm fine with those suggestions.

It is the only thing to handle? If yes, should I send a new patch series
with fixed commit messages?
