Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 356774BF10
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729932AbfFSQyj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Jun 2019 12:54:39 -0400
Received: from mga18.intel.com ([134.134.136.126]:24969 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfFSQyj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 12:54:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 09:54:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,392,1557212400"; 
   d="scan'208";a="181673235"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by fmsmga001.fm.intel.com with ESMTP; 19 Jun 2019 09:54:37 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.248]) by
 ORSMSX106.amr.corp.intel.com ([169.254.1.191]) with mapi id 14.03.0439.000;
 Wed, 19 Jun 2019 09:54:37 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "l@dorileo.org" <l@dorileo.org>
Subject: Re: [PATCH net-next v3 4/6] taprio: Add support for txtime-assist
 mode.
Thread-Topic: [PATCH net-next v3 4/6] taprio: Add support for txtime-assist
 mode.
Thread-Index: AQHVJUNFjRzMm4OAx0i6VLvdOGHz6qag8fWAgAK4KwA=
Date:   Wed, 19 Jun 2019 16:54:32 +0000
Message-ID: <0EE3B2CB-5EEA-47B5-B90D-A74177A04570@intel.com>
References: <1560799870-18956-1-git-send-email-vedang.patel@intel.com>
 <1560799870-18956-5-git-send-email-vedang.patel@intel.com>
 <20190617.162245.717911211395007022.davem@davemloft.net>
In-Reply-To: <20190617.162245.717911211395007022.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.201]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12346ECBE3DED8449C0F8A8F5C8EA8BF@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the input David. 


> On Jun 17, 2019, at 4:22 PM, David Miller <davem@davemloft.net> wrote:
> 
> From: Vedang Patel <vedang.patel@intel.com>
> Date: Mon, 17 Jun 2019 12:31:08 -0700
> 
>> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
>> index a41d7d4434ee..ab6080013666 100644
>> --- a/net/sched/sch_taprio.c
>> +++ b/net/sched/sch_taprio.c
> ...
>> +/* Get how much time has been already elapsed in the current cycle. */
>> +static inline s32 get_cycle_time_elapsed(struct sched_gate_list *sched, ktime_t time)
>> +{
> 
> Please do not use the inline directive in foo.c files, let the compiler decide.
> 
Okay, I will remove inline directive from all C files and send a new version.

-Vedang
> ...
>> +static inline int length_to_duration(struct taprio_sched *q, int len)
>> +{
>> +	return (len * atomic64_read(&q->picos_per_byte)) / 1000;
>> +}
> 
> Likewise.
> 
> ...
>> +static inline ktime_t get_cycle_start(struct sched_gate_list *sched,
>> +				      ktime_t time)
>> +{
> 
> Likewise.

