Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E8B28A938
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 20:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgJKSVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 14:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbgJKSVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 14:21:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38ACA2222A;
        Sun, 11 Oct 2020 18:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602440489;
        bh=8GagMgwL6ZhTQaAft9xW2hZ//p+YJk8GgoQJBdTwBHY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pN+JysvuPZJNcWm3tuvVocf3M6P4sttWf19Gbo/BHVsvBHiLknHpzfdbzNxWWYvdp
         5y+//nwQM+aHwAhash7miM+Oq+zkjdVqs+C+jDOrYutudvsQshLanFcCGYPZk23TI6
         qzxQxbmCHz+kW4o28kpYroex9yVniNBGOXO9ModI=
Date:   Sun, 11 Oct 2020 11:21:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 0/3] Offload tc-vlan mangle to mscc_ocelot
 switch
Message-ID: <20201011112127.32e5731a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008115700.255648-1-vladimir.oltean@nxp.com>
References: <20201008115700.255648-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  8 Oct 2020 14:56:57 +0300 Vladimir Oltean wrote:
> This series offloads one more action to the VCAP IS1 ingress TCAM, which
> is to change the classified VLAN for packets, according to the VCAP IS1
> keys (VLAN, source MAC, source IP, EtherType, etc).

Applied, thanks!
