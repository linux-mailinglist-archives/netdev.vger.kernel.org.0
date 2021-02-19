Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1A131FEBC
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 19:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhBSSXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 13:23:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229765AbhBSSXT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 13:23:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7AEB64E4B;
        Fri, 19 Feb 2021 18:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613758959;
        bh=lvf63DGkJR2fWgH6f/qu5f+xu+b9akz5C3bLJxhEu40=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nyFNGPJFF/UKMapeJ9gM+Z3f++3DBwk6oyXh940tLUDw7DoyhMvbp9NW3PRSMdgr7
         uGwOaYD/2NqbPXkc6lkbKiAqwOLHfQNoGBfWK+KkSyk9tmAyGUwz6dtIhpiB/SAPQd
         fj6Y0CIBe+R1aQ0B+gGI8SRkJXTt+hO5xg3tupGNGMDz/t2fR9MubKtOce1c8UpooB
         NOgyartMYwQZtEdaQd88qzZK9fq6RL7HLv+iuy3hZRXstzn8DIWzfCvFNqBzZ22u6f
         oTaCnAJTg+QBJlYFdoFHP/MAIC0Uv7z5zJQYKp8qyPdZPwvClB2whlcyn3t1O1SDBK
         9R1eU0cKhx59A==
Date:   Fri, 19 Feb 2021 10:22:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net] r8152: move r8153_mac_clk_spd
Message-ID: <20210219102237.024917a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1394712342-15778-346-Taiwan-albertk@realtek.com>
References: <1394712342-15778-346-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Feb 2021 17:38:03 +0800 Hayes Wang wrote:
> Move calling r8153_mac_clk_spd() from r8153_first_init() to rtl8153_up(),
> and from r8153_enter_oob() to rtl8153_down().
> 
> r8153_mac_clk_spd() is used for RTL8153A. However, RTL8153B use
> r8153_first_init() and r8153_enter_oob(), too. Therefore,
> r8153_mac_clk_spd() needs to be moved.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Any word on what user-visible misbehavior this causes?

Can you provide a Fixes tag?
