Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9291EDA3B
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 03:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbgFDBBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 21:01:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35668 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730536AbgFDBBL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 21:01:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qgig+QxxR7tPUl/kgxOiJyYJNdXdDbQx8cvEheiz77E=; b=JuXnc4Ix6ThrhF8KQYwgDcCUPc
        G+0U/tE9RGfPTNKOlLp90SorYLvbKThHUywkJIh99TyKQcF6AiuimcAamPs0GAaoPHVjAas9R4ca0
        DnnS3PBL7zG6AEacjqNwrIjP5QaDPAzLF2PUq1rjvtLpspYj+VjHw2cSJJzbJTjY2Qxg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jgeFj-0046MS-1L; Thu, 04 Jun 2020 03:01:03 +0200
Date:   Thu, 4 Jun 2020 03:01:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Roelof Berg <rberg@berg-solutions.de>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lan743x: Use correct MAC_CR configuration for 1 GBit
 speed
Message-ID: <20200604010103.GB977471@lunn.ch>
References: <20200603215414.3606-1-rberg@berg-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603215414.3606-1-rberg@berg-solutions.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 11:54:14PM +0200, Roelof Berg wrote:
> Corrected the MAC_CR configuration bits for 1 GBit operation. The data
> sheet allows MAC_CR(2:1) to be 10 and also 11 for 1 GBit/s speed, but
> only 10 works correctly.
> 
> Devices tested:
> Microchip Lan7431, fixed-phy mode
> Microchip Lan7430, normal phy mode
> 
> Signed-off-by: Roelof Berg <rberg@berg-solutions.de>

Fixes: 6f197fb63850 ("lan743x: Added fixed link and RGMII support")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

This was probably in the pull request for the merge window.

     Andrew
