Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955DD24A48C
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 19:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgHSRAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 13:00:41 -0400
Received: from mga18.intel.com ([134.134.136.126]:57859 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726640AbgHSRAj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 13:00:39 -0400
IronPort-SDR: bSqgf/hPDrw3+POD6aHHjfJGUEVCHaqaWaf9gchrEpGsp7g6l/YcBwYlwt4889/rG5HjtvCY5V
 pwFxZWiYwtBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9718"; a="142785582"
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="142785582"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 10:00:39 -0700
IronPort-SDR: rvo1GbvxNZbLaj5DUEU+X5tpppCWfLJnUT7DqpATQ82yj8YRqFdVpzvpiuPPoEQAeOX9zEKWnt
 oieYtWS1vIyQ==
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="278378786"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.220.26])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 10:00:38 -0700
Date:   Wed, 19 Aug 2020 10:00:36 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     <sundeep.lkml@gmail.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <sgoutham@marvell.com>, Aleksey Makarov <amakarov@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: Re: [PATCH v6 net-next 3/3] octeontx2-pf: Add support for PTP clock
Message-ID: <20200819100036.00007b24@intel.com>
In-Reply-To: <1597770557-26617-4-git-send-email-sundeep.lkml@gmail.com>
References: <1597770557-26617-1-git-send-email-sundeep.lkml@gmail.com>
        <1597770557-26617-4-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sundeep.lkml@gmail.com wrote:

> From: Aleksey Makarov <amakarov@marvell.com>
> 
> This patch adds PTP clock and uses it in Octeontx2
> network device. PTP clock uses mailbox calls to
> access the hardware counter on the RVU side.
> 
> Co-developed-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Aleksey Makarov <amakarov@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>

Besides that this driver doesn't have copyrights, I don't see many
problems with this part of the patch. I would like to see some of the
other patches have my comments addressed.

For this patch:
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
