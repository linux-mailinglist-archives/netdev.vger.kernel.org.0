Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2CB172347
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 17:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbgB0QZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 11:25:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37192 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729263AbgB0QZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 11:25:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=myK1TSi18MdPxmOQZpDiX3sYSnyZ25KLFXk55FWunf4=; b=X5NOBosuXvExNlJSbVImpgBJGs
        tDGCWPSZ2beY8QTPnQYFBM3qzW57GqVUJoyEwRO9pbJDm0CXlmElPMEpJACZOhTynfPPSIJMEtFEm
        njf7hh6vQB+q/fRGQly3KXs7Hd0Q0dPVaotLl8BEwaR/u1KR+IGaUp1cWpIvR+mr9w1g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j7LyE-0006AU-Iq; Thu, 27 Feb 2020 17:25:06 +0100
Date:   Thu, 27 Feb 2020 17:25:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Quentin Schulz <foss@0leil.net>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: phy: mscc: implement RGMII skew delay
 configuration
Message-ID: <20200227162506.GD5245@lunn.ch>
References: <20200227152859.1687119-1-antoine.tenart@bootlin.com>
 <20200227152859.1687119-4-antoine.tenart@bootlin.com>
 <1f267571ddd9d1caf3e95afe31e47e30@0leil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f267571ddd9d1caf3e95afe31e47e30@0leil.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Also, do we actually need to write that register only when skews are defined
> in the DT? Can't we just write to it anyway (I guess the fact that 0_2 skew
> is actually 0 in value should put me on the right path but I prefer to ask).

Hi Quentin

Ideally, you don't want to rely on the boot loader doing some
magic. So i would prefer the skew is set to 0 if the properties are
not present.

    Andrew
