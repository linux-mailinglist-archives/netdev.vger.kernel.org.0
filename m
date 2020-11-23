Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8EE2C18A1
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732835AbgKWWl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:41:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:22248 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728873AbgKWWl1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 17:41:27 -0500
IronPort-SDR: hlGelISRsegCfFd0Ri2+XukP0iEQZvIXL1+Vn8hEZl1MRwlcHCR1Dl0yyMTg5JO9gw+jXkwTp1
 Tsn3iBJagMrw==
X-IronPort-AV: E=McAfee;i="6000,8403,9814"; a="158898208"
X-IronPort-AV: E=Sophos;i="5.78,364,1599548400"; 
   d="scan'208";a="158898208"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 14:41:26 -0800
IronPort-SDR: vJN4A4DJJkI7jqvaF7H4MZk0eG1r8QwQpXlltnDw211z84znh8bVsZQkp3IzgAbCMqcQJV1foJ
 KXNYdsw6UeYw==
X-IronPort-AV: E=Sophos;i="5.78,364,1599548400"; 
   d="scan'208";a="546586401"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.57.186])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 14:41:26 -0800
Date:   Mon, 23 Nov 2020 14:41:26 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, linux-rdma@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH net-next v2] net: don't include ethtool.h from
 netdevice.h
Message-ID: <20201123144126.00003133@intel.com>
In-Reply-To: <20201120225052.1427503-1-kuba@kernel.org>
References: <20201120225052.1427503-1-kuba@kernel.org>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:

> linux/netdevice.h is included in very many places, touching any
> of its dependecies causes large incremental builds.
> 
> Drop the linux/ethtool.h include, linux/netdevice.h just needs
> a forward declaration of struct ethtool_ops.
> 
> Fix all the places which made use of this implicit include.
> 
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
