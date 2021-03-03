Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9998032C49C
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447064AbhCDAPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:31 -0500
Received: from mga04.intel.com ([192.55.52.120]:61792 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236515AbhCCShZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 13:37:25 -0500
IronPort-SDR: wPbkupIS1YdfYMQc1w4VepcQLP00ADUTpHCotIekpLHKceknZwxZCHwLbmUF7IhlOMxJE7JDP/
 n+NNN0ojotVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="184841172"
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="184841172"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 10:36:26 -0800
IronPort-SDR: Xl25tIzuIWRAEInTAxpzFP8Vi5x5AesZbiSt6fZplwDco2ojVV61tw9OIF49omVMFeB6u6Lv0v
 Gt/mu29GxdhA==
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="445382297"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.143.10])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 10:36:25 -0800
Date:   Wed, 3 Mar 2021 10:36:24 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <brouer@redhat.com>, <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <bjorn.topel@intel.com>, <magnus.karlsson@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH intel-net 0/3] intel: Rx headroom
 fixes
Message-ID: <20210303103624.00003aff@intel.com>
In-Reply-To: <20210303153928.11764-1-maciej.fijalkowski@intel.com>
References: <20210303153928.11764-1-maciej.fijalkowski@intel.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski wrote:

> Fix Rx headroom by calling *_rx_offset() after the build_skb Rx ring
> flag is set.
> 
> It was reported by Jesper in [0] that XDP_REDIRECT stopped working after
> [1] patch in i40e.

Looks good to me, thanks for the fixes Maciej, and especially to
Jesper for the report of the issue.

For the series: 
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
