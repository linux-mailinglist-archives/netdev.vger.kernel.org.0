Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 970D5E1F74
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 17:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406593AbfJWPiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 11:38:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59818 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390140AbfJWPiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 11:38:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=V3oDxr418GNArABHMwXWMqzw6a3zK7l1rUhwHe5yV+s=; b=iPF6zM0xmLLT26VQxQ2zDfozH6
        Ufu9tk0izsRMbMRFuECX4f57dbespw4Njlr/xJPGeq68YebbFOw8Xj9T0O+y+tyD0VunoMF1NuFox
        lGCahVUDmQuh4XIbsHjitNtcznHHv/WYZQ4/l6gBel6v2nWXsWav5UMM5b8RCVR5DLiQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iNIhz-0007MJ-3W; Wed, 23 Oct 2019 17:37:59 +0200
Date:   Wed, 23 Oct 2019 17:37:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: phy: dp83867: move dt parsing to probe
Message-ID: <20191023153759.GA13748@lunn.ch>
References: <20191023144846.1381-1-grygorii.strashko@ti.com>
 <20191023144846.1381-3-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023144846.1381-3-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 05:48:46PM +0300, Grygorii Strashko wrote:
> Move DT parsing code to probe dp83867_probe() as it's one time operation.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
