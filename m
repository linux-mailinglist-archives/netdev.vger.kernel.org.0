Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C24454639
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 13:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237187AbhKQMRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 07:17:30 -0500
Received: from mga18.intel.com ([134.134.136.126]:45535 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233484AbhKQMR3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 07:17:29 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="220821100"
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="220821100"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 04:14:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="506895679"
Received: from mylly.fi.intel.com (HELO [10.237.72.56]) ([10.237.72.56])
  by orsmga008.jf.intel.com with ESMTP; 17 Nov 2021 04:14:28 -0800
Subject: Re: [PATCH net 0/4] Fix bit timings for m_can_pci (Elkhart Lake)
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Felipe Balbi (Intel)" <balbi@kernel.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
 <e38eb4ca0a03c60c8bbeccbd8126ffc5bf97d490.camel@ew.tq-group.com>
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
Message-ID: <72489ea7-cf81-2446-3620-06a98f53ce54@linux.intel.com>
Date:   Wed, 17 Nov 2021 14:14:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <e38eb4ca0a03c60c8bbeccbd8126ffc5bf97d490.camel@ew.tq-group.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 11/16/21 3:58 PM, Matthias Schiffer wrote:
> I just noticed that m_can_pci is completely broken on 5.15.2, while
> it's working fine on 5.14.y.
> 
Hmm.. so that may explain why I once saw candump received just zeroes on 
v5.15-rc something but earlier kernels were ok. What's odd then next 
time v5.15-rc was ok so went blaming sun spots instead of bisecting.

> I assume something simliar to [1] will be necessary in m_can_pci as
> well, however I'm not really familiar with the driver. There is no
> "mram_base" in m_can_plat_pci, only "base". Is using "base" with
> iowrite32/ioread32 + manual increment the correct solution here?
> 
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=99d173fbe8944861a00ebd1c73817a1260d21e60
> 
If your test case after 5.15 reliably fails are you able to bisect or 
check does the regression originate from the same commit?

Jarkko
