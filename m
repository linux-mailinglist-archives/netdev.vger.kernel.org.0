Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A25E719B664
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 21:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732560AbgDATaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 15:30:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43770 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732244AbgDATaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 15:30:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6miRDx/15vjm57aJ2Sx5zO3TfKWc14aFRJ/ODQhTgRA=; b=ZmkQ5tYWfk07mpZ/fktwYupqBl
        OIYZVF+ocMVBv626soABm/CFC4OXwrlDz5GVs/TNr/V3M7rt2ORh3E+Aa5Rssw3WuxDXuyMzlQt4R
        Z2JPRgSTtpKiiXhPQrsCRLAxcbJnr41yDAhI7Lv3QIRgJ4tI+BlvwwASZQzRf6YqEx8g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jJj44-000UAf-Q0; Wed, 01 Apr 2020 21:30:16 +0200
Date:   Wed, 1 Apr 2020 21:30:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Shmuel Hazan <sh@tkos.co.il>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phy: marvell10g: add firmware load support
Message-ID: <20200401193016.GA114745@lunn.ch>
References: <16e4a15e359012fc485d22c7e413a129029fbd0f.1585676858.git.baruch@tkos.co.il>
 <ad024231-40bd-c82f-e6d0-3b1b00c93e9a@gmail.com>
 <87tv23ausd.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tv23ausd.fsf@tarshish>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I can't do much about that, unfortunately.

What did Marvell say when you asked them to release the firmware to
firmware-linux?

	Andrew
