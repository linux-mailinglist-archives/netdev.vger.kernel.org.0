Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714061BE2A1
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgD2PZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:25:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59656 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727840AbgD2PZY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 11:25:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ERta3XGJt44UVRWbLsZErs7dbWP8EYdCh3D7pNMeiPI=; b=n8QpT5LbD2etyGw7FNWCZ9GhQe
        3RY8AzwDD1dKzrU8KRFI/7Nk65M9DfwPH/t5cHeXwmL8s+M1w3vS4j2akJHPl6E9G0KfmlVyUPlSO
        7ZOqBig8pS9wWxcUBA93pn0XG2W/c6OM0mY5pgbiYStwIxBNtK1TDDllQNvWUd6/6FV0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jToaN-000HlH-4n; Wed, 29 Apr 2020 17:25:19 +0200
Date:   Wed, 29 Apr 2020 17:25:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Badel, Laurent" <LaurentBadel@eaton.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "alexander.levin@microsoft.com" <alexander.levin@microsoft.com>,
        "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: Re: [PATCH 1/2] Revert commit
 1b0a83ac04e383e3bed21332962b90710fcf2828
Message-ID: <20200429152519.GB66424@lunn.ch>
References: <CH2PR17MB3542DCD8D9825EE6B88BC5FCDFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR17MB3542DCD8D9825EE6B88BC5FCDFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Test results: using an iMX28-EVK-based board, this patch successfully
> restores network interface functionality when interrupts are enabled.
> Tested using both linux-5.4.23 and latest mainline (5.6.0) kernels.

Hi Laurent

What tree are these patches against?

That is why i pointed you to the netdev FAQ.

Also, for a multi-part series, you should add a cover latter.

     Andrew
