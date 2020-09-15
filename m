Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B04D26AF12
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 23:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgIOVBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 17:01:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:59767 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728066AbgIOVBN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 17:01:13 -0400
IronPort-SDR: Pb/QOaVSIXb6MzQv5lPwu3PmdQ83Znjkgz4OErdpMpa+AQaW1NBP0hmCDpQetfovuCAZD8AoJI
 0WANqjhrgZEA==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="220908134"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="220908134"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 14:01:01 -0700
IronPort-SDR: I/XBhBVhiQRmdXFSW8IHhwqdaQGXrJha0whNjIJTr9uaqsnI+mKGIgXYd1vV4bDA/IKhVmdK4K
 cWHvFrIrNatQ==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="506907383"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.118.172])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 14:01:00 -0700
Date:   Tue, 15 Sep 2020 14:00:58 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net-next v2 00/10] make drivers/net/ethernet W=1 clean
Message-ID: <20200915140058.00007553@intel.com>
In-Reply-To: <20200915.133156.1580615428345209072.davem@davemloft.net>
References: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
        <20200915.133156.1580615428345209072.davem@davemloft.net>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller wrote:
> Jesse, in all of these patches, I want to see the warning you are
> fixing in the commit message.
> 
> Especially for the sh_eth.c one because I have no idea what the
> compiler is actually warning about just by reading your commit
> message and patch on it's own.

Ok, I'll respin with those added for the compiler warning fixes in
particular, and some simplified descriptions of the classes of kdoc
warnings.

