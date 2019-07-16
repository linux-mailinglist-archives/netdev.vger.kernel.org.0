Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 681F26A02F
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 03:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731303AbfGPBRo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 15 Jul 2019 21:17:44 -0400
Received: from mga14.intel.com ([192.55.52.115]:61396 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730690AbfGPBRn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 21:17:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jul 2019 18:17:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,496,1557212400"; 
   d="scan'208";a="366498700"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga006.fm.intel.com with ESMTP; 15 Jul 2019 18:17:43 -0700
Received: from orsmsx114.amr.corp.intel.com (10.22.240.10) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 15 Jul 2019 18:17:42 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.240]) by
 ORSMSX114.amr.corp.intel.com ([169.254.8.237]) with mapi id 14.03.0439.000;
 Mon, 15 Jul 2019 18:17:42 -0700
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
Subject: Re: [PATCH iproute2 net-next v3 3/5] taprio: add support for
 setting txtime_delay.
Thread-Topic: [PATCH iproute2 net-next v3 3/5] taprio: add support for
 setting txtime_delay.
Thread-Index: AQHVO1/oUlZYTWxbwkuNplXD0ES9/abMy2AAgAAbr4A=
Date:   Tue, 16 Jul 2019 01:17:35 +0000
Message-ID: <9CBE2F6E-BA4B-45E7-9368-A5D743E472FD@intel.com>
References: <1563231104-19912-1-git-send-email-vedang.patel@intel.com>
 <1563231104-19912-3-git-send-email-vedang.patel@intel.com>
 <20190715163822.32596123@hermes.lan>
In-Reply-To: <20190715163822.32596123@hermes.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.11.11]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3E55F4230A8248438F8C3CE44467745D@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 15, 2019, at 4:38 PM, Stephen Hemminger <stephen@networkplumber.org> wrote:
> 
> On Mon, 15 Jul 2019 15:51:42 -0700
> Vedang Patel <vedang.patel@intel.com> wrote:
> 
>> +			if (get_s32(&txtime_delay, *argv, 0)) {
> 
> Is txtime_delay of a negative value meaningful?

No, txtime-delay should always be a positive value. I will change this to u32 here.  I will also make the corresponding changes in the kernel and send the updated patch. 

Thanks,
Vedang
