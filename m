Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2B834A6FA
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 13:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbhCZMRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 08:17:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49034 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229758AbhCZMRY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 08:17:24 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPlOt-00D7tn-IE; Fri, 26 Mar 2021 13:17:15 +0100
Date:   Fri, 26 Mar 2021 13:17:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, michael.chan@broadcom.com,
        paul.greenwalt@intel.com, rajur@chelsio.com,
        jaroslawx.gawin@intel.com, vkochan@marvell.com, alobakin@pm.me,
        snelson@pensando.io, shayagr@amazon.com, ayal@nvidia.com,
        shenjian15@huawei.com, saeedm@nvidia.com, mkubecek@suse.cz,
        roopa@nvidia.com
Subject: Re: [PATCH net-next v2 3/6] ethtool: fec: sanitize
 ethtool_fecparam->reserved
Message-ID: <YF3Qy/QdaSBzXOE1@lunn.ch>
References: <20210326020727.246828-1-kuba@kernel.org>
 <20210326020727.246828-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326020727.246828-4-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 07:07:24PM -0700, Jakub Kicinski wrote:
> struct ethtool_fecparam::reserved is never looked at by the core.
> Make sure it's actually 0. Unfortunately we can't return an error
> because old ethtool doesn't zero-initialize the structure for SET.
> On GET we can be more verbose, there are no in tree (ab)users.
> 
> Fix up the kdoc on the structure. Remove the mention of FEC
> bypass. Seems like a niche thing to configure in the first
> place.
> 
> v2: - also mention the zero-init-on-SET kerfuffle in kdoc
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
