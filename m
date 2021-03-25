Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C96C3491DA
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhCYM0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:26:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46768 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230057AbhCYM0C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 08:26:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPP3l-00Cwp3-Sb; Thu, 25 Mar 2021 13:25:57 +0100
Date:   Thu, 25 Mar 2021 13:25:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, michael.chan@broadcom.com,
        damian.dybek@intel.com, paul.greenwalt@intel.com,
        rajur@chelsio.com, jaroslawx.gawin@intel.com, vkochan@marvell.com,
        alobakin@pm.me, snelson@pensando.io, shayagr@amazon.com,
        ayal@nvidia.com, shenjian15@huawei.com, saeedm@nvidia.com,
        mkubecek@suse.cz, roopa@nvidia.com
Subject: Re: [PATCH net-next 4/6] ethtool: fec: sanitize
 ethtool_fecparam->active_fec
Message-ID: <YFyBVbBmMRXd7b1I@lunn.ch>
References: <20210325011200.145818-1-kuba@kernel.org>
 <20210325011200.145818-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325011200.145818-5-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 06:11:58PM -0700, Jakub Kicinski wrote:
> struct ethtool_fecparam::active_fec is a GET-only field,
> all in-tree drivers correctly ignore it on SET. Clear
> the field on SET to avoid any confusion. Again, we can't
> reject non-zero now since ethtool user space does not
> zero-init the param correctly.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
