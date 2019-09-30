Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15A29C26D5
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731448AbfI3UlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:41:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:60535 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730565AbfI3UlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 16:41:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Sep 2019 10:18:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,568,1559545200"; 
   d="scan'208";a="392149442"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.82])
  by fmsmga006.fm.intel.com with ESMTP; 30 Sep 2019 10:18:51 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v2 net] net: sched: taprio: Fix potential integer overflow in taprio_set_picos_per_byte
In-Reply-To: <20190928230139.4027-1-olteanv@gmail.com>
References: <20190928230139.4027-1-olteanv@gmail.com>
Date:   Mon, 30 Sep 2019 10:19:32 -0700
Message-ID: <87wodp7lcr.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> The speed divisor is used in a context expecting an s64, but it is
> evaluated using 32-bit arithmetic.
>
> To avoid that happening, instead of multiplying by 1,000,000 in the
> first place, simplify the fraction and do a standard 32 bit division
> instead.
>
> Fixes: f04b514c0ce2 ("taprio: Set default link speed to 10 Mbps in taprio_set_picos_per_byte")
> Reported-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
