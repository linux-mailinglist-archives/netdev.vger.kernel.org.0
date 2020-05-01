Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9847F1C1F94
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 23:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgEAV1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 17:27:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:61094 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAV1p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 17:27:45 -0400
IronPort-SDR: KMe4vv24DfRlQJyZrzeWIumV7ehvFf1HEms+VL6biKwD+FWIpp0Kxg7/bk0IHdpTLh6SIl0UeX
 KFj6uNllaA5Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 14:27:44 -0700
IronPort-SDR: DzUCHY9HltuWB4t7RSC1RhIvrmeFJMJUTuPJtFP1C8d/9sq3CdzEm2UL1lvvpDlQyBh2OQpao8
 6tZnZsPSvOPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,341,1583222400"; 
   d="scan'208";a="248644027"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.101.237]) ([10.209.101.237])
  by fmsmga007.fm.intel.com with ESMTP; 01 May 2020 14:27:44 -0700
Subject: Re: [PATCH net-next v3 1/3] devlink: factor out building a snapshot
 notification
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
References: <20200430175759.1301789-1-kuba@kernel.org>
 <20200430175759.1301789-2-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <1ee9083b-3841-5745-4b0b-8d1fa63f4121@intel.com>
Date:   Fri, 1 May 2020 14:27:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430175759.1301789-2-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/30/2020 10:57 AM, Jakub Kicinski wrote:
> We'll need to send snapshot info back on the socket
> which requested a snapshot to be created. Factor out
> constructing a snapshot description from the broadcast
> notification code.
> 
> v3: new patch
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
