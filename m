Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E11125EAFE
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 23:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgIEV3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 17:29:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728505AbgIEV3y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 17:29:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F70D2072D;
        Sat,  5 Sep 2020 21:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599341394;
        bh=nrdhJZ17WrrL5Y9PerJBlMMKylSGHspzCdVR+DUJWZs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2DhGJqP/uOB1va18JNY4lrskglHtBZk3LqeZfR/28+i9KgFw5B+zduiedO0RwnqLi
         OTJlkuISoeGQXxZMeNgAoKVO/huKiUiJ9buakfEjSBXYx+JvLABW/pMkqRTgQLv2RO
         QurwXeOF9Uyd5VlQY7KOuGggBae4VGHuw1dCn+/4=
Date:   Sat, 5 Sep 2020 14:29:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED 
        DEVICE TREE)
Subject: Re: [PATCH net-next v2 0/2] net: dsa: bcm_sf2: Ensure MDIO
 diversion is used
Message-ID: <20200905142951.2f1ac216@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200904213730.3467899-1-f.fainelli@gmail.com>
References: <20200904213730.3467899-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Sep 2020 14:37:28 -0700 Florian Fainelli wrote:
> Changes in v2:
> 
> - export of_update_property() to permit building bcm_sf2 as a module
> - provided a better explanation of the problem being solved after
>   explaining it to Andrew during the v1 review

Applied, thanks everyone!
