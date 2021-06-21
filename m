Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5283AEA85
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhFUN4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:56:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47670 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229747AbhFUN4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 09:56:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EuRYsZpTIAL5Pga7FFPt6SR52zcwfxnDhh/v6IjR+W0=; b=gruE0vz7VtmDIsu2YTYiUFfPef
        mFSvc9L6ipYQu6Ymlzd+JvAGrJs0fvSZo/0pX1C6c5/Hr7H6cj7fjxTyyYzGhVuWZdg+SM5zKmraK
        ON/Nmh/pvTUkAsWFKc5IiTJS7OGJT0iVGO88Ata75N/P4Qh8Ygaudsy4/gvvz/eUwXls=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lvKN9-00AVsH-2z; Mon, 21 Jun 2021 15:53:55 +0200
Date:   Mon, 21 Jun 2021 15:53:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 1/6] net: dsa: assert uniqueness of dsa,member
 properties
Message-ID: <YNCZ8xv+b2sDrlNM@lunn.ch>
References: <20210618183017.3340769-1-olteanv@gmail.com>
 <20210618183017.3340769-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618183017.3340769-2-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 09:30:12PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The cross-chip notifiers work by comparing each ds->index against the
> info->sw_index value from the notifier. The ds->index is retrieved from
> the device tree dsa,member property.
> 
> If a single tree cross-chip topology does not declare unique switch IDs,
> this will result in hard-to-debug issues/voodoo effects such as the
> cross-chip notifier for one switch port also matching the port with the
> same number from another switch.
> 
> Check in dsa_switch_parse_member_of() whether the DSA switch tree
> contains a DSA switch with the index we're preparing to add, before
> actually adding it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
