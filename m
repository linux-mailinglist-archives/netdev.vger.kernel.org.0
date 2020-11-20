Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F8E2BB9B7
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgKTXKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:10:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:29811 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727417AbgKTXKe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 18:10:34 -0500
IronPort-SDR: N0V3iEno83xoZBhMuRHwe3LYSEOEA0c/P39O+CwnOdQ2YjK+YMCFzBepS/+jaM+JtltCvFyWD5
 zEOpgxiX/X2A==
X-IronPort-AV: E=McAfee;i="6000,8403,9811"; a="158596758"
X-IronPort-AV: E=Sophos;i="5.78,357,1599548400"; 
   d="scan'208";a="158596758"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2020 15:10:34 -0800
IronPort-SDR: Qx/lMTZaPnHCRmDRCE/knT2SyKnev0TcR9rRii4yajJbKr7RzmK7gkT69B4cpBIYOiLDgXUTQk
 SK4Y2PAk6ceQ==
X-IronPort-AV: E=Sophos;i="5.78,357,1599548400"; 
   d="scan'208";a="533724244"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.67.220])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2020 15:10:33 -0800
Date:   Fri, 20 Nov 2020 15:10:32 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, john.fastabend@gmail.com
Subject: Re: [PATCH net-next 0/3] mvneta: access skb_shared_info only on
 last frag
Message-ID: <20201120151032.00006bd2@intel.com>
In-Reply-To: <cover.1605889258.git.lorenzo@kernel.org>
References: <cover.1605889258.git.lorenzo@kernel.org>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:

> Build skb_shared_info on mvneta_rx_swbm stack and sync it to xdp_buff
> skb_shared_info area only on the last fragment.
> Avoid avoid unnecessary xdp_buff initialization in mvneta_rx_swbm routine.
> This a preliminary series to complete xdp multi-buff in mvneta driver.
> 
> Lorenzo Bianconi (3):
>   net: mvneta: avoid unnecessary xdp_buff initialization
>   net: mvneta: move skb_shared_info in mvneta_xdp_put_buff
>   net: mvneta: alloc skb_shared_info on the mvneta_rx_swbm stack
> 
>  drivers/net/ethernet/marvell/mvneta.c | 55 +++++++++++++++++----------
>  1 file changed, 35 insertions(+), 20 deletions(-)
> 


For the series:
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
