Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3168845D23D
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 01:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245624AbhKYAyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 19:54:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344014AbhKYAwD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 19:52:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 653076101C;
        Thu, 25 Nov 2021 00:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637801333;
        bh=dXRG4rT13IthhEx35fQ/PVR9L2KJ/EFH7m7sK9xa/Zk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TgpLfOxxCjbxOxSgUsQ9S01/FE83TMwKGZl6eT6uFLgEfE2/JPHUZcHEQOpIjj3pZ
         OOuINNT/S3YDo8F8l73zoyPG+Ls59qtgzP0JeRl4asMD4Jg1qe4/juDg17avVgy/jf
         2PsPs7wuX3FNB5l6wpbWGjFSLHrnfZXBbRrS5XyifVo4+F8GqZMfkqzIyrxhcC+YzC
         OR8vpGkzB2+Ad4b3imeButASqleK3/+rvD/SsqWt+7r45bHAU0TsZGwIs/1c+IQvok
         1PTfvP/Iohnm45GnhzRfbVmX/358mImldx2Vt/ChhwyEdIphrrrzM+HzJzbgtJzrhZ
         KaA9xfv6f9Olw==
Date:   Wed, 24 Nov 2021 16:48:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shijith Thotton <sthotton@marvell.com>
Cc:     <davem@davemloft.net>, <sgoutham@marvell.com>,
        <jerinj@marvell.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] octeontx2-af: cn10k: devlink params to
 configure TIM
Message-ID: <20211124164852.46784f83@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f2256d3f1a6a44632b04b182f28faf92848642c3.1637730085.git.sthotton@marvell.com>
References: <f2256d3f1a6a44632b04b182f28faf92848642c3.1637730085.git.sthotton@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 10:38:41 +0530 Shijith Thotton wrote:
> Added devlink parameters to configure the source clock of TIM block.
> Supported clocks are TENNS, GPIOS, GTI, PTP, SYNC, BTS, EXT_MIO and
> EXT_GTI.
> 
> To adjust a given clock, the required delta can be written to the
> corresponding tim_adjust_<clock> parameter and tim_adjust_timers
> parameter can be used to trigger the adjustment. tim_capture_<clock>
> parameter can be used to verify the adjusted values for a clock.
> 
> Example using tenns clock source:
> To adjust a clock source
>  # devlink dev param set pci/0002:01:00.0 name tim_adjust_tenns \
>         value "1000" cmode runtime
> 
> To trigger adjustment
>  # devlink dev param set pci/0002:01:00.0 name tim_adjust_timers \
>         value 1 cmode runtime

PTP subsystem exists.
