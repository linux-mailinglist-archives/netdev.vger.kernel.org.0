Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBCFE1497C4
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 21:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAYUZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 15:25:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:60084 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgAYUZy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 15:25:54 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jan 2020 12:25:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,363,1574150400"; 
   d="scan'208";a="428622215"
Received: from apricoch-mobl2.amr.corp.intel.com (HELO ellie) ([10.252.137.80])
  by fmsmga006.fm.intel.com with ESMTP; 25 Jan 2020 12:25:53 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: Re: [PATCH net v1 2/3] taprio: Fix still allowing changing the flags during runtime
In-Reply-To: <CA+h21hojJYDsb29Xc99hN52J2Vtxd0PbrUWWWGwfBVsKa-RJ=g@mail.gmail.com>
References: <20200125005320.3353761-1-vinicius.gomes@intel.com> <20200125005320.3353761-3-vinicius.gomes@intel.com> <CA+h21hojJYDsb29Xc99hN52J2Vtxd0PbrUWWWGwfBVsKa-RJ=g@mail.gmail.com>
Date:   Sat, 25 Jan 2020 12:25:53 -0800
Message-ID: <87o8ur1dwu.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Vladimir Oltean <olteanv@gmail.com> writes:

>
> You can't quite do this, since it now breaks plain 'tc qdisc add'
> behavior. Can you initialize q->flags to -1 in taprio_init, just below
> q->clockid, and keep the "q->flags != -1" check here? You might also
> need to validate the taprio_flags to be a positive value.
>

Ugh, thanks for pointing this out. Will re-spin the series fixing this.
Another lesson on not sending patches last thing on a friday.


Cheers,
--
Vinicius
