Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E01B326A23
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbfEVSvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:51:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43602 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728674AbfEVSvL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 14:51:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=unw5Kx+EnTIGktZp88SvhPqi10+Ihz3WkP0ztD4tlVY=; b=JMRpmABNnZaInh5lzEGOo9rRpN
        fV/Ci6IJAMUD/gWQ1oX5vN/T0jfCGdhN++Dvg56WYSeiriZLehd0Vpv47dDW1E2j/gGUr6M/VUyxW
        5dYmfunT5Hu5uUtFcwvujdzHTJPVC4UW13sPGX5blW4ON8emki/fSV4uSkZhXS2dFhYA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTWKS-00023C-Qe; Wed, 22 May 2019 20:51:08 +0200
Date:   Wed, 22 May 2019 20:51:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Trent Piepho <tpiepho@impinj.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v2 3/8] net: phy: dp83867: Add ability to
 disable output clock
Message-ID: <20190522185108.GA7281@lunn.ch>
References: <20190522184255.16323-1-tpiepho@impinj.com>
 <20190522184255.16323-3-tpiepho@impinj.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522184255.16323-3-tpiepho@impinj.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 06:43:22PM +0000, Trent Piepho wrote:
> Generally, the output clock pin is only used for testing and only serves
> as a source of RF noise after this.  It could be used to daisy-chain
> PHYs, but this is uncommon.  Since the PHY can disable the output, make
> doing so an option.  I do this by adding another enumeration to the
> allowed values of ti,clk-output-sel.
> 
> The code was not using the value DP83867_CLK_O_SEL_REF_CLK as one might
> expect: to select the REF_CLK as the output.  Rather it meant "keep
> clock output setting as is", which, depending on PHY strapping, might
> not be outputting REF_CLK.
> 
> Change this so DP83867_CLK_O_SEL_REF_CLK means enable REF_CLK output.
> Omitting the property will leave the setting as is (which was the
> previous behavior in this case).
> 
> Out of range values were silently converted into
> DP83867_CLK_O_SEL_REF_CLK.  Change this so they generate an error.
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Trent Piepho <tpiepho@impinj.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
