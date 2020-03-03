Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1795178288
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbgCCShz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 13:37:55 -0500
Received: from mga03.intel.com ([134.134.136.65]:25181 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728787AbgCCShz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 13:37:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 10:37:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="440697483"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.26])
  by fmsmga006.fm.intel.com with ESMTP; 03 Mar 2020 10:37:49 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vedang Patel <vedang.patel@intel.com>
Subject: Re: [PATCH net 10/16] net: taprio: add missing attribute validation for txtime delay
In-Reply-To: <20200303050526.4088735-11-kuba@kernel.org>
References: <20200303050526.4088735-1-kuba@kernel.org> <20200303050526.4088735-11-kuba@kernel.org>
Date:   Tue, 03 Mar 2020 10:39:51 -0800
Message-ID: <87tv35l1u0.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> Add missing attribute validation for TCA_TAPRIO_ATTR_TXTIME_DELAY
> to the netlink policy.
>
> Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: Jamal Hadi Salim <jhs@mojatatu.com>
> CC: Cong Wang <xiyou.wangcong@gmail.com>
> CC: Jiri Pirko <jiri@resnulli.us>
> CC: Vedang Patel <vedang.patel@intel.com>
> CC: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---

Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

-- 
Vinicius
