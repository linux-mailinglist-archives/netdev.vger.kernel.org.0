Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB112C31C9
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 21:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbgKXUPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 15:15:25 -0500
Received: from mga05.intel.com ([192.55.52.43]:38555 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730408AbgKXUPZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 15:15:25 -0500
IronPort-SDR: e8aEXguRVdYtdvyFfYP4tsBVuFd41AP4IlfIQRB/LAr95PKCT1LNzfsZozkE6cDZohQLNypyyx
 i2u5y9RzQLZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9815"; a="256718766"
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="256718766"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 12:15:25 -0800
IronPort-SDR: /RRHm+QyLuOxqSej1KizVEzPk4HI3w2Wys0Vhu6Qnp8S6JVZIIKsQs4MfoKII4c/nBbAMazTms
 i0w3LPde4BXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="370556255"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Nov 2020 12:15:22 -0800
Date:   Tue, 24 Nov 2020 21:07:26 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Camelia Groza <camelia.groza@nxp.com>
Cc:     kuba@kernel.org, brouer@redhat.com, saeed@kernel.org,
        davem@davemloft.net, madalin.bucur@oss.nxp.com,
        ioana.ciornei@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 5/7] dpaa_eth: add XDP_REDIRECT support
Message-ID: <20201124200726.GD12808@ranger.igk.intel.com>
References: <cover.1606150838.git.camelia.groza@nxp.com>
 <89e611f6ffed0a4604c5f70d0050ca5ac243c222.1606150838.git.camelia.groza@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89e611f6ffed0a4604c5f70d0050ca5ac243c222.1606150838.git.camelia.groza@nxp.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 07:36:23PM +0200, Camelia Groza wrote:
> After transmission, the frame is returned on confirmation queues for
> cleanup. For this, store a backpointer to the xdp_frame in the private
> reserved area at the start of the TX buffer.
> 
> No TX batching support is implemented at this time.
> 
> Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 48 +++++++++++++++++++++++++-
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |  1 +
>  2 files changed, 48 insertions(+), 1 deletion(-)
> 

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
