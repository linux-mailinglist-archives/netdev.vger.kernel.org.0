Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFDA261213
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 15:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730030AbgIHNhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 09:37:07 -0400
Received: from mga05.intel.com ([192.55.52.43]:41206 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729545AbgIHLMP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 07:12:15 -0400
IronPort-SDR: KA3BG1x0/KIeeZJWRQ2PSqK8SdoysORIFBjUVTrWzEd0/GJiop6netUoDF9Xu/eYG7gKtiTT34
 zaQ4BB/gYHaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9737"; a="242925918"
X-IronPort-AV: E=Sophos;i="5.76,405,1592895600"; 
   d="scan'208";a="242925918"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2020 04:12:15 -0700
IronPort-SDR: ebvqiBbYWXapEz4ci64bdBQOaYcK2mF5S/5oFyorAuRylRf//LSSu5CczC0iF3r2Si+jwAY83+
 zoimXcqZvq6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,405,1592895600"; 
   d="scan'208";a="284479300"
Received: from pgierasi-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.39.2])
  by fmsmga007.fm.intel.com with ESMTP; 08 Sep 2020 04:12:13 -0700
Subject: Re: [Intel-wired-lan] [PATCH bpf-next 4/4] ixgbe, xsk: use
 XSK_NAPI_WEIGHT as NAPI poll budget
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kuba@kernel.org, intel-wired-lan@lists.osuosl.org,
        magnus.karlsson@intel.com
References: <20200907150217.30888-1-bjorn.topel@gmail.com>
 <20200907150217.30888-5-bjorn.topel@gmail.com>
 <82901368-8e17-a63d-0e46-2434b5777c04@molgen.mpg.de>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <0fb03a39-d098-8fc9-ba70-e919ef8e091e@intel.com>
Date:   Tue, 8 Sep 2020 13:12:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <82901368-8e17-a63d-0e46-2434b5777c04@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-08 12:12, Paul Menzel wrote:
> Dear Björn,
> 
> 
> Am 07.09.20 um 17:02 schrieb Björn Töpel:
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> Start using XSK_NAPI_WEIGHT as NAPI poll budget for the AF_XDP Rx
>> zero-copy path.
> 
> Could you please add the description from the patch series cover letter 
> to this commit too? To my knowledge, the message in the cover letter 
> won’t be stored in the git repository.
>

Paul, thanks for the input! The netdev/bpf trees always include the 
cover letter in the merge commit.


Cheers,
Björn

>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
>> ---
>>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> […]
> 
> 
> Kind regards,
> 
> Paul
