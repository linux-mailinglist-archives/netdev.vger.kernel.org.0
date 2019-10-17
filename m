Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22922DB786
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 21:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391475AbfJQTbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 15:31:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:13356 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387844AbfJQTbh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 15:31:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2019 12:31:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,308,1566889200"; 
   d="scan'208";a="397692900"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.82])
  by fmsmga006.fm.intel.com with ESMTP; 17 Oct 2019 12:31:36 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Murali Karicheri <m-karicheri2@ti.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: taprio testing - Any help?
In-Reply-To: <c4ff605f-d556-2c68-bcfd-65082ec8f73a@ti.com>
References: <a69550fc-b545-b5de-edd9-25d1e3be5f6b@ti.com> <87v9sv3uuf.fsf@linux.intel.com> <7fc6c4fd-56ed-246f-86b7-8435a1e58163@ti.com> <87r23j3rds.fsf@linux.intel.com> <CA+h21hon+QzS7tRytM2duVUvveSRY5BOGXkHtHOdTEwOSBcVAg@mail.gmail.com> <45d3e5ed-7ddf-3d1d-9e4e-f555437b06f9@ti.com> <871rve5229.fsf@linux.intel.com> <f6fb6448-35f0-3071-bda1-7ca5f4e3e11e@ti.com> <87zhi01ldy.fsf@linux.intel.com> <c4ff605f-d556-2c68-bcfd-65082ec8f73a@ti.com>
Date:   Thu, 17 Oct 2019 12:32:39 -0700
Message-ID: <87bluf182w.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Murali Karicheri <m-karicheri2@ti.com> writes:
>
> root@am57xx-evm:~# tc qdisc replace dev eth0 parent root handle 100 taprio \
>  >     num_tc 4 \
>  >     map 2 3 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>  >     queues 1@0 1@0 1@0 1@0 \
>  >     base-time 1564535762845777831 \
>  >     sched-entry S 0xC 15000000 \
>  >     sched-entry S 0x2 15000000 \
>  >     sched-entry S 0x4 15000000 \
>  >     sched-entry S 0x8 15000000 \
>  >     txtime-delay 300000 \
>  >     flags 0x1 \
>  >     clockid CLOCK_TAI
> RTNETLINK answers: Invalid argument
>
> Anything wrong with the command syntax?

I tried this example here, and it got accepted ok. I am using the
current net-next master. The first thing that comes to mind is that
perhaps you backported some old version of some of the patches (so it's
different than what's upstream now).


Cheers,
--
Vinicius
