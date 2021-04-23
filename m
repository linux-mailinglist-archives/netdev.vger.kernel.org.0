Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30347369404
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 15:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbhDWNsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 09:48:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38032 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229454AbhDWNsf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 09:48:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZw9y-000fFh-LN; Fri, 23 Apr 2021 15:47:54 +0200
Date:   Fri, 23 Apr 2021 15:47:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: nxp-c45-tja11xx: add interrupt support
Message-ID: <YILQCubgTI9lCAnq@lunn.ch>
References: <20210423124329.993850-1-radu-nicolae.pirea@oss.nxp.com>
 <YILGp+LdyxsRhkb2@lunn.ch>
 <20210423134229.5cgxprkdcxf7kkwy@skbuf>
 <20210423134608.43tojxbeq36jtip2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423134608.43tojxbeq36jtip2@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ah, you mean the driver could be ACKing an event which was not the event
> that triggered this IRQ. In that case, the ordering should be reversed,
> sorry for the noise.

Yes, that is what i was meaning.

     Andrew
