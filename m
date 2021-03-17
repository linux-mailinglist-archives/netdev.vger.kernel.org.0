Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3DBB33F5C7
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 17:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhCQQmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 12:42:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:30853 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232560AbhCQQlk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 12:41:40 -0400
IronPort-SDR: vvDm5aob2zH/14HhKS89nyok9P3hTVsae0Ycd56TZLcJ9VRcI2MAAVCvSdh/dxjkeArm25B9M3
 mR3E2U1JOl8g==
X-IronPort-AV: E=McAfee;i="6000,8403,9926"; a="189594326"
X-IronPort-AV: E=Sophos;i="5.81,256,1610438400"; 
   d="scan'208";a="189594326"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 09:41:40 -0700
IronPort-SDR: jBh0ESDE3nQ62X8GGYlW2EfcuPeTJTTpknrp5suwpoKISw9McOFxBaO2QU73W1LXVA6s+1vd4q
 FoEDLTrxGrbg==
X-IronPort-AV: E=Sophos;i="5.81,256,1610438400"; 
   d="scan'208";a="372408606"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.10.230])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 09:41:37 -0700
Date:   Wed, 17 Mar 2021 09:41:37 -0700
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
Subject: Re: [net-next PATCH v2 00/10] ethtool: Factor out common code
 related to writing ethtool strings
Message-ID: <20210317094137.00007073@intel.com>
In-Reply-To: <161594093708.5644.11391417312031401152.stgit@localhost.localdomain>
References: <161594093708.5644.11391417312031401152.stgit@localhost.localdomain>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Duyck wrote:

> This patch set is meant to be a cleanup and refactoring of common code bits
> from several drivers. Specificlly a number of drivers engage in a pattern
> where they will use some variant on an sprintf or memcpy to write a string
> into the ethtool string array and then they will increment their pointer by
> ETH_GSTRING_LEN.
> 
> Instead of having each driver implement this independently I am refactoring
> the code so that we have one central function, ethtool_sprintf that does
> all this and takes a double pointer to access the data, a formatted string
> to print, and the variable arguments that are associated with the string.
> 
> Changes from v1:
> Fixed usage of char ** vs  unsigned char ** in hisilicon drivers
> 
> Changes from RFC:
> Renamed ethtool_gsprintf to ethtool_sprintf
> Fixed reverse xmas tree issue in patch 2
> 

Thanks Alex, I had a look over the whole thing and it looks good to me.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
