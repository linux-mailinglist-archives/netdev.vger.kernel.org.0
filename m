Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0F4283EF0
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 20:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbgJESpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 14:45:19 -0400
Received: from mga12.intel.com ([192.55.52.136]:53468 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgJESpS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 14:45:18 -0400
IronPort-SDR: 3FSZuNeWLE69Oj/NonUN39167rJ+Db7PVeOia6VtIR7AZxYdapNZH/DW2pPbFLHkXxQPV1fyXB
 HnAtbkRqlqQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="143228411"
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="143228411"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 11:45:10 -0700
IronPort-SDR: E6pQ9YDI43zkKwK8oS0eoACx4mVqkzMEAalzHvSyvUD1wuPoyXtTbVSvzXE55meb2TUd8mVs0Q
 dOtLAfd3R2ag==
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="310164830"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.255.65.178]) ([10.255.65.178])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 11:45:09 -0700
Subject: Re: [PATCH net-next 03/16] devlink: Add devlink reload limit option
To:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-4-git-send-email-moshe@mellanox.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <150136a2-f391-b588-3d6e-d97cd11e4cf2@intel.com>
Date:   Mon, 5 Oct 2020 11:45:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <1601560759-11030-4-git-send-email-moshe@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/1/2020 6:59 AM, Moshe Shemesh wrote:
> Add reload limit to demand restrictions on reload actions.
> Reload limits supported:
> no_reset: No reset allowed, no down time allowed, no link flap and no
>           configuration is lost.
> 
> By default reload limit is unspecified and so no constrains on reload
> actions are required.

Nit: I think the spelling for the noun here would be "constraints"? Same
for a comment in the header file.

> 
> Some combinations of action and limit are invalid. For example, driver
> can not reinitialize its entities without any downtime.
> 

Good to see that checked in the core code.

> The no_reset reload limit will have usecase in this patchset to
> implement restricted fw_activate on mlx5.
> 
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
> ---

Other than the spelling hit and things pointed out by others, this looks
good to me.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
