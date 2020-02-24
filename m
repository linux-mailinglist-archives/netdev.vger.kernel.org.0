Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2CA16AFBF
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 19:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgBXSyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 13:54:43 -0500
Received: from mga07.intel.com ([134.134.136.100]:63730 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727426AbgBXSyn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 13:54:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 10:54:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,481,1574150400"; 
   d="scan'208";a="436001422"
Received: from anambiar-mobl1.amr.corp.intel.com (HELO [10.251.155.140]) ([10.251.155.140])
  by fmsmga005.fm.intel.com with ESMTP; 24 Feb 2020 10:54:41 -0800
Subject: Re: [net PATCH] net: Fix Tx hash bound checking
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        netdev@vger.kernel.org, davem@davemloft.net
Cc:     alexander.h.duyck@intel.com, sridhar.samudrala@intel.com
References: <158233736265.6609.6785259084260258418.stgit@anambiarhost.jf.intel.com>
 <c0740c47-8b2e-8554-c78d-90461dde1177@cogentembedded.com>
From:   "Nambiar, Amritha" <amritha.nambiar@intel.com>
Message-ID: <b8f23c6a-e703-96b3-7756-0d53bd9f6971@intel.com>
Date:   Mon, 24 Feb 2020 10:54:41 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <c0740c47-8b2e-8554-c78d-90461dde1177@cogentembedded.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/22/2020 12:07 AM, Sergei Shtylyov wrote:
> Hello!
> 
> On 22.02.2020 5:09, Amritha Nambiar wrote:
> 
>> Fixes: commit 1b837d489e06 ("net: Revoke export for __skb_tx_hash, update it to just be static skb_tx_hash")
>> Fixes: commit eadec877ce9c ("net: Add support for subordinate traffic classes to netdev_pick_tx")
> 
>     No need to say "commit" here. And All tags should be together (below the 
> patch description).
> 

Sure. Will send v2 with these changes.

-Amritha

>> Fixes the lower and upper bounds when there are multiple TCs and
>> traffic is on the the same TC on the same device.
>>
>> The lower bound is represented by 'qoffset' and the upper limit for
>> hash value is 'qcount + qoffset'. This gives a clean Rx to Tx queue
>> mapping when there are multiple TCs, as the queue indices for upper TCs
>> will be offset by 'qoffset'.
>>
>> Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
>> Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> [...]
> 
> MBR, Sergei
> 
