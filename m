Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DB23090DA
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 01:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhA3AOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 19:14:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:37441 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229828AbhA3ANq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 19:13:46 -0500
IronPort-SDR: S/f1sTFw+/TZMEWtVO3e0YWyda1GClztUyaDH/CVh9rqFWOVIbxM60SLLaB7Wem/tKgF4QsNTF
 LUlTm/hQl4lg==
X-IronPort-AV: E=McAfee;i="6000,8403,9879"; a="199349808"
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="199349808"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 16:12:05 -0800
IronPort-SDR: /XXIEtMSyiE26QmpZQt8h+eJapzva8LNhC5HhS9PuOmgm/Zpqg73J97YqcVC4RQplgw84YrZna
 ay+B30icH5JQ==
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="365539983"
Received: from ndatiri-mobl.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.212.145.249])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 16:12:04 -0800
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
Subject: Re: [PATCH net-next v3 0/8] ethtool: Add support for frame preemption
In-Reply-To: <20210129233729.bjckcxcx45hueb2z@skbuf>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
 <20210129233729.bjckcxcx45hueb2z@skbuf>
Date:   Fri, 29 Jan 2021 16:11:50 -0800
Message-ID: <87tuqzqo55.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Fri, Jan 22, 2021 at 02:44:45PM -0800, Vinicius Costa Gomes wrote:
>> This is still an RFC because two main reasons, I want to confirm that
>> this approach (per-queue settings via qdiscs, device settings via
>> ethtool) looks good, even though there aren't much more options left ;-)
>
> I don't want to bother you too much, but a consequence of putting the
> per-priority settings into tc-taprio is that those will spill over into
> other qdiscs too that have nothing to do with TSN, for whomever will
> need frame preemption without time-aware scheduling (and there are
> reasons to want that).
> So could we see in the next version the frame preemption bits added to
> tc-mqprio as well? I just want to make sure that we run this by the tc
> maintainers and that the idea gets their informed consent before we end
> up in a position where frame preemption with time-aware scheduling is
> done in one way, but frame preemption without time-aware scheduling is
> done another way.
> You should not need to change anything related to TC_SETUP_PREEMPT in
> the igc driver, so it should be just code addition.

Good suggestion. Will do.


Cheers,
-- 
Vinicius
