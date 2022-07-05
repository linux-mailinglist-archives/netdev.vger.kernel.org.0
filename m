Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46FF5567A2E
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 00:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiGEWpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 18:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiGEWpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 18:45:21 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8694013D43
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 15:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657061120; x=1688597120;
  h=from:to:subject:in-reply-to:references:date:message-id:
   mime-version;
  bh=xjmeVmjIx/Y6eYkPpz+rpBanJPJnMJQIG7fRtO1ZKXg=;
  b=hXjX0Hb8HddMW9CZ12nHUXqgiCcRP6U3y1p6ksdteBHLjZFR8Xq7INuF
   tkyXsIAuICAai88rBXFqlaHLm+EmRRVCOf90YXRZznDjzjl29jjSbK8QJ
   aZWPY6Fz/ouNDoOP4tGvoeu7OvRTgGMKzZiUTCmG7gKV7JCqwHyVOC+UT
   gykarZsWuH0Wc7A/4CBkayMsC3ZWzUXBvPSw6YcldFjDydxCsO9Mjaakz
   doVDNRcMDVyBgM+lvwTT44MPwkDnoc0TjlJEuiQcMsSOMAT2WeoBf0bfx
   eGZnSNB+Lo7cBNJSj3FByC8uXdAOj66RZ64Fz/DMh0Fd9K5HNZcvCYnha
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10399"; a="284283870"
X-IronPort-AV: E=Sophos;i="5.92,248,1650956400"; 
   d="scan'208";a="284283870"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 15:45:20 -0700
X-IronPort-AV: E=Sophos;i="5.92,248,1650956400"; 
   d="scan'208";a="597447147"
Received: from vcostago-mobl3.jf.intel.com (HELO vcostago-mobl3) ([10.24.14.91])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 15:45:19 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Ascend~ <1176303504@qq.com>, netdev <netdev@vger.kernel.org>,
        shemminger <shemminger@osdl.org>
Subject: Re: linux manual question consultation
In-Reply-To: <tencent_4802CC87FBE6F4234103D9D5FD8A4811BB0A@qq.com>
References: <tencent_4802CC87FBE6F4234103D9D5FD8A4811BB0A@qq.com>
Date:   Tue, 05 Jul 2022 15:45:17 -0700
Message-ID: <87k08r6uwy.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

"Ascend~" <1176303504@qq.com> writes:

> Hello, I am studying the linux manual, and I don't understand something, I don't know if it is written wrong, can you provide a little help? Questions are as follows:
> URL:https://www.mankier.com/8/tc-taprio
> I see "the txtime offload mode in taprio" gives an example like this:
>
>  # tc qdisc replace dev eth0 parent root handle 100 taprio \                      num_tc 3 \                      map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \                      queues 1@0 1@0 1@0 \                      base-time 1528743495910289987 \                      sched-entry S 01 300000 \                      sched-entry S 02 300000 \                      sched-entry S 04 400000 \                      flags 0x1 \                      txtime-delay 200000 \                      clockid CLOCK_TAI        # tc qdisc replace dev $IFACE parent 100:1 etf skip_skb_check \                      offload delta 200000 clockid CLOCK_TAI
>
> Why is count@offset written as queues 1@0 1@0 1@0 here?

A bit of background, txtime assisted mode is an implementation of the
enhancements for scheduled traffic state machines from IEEE 802.1Q-2018
using the "LaunchTime" (be able to specify a "precise" transmission time
of a packet) feature, using the ETF qdisc.

The current implementation has a limitation in the sense that it is only
able to use a single HW transmission queue, that's why, all traffic is
directed to a single HW queue.

> Is it mapping all traffic traffic types to queue 0?

Yes.

> If it is understood, is it meaningless to set "sched-entry"? If it is
> not understood this way, can you help me explain it? Thank you very
> much!

It's not meaningless, the traffic scheduling is done in terms of
"traffic classes" (the bit mask in 'sched-entry' are in reference to
traffic classes), "only" when sending packets down to the driver/NIC
that we use a single queue.

Note that this limitation is not a "hard" one, it most probably can be
solved with some time and better data structures in the taprio side.

Hope this answers your questions.


Cheers,
-- 
Vinicius
