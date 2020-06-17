Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070081FD22B
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 18:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgFQQ24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 12:28:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbgFQQ24 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 12:28:56 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ABDF208D5;
        Wed, 17 Jun 2020 16:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592411335;
        bh=1H0CTWgSc5IHvLsUQzrRHh4kgeEBc5Pmj5ZbDHaTDAs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bG7XIEDR98xPTo6lRgqTpTUlXgdz0HlW1l4RSR8QVd0hgd9XqFG1AuMrOYBsa7gEP
         JSRlw6wkXiHht4VFpjafiHea/ZsYrZjPtMdZOrhtPVoqbq8hxy8fnprYf4i/I2Xa12
         f5TNhsJ9hXK5pvRC5EtGbl3YNZtwwa9MQoDjv+Xc=
Date:   Wed, 17 Jun 2020 09:28:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aaron Ma <aaron.ma@canonical.com>
Cc:     jeffrey.t.kirsher@intel.com, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vitaly.lifshits@intel.com,
        kai.heng.feng@canonical.com, sasha.neftin@intel.com
Subject: Re: [v2][PATCH] e1000e: continue to init phy even when failed to
 disable ULP
Message-ID: <20200617092854.7be16376@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200617111249.20855-1-aaron.ma@canonical.com>
References: <20200616100512.22512-1-aaron.ma@canonical.com>
        <20200617111249.20855-1-aaron.ma@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020 19:12:48 +0800 Aaron Ma wrote:
> After commit: e086ba2fccd ("e1000e: disable s0ix entry and exit flows
>  for ME systems").
> ThinkPad P14s always failed to disable ULP by ME.
> commit: 0c80cdbf33 ("e1000e: Warn if disabling ULP failed")
> break out of init phy:
> 
> error log:
> [   42.364753] e1000e 0000:00:1f.6 enp0s31f6: Failed to disable ULP
> [   42.524626] e1000e 0000:00:1f.6 enp0s31f6: PHY Wakeup cause - Unicast Packet
> [   42.822476] e1000e 0000:00:1f.6 enp0s31f6: Hardware Error
> 
> When disable s0ix, E1000_FWSM_ULP_CFG_DONE will never be 1.
> If continue to init phy like before, it can work as before.
> iperf test result good too.
> 
> Fixes: 0c80cdbf33 ("e1000e: Warn if disabling ULP failed")
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>

Fixes tag: Fixes: 0c80cdbf33 ("e1000e: Warn if disabling ULP failed")
Has these problem(s):
	- SHA1 should be at least 12 digits long
	  Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
	  or later) just making sure it is not set (or set to "auto").
