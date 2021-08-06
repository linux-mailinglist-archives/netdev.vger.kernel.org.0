Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B723E273F
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 11:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244390AbhHFJ3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 05:29:42 -0400
Received: from mga06.intel.com ([134.134.136.31]:46728 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231553AbhHFJ3l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 05:29:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="275384403"
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="275384403"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 02:29:26 -0700
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="669347115"
Received: from mckumar-mobl.gar.corp.intel.com (HELO [10.215.201.156]) ([10.215.201.156])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 02:29:23 -0700
Subject: Re: wwan/iosm vs. xmm7360
To:     Jan Kiszka <jan.kiszka@siemens.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        linuxwwan@intel.com
References: <0545a78f-63f0-f8dd-abdb-1887c65e1c79@siemens.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
Message-ID: <eb8fa6ad-10c8-e035-9bd8-1caf470e739e@linux.intel.com>
Date:   Fri, 6 Aug 2021 14:59:20 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <0545a78f-63f0-f8dd-abdb-1887c65e1c79@siemens.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jan,

What is the context of this request ?

FYI, the driver upstreamed is for M.2 7560.

Regards,
Chetan

On 8/6/2021 2:09 AM, Jan Kiszka wrote:
> Hi Chetan,
> 
> at the risk of having missed this being answered already:
> 
> How close is the older xmm7360 to the now supported xmm7560 in mainline?
> 
> There is that reverse engineered PCI driver [1] with non-standard
> userland interface, and it would obviously be great to benefit from
> common infrastructure and specifically the modem-manager compatible
> interface. Is this realistic to achieve for the 7360, or is that
> hardware or its firmware too different?
> 
> Thanks,
> Jan
> 
> [1] https://github.com/xmm7360/xmm7360-pci
> 
