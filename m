Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2A617935F
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 16:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729725AbgCDP2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 10:28:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45576 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbgCDP2x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 10:28:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=x30yDmZgR88IH5jCGtl6A2Rh5dtdI+huFbLm4TgEaJY=; b=Rcxv8wkfn7VxLvNqIF7RivlY6m
        9iROJ3LadRfR1i1aqzdf6I1IWz1KyOBpZwBpBUiOztcoNz6ICm2rEBz74hGAhSl21z6+F9oZDsR3V
        ZOxVbcFfd5J9oqZyU809qj6hXjtB1I16vWhaKRv03oO11wqc39aRDS0hhkUKs6N3CNnw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j9Vx3-0006dJ-5O; Wed, 04 Mar 2020 16:28:49 +0100
Date:   Wed, 4 Mar 2020 16:28:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hau <hau@realtek.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>
Subject: Re: SFP+ support for 8168fp/8117
Message-ID: <20200304152849.GE3553@lunn.ch>
References: <DC28A43E-4F1A-40B6-84B0-3E79215527C9@canonical.com>
 <c148fefc-fd56-26a8-9f9b-fbefbaf25050@gmail.com>
 <02F7CBDE-B877-481C-A5AF-2F4CBF830A2C@canonical.com>
 <80E9C881-91C8-4F29-B9CE-652F9EE0B018@canonical.com>
 <995bddbc4f9d48cbb3a289a7e9799f15@realtek.com>
 <12EA7285-06D7-44D3-B033-4F52A06123CC@canonical.com>
 <cae39cfbb5174c8884328887cdfb5a89@realtek.com>
 <9AAC75D4-B04F-49CD-BBB9-11AE3382E4D8@canonical.com>
 <5A21808E-C9DA-44BF-952B-4A5077B52E9B@canonical.com>
 <e10eef58d8fc4b67ac2a73784bf86381@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e10eef58d8fc4b67ac2a73784bf86381@realtek.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Kai-Heng,
> 
> For adding SFP+ support for rtl8168fp, 
> 1.Some power saving features must be disabled, like APDLS/EEE/EEEPLUS...
> 2.PHY capability must be set to auto-negation.
> 
> I am kind of busy this week. I will try to add support for this chip into upstream next week.

Is it possible to access the I2C bus? The GPIO lines from the SFP
socket like LOS, TX Disable?

Thanks
	Andrew
