Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E406F344FE1
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 20:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhCVT3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 15:29:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41178 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230091AbhCVT2o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 15:28:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lOQE8-00CSEi-Dy; Mon, 22 Mar 2021 20:28:36 +0100
Date:   Mon, 22 Mar 2021 20:28:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: dsa: hellcreek: Report switch name and
 ID
Message-ID: <YFjv5IfZHoPneo8K@lunn.ch>
References: <20210322185113.18095-1-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322185113.18095-1-kurt@kmk-computers.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 07:51:13PM +0100, Kurt Kanzenbach wrote:
> Report the driver name, ASIC ID and the switch name via devlink. This is a
> useful information for user space tooling.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
