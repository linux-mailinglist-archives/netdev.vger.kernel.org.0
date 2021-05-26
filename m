Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9AB3920D3
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 21:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbhEZT3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 15:29:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231321AbhEZT3E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 15:29:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0E65613D3;
        Wed, 26 May 2021 19:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622057253;
        bh=KGVp4wqzVFKRaWAJBaVrOidSt0GjvPkTAxWI+nC6N1U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dkrT6B2xUJ9PSHBypQxKFV1rymUrbguASRGozvNXtFvl2Ycw5zo3vA0MlVaZW/otM
         XZEdInAPTWuCYDjxvxMh82ucBt1V9gxvqvR3ZoUvcIXRnPzWy9uElYZQ9x4it9yDT/
         o9nqRNgTndac8KGeo7hsiABsWJdd9Nr2TMz5vEY3C8gP951zB5JJKAvECtGJuSa6+v
         E4u2ikbZGVLK7U9XF91yg/dmuhr5YKhqqVyc0/sTcJjP70RfnzwpQJ5H0eB7qOcTeS
         5IERcZZQow/CldwbWQYsf5A28k/Y4sqTeBAFRNKeDPosfhks8cAKJsUnb98uLK7izK
         KKAs3gyRHAAIg==
Date:   Wed, 26 May 2021 12:27:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH v2 0/2] fixes for yt8511 phy driver
Message-ID: <20210526122732.5e655b9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210525203314.14681-1-pgwipeout@gmail.com>
References: <20210525203314.14681-1-pgwipeout@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 May 2021 16:33:12 -0400 Peter Geis wrote:
> The Intel clang bot caught a few uninitialized variables in the new
> Motorcomm driver. While investigating the issue, it was found that the
> driver would have unintended effects when used in an unsupported mode.
> 
> Fixed the uninitialized ret variable and abort loading the driver in
> unsupported modes.
> 
> Thank you to the Intel clang bot for catching these.

Fixes tag need work, the hashes don't match the ones in net-next.
