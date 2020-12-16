Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC50E2DC6DA
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732921AbgLPTCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:02:55 -0500
Received: from mga12.intel.com ([192.55.52.136]:52441 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732918AbgLPTCy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 14:02:54 -0500
IronPort-SDR: u2AA02OnByNsB+eDeFthcatTrY+CG/s1XcTe48QElnLcO+MyfnPIx1l8Lxrj7Em5vmhBHbKa+k
 pKA1TxAeyMWA==
X-IronPort-AV: E=McAfee;i="6000,8403,9837"; a="154350452"
X-IronPort-AV: E=Sophos;i="5.78,425,1599548400"; 
   d="scan'208";a="154350452"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 11:01:57 -0800
IronPort-SDR: 7cXZykLQdKlfZHtCk6YeL6cg84S65u3zGdZRDdPNvLXun3FthsOxdWEVRgEhjQw24OhE1O53B6
 i6oQRu8lCv4w==
X-IronPort-AV: E=Sophos;i="5.78,425,1599548400"; 
   d="scan'208";a="391879249"
Received: from jmsulli1-mobl.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.212.96.230])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 11:01:56 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Davide Caratti <dcaratti@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] net/sched: sch_taprio: reset child qdiscs before
 freeing them
In-Reply-To: <63b6d79b0e830ebb0283e020db4df3cdfdfb2b94.1608142843.git.dcaratti@redhat.com>
References: <63b6d79b0e830ebb0283e020db4df3cdfdfb2b94.1608142843.git.dcaratti@redhat.com>
Date:   Wed, 16 Dec 2020 11:01:54 -0800
Message-ID: <87o8itzial.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Davide Caratti <dcaratti@redhat.com> writes:

> syzkaller shows that packets can still be dequeued while taprio_destroy()
> is running. Let sch_taprio use the reset() function to cancel the advance
> timer and drop all skbs from the child qdiscs.
>
> Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
> Link: https://syzkaller.appspot.com/bug?id=f362872379bf8f0017fb667c1ab158f2d1e764ae
> Reported-by: syzbot+8971da381fb5a31f542d@syzkaller.appspotmail.com
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


Cheers,
-- 
Vinicius
