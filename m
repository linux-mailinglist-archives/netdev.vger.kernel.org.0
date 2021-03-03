Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36CC32B3DF
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1840247AbhCCEHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:44 -0500
Received: from mga06.intel.com ([134.134.136.31]:3810 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237276AbhCCAoU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 19:44:20 -0500
IronPort-SDR: rSMsRUJngww1GJXw47+x0abUL/3P/2aZ8If9x1zxU+NIyUbBCaq1eO6BgtUMbV44Phy3ykF92h
 rzrZ6Mg2AaOQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="248455310"
X-IronPort-AV: E=Sophos;i="5.81,218,1610438400"; 
   d="scan'208";a="248455310"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 16:40:57 -0800
IronPort-SDR: mCKJf9u6bb5J4/ayaVlkAwJkxQHexYo3ubZ3HvJrld92vGMJCKEH0Y6QN1w4XYK8fLUMkF+HAm
 KXotOC/lwXUQ==
X-IronPort-AV: E=Sophos;i="5.81,218,1610438400"; 
   d="scan'208";a="367405818"
Received: from jdashevs-mobl.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.209.44.55])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 16:40:57 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuba@kernel.org, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: Re: [PATCH net-next v3 1/8] ethtool: Add support for configuring
 frame preemption
In-Reply-To: <20210302142350.4tu3n4gay53cjnig@skbuf>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
 <20210122224453.4161729-2-vinicius.gomes@intel.com>
 <20210302142350.4tu3n4gay53cjnig@skbuf>
Date:   Tue, 02 Mar 2021 16:40:55 -0800
Message-ID: <87o8g1nk6g.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Vladimir Oltean <olteanv@gmail.com> writes:

> Hi Vinicius,
>
> On Fri, Jan 22, 2021 at 02:44:46PM -0800, Vinicius Costa Gomes wrote:
>> Frame preemption (described in IEEE 802.3br-2016) defines the concept
>> of preemptible and express queues. It allows traffic from express
>> queues to "interrupt" traffic from preemptible queues, which are
>> "resumed" after the express traffic has finished transmitting.
>> 
>> Frame preemption can only be used when both the local device and the
>> link partner support it.
>> 
>> Only parameters for enabling/disabling frame preemption and
>> configuring the minimum fragment size are included here. Expressing
>> which queues are marked as preemptible is left to mqprio/taprio, as
>> having that information there should be easier on the user.
>> 
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> ---
>
> I just noticed that the aMACMergeStatusVerify variable is not exposed in
> the PREEMPT_GET command, which would allow the user to inspect the state
> of the MAC merge sublayer verification state machine. Also, a way in the
> PREEMPT_SET command to set the disableVerify variable would be nice.
>

The hardware I have won't have support for this.

I am going to send the next version of this series soon. Care to send
the support for verifyStatus/disableVerify as follow up series?


Cheers,
-- 
Vinicius
