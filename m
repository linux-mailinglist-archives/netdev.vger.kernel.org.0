Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5251C1FB0
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 23:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgEAVe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 17:34:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:65201 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAVe0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 17:34:26 -0400
IronPort-SDR: wPn3wW/9Dl9f1KVrsQSoDiWaeyjcltQaJe3qCbqDd/vh3nqqU8ElSOIpFG3uf5d2V5mUqnpXMU
 dG6Dfu/E6ICw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 14:34:26 -0700
IronPort-SDR: xgAHGC5jvVECek1a7OeYIGY7K9TQ2DuIHgZFZ6YzAOvFNAeM4agU9GXiYQsNsr1igPwxN/Stw0
 A14uBHSYm4JA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,341,1583222400"; 
   d="scan'208";a="248645379"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.101.237]) ([10.209.101.237])
  by fmsmga007.fm.intel.com with ESMTP; 01 May 2020 14:34:24 -0700
Subject: Re: [PATCH net-next v3 3/3] docs: devlink: clarify the scope of
 snapshot id
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
References: <20200430175759.1301789-1-kuba@kernel.org>
 <20200430175759.1301789-4-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <444b8f2b-42fb-dac7-3fa3-95bb57b7940c@intel.com>
Date:   Fri, 1 May 2020 14:34:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430175759.1301789-4-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/30/2020 10:57 AM, Jakub Kicinski wrote:
> In past discussions Jiri explained snapshot ids are cross-region.
> Explain this in the docs.
> 
> v3: new patch
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>


Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
