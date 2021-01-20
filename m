Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F962FC92C
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731589AbhATDhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:37:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:42600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730106AbhATDgc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 22:36:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9982F22573;
        Wed, 20 Jan 2021 03:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611113750;
        bh=O+8Nr0YZFLEgcrC+VT54cPhLgV4UY7ImN7GJiaGjXrU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=God3T0G2YdRjE7ITtCqRswDu4UQVgh6+/7aR178mK2/JXqhRkm9kaPkFp48t3pup7
         lKbMECpVMbxxSWn3NkgpVe2Jzdw4RgsD1PINqdhxgkp1JqVeK6A7IAPtjRmbT3J5FR
         yyTWTX/h/3EENuUv8Z9wqV90HOvxiBEKqZSy3YWO+Jb8AH9zteNtfptB+XDKKn1Lpt
         hm0nnxHEs8jq2zmEHtlDzoHw+2IFIwHLxeFyb9OidtOugz4CQYgL5YoBQ7IarqJqDi
         hK759EZtzZreWKXu2qJyB5bq/wywY3+qnsf5U7PriRV2Es3JAHry65EakJ1RIrol82
         gVnnyzaa09SJg==
Date:   Tue, 19 Jan 2021 19:35:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: b53: fix an off by one in checking
 "vlan->vid"
Message-ID: <20210119193548.515ab674@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <44c35bd8-b7c3-49be-3a67-e9b1c8a02617@gmail.com>
References: <YAbxI97Dl/pmBy5V@mwanda>
        <44c35bd8-b7c3-49be-3a67-e9b1c8a02617@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 09:14:03 -0800 Florian Fainelli wrote:
> On 1/19/2021 6:48 AM, Dan Carpenter wrote:
> > The > comparison should be >= to prevent accessing one element beyond
> > the end of the dev->vlans[] array in the caller function, b53_vlan_add().
> > The "dev->vlans" array is allocated in the b53_switch_init() function
> > and it has "dev->num_vlans" elements.
> > 
> > Fixes: a2482d2ce349 ("net: dsa: b53: Plug in VLAN support")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>  
> 
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks!
