Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C58D611FE
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 17:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbfGFPry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 11:47:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58066 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726696AbfGFPry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Jul 2019 11:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yQs/mWxorMGK5S+h6pYa/yx93HBUr/8AdLhwNEPUfWw=; b=UeoWoE4VSYPQi+d0o2fqgwVoNL
        zFU/FGybOfWpTg8pkns8vv9ZeanDkDbx5tc73cniNtPt/+wVx6Wh4Cq6QOdf77SPdFnL1ZwvCJ1Lj
        w5vY1dvO/+fMESCi+yc/3lqTNhHWSzxarYsT4j3hiTipMmVYWF/hsP806qu+Ts6C7nBg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hjmum-0000P9-5V; Sat, 06 Jul 2019 17:47:52 +0200
Date:   Sat, 6 Jul 2019 17:47:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     josua@solid-run.com
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/4] net: mvmdio: allow up to four clocks to be specified
 for orion-mdio
Message-ID: <20190706154752.GF4428@lunn.ch>
References: <20190706151900.14355-1-josua@solid-run.com>
 <20190706151900.14355-3-josua@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190706151900.14355-3-josua@solid-run.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 06, 2019 at 05:18:58PM +0200, josua@solid-run.com wrote:
> From: Josua Mayer <josua@solid-run.com>
> 
> Allow up to four clocks to be specified and enabled for the orion-mdio
> interface, which are required by the Armada 8k and defined in
> armada-cp110.dtsi.
> 
> Fixes a hang in probing the mvmdio driver that was encountered on the
> Clearfog GT 8K with all drivers built as modules, but also affects other
> boards such as the MacchiatoBIN.
> 
> Cc: stable@vger.kernel.org
> Fixes: 96cb43423822 ("net: mvmdio: allow up to three clocks to be specified for orion-mdio")
> Signed-off-by: Josua Mayer <josua@solid-run.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
