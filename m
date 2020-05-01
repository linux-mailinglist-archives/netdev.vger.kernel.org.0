Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2381C1FB8
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 23:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgEAVhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 17:37:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:43343 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAVhS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 17:37:18 -0400
IronPort-SDR: hT1MJYrrPPJVJKLdmExLX//FmB7y2zb68z3V13dfOrUWxDOakE3ootrwKBsAHz1eXQ2i6ZFRNU
 nBNSDSl9N06A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 14:37:17 -0700
IronPort-SDR: tJqOBVBAbCjyDDJKQECv8VFJSqZpAq/p1v5KkY4BNMjHXj+k9LEnorRdMJkimov17JTtVocHO6
 otcvErg1ESeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,341,1583222400"; 
   d="scan'208";a="248645901"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.101.237]) ([10.209.101.237])
  by fmsmga007.fm.intel.com with ESMTP; 01 May 2020 14:37:16 -0700
Subject: Re: [PATCH net-next v2] devlink: let kernel allocate region snapshot
 id
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
References: <20200429233813.1137428-1-kuba@kernel.org>
 <20200430045315.GF6581@nanopsycho.orion>
 <02874ECE860811409154E81DA85FBB58C0771750@ORSMSX151.amr.corp.intel.com>
 <20200501143251.1f7026ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <aa51f181-69f7-edc6-1987-be1dce31d3ab@intel.com>
Date:   Fri, 1 May 2020 14:37:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501143251.1f7026ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/1/2020 2:32 PM, Jakub Kicinski wrote:
> On Fri, 1 May 2020 21:23:25 +0000 Keller, Jacob E wrote:
>>> Could you please send the snapshot id just before you return 0 in this
>>> function, as you offered in v1? I think it would be great to do it like
>>> that.
>>>
>>
>> Also: Does it make sense to send the snapshot id regardless of
>> whether it was auto-generated or not?
> 
> I may be wrong, but I think sending extra messages via netlink,
> which user space may not expect based on previous kernel versions 
> is considered uAPI breakage.
> 

Ok makes sense.

Thanks,
Jake
