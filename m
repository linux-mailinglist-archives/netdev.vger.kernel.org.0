Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FA930E742
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbhBCXZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:25:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:23948 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233210AbhBCXZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 18:25:08 -0500
IronPort-SDR: QQfWHrn9tOb6PtI0MiDD360CKTb3aPNhg0a52EuPBG50OlTCfD98MAhJsmOQbxkD20s5zK6xht
 8R8iEFwmvRDQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="200106321"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="200106321"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 15:24:26 -0800
IronPort-SDR: NBZiFBwwcwVd4Wgjr7dWsVE5+3zJXN7/osWGPQALR1Fe+Q837XBS7c3eFFrbQMFxXqdaUSU87n
 sd/zCEwwW4Zw==
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="356185467"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.23.15])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 15:24:25 -0800
Date:   Wed, 3 Feb 2021 15:24:25 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "Guangbin Huang" <huangguangbin2@huawei.com>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] net: hns3: remove redundant null check of an
 array
Message-ID: <20210203152425.00007a51@intel.com>
In-Reply-To: <20210203131040.21656-1-colin.king@canonical.com>
References: <20210203131040.21656-1-colin.king@canonical.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The null check of filp->f_path.dentry->d_iname is redundant because
> it is an array of DNAME_INLINE_LEN chars and cannot be a null. Fix
> this by removing the null check.
> 
> Addresses-Coverity: ("Array compared against 0")
> Fixes: 04987ca1b9b6 ("net: hns3: add debugfs support for tm nodes, priority and qset info")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
