Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B35DFECAB
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbfD2WTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:19:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49225 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728105AbfD2WTB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 18:19:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4k+j06HYbCfMuWfdD8ZClUNb1uKBylx/RNhaeXzQeg4=; b=MzscgyER8+i6YKJuG2RsWT6IL8
        ngBlTmAMYclIOJUBHHPsHptm8kdjEuXAMAxLV4599Wp0tPfbSu8/ewMJHw6ySUKmcGyYBWvlqslMg
        xBPrm59EbfqNQi22MXNZ9b8P65gTGiQdDj0G6UQWxyalOrZrmIiZ+Lw2zK5HYdEATw5M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLEby-0007m3-IL; Tue, 30 Apr 2019 00:18:58 +0200
Date:   Tue, 30 Apr 2019 00:18:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 net-next 05/12] ether: Add dedicated Ethertype for
 pseudo-802.1Q DSA tagging
Message-ID: <20190429221858.GR12333@lunn.ch>
References: <20190429001706.7449-1-olteanv@gmail.com>
 <20190429001706.7449-6-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429001706.7449-6-olteanv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 03:16:59AM +0300, Vladimir Oltean wrote:
> There are two possible utilizations so far:
> 
> - Switch devices that don't support a native insertion/extraction header
>   on the CPU port may still enjoy the benefits of port isolation with a
>   custom VLAN tag.
> 
>   For this, they need to have a customizable TPID in hardware and a new
>   Ethertype to distinguish between real 802.1Q traffic and the private
>   tags used for port separation.
> 
> - Switches that don't support the deactivation of VLAN awareness, but
>   still want to have a mode in which they accept all traffic, including
>   frames that are tagged with a VLAN not configured on their ports, may
>   use this as a fake to trick the hardware into thinking that the TPID
>   for VLAN is something other than 0x8100.
> 
> What follows after the ETH_P_DSA_8021Q EtherType is a regular VLAN
> header (TCI), however there is no other EtherType that can be used for
> this purpose and doesn't already have a well-defined meaning.
> ETH_P_8021AD, ETH_P_QINQ1, ETH_P_QINQ2 and ETH_P_QINQ3 expect that
> another follow-up VLAN tag is present, which is not the case here.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Suggested-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
