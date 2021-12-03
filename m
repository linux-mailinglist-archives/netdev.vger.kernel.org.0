Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B625D466FB3
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350559AbhLCCZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:25:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:54788 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240146AbhLCCZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 21:25:26 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10186"; a="260897580"
X-IronPort-AV: E=Sophos;i="5.87,283,1631602800"; 
   d="scan'208";a="260897580"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 18:22:03 -0800
X-IronPort-AV: E=Sophos;i="5.87,283,1631602800"; 
   d="scan'208";a="459894360"
Received: from liweilv-mobl.ccr.corp.intel.com (HELO [10.167.226.45]) ([10.255.30.243])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 18:22:00 -0800
Subject: Re: [PATCH v2 1/3] selftests/tc-testing: add exit code
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Davide Caratti <dcaratti@redhat.com>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, lizhijian@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, lkp@intel.com, philip.li@intel.com,
        Networking <netdev@vger.kernel.org>
References: <20211117054517.31847-1-zhijianx.li@intel.com>
 <YZTDcjv4ZPXv8Oaz@dcaratti.users.ipa.redhat.com>
 <20211117060535.1d47295a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4ed23cd5-f4a1-aa70-183f-fbea407c19ee@mojatatu.com>
 <20211117084854.0d44d64b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d0c32c34-b0a4-ce1e-35d6-1894222e825a@mojatatu.com>
From:   Li Zhijian <zhijianx.li@intel.com>
Message-ID: <236a81d3-db14-902f-8833-377ec0a9b7da@intel.com>
Date:   Fri, 3 Dec 2021 10:21:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <d0c32c34-b0a4-ce1e-35d6-1894222e825a@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CCed netdev

Kindly ping


On 18/11/2021 00:51, Jamal Hadi Salim wrote:
> On 2021-11-17 11:48, Jakub Kicinski wrote:
>> On Wed, 17 Nov 2021 11:41:18 -0500 Jamal Hadi Salim wrote:
>>> Did you mean adding a maintainer for tdc or just generally point
>>> who/what to involve when making changes? Typically the mailing list
>>> should be sufficient. Outside the list, at the moment, any outstanding
>>> issues on tdc are discussed/resolved in the monthly TC meetups (where
>>> all the stake holders show up)...
>>
>> I'm mostly interested in the code review and merging part.
>>
>> Would be great to have a MAINTAINERS entry with a set of folks
>> who can review patches, so that get_maintainers.pl can do its job.
>>
>> At the very least to make sure netdev is CCed.
>
> ACK.
>
> cheers,
> jamal
>

