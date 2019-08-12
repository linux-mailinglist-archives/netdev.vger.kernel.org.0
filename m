Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1F818A057
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 16:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfHLOGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 10:06:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53432 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbfHLOGv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 10:06:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LzrGsmrOZ2upp/2t0x+VbvfOPplojbnp9F3aLB8WpRc=; b=udxBoe6OHQjDewBeuq/w89ypGF
        g0rlx6neSrACL/7GnMR4vO5iHi3peHKJ+BmAI2qIvJZgOTiz+aGs05LEvoE8ECrPJ0992Hc+acTkX
        JkG8ybQUU/lpqPemAxpyOIMuzeUibEg2CNHM8fFRE7cl45qPuoQCen+aCZr2rMMEuJL8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxAyG-0000g9-4c; Mon, 12 Aug 2019 16:06:48 +0200
Date:   Mon, 12 Aug 2019 16:06:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH v4 04/14] net: phy: adin: add {write,read}_mmd hooks
Message-ID: <20190812140648.GN14290@lunn.ch>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
 <20190812112350.15242-5-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812112350.15242-5-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 02:23:40PM +0300, Alexandru Ardelean wrote:
> Both ADIN1200 & ADIN1300 support Clause 45 access for some registers.
> The Extended Management Interface (EMI) registers are accessible via both
> Clause 45 (at register MDIO_MMD_VEND1) and using Clause 22.
> 
> The Clause 22 access for MMD regs differs from the standard one defined by
> 802.3. The ADIN PHYs  use registers ExtRegPtr (0x0010) and ExtRegData
> (0x0011) to access Clause 45 & EMI registers.
> 
> The indirect access is done via the following mechanism (for both R/W):
> 1. Write the address of the register in the ExtRegPtr
> 2. Read/write the value of the register via reg ExtRegData
> 
> This mechanism is needed to manage configuration of chip settings and to
> access EEE registers via Clause 22.
> 
> Since Clause 45 access will likely never be used, it is not implemented via
> this hook.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
