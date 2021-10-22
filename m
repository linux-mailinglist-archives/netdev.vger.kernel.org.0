Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77FFD437F47
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 22:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbhJVUW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 16:22:57 -0400
Received: from mga14.intel.com ([192.55.52.115]:8632 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232082AbhJVUW5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 16:22:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10145"; a="229649504"
X-IronPort-AV: E=Sophos;i="5.87,173,1631602800"; 
   d="scan'208";a="229649504"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2021 13:20:39 -0700
X-IronPort-AV: E=Sophos;i="5.87,173,1631602800"; 
   d="scan'208";a="528050892"
Received: from rmarti10-mobl1.amr.corp.intel.com (HELO [10.241.224.119]) ([10.241.224.119])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2021 13:20:38 -0700
Message-ID: <cdb9e908-b87f-cda9-5b5d-bd1eb250ba10@linux.intel.com>
Date:   Fri, 22 Oct 2021 13:20:38 -0700
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
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <20211021152317.3de4d226@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/21/2021 3:23 PM, Jakub Kicinski wrote:
> On Thu, 21 Oct 2021 13:27:24 -0700 Ricardo Martinez wrote:
>> t7xx is the PCIe host device driver for Intel 5G 5000 M.2 solution
>> which is based on MediaTek's T700 modem to provide WWAN connectivity.
> 
> It needs to build cleanly with W=1, and have no kdoc warnings
> (scripts/kernel-doc -none).
> 
It builds cleanly with W=1, I test with 'make W=1 -C . M=drivers/net/wwan/t7xx'.
Regarding kernel-doc, there's an enum that does need a documentation update.
