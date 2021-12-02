Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105BD465BE1
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 02:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349037AbhLBB7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 20:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344435AbhLBB7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 20:59:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CDBC061574;
        Wed,  1 Dec 2021 17:56:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8ABBACE2146;
        Thu,  2 Dec 2021 01:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B30FC00446;
        Thu,  2 Dec 2021 01:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638410176;
        bh=zZKEPA4iQLhVBOohhM5LVpxfiIwhRk/rw5IJ70ettsA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lVmGD3Y3/K7DR9EMi4LBt1SaFrFcKB0/tR6l79vW/ULfbEKE/RYO6PqGXMWOvrVQU
         IymafejFxgjn0y83/wrL4eCuwDt6NGSQTJdsZn7kuzauxyVotBAfehUu0WWx8ErEBK
         94Mj6uRKgnB2diR2/EPgoE0n/DrhQvhcNMR6ICC6yLkhpANTBhmuDN3zrQ9bOzEKQK
         mwhZsBlJq7GNL7aObI5N4nWK1o/o3kYFcNV/oqRHbK6Kz5KPv6btABBkM3tOA+NFuT
         mkDersY9MwU5AQ2GsNDp3dPrb7T/LCNoEbLdE8HVW+faXFSV9WdAQhs5Iw/jxN4wUK
         A0eG0nMdUb48g==
Date:   Wed, 1 Dec 2021 17:56:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        arkadiusz.kubalewski@intel.com, richardcochran@gmail.com,
        abyagowi@fb.com, anthony.l.nguyen@intel.com, davem@davemloft.net,
        linux-kselftest@vger.kernel.org, idosch@idosch.org,
        mkubecek@suse.cz, saeed@kernel.org, michael.chan@broadcom.com,
        petrm@nvidia.com
Subject: Re: [PATCH v4 net-next 4/4] ice: add support for SyncE recovered
 clocks
Message-ID: <20211201175615.4b403560@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211201180208.640179-5-maciej.machnikowski@intel.com>
References: <20211201180208.640179-1-maciej.machnikowski@intel.com>
        <20211201180208.640179-5-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 Dec 2021 19:02:08 +0100 Maciej Machnikowski wrote:
> Implement ethtool netlink functions for handling SyncE recovered clocks
> configuration on ice driver:
> - ETHTOOL_MSG_RCLK_SET
> - ETHTOOL_MSG_RCLK_GET
> 
> Co-developed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>

drivers/net/ethernet/intel/ice/ice_ethtool.c:4090: warning: Excess function parameter 'ena_mask' description in 'ice_get_rclk_range'

drivers/net/ethernet/intel/ice/ice_dcb_nl.c:66:6: warning: variable 'bwcfg' set but not used [-Wunused-but-set-variable]
        int bwcfg = 0, bwrec = 0;
            ^
