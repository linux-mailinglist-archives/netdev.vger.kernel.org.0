Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F17C73003
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 15:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbfGXNgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 09:36:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34300 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbfGXNgM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 09:36:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CbbLlsxY65sOssFP4N3qCJHoZzpk6StaGkrvzZdnbOU=; b=vZQLQmaVY9c7oZ4fPw12uzGZQW
        jq4yD7QhQr1JJf2cP82pzjTzhhkQqkqs/mpIbzoz9R/VYJpsewSqdsIyFTft6+w5S0Wr2C0ULNWxL
        Bn5qD9/h/z7qiuiYX57Mv2EaWr4oE3f8+NBUHlzOP+c8QUtWygaPCSXkO2fH97YC4vW8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hqHR5-0007tL-UU; Wed, 24 Jul 2019 15:36:03 +0200
Date:   Wed, 24 Jul 2019 15:36:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arseny Solokha <asolokha@kb.kras.ru>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: phylink: don't start and stop SGMII PHYs in SFP
 modules twice
Message-ID: <20190724133603.GP25635@lunn.ch>
References: <20190724090139.GG1330@shell.armlinux.org.uk>
 <20190724133139.8356-1-asolokha@kb.kras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724133139.8356-1-asolokha@kb.kras.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This is a general fix and may be taken out from the driver conversion series
> and applied separately.

Hi Arseny

Yes please. Add a Fixes: tag and post it as a single patch for the net
tree.

Thanks
	Andrew
