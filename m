Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D06C2D1D17
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 23:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgLGWQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 17:16:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:8521 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbgLGWQH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 17:16:07 -0500
IronPort-SDR: bDx7ktRKFlht1sf/IjolPcQr8/SpZwMHgAIUC5Zw86uVy4rDxQxltnrEmkUI0zOAIAPAlKhlRv
 xoiUXIelnbSA==
X-IronPort-AV: E=McAfee;i="6000,8403,9828"; a="173935701"
X-IronPort-AV: E=Sophos;i="5.78,400,1599548400"; 
   d="scan'208";a="173935701"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 14:15:26 -0800
IronPort-SDR: vZv6vjibZEslUQzBm1ROhICgQjPzhTAI2Kqbsvm47KWdTZNZ6qk3UL241la+pj5EqO0nCZtOPR
 ipBnRnKstp8w==
X-IronPort-AV: E=Sophos;i="5.78,400,1599548400"; 
   d="scan'208";a="367446111"
Received: from seherahx-mobl1.amr.corp.intel.com (HELO ellie) ([10.209.17.196])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 14:15:26 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v1 6/9] igc: Add support for tuning frame
 preemption via ethtool
In-Reply-To: <20201205100030.2e3c5dd2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
 <20201202045325.3254757-7-vinicius.gomes@intel.com>
 <20201205100030.2e3c5dd2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Date:   Mon, 07 Dec 2020 14:15:25 -0800
Message-ID: <87a6up1cw2.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Tue,  1 Dec 2020 20:53:22 -0800 Vinicius Costa Gomes wrote:
>> The tc subsystem sets which queues are marked as preemptible, it's the
>> role of ethtool to control more hardware specific parameters. These
>> parameters include:
>> 
>>  - enabling the frame preemption hardware: As enabling frame
>>  preemption may have other requirements before it can be enabled, it's
>>  exposed via the ethtool API;
>> 
>>  - mininum fragment size multiplier: expressed in usually in the form
>>  of (1 + N)*64, this number indicates what's the size of the minimum
>>  fragment that can be preempted.
>> 
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>
> WARNING: 'PREEMPTABLE' may be misspelled - perhaps 'PREEMPTIBLE'?

In the datasheet the term PREEMPTABLE is used, and when refering to
register values I chose to be consistent with the datasheet. But as the
margin for confusion is small, I can change to use "preemptible"
everywhere, no problem.


Cheers,
-- 
Vinicius
