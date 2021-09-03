Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2A14007C4
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 00:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349684AbhICWHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 18:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233367AbhICWHy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 18:07:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B521660724;
        Fri,  3 Sep 2021 22:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630706814;
        bh=Ht8W/A3YSRfdKt4bjSIX0wrzEonGzovb9ZbFOC0prHY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dYeui8dOxlxIg3yYFsTSW7k4voBAiYXkmK/o2ukD5V8/4c50RG7Ah/37DLVYQ0oBv
         AhFVA4aOEW4xfkOsSNRb2gRNYgR0sgcKvFQZmfC6uMNud03RLWUVWw6f32nZJlQTlz
         UewG6JboLOURRmqR2zdkPXugqbbvaQrg6EQOpTye8U/TP7pmrVi88+9mLIGi4KqXKT
         2xkFZn/36ov8qBlKuyub7Y4/pnKToKK2+TKcRLGUHdW0ySjfQHp0QinIGKod0PzuGM
         QInZP+nW0AGuwU9xemq7hwPNbBCBELXZCUUmRHMr4nwZJzJSbODvqAdplH3alNev0A
         WQjxTuZb6FaiQ==
Date:   Fri, 3 Sep 2021 15:06:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] ice: add support for reading SyncE DPLL
 state
Message-ID: <20210903150652.6e763cb6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210903151436.529478-3-maciej.machnikowski@intel.com>
References: <20210903151436.529478-1-maciej.machnikowski@intel.com>
        <20210903151436.529478-3-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Sep 2021 17:14:36 +0200 Maciej Machnikowski wrote:
> Implement SyncE DPLL monitoring for E810-T devices.
> Poll loop will periodically check the state of the DPLL and cache it
> in the pf structure. State changes will be logged in the system log.
> 
> Cached state can be read using the RTM_GETEECSTATE rtnetlink
> message.
> 
> Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>

kdoc issues here:

drivers/net/ethernet/intel/ice/ice_main.c:5990: warning: Function parameter or member 'eec_flags' not described in 'ice_get_eec_state'
drivers/net/ethernet/intel/ice/ice_main.c:5990: warning: Function parameter or member 'extack' not described in 'ice_get_eec_state'
drivers/net/ethernet/intel/ice/ice_main.c:5990: warning: Excess function parameter 'sync_src' description in 'ice_get_eec_state'

./scripts/kernel-doc -none and/or W=1 is your friend.
