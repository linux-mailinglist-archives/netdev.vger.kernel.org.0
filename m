Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4EB308EF2
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 22:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbhA2VCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 16:02:52 -0500
Received: from mga17.intel.com ([192.55.52.151]:51137 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233058AbhA2VCt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 16:02:49 -0500
IronPort-SDR: 8KblLcceztZkYaPwKrtUs3MHaRKVSg7Zpa4Bdu31wt16ydqP5vFqWUwYsJ4sydo0/mAOXH81Za
 cKGH237Us7IA==
X-IronPort-AV: E=McAfee;i="6000,8403,9879"; a="160254863"
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="160254863"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 13:02:07 -0800
IronPort-SDR: WRXbI5a0a2lSURK7Xr+Kb73RU8Knx2kYK8+5YKwRrDalQfM+N1tz56QvtjlLDZxPBLbsnQF1Zr
 wiJYNCMM+VoA==
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="389456096"
Received: from ndatiri-mobl.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.212.145.249])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 13:02:06 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v3 5/8] igc: Avoid TX Hangs because long cycles
In-Reply-To: <20210126000228.gpyh3rrp662wysit@skbuf>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
 <20210122224453.4161729-6-vinicius.gomes@intel.com>
 <20210126000228.gpyh3rrp662wysit@skbuf>
Date:   Fri, 29 Jan 2021 13:01:53 -0800
Message-ID: <877dnvtq2m.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Fri, Jan 22, 2021 at 02:44:50PM -0800, Vinicius Costa Gomes wrote:
>> Avoid possible TX Hangs caused by using long Qbv cycles. In some
>> cases, using long cycles (more than 1 second) can cause transmissions
>> to be blocked for that time. As the TX Hang timeout is close to 1
>> second, we may need to reduce the cycle time to something more
>> reasonable: the value chosen is 1ms.
>> 
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> ---
>
> Don't you want this patch to go to 'net' and be backported?

Will propose this patch to 'net'. Thanks.


Cheers,
-- 
Vinicius
