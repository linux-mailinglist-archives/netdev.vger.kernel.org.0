Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135C92AEA22
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 08:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgKKHZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 02:25:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:62905 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbgKKHZg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 02:25:36 -0500
IronPort-SDR: IT6p6vd1vGZukJJDn3WZAyN4RVHM/TdDCZvzhiVtopCXLWh/rtgRm/8mo9SArvKVefKTMpnR75
 EBEJOAsipYJw==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="188085460"
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="188085460"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 23:25:29 -0800
IronPort-SDR: msmPdEXzTHAN0BtSyPT/603HkxFtvLNOxC08MwlWv3bMdXZR2YXaUugg/t8aOuPjBlzWbF1IS8
 KK8U/vxPSsxw==
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="356522742"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 23:25:26 -0800
Received: by lahna (sSMTP sendmail emulation); Wed, 11 Nov 2020 09:23:12 +0200
Date:   Wed, 11 Nov 2020 09:23:12 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 00/10] thunderbolt: Add DMA traffic test driver
Message-ID: <20201111072312.GI2495@lahna.fi.intel.com>
References: <20201110091957.17472-1-mika.westerberg@linux.intel.com>
 <X6pdxfCFicGVqcM5@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X6pdxfCFicGVqcM5@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 10:30:45AM +0100, Greg Kroah-Hartman wrote:
> On Tue, Nov 10, 2020 at 12:19:47PM +0300, Mika Westerberg wrote:
> > Hi all,
> > 
> > This series adds a new Thunderbolt service driver that can be used on
> > manufacturing floor to test that each Thunderbolt/USB4 port is functional.
> > It can be done either using a special loopback dongle that has RX and TX
> > lanes crossed, or by connecting a cable back to the host (for those who
> > don't have these dongles).
> > 
> > This takes advantage of the existing XDomain protocol and creates XDomain
> > devices for the loops back to the host where the DMA traffic test driver
> > can bind to.
> > 
> > The DMA traffic test driver creates a tunnel through the fabric and then
> > sends and receives data frames over the tunnel checking for different
> > errors.
> > 
> > The previous version can be found here:
> > 
> >   https://lore.kernel.org/linux-usb/20201104140030.6853-1-mika.westerberg@linux.intel.com/
> > 
> > Changes from the previous version:
> > 
> >   * Fix resource leak in tb_xdp_handle_request() (patch 2/10)
> >   * Use debugfs_remove_recursive() in tb_service_debugfs_remove() (patch 6/10)
> >   * Add tags from Yehezkel
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks!

Applied the series to thunderbolt.git/next.
