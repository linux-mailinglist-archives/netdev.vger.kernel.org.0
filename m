Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBDA8C1FD
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 22:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfHMUQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 16:16:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58206 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfHMUQM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 16:16:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kAF7eVnNPJQynBUIpx5n8irHsMaEIfa7VxDPBSOiHXU=; b=a+l5Gkmag6jvc4e57Ky17d4gxt
        OU5tnoD5+R4z6yKpMld2SRmKx/v0DLZW637DRBeyfbmzWGWj+T67AIgZJDXOaMqldRYdzRVBSJ7az
        YN2qy6rQUuwumwMhF1DGxcQ0TScfQHtqFb3RMT47ESGM/5OCPprhf6kbLq2rM5LkjeNc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxdDF-0004Lp-Ta; Tue, 13 Aug 2019 22:16:09 +0200
Date:   Tue, 13 Aug 2019 22:16:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/3] net: phy: add __set_linkmode_max_speed
Message-ID: <20190813201609.GM15047@lunn.ch>
References: <dca82a0e-e936-b60a-3a1c-9fdb1714d1d3@gmail.com>
 <4c77b801-6005-834c-da0e-f32847961f81@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c77b801-6005-834c-da0e-f32847961f81@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 11:50:30PM +0200, Heiner Kallweit wrote:
> We will need the functionality of __set_linkmode_max_speed also for
> linkmode bitmaps other than phydev->supported. Therefore split it.
> 
> v2:
> - remove unused parameter from __set_linkmode_max_speed
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
