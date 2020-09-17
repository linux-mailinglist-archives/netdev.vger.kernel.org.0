Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5798726E382
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgIQS1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:27:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:34824 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbgIQS1I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 14:27:08 -0400
IronPort-SDR: Vh06kQPfuzX5bqEMrZm6xtTJqzLOqbTysiIJqPvB5eZCUj7bpQupAgAsNoxFic+5ccpeqM6N/J
 Xpal861q8dTA==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="147453694"
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="147453694"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 11:26:39 -0700
IronPort-SDR: zvIu7r0T3J1bEagPKIhVq8sbXV/5IEdJN9wQZ/7o7EDmRRMos2/KKIrb04snyTX6FDJX5Pvi4N
 Ea0VeZ0s0cKw==
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="483853045"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.251.16.238])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 11:26:38 -0700
Date:   Thu, 17 Sep 2020 11:26:38 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        simon.horman@netronome.com, oss-drivers@netronome.com
Subject: Re: [PATCH net] nfp: use correct define to return NONE fec
Message-ID: <20200917112638.00007d5c@intel.com>
In-Reply-To: <20200917175257.592636-1-kuba@kernel.org>
References: <20200917175257.592636-1-kuba@kernel.org>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:

> struct ethtool_fecparam carries bitmasks not bit numbers.
> We want to return 1 (NONE), not 0.
> 
> Fixes: 0d0870938337 ("nfp: implement ethtool FEC mode settings")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Good catch!

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
