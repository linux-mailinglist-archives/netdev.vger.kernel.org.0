Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6822E21E6
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 22:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgLWVJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 16:09:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:48972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbgLWVJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 16:09:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C6F4223E4;
        Wed, 23 Dec 2020 21:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608757702;
        bh=9o+wLiiWUlEclcEO6RrklnPQZ/hwz8qssl8eooZrwmY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pLLIUMPbjykoJIdEF9TptnyNl4rNCAb/0Rg7hJlopLVTGsiG4OJAHvpNFF83zD878
         8G68o5AxOFTfaXAqkCXYil4p9d8yFY6EvpVjU0LgQBuulzVRIibcr6qj8YdWOSH0e3
         mnu6tojED3dMGubbWzkxFDboknprS0WrqMQOWHzg02fKpMqrB11FZTUi4csbUtI+H+
         pGfucF58SA/d9DUAyY4kccANR7G4lWaVttS7Btv7szOYK4BohJH13h2Z6D52qPBP0y
         6mpC6ZKwA/OrG/WfcT9vZnJOSos0vZpWixHAKeFmqPZV2lKpuyWOxAhccrPWuJ+mtf
         ukaOx7qd+Go0Q==
Date:   Wed, 23 Dec 2020 13:08:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     trix@redhat.com
Cc:     netanel@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        saeedb@amazon.com, zorik@amazon.com, davem@davemloft.net,
        sameehj@amazon.com, shayagr@amazon.com, amitbern@amazon.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ena: remove h from printk format specifier
Message-ID: <20201223130821.3fb80f37@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201223193144.123521-1-trix@redhat.com>
References: <20201223193144.123521-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Dec 2020 11:31:44 -0800 trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> This change fixes the checkpatch warning described in this commit
> commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of unnecessary %h[xudi] and %hh[xudi]")
> 
> Standard integer promotion is already done and %hx and %hhx is useless
> so do not encourage the use of %hh[xudi] or %h[xudi].
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

This really is not a change worth making in existing code, IMO.

I find it a little ironic that nacking of unnecessary code churn has
spawned unnecessary code churn in the opposite direction.

I'd leave it up to maintainers of specific drivers to decide, but for
now - net-next is closed anyway, please come back with these after
merge window is over.

Thanks!
