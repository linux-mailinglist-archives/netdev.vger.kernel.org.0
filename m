Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB00734918F
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhCYMHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:07:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46676 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230237AbhCYMHV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 08:07:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPOlh-00CwdT-LY; Thu, 25 Mar 2021 13:07:17 +0100
Date:   Thu, 25 Mar 2021 13:07:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, michael.chan@broadcom.com,
        damian.dybek@intel.com, paul.greenwalt@intel.com,
        rajur@chelsio.com, jaroslawx.gawin@intel.com, vkochan@marvell.com,
        alobakin@pm.me, snelson@pensando.io, shayagr@amazon.com,
        ayal@nvidia.com, shenjian15@huawei.com, saeedm@nvidia.com,
        mkubecek@suse.cz, roopa@nvidia.com
Subject: Re: [PATCH net-next 2/6] ethtool: fec: remove long structure
 description
Message-ID: <YFx89RnVmauonPQp@lunn.ch>
References: <20210325011200.145818-1-kuba@kernel.org>
 <20210325011200.145818-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325011200.145818-3-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 06:11:56PM -0700, Jakub Kicinski wrote:
> Digging through the mailing list archive @autoneg was part
> of the first version of the RFC, this left over comment was
> pointed out twice in review but wasn't removed.
> 
> The sentence is an exact copy-paste from pauseparam.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
