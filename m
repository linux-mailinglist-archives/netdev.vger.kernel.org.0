Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE80D2F031A
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 20:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbhAITPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 14:15:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:49504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbhAITPc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 14:15:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E59D1206E9;
        Sat,  9 Jan 2021 19:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610219691;
        bh=SmXXBg/PFAnVl4lD56Fg2Rze5qQDH/LIcfWit7B6gj0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VVjgQ/HmLei1LhTXGEgh0JNvoyCrACFM2Vc3OM+ABfDDK0XVb7vejOZ6hvNfZIBJn
         YddthS46XgKURJbWntrtivYOv0G3WP9FjjX0RABnP3Ag+ZUhEU+zLQZR1PzPJeta4E
         vzTs12y/igN2ZePwv7Hep4paZryhb9fMr+KfiMbV79e3CPSzUzXIPJ4tcHPnujREsQ
         6qzxpoJT8bcvEkWT2/YnAL1xL2emvtRoCe600LcFcIB70K70YCmyk2988fOtcVs4Ke
         W3cR/O7/x7+6eAYQ3+uOkileupEECXmrMH9eLzXAmX8re4369xkd5w3tmQZDiJYd13
         M4U0nq0RL/sSg==
Received: by pali.im (Postfix)
        id CB2B277B; Sat,  9 Jan 2021 20:14:47 +0100 (CET)
Date:   Sat, 9 Jan 2021 20:14:47 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] net: sfp: assume that LOS is not implemented if
 both LOS normal and inverted is set
Message-ID: <20210109191447.hunwx4fc4d4lox5f@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210106153749.6748-1-pali@kernel.org>
 <20210106153749.6748-3-pali@kernel.org>
 <X/c8xJcwj8Y1t3u4@lunn.ch>
 <20210109154601.GZ1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210109154601.GZ1551@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday 09 January 2021 15:46:01 Russell King - ARM Linux admin wrote:
> On Thu, Jan 07, 2021 at 05:54:28PM +0100, Andrew Lunn wrote:
> > On Wed, Jan 06, 2021 at 04:37:48PM +0100, Pali Rohár wrote:
> > > From: Russell King <rmk+kernel@armlinux.org.uk>
> > > 
> > > Some GPON SFP modules (e.g. Ubiquiti U-Fiber Instant) have set both
> > > SFP_OPTIONS_LOS_INVERTED and SFP_OPTIONS_LOS_NORMAL bits in their EEPROM.
> > > 
> > > Such combination of bits is meaningless so assume that LOS signal is not
> > > implemented.
> > > 
> > > This patch fixes link carrier for GPON SFP module Ubiquiti U-Fiber Instant.
> > > 
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > 
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> I'd like to send this patch irrespective of discussion on the other
> patches - I already have it committed in my repository with a different
> description, but the patch content is the same.
> 
> Are you happy if I transfer Andrew's r-b tag, and convert yours to an
> acked-by before I send it?
> 
> I'd also like to add a patch that allows 2.5G if no other modes are
> found, but the bitrate specified by the module allows 2.5G speed - much
> like we do for 1G speeds.

Russell, should I send a new version of patch series without this patch?
