Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1778414D02A
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 19:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbgA2SME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 13:12:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:37166 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgA2SME (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 13:12:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 10:12:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,378,1574150400"; 
   d="scan'208";a="429757900"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.26])
  by fmsmga006.fm.intel.com with ESMTP; 29 Jan 2020 10:12:03 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: Re: [PATCH net v2 2/3] taprio: Allow users not to specify "flags" when changing schedules
In-Reply-To: <20200129.111245.1611718557356636170.davem@davemloft.net>
References: <20200128235227.3942256-1-vinicius.gomes@intel.com> <20200128235227.3942256-3-vinicius.gomes@intel.com> <20200129.111245.1611718557356636170.davem@davemloft.net>
Date:   Wed, 29 Jan 2020 10:13:22 -0800
Message-ID: <87eevicerh.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Date: Tue, 28 Jan 2020 15:52:26 -0800
>
>> When any offload mode is enabled, users had to specify the
>> "flags" parameter when adding a new "admin" schedule.
>> 
>> This fix allows that parameter to be omitted when adding a new
>> schedule.
>> 
>> This will make that we have one source of truth for 'flags'.
>> 
>> Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> This will visibly change behavior for a feature in a released
> kernel (v5.3 and later) and it means that newer tools will do
> things that don't work in older kernels.
>
> I think your opportunity to adjust these semantics, has therefore,
> long passed.

Understood. Another lesson learned.

I'll need to send another version then. This semantic change have
creeped up to the "rcu stall" fix.


Cheers,
--
Vinicius
