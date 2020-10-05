Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF79283E5D
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 20:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgJESeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 14:34:36 -0400
Received: from mga18.intel.com ([134.134.136.126]:46118 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgJESeg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 14:34:36 -0400
IronPort-SDR: cSEhg5Pishzj3ND3pMCztD8lemWXiNXLnh+LfACH82oaDA9c3qre8XRm0aV1calPH3JrtFRA38
 Y0GYSMQzd6wQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="151613987"
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="151613987"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 11:34:26 -0700
IronPort-SDR: kunrzPL0zLYx+ilbaCZZyYZDiXgyQ9DljQOxNsW7y10KymWy6IekP2tN2DRAi/1MRF1eMIrTCL
 xsukPRGbcRDA==
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="310154543"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.255.65.178]) ([10.255.65.178])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 11:34:25 -0700
Subject: Re: [PATCH net-next 01/16] devlink: Change devlink_reload_supported()
 param type
To:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-2-git-send-email-moshe@mellanox.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <c9d85ec9-27cf-19de-0ad1-a687d61484ca@intel.com>
Date:   Mon, 5 Oct 2020 11:34:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <1601560759-11030-2-git-send-email-moshe@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/1/2020 6:59 AM, Moshe Shemesh wrote:
> Change devlink_reload_supported() function to get devlink_ops pointer
> param instead of devlink pointer param.
> This change will be used in the next patch to check if devlink reload is
> supported before devlink instance is allocated.
> 
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
