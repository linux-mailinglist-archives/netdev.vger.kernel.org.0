Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 723FB36DB6
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 09:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfFFHrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 03:47:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:56593 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbfFFHrT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 03:47:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 00:47:19 -0700
X-ExtLoop1: 1
Received: from scohe14-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.255.41.151])
  by orsmga006.jf.intel.com with ESMTP; 06 Jun 2019 00:47:17 -0700
Subject: Re: questions about AF_PACKET V4 and AF_XDP
To:     "Junsong Zhao (junszhao)" <junszhao@cisco.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <77a8123886714daeb9d2518dce45da1e@XCH-ALN-014.cisco.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <95aaafdc-ef8a-c4b9-6104-a1a753c81820@intel.com>
Date:   Thu, 6 Jun 2019 09:47:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <77a8123886714daeb9d2518dce45da1e@XCH-ALN-014.cisco.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-06-05 19:56, Junsong Zhao (junszhao) wrote:
> Hi Magnus and Bjorn,
> 
> I saw your articles and presentation about AF_PACKET V4. It is exciting 
> to know that the kernel socket can have 40G throughput.
> 
> But it seems the code is not in the 4.19 or 5.1 kernel. Instead there is 
> a new feature AF_XDP in 4.19 kernel and it is kind of similar to 
> AF_PACKET V4.
> 
> Can you clarify if AF_XDP is the successor of AF_PACKET V4? Apart from 
> i40e driver, is there any other driver that supports the feature?
>

AF_PACKET v4 never made it to mainland, instead AF_XDP took that place.

Drivers with zero-copy support are i40e, ixgbe, and soon mlx5 and ice.

There's an LWN article on AF_XDP here: https://lwn.net/Articles/750845/


Thanks,
Björn


> Here is the link to the article:
> 
> https://lwn.net/Articles/737947/
> 
> Regards,
> 
> Junsong Zhao
> 
> Tech Lead
> 
> Stealthwatch
> 
> junszhao@cisco.com
> 
> Mobile: +1-410-530-1036
> 
