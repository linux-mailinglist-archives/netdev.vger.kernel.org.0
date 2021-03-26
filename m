Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D22734A6FB
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 13:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbhCZMSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 08:18:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49064 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229848AbhCZMSS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 08:18:18 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPlPq-00D7ub-BM; Fri, 26 Mar 2021 13:18:14 +0100
Date:   Fri, 26 Mar 2021 13:18:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, michael.chan@broadcom.com,
        paul.greenwalt@intel.com, rajur@chelsio.com,
        jaroslawx.gawin@intel.com, vkochan@marvell.com, alobakin@pm.me,
        snelson@pensando.io, shayagr@amazon.com, ayal@nvidia.com,
        shenjian15@huawei.com, saeedm@nvidia.com, mkubecek@suse.cz,
        roopa@nvidia.com
Subject: Re: [PATCH net-next v2 5/6] ethtool: fec: sanitize
 ethtool_fecparam->fec
Message-ID: <YF3RBg+xDHMi6YIB@lunn.ch>
References: <20210326020727.246828-1-kuba@kernel.org>
 <20210326020727.246828-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326020727.246828-6-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 07:07:26PM -0700, Jakub Kicinski wrote:
> Reject NONE on set, this mode means device does not support
> FEC so it's a little out of place in the set interface.
> 
> This should be safe to do - user space ethtool does not allow
> the use of NONE on set. A few drivers treat it the same as OFF,
> but none use it instead of OFF.
> 
> Similarly reject an empty FEC mask. The common user space tool
> will not send such requests and most drivers correctly reject
> it already.
> 
> v2: - use mask not bit pos
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
