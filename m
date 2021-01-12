Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02CDF2F31D7
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732590AbhALNe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:34:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbhALNe3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:34:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 218B420771;
        Tue, 12 Jan 2021 13:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610458428;
        bh=WrCHwUdkaHpYzAvN6fVg5rEj3GG9wi+m3AVS7OORue8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uKqI7j70dPNHHIcZ0mKxtZcm+aXsdA9YNKc4n7qWnR+4dabmQJPuQN0IHTQuPgV3G
         rIYltVWr92hgYTtGhjKygVjIVltJwNydPGN/Tic7s4V+pSjQezo1NbDofZXWRUjaP+
         8lkAYpQ9Cm6t21iyTPPwsV9+kNH5RgZAkaHOO/+aF1q4ccSmBV3DnZCPeqP3jlmjMg
         sV/GobDWnewpvVndsGSFgERtAuYK2SgIxW7yRYuBdS+tnIyfvrHGU+hgpf8CEQxN+e
         VIzC6i/O0WNkwcwLeSHCMSCgmODEulU+sHH32r0ZVomDcLT9j0hBeCHrVQtGTOhHVx
         TleWmfy16nOVw==
Received: by pali.im (Postfix)
        id B442C856; Tue, 12 Jan 2021 14:33:45 +0100 (CET)
Date:   Tue, 12 Jan 2021 14:33:45 +0100
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
Message-ID: <20210112133345.h3dwe3s2f4lxgliu@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210111113909.31702-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210111113909.31702-1-pali@kernel.org>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 11 January 2021 12:39:07 Pali Rohár wrote:
> This is a third version of patches which add workarounds for
> RTL8672/RTL9601C EEPROMs and Ubiquiti U-Fiber Instant SFP.
> 
> Russel's PATCH v2 2/3 was dropped from this patch series as
> it is being handled separately.
> 
> Pali Rohár (2):
>   net: sfp: add workaround for Realtek RTL8672 and RTL9601C chips
>   net: sfp: add mode quirk for GPON module Ubiquiti U-Fiber Instant
> 
>  drivers/net/phy/sfp-bus.c |  15 +++++
>  drivers/net/phy/sfp.c     | 117 ++++++++++++++++++++++++++------------
>  2 files changed, 97 insertions(+), 35 deletions(-)

I'm fine with Marek's commit message changes.

Russell, Andrew, anything else is needed for these two patches?
