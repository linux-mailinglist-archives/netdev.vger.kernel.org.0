Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B85B133CE0
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 03:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfFDBur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 21:50:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52744 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfFDBuq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 21:50:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9aYBR+ChM9b0r9InSGeh76Dfwf6gDMyd/B79DaUVug4=; b=a9v2rM9/oUHa3Ap+YHUnQd1VdW
        Bxf9pmBthKBI1CHBJbaWpqCLj6UfDn8Xu+MXE45Fp2eusQ70WiUyIA4A9ajkzyjA52i5XTTPHioXS
        1T5hjFC/Ov19YCrDJWlRiUiN0VfiYYoAgtpai44WlhKCJSmuLmorjKhvn25KNOnNTvyQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXyb5-0001AY-BS; Tue, 04 Jun 2019 03:50:43 +0200
Date:   Tue, 4 Jun 2019 03:50:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Wilson, Matt" <msw@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Subject: Re: [PATCH V2 net 00/11] Extending the ena driver to support new
 features and enhance performance
Message-ID: <20190604015043.GG17267@lunn.ch>
References: <20190603144329.16366-1-sameehj@amazon.com>
 <20190603143205.1d95818e@cakuba.netronome.com>
 <9da931e72debc868efaac144082f40d379c50f3c.camel@amazon.co.uk>
 <20190603160351.085daa91@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603160351.085daa91@cakuba.netronome.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Any "SmartNIC" vendor has temptation of uAPI-level hand off to the
> firmware (including my employer), we all run pretty beefy processors
> inside "the NIC" after all.  The device centric ethtool configuration
> can be implemented by just forwarding the uAPI structures as they are
> to the FW.  I'm sure Andrew and others who would like to see Linux
> takes more control over PHYs etc. would not like this scenario, either.

No, i would not. There are a few good examples of both firmware and
open drivers being used to control the same PHY, on different
boards. The PHY driver was developed by the community, and has more
features than the firmware driver. And it keeps gaining features. The
firmware i stuck, no updates. The community driver can be debugged,
the firmware is a black box, no chance of the community fixing any
bugs in it.

And PHYs are commodity devices. I doubt there is any value add in the
firmware for a PHY, any real IPR which makes the product better, magic
sauce related to the PHY. So just save the cost of writing and
maintaining firmware, export the MDIO bus, and let Linux control it.
Concentrate the engineers on the interesting parts of the NIC, the
Smart parts, where there can be real IPR.

And i would say this is true for any NIC. Let Linux control the PHY.

      Andrew

