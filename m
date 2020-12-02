Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7211E2CC853
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731333AbgLBUuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:50:22 -0500
Received: from mga12.intel.com ([192.55.52.136]:30128 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727489AbgLBUuW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 15:50:22 -0500
IronPort-SDR: krrEjdKysrsk9bu9mSMei6roZgLSiCgnrcfUi9QgrpqqoDNEZJ42qp7HPlORLvlDf55OQyVnmJ
 eCOf3VdYCplA==
X-IronPort-AV: E=McAfee;i="6000,8403,9823"; a="152338730"
X-IronPort-AV: E=Sophos;i="5.78,387,1599548400"; 
   d="scan'208";a="152338730"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 12:49:42 -0800
IronPort-SDR: +laTcOwiOW2/GRPfE5YXVF/GQXc7gPwyriCgFf6WVhR5ZrchMuhEOjr9/YLhxgJNCM47asLnKm
 spcD5wPDLc8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,387,1599548400"; 
   d="scan'208";a="335706146"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga006.jf.intel.com with ESMTP; 02 Dec 2020 12:49:40 -0800
Date:   Wed, 2 Dec 2020 21:40:41 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        netdev@vger.kernel.org, maciejromanfijalkowski@gmail.com
Subject: Re: [PATCH net-next 0/3] i40e, ice, ixgbe: optimize for XDP_REDIRECT
 in xsk path
Message-ID: <20201202204041.GA30907@ranger.igk.intel.com>
References: <20201202150724.31439-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202150724.31439-1-magnus.karlsson@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 04:07:21PM +0100, Magnus Karlsson wrote:
> Optimize run_xdp_zc() for the XDP program verdict being XDP_REDIRECT
> in the zsk zero-copy path. This path is only used when having AF_XDP
> zero-copy on and in that case most packets will be directed to user
> space. This provides around 100k extra packets in throughput on my
> server when running l2fwd in xdpsock.
> 
> Thanks: Magnus

For series:
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

You only ate 'e' from i40e subject line.

> 
> Magnus Karlsson (3):
>   i40: optimize for XDP_REDIRECT in xsk path
>   ixgbe: optimize for XDP_REDIRECT in xsk path
>   ice: optimize for XDP_REDIRECT in xsk path
> 
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c   | 11 +++++++----
>  drivers/net/ethernet/intel/ice/ice_xsk.c     | 12 ++++++++----
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 11 +++++++----
>  3 files changed, 22 insertions(+), 12 deletions(-)
> 
> 
> base-commit: 6b4f503186b73e3da24c6716c8c7ea903e6b74d4
> --
> 2.29.0
