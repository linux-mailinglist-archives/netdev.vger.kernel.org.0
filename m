Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFD6409C86
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 20:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244373AbhIMSuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 14:50:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38868 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233322AbhIMSup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 14:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5FAlYJR+L5K5/mBd9HnFp40bPv/czg5qf8z7Hb1WYVw=; b=PWXhzXJZ+LIy86u9GTxMu/azsa
        Xezrgnl7esbVqQxEcugmLxSblI2wIzy7qPfIdahoI1FLLxjDJsvYnP0J/lUP6WmmjlAp0uaYOSexz
        C5YCrYF5Un2Em1vyDbJ02+ESHozfoSRpa2qt6glrq43lx9Q48DBOMbBdzfiiYi2lJ9G8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mPr15-006RuN-Sl; Mon, 13 Sep 2021 20:49:19 +0200
Date:   Mon, 13 Sep 2021 20:49:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net] Revert "net: phy: Uniform PHY driver access"
Message-ID: <YT+dL1R/DTVBWQ7D@lunn.ch>
References: <20210912192805.1394305-1-vladimir.oltean@nxp.com>
 <CANr-f5wCpcPM+FbeW+x-JmZt0-WmE=b5Ys1Pa_G7p8v3nLyCcQ@mail.gmail.com>
 <20210912213855.kxoyfqdyxktax6d3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210912213855.kxoyfqdyxktax6d3@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I am not sure why "to_phy_driver" needs cleanup. Au contraire, I think
> the PHY library's usage of struct phy_device :: drv is what is strange
> and potentially buggy, it is the only subsystem I know of that keeps its
> own driver pointer rather than looking at struct device :: driver.

There is one odd driver in the mix. Take a look at xilinx_gmii2rgmii.c.

It probably could be done a better way, but that is what we have.

   Andrew
