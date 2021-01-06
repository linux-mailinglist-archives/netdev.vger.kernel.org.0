Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C1C2EBD99
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 13:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbhAFMWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 07:22:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:58544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbhAFMWA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 07:22:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B13ED2311D;
        Wed,  6 Jan 2021 12:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609935679;
        bh=WAm/RhnYSKI7FNej0EIyJcFG4Mw69Zq4xvi2vdKUvKY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EFqt/4YEevvHaPLx967fpBTZcI/+548l6LR6bBN/0B0bBWvU0bYq2N+5fblMroJL8
         xb0u579zUG7NzKcnQQ+MKF3jaSy2g6XFIFCcvPeEj8diZK5Jw1Y5/FqQGmM4fTpIn+
         PsheQjel/dq1hoFK5S0Cx7gcaWRRj4/qT0u/SNcSaEclNRZVU9uyACTmNPOg8WNZ7d
         QtO7QspxuWHzd0WatLIWX9d674NKThw0WDKJX/pt372KXxGMz+2sup7FB3VMjhhds3
         5bV0cxoJ0Egv3k3UFgFFBHXGNibprJTHCC7UK8jrSWwnjgdA1582lmM4oduTgjblRH
         A21687mqHVHRA==
Date:   Wed, 6 Jan 2021 13:20:50 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com,
        clang-built-linux@googlegroups.com, davem@davemloft.net,
        devicetree@vger.kernel.org, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kbuild-all@lists.01.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, lkp@intel.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        vivien.didelot@gmail.com
Subject: Re: [net-next PATCH v12 4/4] net: dsa: mv88e6xxx: Add support for
 mv88e6393x  family of Marvell
Message-ID: <20210106132050.4f0875c7@kernel.org>
In-Reply-To: <20210106004530.22197-1-pavana.sharma@digi.com>
References: <20210105131343.4d0fff05@nic.cz>
        <20210106004530.22197-1-pavana.sharma@digi.com>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Jan 2021 10:45:30 +1000
Pavana Sharma <pavana.sharma@digi.com> wrote:

> Thanks Marek for catching this.
> 
> I will have a closer look and update the patchset.

I also sent a reply patch with subject
  "patch fixing mv88e6393x SERDES IRQ for Pavana's series"

it contains the changes necessary to your series. Please look at that.
You can apply it to your commit via
  patch -p1 <patch_from_marek.patch
  git commit --amend drivers/net/dsa/mv88e6xxx/{chip.c,serdes.c,serdes.h}

Marek
