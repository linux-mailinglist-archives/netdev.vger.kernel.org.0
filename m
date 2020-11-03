Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439A92A3834
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgKCBKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:10:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbgKCBKq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 20:10:46 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63EB122243;
        Tue,  3 Nov 2020 01:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604365845;
        bh=oC4/hbxNLi824qt/a+010PVAliecNxBJFV/NBqYByVk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vKe/ZuC3UHtqyNUNzLMQ6GmWDL6NML7bxIDcHAoyuAkjH7G+WTBpnhFbathtOoGRG
         wN97erjfuboWxvjkUhFXFKr4bIcTXF+l9ZTx6LcYXJhBaFFe/7sIqBJUMRILaJGIMk
         +PC3A0wGSctFoh5myoBS48u9B/dKyX4U1oRna7tU=
Date:   Mon, 2 Nov 2020 17:10:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/7] VLAN improvements for Ocelot switch
Message-ID: <20201102171039.654adb36@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031102916.667619-1-vladimir.oltean@nxp.com>
References: <20201031102916.667619-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 12:29:09 +0200 Vladimir Oltean wrote:
> The main reason why I started this work is that deleting the bridge mdb
> entries fails when the bridge is deleted, as described here:
> https://lore.kernel.org/netdev/20201015173355.564934-1-vladimir.oltean@nxp.com/
> 
> In short, that happens because the bridge mdb entries are added with a
> vid of 1, but deletion is attempted with a vid of 0. So the deletion
> code fails to find the mdb entries.
> 
> The solution is to make ocelot use a pvid of 0 when it is under a bridge
> with vlan_filtering 0. When vlan_filtering is 1, the pvid of the bridge
> is what is programmed into the hardware.
> 
> The patch series also uncovers more bugs and does some more cleanup, but
> the above is the main idea behind it.

Applied, thanks!
