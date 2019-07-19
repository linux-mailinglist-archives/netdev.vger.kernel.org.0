Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4F26EC23
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 23:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388233AbfGSVji convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 19 Jul 2019 17:39:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:3676 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727528AbfGSVji (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 17:39:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 14:39:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,283,1559545200"; 
   d="scan'208";a="162525502"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by orsmga008.jf.intel.com with ESMTP; 19 Jul 2019 14:39:37 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.240]) by
 ORSMSX102.amr.corp.intel.com ([169.254.3.142]) with mapi id 14.03.0439.000;
 Fri, 19 Jul 2019 14:39:37 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Dorileo, Leandro" <leandro.maciel.dorileo@intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>
Subject: Re: [PATCH iproute2 net-next v5 1/5] etf: Add skip_sock_check
Thread-Topic: [PATCH iproute2 net-next v5 1/5] etf: Add skip_sock_check
Thread-Index: AQHVPaLRkfOOtRkfy06B8FV5Ws53c6bR2zCAgAETw4A=
Date:   Fri, 19 Jul 2019 21:39:33 +0000
Message-ID: <C21E09F7-D035-46A5-A924-95AF9FB07D97@intel.com>
References: <1563479743-8371-1-git-send-email-vedang.patel@intel.com>
 <20190718221227.46631096@hermes.lan>
In-Reply-To: <20190718221227.46631096@hermes.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.183]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E7D35B2EEC5FEC4D868F6F5CFB5264B7@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 18, 2019, at 10:12 PM, Stephen Hemminger <stephen@networkplumber.org> wrote:
> 
> On Thu, 18 Jul 2019 12:55:39 -0700
> Vedang Patel <vedang.patel@intel.com> wrote:
> 
>> -	print_string(PRINT_ANY, "deadline_mode", "deadline_mode %s",
>> +	print_string(PRINT_ANY, "deadline_mode", "deadline_mode %s ",
>> 				(qopt->flags & TC_ETF_DEADLINE_MODE_ON) ? "on" : "off");
>> +	print_string(PRINT_ANY, "skip_sock_check", "skip_sock_check %s",
>> +				(qopt->flags & TC_ETF_SKIP_SOCK_CHECK) ? "on" : "off");
> 
> These should really be boolean options in JSON, not string values.
Ok. Sending out a patch to fix this.

Thanks,
Vedang
