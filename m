Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4017834A708
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 13:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhCZMU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 08:20:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49100 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229982AbhCZMUf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 08:20:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPlS0-00D7wR-C3; Fri, 26 Mar 2021 13:20:28 +0100
Date:   Fri, 26 Mar 2021 13:20:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, michael.chan@broadcom.com,
        paul.greenwalt@intel.com, rajur@chelsio.com,
        jaroslawx.gawin@intel.com, vkochan@marvell.com, alobakin@pm.me,
        snelson@pensando.io, shayagr@amazon.com, ayal@nvidia.com,
        shenjian15@huawei.com, saeedm@nvidia.com, mkubecek@suse.cz,
        roopa@nvidia.com
Subject: Re: [PATCH net-next v2 6/6] ethtool: clarify the ethtool FEC
 interface
Message-ID: <YF3RjFWaFg7TMwgQ@lunn.ch>
References: <20210326020727.246828-1-kuba@kernel.org>
 <20210326020727.246828-7-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326020727.246828-7-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 07:07:27PM -0700, Jakub Kicinski wrote:
> The definition of the FEC driver interface is quite unclear.
> Improve the documentation.
> 
> This is based on current driver and user space code, as well
> as the discussions about the interface:
> 
> RFC v1 (24 Oct 2016): https://lore.kernel.org/netdev/1477363849-36517-1-git-send-email-vidya@cumulusnetworks.com/
>  - this version has the autoneg field
>  - no active_fec field
>  - none vs off confusion is already present
> 
> RFC v2 (10 Feb 2017): https://lore.kernel.org/netdev/1486727004-11316-1-git-send-email-vidya@cumulusnetworks.com/
>  - autoneg removed
>  - active_fec added
> 
> v1 (10 Feb 2017): https://lore.kernel.org/netdev/1486751311-42019-1-git-send-email-vidya@cumulusnetworks.com/
>  - no changes in the code
> 
> v1 (24 Jun 2017):  https://lore.kernel.org/netdev/1498331985-8525-1-git-send-email-roopa@cumulusnetworks.com/
>  - include in tree user
> 
> v2 (27 Jul 2017): https://lore.kernel.org/netdev/1501199248-24695-1-git-send-email-roopa@cumulusnetworks.com/
> 
> v2: - make enum kdoc reference bits
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
