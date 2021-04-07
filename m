Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D746535783B
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhDGXFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:05:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39172 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229460AbhDGXFa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 19:05:30 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lUHEd-00FOrM-5S; Thu, 08 Apr 2021 01:05:19 +0200
Date:   Thu, 8 Apr 2021 01:05:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, kuba@kernel.org
Subject: Re: [PATCH net-next v4 08/16] net: phy: marvell10g: check for
 correct supported interface mode
Message-ID: <YG46ryy1C++lsykV@lunn.ch>
References: <20210407202254.29417-1-kabel@kernel.org>
 <20210407202254.29417-9-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210407202254.29417-9-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 10:22:46PM +0200, Marek Behún wrote:
> The 88E2110 does not support xaui nor rxaui modes. Check for correct
> interface mode for different chips.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
