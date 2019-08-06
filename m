Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBD9783699
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 18:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387527AbfHFQV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 12:21:58 -0400
Received: from mga04.intel.com ([192.55.52.120]:22438 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732531AbfHFQV6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 12:21:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 09:21:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,353,1559545200"; 
   d="scan'208";a="374103242"
Received: from ellie.jf.intel.com (HELO ellie) ([10.24.12.161])
  by fmsmga006.fm.intel.com with ESMTP; 06 Aug 2019 09:21:56 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>, davem@davemloft.net
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [PATCH] net: sched: sch_taprio: fix memleak in error path for sched list parse
In-Reply-To: <20190806100425.4356-1-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
References: <20190806100425.4356-1-ivan.khoronzhuk@linaro.org>
Date:   Tue, 06 Aug 2019 09:21:56 -0700
Message-ID: <871rxyqn6j.fsf@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> writes:

> In case off error, all entries should be freed from the sched list
> before deleting it. For simplicity use rcu way.
>
> Fixes: 5a781ccbd19e46 ("tc: Add support for configuring the taprio scheduler")
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


