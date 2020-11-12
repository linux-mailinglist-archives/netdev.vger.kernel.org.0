Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805C72B113C
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbgKLWRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:17:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:59530 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgKLWRy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 17:17:54 -0500
IronPort-SDR: DLIeXVrGKoGOUjft7RtZYdVFkHFFfRBKf0oeYwTTF8FqcIVSidRT/KhYEVlY9oqcM0CyM/4xaI
 ZUPf2Oc93Lew==
X-IronPort-AV: E=McAfee;i="6000,8403,9803"; a="166882697"
X-IronPort-AV: E=Sophos;i="5.77,473,1596524400"; 
   d="scan'208";a="166882697"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 14:17:54 -0800
IronPort-SDR: 64LlgF/erPZsctOLVzwRWk/jGyb5Iqa4376HyN5vdqQTU9uXp0actb5cVFgTPPAcDwfAM7g2Zm
 byFffLoO17jg==
X-IronPort-AV: E=Sophos;i="5.77,473,1596524400"; 
   d="scan'208";a="530838460"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.132.156])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 14:17:53 -0800
Date:   Thu, 12 Nov 2020 14:17:52 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <jakub.pawlak@intel.com>,
        <jeffrey.t.kirsher@intel.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] iavf: fix error return code in
 iavf_init_get_resources()
Message-ID: <20201112141752.00006b80@intel.com>
In-Reply-To: <1605181194-3093-1-git-send-email-zhangchangzhong@huawei.com>
References: <1605181194-3093-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhang Changzhong wrote:

> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: b66c7bc1cd4d ("iavf: Refactor init state machine")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Thanks!

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
