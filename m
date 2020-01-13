Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E78A1398C7
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 19:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgAMSW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 13:22:58 -0500
Received: from mga14.intel.com ([192.55.52.115]:12843 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbgAMSW5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 13:22:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jan 2020 10:22:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,429,1571727600"; 
   d="scan'208";a="273098006"
Received: from jekeller-mobl.amr.corp.intel.com (HELO [134.134.177.84]) ([134.134.177.84])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jan 2020 10:22:57 -0800
Subject: Re: [PATCH v2 0/3] devlink region trigger support
To:     Jiri Pirko <jiri@resnulli.us>,
        Yunsheng Lin <linyunsheng@huawei.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
 <4d8fe881-8d36-06dd-667a-276a717a0d89@huawei.com>
 <1d00deb9-16fc-b2a5-f8f7-5bb8316dbac2@intel.com>
 <fe6c0d5e-5705-1118-1a71-80bd0e26a97e@huawei.com>
 <20200113165858.GG2131@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <1771df1d-8f2e-8622-5edf-2cce47571faf@intel.com>
Date:   Mon, 13 Jan 2020 10:22:57 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200113165858.GG2131@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/2020 8:58 AM, Jiri Pirko wrote:
> Why? That is the purpose of the dpipe, but make the hw
> pipeline visible and show you the content of individual nodes.
> 

I agree. dpipe seems to be focused specifically on dumping nodes of the
tables that represent the hardware's pipeline. I think it's unrelated to
this discussion about regions vs health API.
