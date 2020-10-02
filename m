Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8BB281508
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388113AbgJBOZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:25:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40376 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387777AbgJBOZF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:25:05 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kOLzc-00HE8k-4o; Fri, 02 Oct 2020 16:25:04 +0200
Date:   Fri, 2 Oct 2020 16:25:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 net-next 1/3] ethtool: allow netdev driver to define
 phy tunables
Message-ID: <20201002142504.GE3996795@lunn.ch>
References: <20201002133923.1677-1-irusskikh@marvell.com>
 <20201002133923.1677-2-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002133923.1677-2-irusskikh@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 04:39:21PM +0300, Igor Russkikh wrote:
> Define get/set phy tunable callbacks in ethtool ops.
> This will allow MAC drivers with integrated PHY still to implement
> these tunables.
> 
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
