Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492072498C4
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 10:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgHSIyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 04:54:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:2563 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726759AbgHSIwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 04:52:46 -0400
IronPort-SDR: 1EY4Bcwnnx0fp8uuovSyiloJdrdCZDdwpdFCtNlL/RNU3LhohZrr8/BM+S/ne1/MqaueWfgyjH
 dpP9FZQPQyQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="156141415"
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="156141415"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 01:52:45 -0700
IronPort-SDR: O3igYNVHERIrPEv+6BPrS2p5Ge2MIOT25tEwj5DhNH39mzqpsLzydvBO39XZCodjqWu7rRLW+r
 yplyU9mxvvIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="497168072"
Received: from skirillo-mobl2.ccr.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.32.199])
  by fmsmga006.fm.intel.com with ESMTP; 19 Aug 2020 01:52:42 -0700
Subject: =?UTF-8?B?UmU6IOetlOWkjTog562U5aSNOiBbSW50ZWwtd2lyZWQtbGFuXSBbUEFU?=
 =?UTF-8?Q?CH_0/2=5d_intel/xdp_fixes_for_fliping_rx_buffer?=
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
To:     "Li,Rongqing" <lirongqing@baidu.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Piotr <piotr.raczynski@intel.com>,
        Maciej <maciej.machnikowski@intel.com>
References: <1594967062-20674-1-git-send-email-lirongqing@baidu.com>
 <CAJ+HfNi2B+2KYP9A7yCfFUhfUBd=sFPeuGbNZMjhNSdq3GEpMg@mail.gmail.com>
 <4268316b200049d58b9973ec4dc4725c@baidu.com>
 <83e45ec2-1c66-59f6-e817-d4c523879007@intel.com>
 <c3695fc71ca140d08a795bbd32d8522f@baidu.com>
 <c691e3d2-8b16-744c-8918-5be042bd37dc@intel.com>
Message-ID: <7d5ec101-b14c-ffda-053b-8a1ab46bf265@intel.com>
Date:   Wed, 19 Aug 2020 10:52:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c691e3d2-8b16-744c-8918-5be042bd37dc@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-19 10:31, Björn Töpel wrote:
[...]
> 
> But please, try to reproduce with a newer kernel.
>

Also, you are *sure* that you're touching stale data? Have you tried 
running with CONFIG_DEBUG_PAGEALLOC and CONFIG_PAGE_POISONING?


Björn
