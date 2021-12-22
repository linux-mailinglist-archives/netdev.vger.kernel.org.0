Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286C447D949
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 23:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236666AbhLVWXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 17:23:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47578 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhLVWXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 17:23:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A71B061C4F;
        Wed, 22 Dec 2021 22:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F04C36AE8;
        Wed, 22 Dec 2021 22:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640211819;
        bh=cXkz/cQ2pbZxaj1t81i1pc+KWHw9fIJz3gJY+hn67mw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ci7gtavkVHhFDg0KRoHW9hN7JEiIvbXwFGryNCFzSLjtTgrDbg1tZIv9JMoTx7Fd3
         U3Rp+bqZTvU2Gk7EctpaqTOP+uC17hn88JhUMwFZBvUQFQ+wetddtE4raPNvqBq+wC
         jiqKmyvTfWlOF00vbW0Q9PD+Fma837g6qri33jm4ORnOUbi5YXVFh/jjHK/GQHRz0b
         lxp6/PMazKPz+Kd2XDyTss2KRKW0/7OplFyysF8a6z6/824IYH2q3OyQjLoOvTBX9t
         0gjzdhaJJVNyWK6z6pGGgLnmv3N2DI5H932aaw5U2x1vVzqDvMDsQFJy/69q9/eMuo
         9UbLXLeboWACA==
Date:   Wed, 22 Dec 2021 14:23:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, marouen.ghodhbane@nxp.com
Subject: Re: [PATCH net-next] net: dsa: tag_ocelot: use traffic class to map
 priority on injected header
Message-ID: <20211222142337.0325219b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211221110209.31309-1-xiaoliang.yang_1@nxp.com>
References: <20211221110209.31309-1-xiaoliang.yang_1@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Dec 2021 19:02:09 +0800 Xiaoliang Yang wrote:
> For Ocelot switches, the CPU injected frames have an injection header
> where it can specify the QoS class of the packet and the DSA tag, now it
> uses the SKB priority to set that. If a traffic class to priority
> mapping is configured on the netdevice (with mqprio for example ...), it
> won't be considered for CPU injected headers. This patch make the QoS
> class aligned to the priority to traffic class mapping if it exists.
> 
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> Signed-off-by: Marouen Ghodhbane <marouen.ghodhbane@nxp.com>

Is this a fix? Looks like one.
