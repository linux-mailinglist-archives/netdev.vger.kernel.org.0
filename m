Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 880EF78F4F
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 17:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388083AbfG2PcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 11:32:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45042 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387983AbfG2PcK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 11:32:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=87rbIchsoG1YbtVeld/osip7Rb3mOAkZcZQFZiCcJK0=; b=I8G1Uh04QiypKHAkVqakyYRmnv
        l7sTDr2lgKbI0wUx5hsN86wuPvbyKc3s1+JCbyYsdwysrCppBAXbdEq2CudWEbbb1Awm9kl3D6Oz+
        QDKrg34UxvREmqS2GP579i1YPyUEea0YxgWsGIjnNCYAfdEk5a5f5/Noazw5+f2CALwo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hs7d4-0002R2-28; Mon, 29 Jul 2019 17:32:02 +0200
Date:   Mon, 29 Jul 2019 17:32:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/4] enetc: Clean up local mdio bus allocation
Message-ID: <20190729153202.GF4110@lunn.ch>
References: <1564394627-3810-1-git-send-email-claudiu.manoil@nxp.com>
 <1564394627-3810-2-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564394627-3810-2-git-send-email-claudiu.manoil@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 01:03:44PM +0300, Claudiu Manoil wrote:
> What's needed is basically a pointer to the mdio registers.
> This is one way to store it inside bus->priv allocated space,
> without upsetting sparse.
> Reworked accessors to avoid __iomem casting.
> Used devm_* variant to further clean up the init error /
> remove paths.
> 
> Fixes following sparse warning:
>  warning: incorrect type in assignment (different address spaces)
>     expected void *priv
>     got struct enetc_mdio_regs [noderef] <asn:2>*[assigned] regs
> 
> Fixes: ebfcb23d62ab ("enetc: Add ENETC PF level external MDIO support")
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>


Thanks, much nicer.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
