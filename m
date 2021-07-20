Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F2D3CF11C
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 03:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356481AbhGTA1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 20:27:42 -0400
Received: from mga03.intel.com ([134.134.136.65]:13551 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353714AbhGTAYK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 20:24:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10050"; a="211215845"
X-IronPort-AV: E=Sophos;i="5.84,253,1620716400"; 
   d="scan'208";a="211215845"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2021 18:03:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,253,1620716400"; 
   d="scan'208";a="461801768"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga008.jf.intel.com with ESMTP; 19 Jul 2021 18:03:27 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 00F33580895;
        Mon, 19 Jul 2021 18:03:24 -0700 (PDT)
Date:   Tue, 20 Jul 2021 09:03:22 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Xu Liang <lxu@maxlinear.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        hmehrtens@maxlinear.com, tmohren@maxlinear.com,
        mohammad.athari.ismail@intel.com
Subject: Re: [PATCH v6 2/2] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <20210720010322.GA22828@linux.intel.com>
References: <20210719053212.11244-1-lxu@maxlinear.com>
 <20210719053212.11244-2-lxu@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719053212.11244-2-lxu@maxlinear.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 01:32:12PM +0800, Xu Liang wrote:
> Add driver to support the Maxlinear GPY115, GPY211, GPY212, GPY215,
> GPY241, GPY245 PHYs. Separate from XWAY PHY driver because this series
> has different register layout and new features not supported in XWAY PHY.
> 
> Signed-off-by: Xu Liang <lxu@maxlinear.com>
> ---

Tested-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>

