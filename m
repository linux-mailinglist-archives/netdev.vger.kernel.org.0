Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77BC614F222
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgAaS0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:26:13 -0500
Received: from mga12.intel.com ([192.55.52.136]:46366 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgAaS0N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:26:13 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 10:26:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,386,1574150400"; 
   d="scan'208";a="377419511"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.86]) ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2020 10:26:12 -0800
Subject: Re: [PATCH 11/15] ice: add board identifier info to devlink .info_get
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-12-jacob.e.keller@intel.com>
 <20200131100733.113d5a17@cakuba.hsd1.ca.comcast.net>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <2ccf58f5-5298-c05a-e8e6-c619d0337390@intel.com>
Date:   Fri, 31 Jan 2020 10:26:12 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200131100733.113d5a17@cakuba.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/2020 10:07 AM, Jakub Kicinski wrote:
> On Thu, 30 Jan 2020 14:59:06 -0800, Jacob Keller wrote:
>> Export a unique board identifier using "board.id" for devlink's
>> .info_get command.
>>
>> Obtain this by reading the NVM for the PBA identification string.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> 
> In general for the devlink info it'd be really useful to have example
> outputs to see what the values actually are.
> 

Makes sense, will add some.

Thanks,
Jake
