Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4158682003
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 17:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbfHEPWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 11:22:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34420 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728468AbfHEPWR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 11:22:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=G97AtjejQ0YitxzTxvbG9179M8ZKJZL8NT3sd8Ao4PY=; b=PrNPgYe7Mxd2wd2EzGYalDuL4v
        LmVllUTtc62qZBRhS3/+R7vXXPvJ2C9RQjbpwb0j/AcyQsnEeU3dbc+vUJj1aqqAWRHZHOujSboLN
        cSC+H7hC8TBDuAlXkQCP+uwmKq6V6yuQgupN8D/W5Bx3nJ++rbjVj8sMJxWECoP6hQv4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hueoQ-0007tQ-Ob; Mon, 05 Aug 2019 17:22:14 +0200
Date:   Mon, 5 Aug 2019 17:22:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH 14/16] net: phy: adin: make sure down-speed auto-neg is
 enabled
Message-ID: <20190805152214.GS24275@lunn.ch>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-15-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805165453.3989-15-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 07:54:51PM +0300, Alexandru Ardelean wrote:
> Down-speed auto-negotiation may not always be enabled, in which case the
> PHY won't down-shift to 100 or 10 during auto-negotiation.

Please look at how the marvell driver enables and configures this
feature. Ideally we want all PHY drivers to use the same configuration
API for features like this.

    Andrew
