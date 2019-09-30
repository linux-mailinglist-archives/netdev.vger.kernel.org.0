Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F03ABC2543
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 18:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732344AbfI3Qgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 12:36:45 -0400
Received: from mga04.intel.com ([192.55.52.120]:44709 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731459AbfI3Qgo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 12:36:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Sep 2019 09:36:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,567,1559545200"; 
   d="scan'208";a="392133090"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.82])
  by fmsmga006.fm.intel.com with ESMTP; 30 Sep 2019 09:36:43 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net] net: sched: cbs: Avoid division by zero when calculating the port rate
In-Reply-To: <20190928233948.15866-1-olteanv@gmail.com>
References: <20190928233948.15866-1-olteanv@gmail.com>
Date:   Mon, 30 Sep 2019 09:37:25 -0700
Message-ID: <875zl991ve.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> As explained in the "net: sched: taprio: Avoid division by zero on
> invalid link speed" commit, it is legal for the ethtool API to return
> zero as a link speed. So guard against it to ensure we don't perform a
> division by zero in kernel.
>
> Fixes: e0a7683d30e9 ("net/sched: cbs: fix port_rate miscalculation")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

