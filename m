Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D22EEFB3DE
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 16:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbfKMPkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 10:40:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38266 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726957AbfKMPkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 10:40:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=T/hX9SJQq6Ws1YkXKuSDFzJIPqQ2Lt93HIkRi5lZFOY=; b=ov5QI+U6fg1pOfHKSzeVX8buX4
        ortfu3P/IpX4+7G0jpt6fy2dNH+FIZdlUJOHuZI9FGYPlWpbhA9onuMlAlvU3F2IibNRVFmsmjLP+
        XkbIsMLktA9hlXjUMRQdiKFV7BZFx9ACdNeFO5P78CEVm45hehwB8h8d7g45/V0sN3cI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUukZ-0007nT-Bb; Wed, 13 Nov 2019 16:40:07 +0100
Date:   Wed, 13 Nov 2019 16:40:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bryan.Whitehead@microchip.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v1 net-next] mscc.c: Add support for additional VSC PHYs
Message-ID: <20191113154007.GJ10875@lunn.ch>
References: <1573574048-12251-1-git-send-email-Bryan.Whitehead@microchip.com>
 <20191112204031.GH10875@lunn.ch>
 <MN2PR11MB4333B89CD568C6B66C8C60E3FA770@MN2PR11MB4333.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR11MB4333B89CD568C6B66C8C60E3FA770@MN2PR11MB4333.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> 
> I would like to do exactly that, but I was concerned future changes might change the phy_id_mask, so to keep code less brittle, and more flexible I thought I should keep the "AND mask" operations such as (PHY_ID_VSC8<FOO> & phydev->drv->phy_id_mask)

Hi Bryan

You could add a WARN_ON(phydev->drv->phy_id_mask & 0xf); That should
catch any new PHY breaking the assumption.

    Andrew
