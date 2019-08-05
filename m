Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7319981ED9
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 16:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbfHEORI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 10:17:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34200 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728852AbfHEORI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 10:17:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=R/2w3aRjCGD1Eg1zP2XPPpvmcPT8nfKg6EV3HX/nTXE=; b=fTMyTiRmyqMc+Tbvi8kwTyUwAf
        nR3/QDwh1iFlgZATwP7md/qI6Ktmo241JtOctSBJWATS3ZJFhpG4SWRWpfjEiFjQdanIsYG8atAZE
        MczkXEB6KiipJngIPrStldMGfvoWAIyyzOj8kCgL1vp3j+QeIy76XLLA8ok5A9EIljCQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hudnP-0007O5-5C; Mon, 05 Aug 2019 16:17:07 +0200
Date:   Mon, 5 Aug 2019 16:17:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH 02/16] net: phy: adin: hook genphy_{suspend,resume} into
 the driver
Message-ID: <20190805141707.GI24275@lunn.ch>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-3-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805165453.3989-3-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 07:54:39PM +0300, Alexandru Ardelean wrote:
> The chip supports standard suspend/resume via BMCR reg.
> Hook these functions into the `adin` driver.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
