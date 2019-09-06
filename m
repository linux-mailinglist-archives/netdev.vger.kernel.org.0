Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F569AC0F1
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 21:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731576AbfIFTxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 15:53:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60488 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727004AbfIFTxW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 15:53:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cv21XlsJYoLyi+OCterBTgXFjPexWPivCC9FVeGN0ew=; b=1lpRsIIMuuEFWmuhhPhhDXOx9L
        boyIabWu+kt0XJtl8I1+56+SfuQRPeFJ8QHMV/8DvcP/FU50sQmBW1uxaemd0uNY92N8HGgu2SSqE
        38Fs5ZkfEld6E854xiMejjYzxrAsCSETxP+eTUq3qOwvExEQCVUec0xl0dmeYtf+kl0c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i6KIG-0001Dj-OV; Fri, 06 Sep 2019 21:53:16 +0200
Date:   Fri, 6 Sep 2019 21:53:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/5] enetc: Make mdio accessors more generic
Message-ID: <20190906195316.GC2339@lunn.ch>
References: <1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com>
 <1567779344-30965-3-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567779344-30965-3-git-send-email-claudiu.manoil@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 05:15:41PM +0300, Claudiu Manoil wrote:
> +#define enetc_mdio_rd(mdio_priv, off) \
> +	_enetc_mdio_rd(mdio_priv, ENETC_##off)
> +#define enetc_mdio_wr(mdio_priv, off, val) \
> +	_enetc_mdio_wr(mdio_priv, ENETC_##off, val)

Hi Claudiu

The MDIO code appears to be the only part of this driver which does
these ENETC_##off games. Could you please clean this up and use the
full name in the enetc_mdio_rd() and enetc_mdio_wr() calls.

Otherwise this looks good.

	  Andrew
