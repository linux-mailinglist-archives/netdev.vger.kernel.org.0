Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6D9437FBE
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 23:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhJVVFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 17:05:38 -0400
Received: from mga17.intel.com ([192.55.52.151]:33834 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234342AbhJVVFg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 17:05:36 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10145"; a="210172728"
X-IronPort-AV: E=Sophos;i="5.87,173,1631602800"; 
   d="scan'208";a="210172728"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2021 14:03:18 -0700
X-IronPort-AV: E=Sophos;i="5.87,173,1631602800"; 
   d="scan'208";a="528060973"
Received: from rmarti10-mobl1.amr.corp.intel.com (HELO [10.241.224.119]) ([10.241.224.119])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2021 14:03:17 -0700
Message-ID: <e373d617-4884-08d6-1aae-4fbfa7b01767@linux.intel.com>
Date:   Fri, 22 Oct 2021 14:03:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 00/14] net: wwan: t7xx: PCIe driver for MediaTek M.2 modem
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com
References: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
 <20211021152317.3de4d226@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cdb9e908-b87f-cda9-5b5d-bd1eb250ba10@linux.intel.com>
 <20211022134330.25ac88af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <20211022134330.25ac88af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/22/2021 1:43 PM, Jakub Kicinski wrote:
> On Fri, 22 Oct 2021 13:20:38 -0700 Martinez, Ricardo wrote:
>> On 10/21/2021 3:23 PM, Jakub Kicinski wrote:
>>> On Thu, 21 Oct 2021 13:27:24 -0700 Ricardo Martinez wrote:
>>>> t7xx is the PCIe host device driver for Intel 5G 5000 M.2 solution
>>>> which is based on MediaTek's T700 modem to provide WWAN connectivity.
>>>
>>> It needs to build cleanly with W=1, and have no kdoc warnings
>>> (scripts/kernel-doc -none).
>>>    
>> It builds cleanly with W=1, I test with 'make W=1 -C . M=drivers/net/wwan/t7xx'.
>> Regarding kernel-doc, there's an enum that does need a documentation update.
> 
> Fetch the latest net-next/master, rebase and try again.
> 
> Throw in sparse checking for good measure (C=1).
> 
I see that now, thanks.
