Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D2D33F5A5
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 17:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhCQQgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 12:36:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:56204 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232342AbhCQQgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 12:36:25 -0400
IronPort-SDR: dCvCA6qnS/b7UXHthWRG2Zvud9MaVuu2LLHyzjXAbwcGRft2mY3O3n54DByOTK8iyiKso/HhEe
 NCIrfLYROPGg==
X-IronPort-AV: E=McAfee;i="6000,8403,9926"; a="250858733"
X-IronPort-AV: E=Sophos;i="5.81,256,1610438400"; 
   d="scan'208";a="250858733"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 09:36:25 -0700
IronPort-SDR: SHus9+wDX8b0eIupvkjhQgwqpU2eyRx/H6MOHPhxShhdm6rqrk3xoRC5rvqvOKV1xIcXyITO47
 IrkZUrEeWdVg==
X-IronPort-AV: E=Sophos;i="5.81,256,1610438400"; 
   d="scan'208";a="372406847"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.10.230])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 09:36:24 -0700
Date:   Wed, 17 Mar 2021 09:36:24 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, simon.horman@netronome.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        drivers@pensando.io, snelson@pensando.io, netanel@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com, saeedb@amazon.com,
        GR-Linux-NIC-Dev@marvell.com, skalluru@marvell.com,
        rmody@marvell.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, mst@redhat.com,
        jasowang@redhat.com, pv-drivers@vmware.com, doshir@vmware.com,
        alexanderduyck@fb.com, Kernel-team@fb.com
Subject: Re: [net-next PATCH v2 02/10] intel: Update drivers to use
 ethtool_sprintf
Message-ID: <20210317093624.00005020@intel.com>
In-Reply-To: <161594104491.5644.18446437902161792108.stgit@localhost.localdomain>
References: <161594093708.5644.11391417312031401152.stgit@localhost.localdomain>
        <161594104491.5644.18446437902161792108.stgit@localhost.localdomain>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Duyck wrote:

> From: Alexander Duyck <alexanderduyck@fb.com>
> 
> Update the Intel drivers to make use of ethtool_sprintf. The general idea
> is to reduce code size and overhead by replacing the repeated pattern of
> string printf statements and ETH_STRING_LEN counter increments.
> 
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>

Thanks!

Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
