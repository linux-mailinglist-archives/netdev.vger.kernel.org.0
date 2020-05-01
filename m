Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AF21C1FB4
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 23:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgEAVfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 17:35:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:37984 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAVfs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 17:35:48 -0400
IronPort-SDR: 76AEViB0FRM1wM8iaonpvLmMxk9U9z9cBbnYg3+t3WpBdK6wQC5VTl4JSJvRWuPGwWtvGZ/0Y2
 dfJ0pcDB233g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 14:35:48 -0700
IronPort-SDR: /9Sqh4+gj9RgN4Q+iPnfksKPXigsHRKBZaemSTbduWjaxHuel5tBwiPc+QhBWaNfCCW4C+o/h6
 QtDQZ6a7Ndfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,341,1583222400"; 
   d="scan'208";a="248645609"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.101.237]) ([10.209.101.237])
  by fmsmga007.fm.intel.com with ESMTP; 01 May 2020 14:35:45 -0700
Subject: Re: [PATCH net-next v4 1/3] devlink: factor out building a snapshot
 notification
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Jiri Pirko <jiri@mellanox.com>
References: <20200501164042.1430604-1-kuba@kernel.org>
 <20200501164042.1430604-2-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <8a3ab69d-8416-6c9d-7be1-318b72379b97@intel.com>
Date:   Fri, 1 May 2020 14:35:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501164042.1430604-2-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/1/2020 9:40 AM, Jakub Kicinski wrote:
> We'll need to send snapshot info back on the socket
> which requested a snapshot to be created. Factor out
> constructing a snapshot description from the broadcast
> notification code.
> 
> v3: new patch
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
