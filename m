Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF73BC120
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 06:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404725AbfIXEnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 00:43:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:15801 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390852AbfIXEnS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 00:43:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 21:43:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,542,1559545200"; 
   d="scan'208";a="389727154"
Received: from unknown (HELO ellie) ([10.252.195.153])
  by fmsmga006.fm.intel.com with ESMTP; 23 Sep 2019 21:43:17 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net v2] net/sched: cbs: Fix not adding cbs instance to list
In-Reply-To: <CAM_iQpVsNdqQPY5p8ZaN6_soBx+TuTT_vjfYWod7LrSuw3ufeA@mail.gmail.com>
References: <20190924001502.22384-1-vinicius.gomes@intel.com> <CAM_iQpVsNdqQPY5p8ZaN6_soBx+TuTT_vjfYWod7LrSuw3ufeA@mail.gmail.com>
Date:   Mon, 23 Sep 2019 21:43:16 -0700
Message-ID: <87wodyfgnv.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Mon, Sep 23, 2019 at 5:14 PM Vinicius Costa Gomes
> <vinicius.gomes@intel.com> wrote:
>> @@ -417,12 +421,6 @@ static int cbs_init(struct Qdisc *sch, struct nlattr *opt,
>>         if (err)
>>                 return err;
>>
>> -       if (!q->offload) {
>> -               spin_lock(&cbs_list_lock);
>> -               list_add(&q->cbs_list, &cbs_list);
>> -               spin_unlock(&cbs_list_lock);
>> -       }
>> -
>>         return 0;
>
> These two return's now can be folded into one, right?

Yeah, good catch. Will fix.


Cheers,
--
Vinicius
