Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308011C04A1
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 20:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgD3SXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 14:23:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34606 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgD3SXj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 14:23:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Z/8aIQFJ6dM3DkTEaEelA0KyajxuIhfuurg6Vcp9K08=; b=R6jGHoNYUtTxSdOEuTDSACDM4Z
        LIDnkrQoBU+c5QMlAEd0W9bC3RZS7BkOO3chbsGMaOpmhXxwvBMZwgYrIylEdMlmBgcn6nHnrRGhJ
        eUsLvnQSZI8XoiEEUyhbVg3e5WZaoRzar953SGfVvCm850BV693oBeAV5L2iPv8g4Rrw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUDqN-000Rjx-6X; Thu, 30 Apr 2020 20:23:31 +0200
Date:   Thu, 30 Apr 2020 20:23:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     cphealy@gmail.com, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 0/9] Ethernet Cable test support
Message-ID: <20200430182331.GE76972@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200429160213.21777-1-michael@walle.cc>
 <20200429163247.GC66424@lunn.ch>
 <c4363f2888192efc692e08cc1a4a9a57@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4363f2888192efc692e08cc1a4a9a57@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ok. I do have one problem. TDR works fine for the AR8031 and the
> BCM54140 as long as there is no link partner, i.e. open cable,
> shorted pairs etc. But as soon as there is a link partner and a
> link, both PHYs return garbage. As far as I understand TDR, there
> must not be a link, correct?

Correct.

The Marvell PHY will down the link and then wait 1.5 seconds before
starting TDR, if you set a bit. I _think_ it downs the link by turning
off autoneg.

Maybe there is some hints in 802.3 clause 22?

      Andrew
