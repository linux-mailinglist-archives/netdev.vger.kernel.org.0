Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D051DA07C5
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 18:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfH1Qpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 12:45:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:18621 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbfH1Qpy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 12:45:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 09:45:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,441,1559545200"; 
   d="scan'208";a="381342017"
Received: from unknown (HELO ellie) ([10.24.12.211])
  by fmsmga006.fm.intel.com with ESMTP; 28 Aug 2019 09:45:54 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vedang.patel@intel.com, leandro.maciel.dorileo@intel.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net 3/3] net/sched: cbs: Set default link speed to 10 Mbps in cbs_set_port_rate
In-Reply-To: <20190828144829.32570-4-olteanv@gmail.com>
References: <20190828144829.32570-1-olteanv@gmail.com> <20190828144829.32570-4-olteanv@gmail.com>
Date:   Wed, 28 Aug 2019 09:45:53 -0700
Message-ID: <87zhjtp7b2.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> The discussion to be made is absolutely the same as in the case of
> previous patch ("taprio: Set default link speed to 10 Mbps in
> taprio_set_picos_per_byte"). Nothing is lost when setting a default.
>
> Cc: Leandro Dorileo <leandro.maciel.dorileo@intel.com>
> Fixes: e0a7683d30e9 ("net/sched: cbs: fix port_rate miscalculation")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---

Hm, taking another look at cbs it has a similar problem than the problem
your patch 1/3 solves for taprio, I will propose a patch in a few
moments.

For this one:

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


Cheers,
--
Vinicius
