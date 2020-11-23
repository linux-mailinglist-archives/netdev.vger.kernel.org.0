Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2EE2C1900
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387943AbgKWWzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:55:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:14836 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387934AbgKWWzO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 17:55:14 -0500
IronPort-SDR: qj3gTLg1WW1DGjHUrhcpsT6qQm2ZuYe9G2QWQOFFzgOqFfkpX9TJQLMJLp1NYptTUxwHUu240m
 lRz6M5G8TE6A==
X-IronPort-AV: E=McAfee;i="6000,8403,9814"; a="168348219"
X-IronPort-AV: E=Sophos;i="5.78,364,1599548400"; 
   d="scan'208";a="168348219"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 14:55:10 -0800
IronPort-SDR: sINrrY2GOCALc3Zhd6FPs0Dnm1638t4PbO26AGV6AsajeMHLhZvMNuThVukLQ4FkN8e4UIajq9
 KW8C5UtRCbrg==
X-IronPort-AV: E=Sophos;i="5.78,364,1599548400"; 
   d="scan'208";a="546591122"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.57.186])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 14:55:03 -0800
Date:   Mon, 23 Nov 2020 14:55:02 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>, <kuba@kernel.org>
Subject: Re: [PATCH V4 net-next 0/4] net: hns3: updates for -next
Message-ID: <20201123145502.00001e2a@intel.com>
In-Reply-To: <1605514854-11205-1-git-send-email-tanhuazhong@huawei.com>
References: <1605514854-11205-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Huazhong Tan wrote:

> There are several updates relating to the interrupt coalesce for
> the HNS3 ethernet driver.
> 
> #1 adds support for QL(quantity limiting, interrupt coalesce
>    based on the frame quantity).
> #2 queries the maximum value of GL from the firmware instead of
>    a fixed value in code.
> #3 adds support for 1us unit GL(gap limiting, interrupt coalesce
>    based on the gap time).
> #4 renames gl_adapt_enable in struct hns3_enet_coalesce to fit
>    its new usage.
> 
> change log:
> V4 - remove #5~#10 from this series, which needs more discussion.
> V3 - fix a typo error in #1 reported by Jakub Kicinski.
>      rewrite #9 commit log.
>      remove #11 from this series.
> V2 - reorder #2 & #3 to fix compiler error.
>      fix some checkpatch warnings in #10 & #11.


For the series:
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
