Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD97638D1FB
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 01:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhEUXcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 19:32:02 -0400
Received: from mga06.intel.com ([134.134.136.31]:65065 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229937AbhEUXcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 19:32:00 -0400
IronPort-SDR: vLzG0HMdXG6TDFQmPhSrp859cXZdTiJPSJlylt+HUVqqHyRhDx2jy0Y5g9LRvCORBAHtj0cQnm
 g3rTR8CRtLHg==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="262812403"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="262812403"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 16:30:34 -0700
IronPort-SDR: cxf65ZXCcPYgd4fHNuoiErHRI9kSd4BkL5LCczOTzfOtWoFXphbD5KaLpvEOKUxGtvThR9DZk/
 VU6McGHfTsLg==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="462674341"
Received: from mooremel-mobl.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.209.84.48])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 16:30:33 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v1] MAINTAINERS: Add entries for CBS, ETF and
 taprio qdiscs
In-Reply-To: <CAM_iQpVf+9DQktJKJxa49z6m8HZAzvRH9Y9Lk6whcgbXL_24KA@mail.gmail.com>
References: <20210521223337.1873836-1-vinicius.gomes@intel.com>
 <CAM_iQpVf+9DQktJKJxa49z6m8HZAzvRH9Y9Lk6whcgbXL_24KA@mail.gmail.com>
Date:   Fri, 21 May 2021 16:30:30 -0700
Message-ID: <87tumvzmuh.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Fri, May 21, 2021 at 3:34 PM Vinicius Costa Gomes
> <vinicius.gomes@intel.com> wrote:
>>
>> Add Vinicius Costa Gomes as maintainer for these qdiscs.
>>
>> These qdiscs are all TSN (Time Sensitive Networking) related.
>
> I do not mind adding a new section for specific qdisc's, but
> can you merge all of the 3 into 1 as you maintain all of them?
>
> Something like:
>
> CBS/ETF/TAPRIO QDISC
> M: ...
> F: ...
> F: ...
> F: ...
> ...

Sure. Sounds good.


Cheers,
-- 
Vinicius
