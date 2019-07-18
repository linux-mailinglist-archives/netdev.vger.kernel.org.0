Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA7B6D550
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 21:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404231AbfGRTqX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jul 2019 15:46:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:9311 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403805AbfGRTqU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 15:46:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 12:46:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,279,1559545200"; 
   d="scan'208";a="179354434"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by orsmga002.jf.intel.com with ESMTP; 18 Jul 2019 12:46:19 -0700
Received: from orsmsx155.amr.corp.intel.com (10.22.240.21) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 18 Jul 2019 12:46:19 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.240]) by
 ORSMSX155.amr.corp.intel.com ([169.254.7.34]) with mapi id 14.03.0439.000;
 Thu, 18 Jul 2019 12:46:19 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     David Ahern <dsahern@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Dorileo, Leandro" <leandro.maciel.dorileo@intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>
Subject: Re: [PATCH iproute2 net-next v4 5/6] tc: etf: Add documentation for
 skip-skb-check.
Thread-Topic: [PATCH iproute2 net-next v4 5/6] tc: etf: Add documentation
 for skip-skb-check.
Thread-Index: AQHVPBAl9DzL9SOaAEauhmueMNwg4abRG/CAgAAkJgA=
Date:   Thu, 18 Jul 2019 19:46:15 +0000
Message-ID: <9198D117-BE06-468A-A908-24A162EDED0A@intel.com>
References: <1563306789-2908-1-git-send-email-vedang.patel@intel.com>
 <1563306789-2908-5-git-send-email-vedang.patel@intel.com>
 <32e4deac-aaab-c437-1b76-529c16731877@gmail.com>
In-Reply-To: <32e4deac-aaab-c437-1b76-529c16731877@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.208]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BAC54C2689563A498324377805648A19@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 18, 2019, at 10:36 AM, David Ahern <dsahern@gmail.com> wrote:
> 
> On 7/16/19 1:53 PM, Vedang Patel wrote:
>> Document the newly added option (skip-skb-check) on the etf man-page.
>> 
>> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
>> ---
>> man/man8/tc-etf.8 | 10 ++++++++++
>> 1 file changed, 10 insertions(+)
>> 
>> diff --git a/man/man8/tc-etf.8 b/man/man8/tc-etf.8
>> index 30a12de7d2c7..2e01a591dbaa 100644
>> --- a/man/man8/tc-etf.8
>> +++ b/man/man8/tc-etf.8
>> @@ -106,6 +106,16 @@ referred to as "Launch Time" or "Time-Based Scheduling" by the
>> documentation of network interface controllers.
>> The default is for this option to be disabled.
>> 
>> +.TP
>> +skip_skb_check
> 
> patch 1 adds skip_sock_check.
> 
Yes. I will fix this typo in the next version.

Thanks,
Vedang
>> +.br
>> +.BR etf(8)
>> +currently drops any packet which does not have a socket associated with it or
>> +if the socket does not have SO_TXTIME socket option set. But, this will not
>> +work if the launchtime is set by another entity inside the kernel (e.g. some
>> +other Qdisc). Setting the skip_skb_check will skip checking for a socket
>> +associated with the packet.
>> +
>> .SH EXAMPLES
>> 
>> ETF is used to enforce a Quality of Service. It controls when each

