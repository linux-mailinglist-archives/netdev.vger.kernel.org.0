Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 474548EF9B
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 17:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730803AbfHOPne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 11:43:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35100 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729975AbfHOPne (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 11:43:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=v+vEKpkiTrCRCviBkUT/dy67Acr/g1WViBiOURM2aww=; b=z2WIMJFqszQsU/fKTOspR+opOn
        Mons+XbPSrrbrm5uyuKnlDCNbIqOzrPDuDiSqAPeYucUo+2MuLFuwV+K8dh/nx9PppS3/dQRBWWib
        jgSwWVM7WahCIIv1c5Y5ewyY4ZImkf7BUWjdy39Ij45pgBswPfbw+Q08ql4Nto7ua+1s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hyHuR-0001Zg-Rw; Thu, 15 Aug 2019 17:43:27 +0200
Date:   Thu, 15 Aug 2019 17:43:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Herber <christian.herber@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 0/1] Add BASE-T1 PHY support
Message-ID: <20190815154327.GD15291@lunn.ch>
References: <20190815153209.21529-1-christian.herber@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815153209.21529-1-christian.herber@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 03:32:27PM +0000, Christian Herber wrote:
> This patch adds basic support for BASE-T1 PHYs in the framework.
> BASE-T1 PHYs main area of application are automotive and industrial.
> BASE-T1 is standardized in IEEE 802.3, namely
> - IEEE 802.3bw: 100BASE-T1
> - IEEE 802.3bp 1000BASE-T1
> - IEEE 802.3cg: 10BASE-T1L and 10BASE-T1S

Hi Christian

Please make sure you Cc: the PHY subsystem maintainers.

       Andrew
