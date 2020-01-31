Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B58614F1F5
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbgAaSJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:09:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:39831 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbgAaSJO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:09:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 10:09:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,386,1574150400"; 
   d="scan'208";a="377414721"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.86]) ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2020 10:09:13 -0800
Subject: Re: [RFC PATCH 00/13] devlink direct region reading
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200131100658.718d3be6@cakuba.hsd1.ca.comcast.net>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <7ebd28d0-4e9f-be92-b9ac-b29b5916500f@intel.com>
Date:   Fri, 31 Jan 2020 10:09:13 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200131100658.718d3be6@cakuba.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/2020 10:06 AM, Jakub Kicinski wrote:
> On Thu, 30 Jan 2020 14:58:55 -0800, Jacob Keller wrote:
>> Finally, the last 3 patches implement a new region in the ice driver for
>> accessing the shadow RAM. This region will support the immediate trigger
>> operation as well as a new read operation that enables directly reading from
>> the shadow RAM without a region.
> 
> ... without a snapshot?
> 

Woops. Yes that's the correct word I meant here.

Thanks,
Jake
