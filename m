Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEB833794E
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbhCKQ2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:28:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52176 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234532AbhCKQ2K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 11:28:10 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lKOAR-00ANev-QC; Thu, 11 Mar 2021 17:28:07 +0100
Date:   Thu, 11 Mar 2021 17:28:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: b53: Add debug prints in
 b53_vlan_enable()
Message-ID: <YEpFF1MlBEToRW6Z@lunn.ch>
References: <20210310185227.2685058-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310185227.2685058-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 10:52:26AM -0800, Florian Fainelli wrote:
> Having dynamic debug prints in b53_vlan_enable() has been helpful to
> uncover a recent but update the function to indicate the port being
> configured (or -1 for initial setup) and include the global VLAN enabled
> and VLAN filtering enable status.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
