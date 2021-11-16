Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4FA4534AB
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237704AbhKPOyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:54:08 -0500
Received: from mga06.intel.com ([134.134.136.31]:32437 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237680AbhKPOxi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 09:53:38 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="294521323"
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="294521323"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 06:50:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="494482103"
Received: from mylly.fi.intel.com (HELO [10.237.72.56]) ([10.237.72.56])
  by orsmga007.jf.intel.com with ESMTP; 16 Nov 2021 06:50:38 -0800
Subject: Re: [PATCH net 1/4] can: m_can: pci: fix incorrect reference clock
 rate
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Felipe Balbi (Intel)" <balbi@kernel.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
 <c9cf3995f45c363e432b3ae8eb1275e54f009fc8.1636967198.git.matthias.schiffer@ew.tq-group.com>
 <48d37d59-e7d1-e151-4201-1dcc151819fe@linux.intel.com>
 <0400022a-0515-db87-03cc-30b83c2aede2@linux.intel.com>
 <20211116071530.k2qaccz5qixgt2jj@pengutronix.de>
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
Message-ID: <86455e0b-fc4e-d862-7c05-d4ad20bb1789@linux.intel.com>
Date:   Tue, 16 Nov 2021 16:50:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211116071530.k2qaccz5qixgt2jj@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/21 9:15 AM, Marc Kleine-Budde wrote:
> On 16.11.2021 09:11:40, Jarkko Nikula wrote:
>>> ip link set can0 type can bitrate 1000000 dbitrate 2000000 fd on
>>
>> I got confirmation the clock to CAN controller is indeed changed from 100
>> MHz to 200 MHz in release HW & firmware.
>>
>> I haven't upgraded the FW in a while on our HW so that perhaps explain
>> why I was seeing expected rate :-)
> 
> Can we query the FW version in the driver and set the clock rate
> accordingly?
> 
Perhaps or check some clock register. I guess for now it can be 
considered fixed clock since I understood rate was changed before 
released to customers. I.e. customers shouldn't have firmware with 
different rates. At least I hope so :-)

Jarkko
