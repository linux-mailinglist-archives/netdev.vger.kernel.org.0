Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A822A92A3
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729910AbfIDTyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 15:54:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55172 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbfIDTyD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 15:54:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TO3XmjK7/zkVIsdutEk+4Z0LXFPsPRLuV22DXu6h7GE=; b=XuGIq/dPS3G9wxj8KNBtmbPkxX
        jRyxT56aw9Kws2n+4QEsPCMntw8AOq5lGzqL5k/HmLQ2e80xkKQzzFi56u4ogCQ+AnhMmfhQR276/
        Ui35Mp0bJCKR/eu388lJNsjyvt12fktW1qHI9CoBpJtO3h5aaYQqJ7aJP/53OdPkYZZY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i5bLp-0005os-Bn; Wed, 04 Sep 2019 21:53:57 +0200
Date:   Wed, 4 Sep 2019 21:53:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net
Subject: Re: [PATCH v2 1/2] ethtool: implement Energy Detect Powerdown
 support via phy-tunable
Message-ID: <20190904195357.GA21264@lunn.ch>
References: <20190904162322.17542-1-alexandru.ardelean@analog.com>
 <20190904162322.17542-2-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904162322.17542-2-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 04, 2019 at 07:23:21PM +0300, Alexandru Ardelean wrote:

Hi Alexandru

Somewhere we need a comment stating what EDPD means. Here would be a
good place.

> +#define ETHTOOL_PHY_EDPD_DFLT_TX_INTERVAL	0x7fff
> +#define ETHTOOL_PHY_EDPD_NO_TX			0x8000
> +#define ETHTOOL_PHY_EDPD_DISABLE		0

I think you are passing a u16. So why not 0xfffe and 0xffff?  We also
need to make it clear what the units are for interval. This file
specifies the contract between the kernel and user space. So we need
to clearly define what we mean here. Lots of comments are better than
no comments.

   Andrew
