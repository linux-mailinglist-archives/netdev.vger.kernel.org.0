Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A4D1D166C
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 15:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388747AbgEMNta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 09:49:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57966 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbgEMNta (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 09:49:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vE3N/bgCOSuBsuoedjezPDBuOaPIgi01RG5Bucwqlu8=; b=ewcl5ODpAGeimIVHP1ORPWJEFl
        QIJBqbAhMG7S4Plui+l8Ele2Wr4GEWqKdI8dth1eWMUbgvCcd22tHLWy8Hlnc2F/LD7MVRhdm+j6e
        aAW5YRVXbg20bp05k8hUBL3e3VHZdFBbnaUCF0IUE3+DBg4hUtS6Wrg9YgysqUc8j+Fo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jYrlF-002ARp-BL; Wed, 13 May 2020 15:49:25 +0200
Date:   Wed, 13 May 2020 15:49:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] net: ethernet: validate pause autoneg
 setting
Message-ID: <20200513134925.GE499265@lunn.ch>
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-2-git-send-email-opendmb@gmail.com>
 <20200512004714.GD409897@lunn.ch>
 <ae63b295-b6e3-6c34-c69d-9e3e33bf7119@gmail.com>
 <20200512185503.GD1551@shell.armlinux.org.uk>
 <0cf740ed-bd13-89d5-0f36-1e5305210e97@gmail.com>
 <20200513053405.GE1551@shell.armlinux.org.uk>
 <20200513092050.GB1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513092050.GB1605@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So, I think consistency of implementation is more important than fixing
> this; the current behaviour has been established for many years now.

Hi Russell, Doug

With netlink ethtool we have the possibility of adding a new API to
control this. And we can leave the IOCTL API alone, and the current
ethtool commands. We can add a new command to ethtool which uses the new API.

Question is, do we want to do this? Would we be introducing yet more
confusion, rather than making the situation better?

	Andrew
