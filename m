Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F31953BEA6
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390033AbfFJV1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:27:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43042 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389945AbfFJV1r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 17:27:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qxJMlyJiW2BUUReUE3eBA6Nf+lTMls7+oxfH/vac334=; b=ikRkuvTqcLXYDDg5drmlGHpFXJ
        tO2lGs8AIaYVW0Zzw0SwjYNo63YLDX3u3+lriupqeKNFkbnlL+QRQ5KJWhqVijeCaTYpyKeGoyGN5
        M0lOuDhb55dybAvlyjexj56M42+NN8k6eGkgWbK0VU9K0ZJUddwtD0dKVEfDmu7uQhDo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1haRpP-00028J-3c; Mon, 10 Jun 2019 23:27:43 +0200
Date:   Mon, 10 Jun 2019 23:27:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] net: phy: add state PERM_FAIL
Message-ID: <20190610212743.GE2191@lunn.ch>
References: <8e4cd03b-2c0a-ada9-c44d-2b5f5bd4f148@gmail.com>
 <9e1b2e30-139d-c3b9-0ac3-5775a4ade3a6@gmail.com>
 <20190610185123.GA2191@lunn.ch>
 <68508be9-1a36-48ab-7428-bf6e7f71be59@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68508be9-1a36-48ab-7428-bf6e7f71be59@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Maybe the broader question is how do you, Heiner and Russell imagine a
> genuine case where the PHY does not have a firmware provided/loaded
> before Linux does take over (say, BoM cost savings dictate no flash can
> be used

I've not seen either of these PHY devices not have a FLASH. I also
wonder how long such a download to RAM takes. I suspect it is
slow. The boards i have, have a 4Mbit Flash, so, 256K 16bit words.
How long does 256K MDIO transfers take, given that they are typically
polled IO? Is that a reasonable design/cost trade off?

       Andrew
