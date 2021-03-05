Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D73232F5FD
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 23:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhCEWio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 17:38:44 -0500
Received: from mga17.intel.com ([192.55.52.151]:64863 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhCEWi0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 17:38:26 -0500
IronPort-SDR: gJUMpZFk7P4tkPlYF4m5pAfWy56d/TIFj/ZI3Ej2yS8ybqr6vq98y6EXTCuxsmds3NFlIqr0ec
 8omB1pKBELfA==
X-IronPort-AV: E=McAfee;i="6000,8403,9914"; a="167640403"
X-IronPort-AV: E=Sophos;i="5.81,226,1610438400"; 
   d="scan'208";a="167640403"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 14:38:26 -0800
IronPort-SDR: +gaITYTI6NYm23BqUUvKOghOCpx+Z4Lkhy/OW54TUB/LxCe3h9FAFg4RctYmKgFk9dMQfq/cvl
 R6Rx6cu+ry9w==
X-IronPort-AV: E=Sophos;i="5.81,226,1610438400"; 
   d="scan'208";a="508215288"
Received: from bfrahm-mobl2.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.212.101.47])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 14:38:25 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuba@kernel.org, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: Re: [PATCH net-next v3 1/8] ethtool: Add support for configuring
 frame preemption
In-Reply-To: <20210303005112.im2zur47553uv2ld@skbuf>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
 <20210122224453.4161729-2-vinicius.gomes@intel.com>
 <20210302142350.4tu3n4gay53cjnig@skbuf>
 <87o8g1nk6g.fsf@vcostago-mobl2.amr.corp.intel.com>
 <20210303005112.im2zur47553uv2ld@skbuf>
Date:   Fri, 05 Mar 2021 14:38:24 -0800
Message-ID: <874khpns4f.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> On Tue, Mar 02, 2021 at 04:40:55PM -0800, Vinicius Costa Gomes wrote:
>> Hi Vladimir,
>>
>> Vladimir Oltean <olteanv@gmail.com> writes:
>>
>> > Hi Vinicius,
>> >
>> > On Fri, Jan 22, 2021 at 02:44:46PM -0800, Vinicius Costa Gomes wrote:
>> >> Frame preemption (described in IEEE 802.3br-2016) defines the concept
>> >> of preemptible and express queues. It allows traffic from express
>> >> queues to "interrupt" traffic from preemptible queues, which are
>> >> "resumed" after the express traffic has finished transmitting.
>> >>
>> >> Frame preemption can only be used when both the local device and the
>> >> link partner support it.
>> >>
>> >> Only parameters for enabling/disabling frame preemption and
>> >> configuring the minimum fragment size are included here. Expressing
>> >> which queues are marked as preemptible is left to mqprio/taprio, as
>> >> having that information there should be easier on the user.
>> >>
>> >> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> >> ---
>> >
>> > I just noticed that the aMACMergeStatusVerify variable is not exposed in
>> > the PREEMPT_GET command, which would allow the user to inspect the state
>> > of the MAC merge sublayer verification state machine. Also, a way in the
>> > PREEMPT_SET command to set the disableVerify variable would be nice.
>> >
>>
>> The hardware I have won't have support for this.
>
> What exactly is not supported, FP verification or the disabling of it?
> Does your hardware at least respond to verification frames?
>

Not supported in the sense that the NIC doesn't expose those variables
into registers.

About the behavior, I am asking our hardware folks.


Cheers,
-- 
Vinicius
