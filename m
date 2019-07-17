Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 774826C06F
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 19:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfGQRcQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Jul 2019 13:32:16 -0400
Received: from mga07.intel.com ([134.134.136.100]:41732 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbfGQRcP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 13:32:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 10:32:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,275,1559545200"; 
   d="scan'208";a="178968431"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga002.jf.intel.com with ESMTP; 17 Jul 2019 10:32:15 -0700
Received: from orsmsx159.amr.corp.intel.com (10.22.240.24) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 17 Jul 2019 10:32:15 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.240]) by
 ORSMSX159.amr.corp.intel.com ([169.254.11.26]) with mapi id 14.03.0439.000;
 Wed, 17 Jul 2019 10:32:14 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "l@dorileo.org" <l@dorileo.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Murali Karicheri" <m-karicheri2@ti.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH net-next v1] fix: taprio: Change type of txtime-delay
 parameter to u32
Thread-Topic: [PATCH net-next v1] fix: taprio: Change type of txtime-delay
 parameter to u32
Thread-Index: AQHVPBAH2Iab5gicXE2VxFW40gJB96bONWkAgAFS4wA=
Date:   Wed, 17 Jul 2019 17:32:10 +0000
Message-ID: <D18998A5-4B08-4F27-897F-A34B7C15684F@intel.com>
References: <1563306738-2779-1-git-send-email-vedang.patel@intel.com>
 <20190716.141904.308520366333461345.davem@davemloft.net>
In-Reply-To: <20190716.141904.308520366333461345.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.140]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25F096A2937A7A4CA810742E06D34141@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 16, 2019, at 2:19 PM, David Miller <davem@davemloft.net> wrote:
> 
> From: Vedang Patel <vedang.patel@intel.com>
> Date: Tue, 16 Jul 2019 12:52:18 -0700
> 
>> During the review of the iproute2 patches for txtime-assist mode, it was
>> pointed out that it does not make sense for the txtime-delay parameter to
>> be negative. So, change the type of the parameter from s32 to u32.
>> 
>> Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
>> Reported-by: Stephen Hemminger <stephen@networkplumber.org>
>> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
> 
> You should have targetted this at 'net' as that's the only tree open
> right now.
> 
> I'll apply this.

Sorry about that.

I will keep this in mind from next time. 

Thanks,
Vedang
