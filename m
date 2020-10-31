Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E5B2A183C
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 15:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgJaOgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 10:36:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56296 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbgJaOgv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 10:36:51 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYrzq-004W5U-Ua; Sat, 31 Oct 2020 15:36:46 +0100
Date:   Sat, 31 Oct 2020 15:36:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <ardeleanalex@gmail.com>
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 1/2] net: phy: adin: disable diag clock & disable
 standby mode in config_aneg
Message-ID: <20201031143646.GB1076434@lunn.ch>
References: <20201022074551.11520-1-alexandru.ardelean@analog.com>
 <20201023224336.GF745568@lunn.ch>
 <CA+U=Dsr3pbZspQu13YmZSLthgCeMNx_7guWTwLtb8vETbVsT_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+U=Dsr3pbZspQu13YmZSLthgCeMNx_7guWTwLtb8vETbVsT_A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So, then re-send for this or just this patch ping?
> Naturally, this is for net-next.
> I don't mind doing either way.

Please resend, with all the acked-by, reviewed-by added, now that
net-next is open.

	 Andrew
