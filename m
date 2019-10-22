Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26AFBE03EE
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 14:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389023AbfJVMe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 08:34:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57512 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388066AbfJVMe2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 08:34:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DaWu7ewNHf0bG3S4bYR7+QQhteeZV+2msxTJnL4r6rU=; b=TKE3iX4E8mAD7D5hy2pkpQE7EF
        LbEtQPAWCo67DEL1DXsSOC4dRAZ6ljT2+NojoAEBx6CvAxeySpBjmk6vNrHOfYfqFzI7RH6fibAem
        BXKDWTJB384zuu8B3+RFLoNd5H8/nKPAERrvzA+26Fq4iRf/RbUSwWdg9Qwjs6emfLiA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iMtMm-0001X0-B6; Tue, 22 Oct 2019 14:34:24 +0200
Date:   Tue, 22 Oct 2019 14:34:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Thomas =?iso-8859-1?Q?H=E4mmerle?= 
        <Thomas.Haemmerle@wolfvision.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "m.tretter@pengutronix.de" <m.tretter@pengutronix.de>
Subject: Re: [PATCH] net: phy: dp83867: support Wake on LAN
Message-ID: <20191022123424.GA5707@lunn.ch>
References: <1571742645-13800-1-git-send-email-thomas.haemmerle@wolfvision.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1571742645-13800-1-git-send-email-thomas.haemmerle@wolfvision.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 11:11:07AM +0000, Thomas Hämmerle wrote:
> +		if (wol->wolopts & WAKE_MAGICSECURE) {
> +			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP1,
> +				      (wol->sopass[1] << 8) | wol->sopass[0]);
> +			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP1,
> +				      (wol->sopass[3] << 8) | wol->sopass[2]);
> +			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP1,
> +				      (wol->sopass[5] << 8) | wol->sopass[3]);

Hi Thomas

I see sopass[3] twice here. Is that a typo?

  Andrew
