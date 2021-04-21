Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76189366AC5
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 14:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239745AbhDUM24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 08:28:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33566 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232442AbhDUM2z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 08:28:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZBxp-000JNQ-CO; Wed, 21 Apr 2021 14:28:17 +0200
Date:   Wed, 21 Apr 2021 14:28:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: Export cross-chip PVT
 as devlink region
Message-ID: <YIAaYW1sKy1Vj1kF@lunn.ch>
References: <20210421120454.1541240-1-tobias@waldekranz.com>
 <20210421120454.1541240-4-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421120454.1541240-4-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 02:04:54PM +0200, Tobias Waldekranz wrote:
> Export the raw PVT data in a devlink region so that it can be
> inspected from userspace and compared to the current bridge
> configuration.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
