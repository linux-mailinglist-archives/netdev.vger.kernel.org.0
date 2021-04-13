Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27EF35E159
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 16:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbhDMO0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 10:26:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48436 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231894AbhDMO0k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 10:26:40 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lWJzg-00GU3W-3p; Tue, 13 Apr 2021 16:26:20 +0200
Date:   Tue, 13 Apr 2021 16:26:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Subject: Re: [PATCH net-next 4/5] net: dsa: mv88e6xxx: simulate Amethyst PHY
 model number
Message-ID: <YHWqDGyIfsQ/lcCf@lunn.ch>
References: <20210413075538.30175-1-kabel@kernel.org>
 <20210413075538.30175-5-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210413075538.30175-5-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 09:55:37AM +0200, Marek Behún wrote:
> Amethyst internal PHYs also report empty model number in MII_PHYSID2.
> 
> Fill in switch product number, as is done for Topaz and Peridot.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
