Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C353851F23
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 01:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbfFXXeg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 24 Jun 2019 19:34:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:29291 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbfFXXef (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 19:34:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jun 2019 16:34:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,413,1557212400"; 
   d="scan'208";a="169594252"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Jun 2019 16:34:34 -0700
Received: from orsmsx124.amr.corp.intel.com (10.22.240.120) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 24 Jun 2019 16:34:34 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.248]) by
 ORSMSX124.amr.corp.intel.com ([169.254.2.150]) with mapi id 14.03.0439.000;
 Mon, 24 Jun 2019 16:34:34 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Jiri Pirko" <jiri@resnulli.us>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "l@dorileo.org" <l@dorileo.org>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>
Subject: Re: [PATCH net-next v5 2/7] etf: Add skip_sock_check
Thread-Topic: [PATCH net-next v5 2/7] etf: Add skip_sock_check
Thread-Index: AQHVKFbNDyd+bM++9UqRiSWGp4bsQ6arz3qAgAAf8YA=
Date:   Mon, 24 Jun 2019 23:34:33 +0000
Message-ID: <CAF959A4-553C-441D-A8E7-53F325D3B272@intel.com>
References: <1561138108-12943-1-git-send-email-vedang.patel@intel.com>
 <1561138108-12943-3-git-send-email-vedang.patel@intel.com>
 <20190624144013.3168dde2@cakuba.netronome.com>
In-Reply-To: <20190624144013.3168dde2@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.11.19]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6004587AB57A7E46BB369711B393B088@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Jun 24, 2019, at 2:40 PM, Jakub Kicinski <jakub.kicinski@netronome.com> wrote:
> 
> On Fri, 21 Jun 2019 10:28:23 -0700, Vedang Patel wrote:
>> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
>> index 8b2f993cbb77..409d1616472d 100644
>> --- a/include/uapi/linux/pkt_sched.h
>> +++ b/include/uapi/linux/pkt_sched.h
>> @@ -990,6 +990,7 @@ struct tc_etf_qopt {
>> 	__u32 flags;
>> #define TC_ETF_DEADLINE_MODE_ON	BIT(0)
>> #define TC_ETF_OFFLOAD_ON	BIT(1)
>> +#define TC_ETF_SKIP_SOCK_CHECK	BIT(2)
>> };
>> 
>> enum {
> 
> I think build bot complained about the code not building on 32bit.
> When you respin could you include a patch to remove the uses of BIT()
> in UAPI?  See: https://www.spinics.net/lists/netdev/msg579344.html

Thanks for the info Jakub. Yeah I will include it in the next version.

-Vedang
