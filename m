Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DA5233B0B
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 00:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730676AbgG3WBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 18:01:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:31701 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730649AbgG3WBO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 18:01:14 -0400
IronPort-SDR: c8JH65XtcPKjsVUAeMWeTpXS7Ro6ufUQUZ461BGDr99wK1gPNW6S7ScAKEJKK+itOiJmNKLC+C
 Fsyc7h6zVdsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="152913065"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="152913065"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 15:01:13 -0700
IronPort-SDR: Nc/PXyov5WPK7M8zLClsubrzO727PFR9PQ/cC5SNlB9Wk49fmQDj5lUc7CKiLJbjcO7TCBYEVN
 FeHZ0wPbF0XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="490819822"
Received: from kyoungil-mobl1.amr.corp.intel.com (HELO ellie) ([10.209.108.110])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jul 2020 15:01:12 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     "Zhang\, Qiang" <Qiang.Zhang@windriver.com>,
        syzbot <syzbot+9f78d5c664a8c33f4cce@syzkaller.appspotmail.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "fweisbec\@gmail.com" <fweisbec@gmail.com>,
        "jhs\@mojatatu.com" <jhs@mojatatu.com>,
        "jiri\@resnulli.us" <jiri@resnulli.us>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo\@kernel.org" <mingo@kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs\@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "xiyou.wangcong\@gmail.com" <xiyou.wangcong@gmail.com>
Subject: Re: =?utf-8?B?5Zue5aSNOg==?= INFO: rcu detected stall in
 tc_modify_qdisc
In-Reply-To: <CACT4Y+ZY-JnawN5Tmeh0+EfbsXgcv11QDiE-Lh2t8Cc3L1OEXg@mail.gmail.com>
References: <0000000000006f179d05ab8e2cf2@google.com> <BYAPR11MB2632784BE3AD9F03C5C95263FF700@BYAPR11MB2632.namprd11.prod.outlook.com> <87tuxqxhgq.fsf@intel.com> <CACT4Y+ZMvaJMiXikYCm-Xym8ddKDY0n-5=kwH7i2Hu-9uJW1kQ@mail.gmail.com> <87pn8cyk2b.fsf@intel.com> <CACT4Y+ZY-JnawN5Tmeh0+EfbsXgcv11QDiE-Lh2t8Cc3L1OEXg@mail.gmail.com>
Date:   Thu, 30 Jul 2020 15:01:11 -0700
Message-ID: <874kpoy860.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitry Vyukov <dvyukov@google.com> writes:

>> >
>> > Also are we talking about CAP_NET_ADMIN in a user ns as well
>> > (effectively nobody)?
>>
>> Just checked, we are talking about CAP_NET_ADMIN in user namespace as
>> well.
>
> OK, so this is not root/admin, this is just any user.

Yeah, will fix this.


Thanks,
-- 
Vinicius
