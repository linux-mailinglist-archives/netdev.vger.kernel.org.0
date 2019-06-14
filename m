Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA40245068
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 02:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfFNABr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 20:01:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54036 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbfFNABr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 20:01:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KlljRKvActs+eqFAPylH3ixpEDSoHeVO7/3wDyc1jTw=; b=GYOmCN6RnfJIStux15cCmo1qOG
        4GQffgf+OdwSmUtv8+Hypr0Tpa7engWHSFmIJMdVqnXOKLnmHFUNFc4YJbwUE30hddDCHfEeNYUMr
        bl1gBZ4Yh7MToScD0ZRoF3TcRZu9M9sW0zbYur3Bmp6xQCfaCzAltlNtBuh0hm+6cvxc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hbZf7-0007ev-F8; Fri, 14 Jun 2019 02:01:45 +0200
Date:   Fri, 14 Jun 2019 02:01:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH RFC 00/13] Ethernet PHY cable test support
Message-ID: <20190614000145.GA28822@lunn.ch>
References: <20190612160534.23533-1-andrew@lunn.ch>
 <20190613095748.GA27054@microsemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613095748.GA27054@microsemi.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 03:28:04PM +0530, Raju Lakkaraju wrote:
> Hi Andrew,
> 
> Look like these patches are not create from "net-next" branch.
> Can you please share branch detail where i can apply patches and check the code
> flow?

Hi Raju

There is a branch https://github.com/lunn/linux.git v5.1-rc7-cable-test-vct7

You can also find the user space code in my github.

    Andrew
