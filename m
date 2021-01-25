Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B510E30340E
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbhAZFNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:13:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729209AbhAYOKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 09:10:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B55E12145D;
        Mon, 25 Jan 2021 14:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611583799;
        bh=2R7CgtOTeefx6N1YztLJLOjX15S7csxGMVw+TKDmbwQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AxfOrWGYc03CMjfCaDFFJ5jXObCKuEV0WOwxX9i14/cUJ9DJ063kMRQree+jsr43g
         jt5jGYKaJ7o0CjqiaNO/D9B8mY/mHGcZdDECleI/aH3mckxvlNwkEo7n/It1GYDjkQ
         HFsS7SOzKBpoDDS2oMbYpywieqGzQp4LqXYrmLi6HRyqTMM5yiuZSaR2RhcNBgjiZF
         s/k6DsZQSK8wP4N0a0zCExckxR7LAzB8wPO1HpUP69mVM6bJTQvLNij6orC3aRi1sm
         8HuYXClhjWftUfwXNIttK5PBBBxgZ1ywp6+c4JCfZFLmGcvXJXmaQxM+KNUPrStU/W
         Ee6SPAHSacm6w==
Received: by pali.im (Postfix)
        id 658DF768; Mon, 25 Jan 2021 15:09:57 +0100 (CET)
Date:   Mon, 25 Jan 2021 15:09:57 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] net: sfp: add support for GPON RTL8672/RTL9601C
 and Ubiquiti U-Fiber
Message-ID: <20210125140957.4afiqlfprm65jcr5@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210111113909.31702-1-pali@kernel.org>
 <20210118093435.coy3rnchbmlkinpe@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210118093435.coy3rnchbmlkinpe@pali>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 18 January 2021 10:34:35 Pali Rohár wrote:
> On Monday 11 January 2021 12:39:07 Pali Rohár wrote:
> > This is a third version of patches which add workarounds for
> > RTL8672/RTL9601C EEPROMs and Ubiquiti U-Fiber Instant SFP.
> > 
> > Russel's PATCH v2 2/3 was dropped from this patch series as
> > it is being handled separately.
> 
> Andrew and Russel, are you fine with this third iteration of patches?
> Or are there still some issues which needs to be fixed?

PING!

> > Pali Rohár (2):
> >   net: sfp: add workaround for Realtek RTL8672 and RTL9601C chips
> >   net: sfp: add mode quirk for GPON module Ubiquiti U-Fiber Instant
> > 
> >  drivers/net/phy/sfp-bus.c |  15 +++++
> >  drivers/net/phy/sfp.c     | 117 ++++++++++++++++++++++++++------------
> >  2 files changed, 97 insertions(+), 35 deletions(-)
> > 
> > -- 
> > 2.20.1
> > 
