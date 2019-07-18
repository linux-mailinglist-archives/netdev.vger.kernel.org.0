Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD166D547
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 21:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404179AbfGRTp5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jul 2019 15:45:57 -0400
Received: from mga18.intel.com ([134.134.136.126]:40300 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404208AbfGRTp4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 15:45:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 12:45:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,279,1559545200"; 
   d="scan'208";a="176107529"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Jul 2019 12:45:55 -0700
Received: from orsmsx161.amr.corp.intel.com (10.22.240.84) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 18 Jul 2019 12:45:55 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.240]) by
 ORSMSX161.amr.corp.intel.com ([169.254.4.246]) with mapi id 14.03.0439.000;
 Thu, 18 Jul 2019 12:45:55 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     David Ahern <dsahern@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Dorileo, Leandro" <leandro.maciel.dorileo@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH iproute2 net-next v4 1/6] Update kernel headers
Thread-Topic: [PATCH iproute2 net-next v4 1/6] Update kernel headers
Thread-Index: AQHVPBAl/v6gN2xMYUaZ5DN8ENyYoKbRGsGAgAAlKgA=
Date:   Thu, 18 Jul 2019 19:45:50 +0000
Message-ID: <0D8498F1-430A-4C4C-9E9D-1F2A205BB672@intel.com>
References: <1563306789-2908-1-git-send-email-vedang.patel@intel.com>
 <f1a94a8c-ca50-f9db-795f-b5077a2d308e@gmail.com>
In-Reply-To: <f1a94a8c-ca50-f9db-795f-b5077a2d308e@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.208]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8345B6B9B559C04F8571ED319438143E@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 18, 2019, at 10:32 AM, David Ahern <dsahern@gmail.com> wrote:
> 
> On 7/16/19 1:53 PM, Vedang Patel wrote:
>> The type for txtime-delay parameter will change from s32 to u32. So,
>> make the corresponding change in the ABI file as well.
>> 
>> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
>> ---
>> include/uapi/linux/pkt_sched.h | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
>> index 1f623252abe8..18f185299f47 100644
>> --- a/include/uapi/linux/pkt_sched.h
>> +++ b/include/uapi/linux/pkt_sched.h
>> @@ -1174,7 +1174,7 @@ enum {
>> 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME, /* s64 */
>> 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
>> 	TCA_TAPRIO_ATTR_FLAGS, /* u32 */
>> -	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* s32 */
>> +	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* u32 */
>> 	__TCA_TAPRIO_ATTR_MAX,
>> };
>> 
>> 
> 
> kernel uapi headers are synced from the kernel. You will need to make
> this change to the kernel header and it will make its way to iproute2
Okay, I will drop this patch in the next version.

Thanks,
Vedang
