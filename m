Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6522136F514
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 06:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhD3Eak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 00:30:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:23937 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhD3Eaj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 00:30:39 -0400
IronPort-SDR: tlwbkN2Mo/AlW3oklae25ZVSqRFmm4Gnzgtbd3DVsepwTV6tRqIGtcI4gIq1o+9JbF2vWO1W83
 wQNHK5siSsGA==
X-IronPort-AV: E=McAfee;i="6200,9189,9969"; a="197292429"
X-IronPort-AV: E=Sophos;i="5.82,260,1613462400"; 
   d="scan'208";a="197292429"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2021 21:29:50 -0700
IronPort-SDR: r5kBLHUL3Iu39C7dc3kM5eVDixAXaqGfwZ13+A0O0LtenkAS7J7fKqvNRIG3Gusvq1+KyiB9yP
 OIWP3S79MbWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,260,1613462400"; 
   d="scan'208";a="605540583"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga005.jf.intel.com with ESMTP; 29 Apr 2021 21:29:49 -0700
Received: from linux.intel.com (unknown [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 16A58580569;
        Thu, 29 Apr 2021 21:29:46 -0700 (PDT)
Date:   Fri, 30 Apr 2021 12:29:44 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kael_w@yeah.net
Subject: Re: [PATCH] net: stmmac: Remove duplicate declaration of stmmac_priv
Message-ID: <20210430042944.GA5444@linux.intel.com>
References: <20210430031047.34888-1-wanjiabing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430031047.34888-1-wanjiabing@vivo.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 11:10:47AM +0800, Wan Jiabing wrote:
> In commit f4da56529da60 ("net: stmmac: Add support for external
> trigger timestamping"), struct stmmac_priv was declared at line 507
> which caused duplicate struct declarations.
> Remove later duplicate declaration here.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>

Reviewed-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>

