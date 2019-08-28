Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E869A0939
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 20:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfH1SHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 14:07:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38480 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbfH1SHA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 14:07:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZFvGMza15ngZrDEMw/qc9GUTeA/63ZnQGGVV9mb6/TU=; b=at4nmbDEh46aU3q3P9/CB2+YsF
        3HHB6SMsVAaQ8sbF/sKmg7KyQLVkr8BRFDknUQKwwYHDKle465IBrVj7Klv7H8rdT0FBccqq9ogey
        sRpdwlWsc4Pqh7X+CjViHhH3fox8xsDHB/3d6wQhDhsdh3eMywtSQpqDR0+cxc+uzrcA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i32LH-000512-Ra; Wed, 28 Aug 2019 20:06:47 +0200
Date:   Wed, 28 Aug 2019 20:06:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     davem@davemloft.net, linux@armlinux.org.uk,
        mcoquelin.stm32@gmail.com, joabreu@synopsys.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, weifeng.voon@intel.com
Subject: Re: [RFC net-next v2 3/5] net: phy: add private data to mdio_device
Message-ID: <20190828180647.GA17864@lunn.ch>
References: <20190828174722.6726-1-boon.leong.ong@intel.com>
 <20190828174722.6726-4-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828174722.6726-4-boon.leong.ong@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 01:47:20AM +0800, Ong Boon Leong wrote:
> PHY converter device is represented as mdio_device and requires private
> data. So, we add pointer for private data to mdio_device struct.

Hi Ong

This was discussed recently with regard to the xilinx_gmii2rgmii.c
driver. You can use the usual dev_get_drvdata() to get private data
associated to the device. I did suggest adding wrappers, so you can
pass a phydev, or and mdiodev.

     Andrew

