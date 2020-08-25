Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E715251E9A
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgHYRqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:46:30 -0400
Received: from mga17.intel.com ([192.55.52.151]:25820 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgHYRq2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 13:46:28 -0400
IronPort-SDR: cQpSD+idSkOIt1uXESuaZIa3n1IpXWcwO6zEkZocb9y7PvmDxyOL1WIYPKK5ABPbDLI6wybCgI
 19C7mb7+g+Fw==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="136228362"
X-IronPort-AV: E=Sophos;i="5.76,353,1592895600"; 
   d="scan'208";a="136228362"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 10:46:27 -0700
IronPort-SDR: FkQ4Y2OERWw+At5i7+dWYQzpDTgYV+0TKYcHslKswKogDt4//VRTDMCIe1/R2fngyBfeezCqVe
 xeswMREuGYFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,353,1592895600"; 
   d="scan'208";a="443714708"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 25 Aug 2020 10:46:25 -0700
Date:   Tue, 25 Aug 2020 19:40:18 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        netdev@vger.kernel.org, piotr.raczynski@intel.com,
        maciej.machnikowski@intel.com, lirongqing@baidu.com
Subject: Re: [PATCH net v3 0/3] Avoid premature Rx buffer reuse for
 XDP_REDIRECT
Message-ID: <20200825174018.GA41513@ranger.igk.intel.com>
References: <20200825172736.27318-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200825172736.27318-1-bjorn.topel@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 07:27:33PM +0200, Björn Töpel wrote:

[...]

> 
> v2->v3: Fixed kdoc for i40e/ice. (Jakub)
> v1->v2: Removed page count function into get Rx buffer function, and
>         changed scope of automatic variable. (Maciej)
> 

For the series:
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> 
> Björn Töpel (3):
>   i40e: avoid premature Rx buffer reuse
>   ixgbe: avoid premature Rx buffer reuse
>   ice: avoid premature Rx buffer reuse
> 
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 27 ++++++++++++-----
>  drivers/net/ethernet/intel/ice/ice_txrx.c     | 30 +++++++++++++------
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 24 ++++++++++-----
>  3 files changed, 58 insertions(+), 23 deletions(-)
> 
> 
> base-commit: 99408c422d336db32bfab5cbebc10038a70cf7d2
> -- 
> 2.25.1
> 
