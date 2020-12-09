Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B9B2D448C
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733027AbgLIOlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:41:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:33478 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731477AbgLIOlM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 09:41:12 -0500
IronPort-SDR: rCob4zDUMllNavMr56jtUcuQGs/24HrgO3HdlH/ahbQ4HK57T96rp0XJxOfSyBbIf+nIrte4xP
 CkF+f4o/bMGA==
X-IronPort-AV: E=McAfee;i="6000,8403,9829"; a="192387017"
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="192387017"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 06:39:24 -0800
IronPort-SDR: pyJNMoe69/uLLsTsFjVDwidhM2zQdNV9tWfpqmeZCfY6efzG9gWVU5nUc/DIccBT/tpBRYM0I4
 /BfI9bLyQpew==
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="364154509"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 06:39:21 -0800
Received: by lahna (sSMTP sendmail emulation); Wed, 09 Dec 2020 16:39:19 +0200
Date:   Wed, 9 Dec 2020 16:39:19 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.jamet@intel.com,
        YehezkelShB@gmail.com
Subject: Re: [PATCH net-next] net: thunderbolt: convert comma to semicolon
Message-ID: <20201209143919.GT5246@lahna.fi.intel.com>
References: <20201209133852.1475-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209133852.1475-1-zhengyongjun3@huawei.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 09:38:52PM +0800, Zheng Yongjun wrote:
> Replace a comma between expression statements by a semicolon.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
