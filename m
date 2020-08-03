Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5B223B062
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgHCWoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:44:22 -0400
Received: from mga04.intel.com ([192.55.52.120]:10978 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727779AbgHCWoW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 18:44:22 -0400
IronPort-SDR: /rUtTAty6sgpqZY06l0pteNMPJY0XMPMIzsk8JXSioDukNiXOUN+TYaA2UMWQT3TORMkyDXRXS
 KYnwWkOmnyhg==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="149663556"
X-IronPort-AV: E=Sophos;i="5.75,431,1589266800"; 
   d="scan'208";a="149663556"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 15:44:21 -0700
IronPort-SDR: uKl5RuPeyFQbrufZmfgM+ABLwJpUt2HijqmezLk/jMz7EQc7RHrgSXlCD4sIm/3bogHLALPjf4
 Y0pN7v/1Ml5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,431,1589266800"; 
   d="scan'208";a="366611297"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.196.183]) ([10.212.196.183])
  by orsmga001.jf.intel.com with ESMTP; 03 Aug 2020 15:44:21 -0700
Subject: Re: [iproute2-next v2 5/5] devlink: support setting the overwrite
 mask
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
References: <20200801002159.3300425-1-jacob.e.keller@intel.com>
 <20200801002159.3300425-6-jacob.e.keller@intel.com>
 <0bb895a2-e233-0426-3e48-d8422fa5b7cf@gmail.com>
 <c317a649-59f4-82a2-5617-0f6209964b8e@intel.com>
 <1dfbda13-6e49-ba5f-135e-9a5ced48bb50@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <08343b3d-7d7e-555a-c0f1-13c0fbf3218e@intel.com>
Date:   Mon, 3 Aug 2020 15:44:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <1dfbda13-6e49-ba5f-135e-9a5ced48bb50@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/3/2020 2:20 PM, David Ahern wrote:
> On 8/3/20 10:56 AM, Jacob Keller wrote:
>> Sorry for the confusion here. I sent both the iproute2 and net-next
>> changes to implement it in the kernel.
> 
> please re-send the iproute2 patch; I already marked it in patchworks. I
> get sending the patches in 1 go, but kernel and iproute2 patch numbering
> should be separate.
> 

Yep, I'll do that in the future, an will be re-sending a v2 shortly with
changes on the kernel side from Jiri's review.

Thanks,
Jake
