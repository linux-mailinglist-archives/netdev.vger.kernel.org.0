Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52CF43C634
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241201AbhJ0JNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 05:13:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:29659 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241198AbhJ0JNA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 05:13:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="229973552"
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="229973552"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 02:10:35 -0700
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="447132742"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 02:10:32 -0700
Received: by lahna (sSMTP sendmail emulation); Wed, 27 Oct 2021 12:10:30 +0300
Date:   Wed, 27 Oct 2021 12:10:30 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.jamet@intel.com, YehezkelShB@gmail.com
Subject: Re: [PATCH net-next] net: thunderbolt: use eth_hw_addr_set()
Message-ID: <YXkXho54mwHeqSCJ@lahna>
References: <20211026175547.3198242-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026175547.3198242-1-kuba@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 10:55:47AM -0700, Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it go through appropriate helpers.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: michael.jamet@intel.com
> CC: mika.westerberg@linux.intel.com

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
