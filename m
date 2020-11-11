Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1CC2AE4C5
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 01:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731610AbgKKANh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 19:13:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:57042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgKKANh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 19:13:37 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AE9B20855;
        Wed, 11 Nov 2020 00:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605053616;
        bh=6A87Cu9B1wBlxV+IkKipZ7SubIi9ZDbtKY1vvCPIduo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YG+561XTtD5wx8Rb7ClKmnFgoE1lHe2yRBnenaNX13TDfxPv7ZBWdyI/McEi8tvTe
         eq/2ik7Yq4K5pg/WEZXB+vhDnW8X0Q6nHu8zWld2ExGSFJOVHyX79wWbQByhTZme0S
         vVVF85N67XVGiyYxrXstDwgyE7jnvZN8Z5vMYaZo=
Date:   Tue, 10 Nov 2020 16:13:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: phy: realtek: support paged operations on
 RTL8201CP
Message-ID: <20201110161334.037ff026@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <69882f7a-ca2f-e0c7-ae83-c9b6937282cd@gmail.com>
References: <69882f7a-ca2f-e0c7-ae83-c9b6937282cd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 8 Nov 2020 22:44:02 +0100 Heiner Kallweit wrote:
> The RTL8401-internal PHY identifies as RTL8201CP, and the init
> sequence in r8169, copied from vendor driver r8168, uses paged
> operations. Therefore set the same paged operation callbacks as
> for the other Realtek PHY's.
> 
> Fixes: cdafdc29ef75 ("r8169: sync support for RTL8401 with vendor driver")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks!
