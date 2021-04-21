Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3130F366F6B
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244084AbhDUPsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:48:32 -0400
Received: from mga03.intel.com ([134.134.136.65]:7382 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243712AbhDUPsa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:48:30 -0400
IronPort-SDR: CDumP53UWcFtdIRuS+0LQlnZo6H5aH4HMvZVIh9DL2beQKfOfXRPjSp/I33txvh1krYnu5SUG1
 FeT6Mr9XvGfA==
X-IronPort-AV: E=McAfee;i="6200,9189,9961"; a="195746943"
X-IronPort-AV: E=Sophos;i="5.82,240,1613462400"; 
   d="scan'208";a="195746943"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2021 08:47:56 -0700
IronPort-SDR: eHLdZFql0BmKUV9o3AAeOQH/5qTMuOjY6FBe3m2huykpG3k9I/xnPk46S9ndjcZy3e0NSusWDA
 icamdntlc9Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,240,1613462400"; 
   d="scan'208";a="455391360"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 21 Apr 2021 08:47:56 -0700
Received: from linux.intel.com (unknown [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 700105808CA;
        Wed, 21 Apr 2021 08:47:53 -0700 (PDT)
Date:   Wed, 21 Apr 2021 23:47:50 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] stmmac: intel: unlock on error path in
 intel_crosststamp()
Message-ID: <20210421154750.GA20299@linux.intel.com>
References: <YIAnKtpJa/K+0efq@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIAnKtpJa/K+0efq@mwanda>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 04:22:50PM +0300, Dan Carpenter wrote:
> We recently added some new locking to this function but one error path
> was overlooked.  We need to drop the lock before returning.
> 
> Fixes: f4da56529da6 ("net: stmmac: Add support for external trigger timestamping")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>

