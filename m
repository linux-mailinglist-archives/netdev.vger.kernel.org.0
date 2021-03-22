Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F7A344961
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 16:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhCVPgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 11:36:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:20852 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229590AbhCVPg2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 11:36:28 -0400
IronPort-SDR: Xef8bqsYUlx85NsM4WkUOGTIaWuCUnxKLqQyJrdbvNlJ+jzQGXhgp7XPrdpsjPm9ibNg78PGOJ
 MpYr6p/ZIX3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="187972122"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="187972122"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 08:36:27 -0700
IronPort-SDR: Q/H4/+JVNJok82pFItWldcl3WVNosJ0SalGgqz6jpWL1XnigUMagnhUZ9QrID+lspV8TjLunmw
 hiaI1gy4xMRw==
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="451777329"
Received: from canguven-mobl1.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.255.87.118])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 08:36:27 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support
 for PTP getcrosststamp()
In-Reply-To: <20201118125451.GC23320@hoboy.vegasvil.org>
References: <20201114025704.GA15240@hoboy.vegasvil.org>
 <874klo7pwp.fsf@intel.com> <20201117014926.GA26272@hoboy.vegasvil.org>
 <87d00b5uj7.fsf@intel.com> <20201118125451.GC23320@hoboy.vegasvil.org>
Date:   Mon, 22 Mar 2021 08:36:26 -0700
Message-ID: <87czvrkxol.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Richard Cochran <richardcochran@gmail.com> writes:

> On Tue, Nov 17, 2020 at 05:21:48PM -0800, Vinicius Costa Gomes wrote:
>> Agreed that would be easiest/simplest. But what I have in hand seems to
>> not like it, i.e. I have an earlier series implementing this "one shot" way
>> and it's not reliable over long periods of time or against having the
>> system time adjusted.
>
> Before we go inventing a new API, I think we should first understand
> why the one shot thing fails.

After a long time, a couple of internal misunderstandings, fixing some
typos in the delay adjustment constants and better error handling, this
one shot method is working well.

I will propose a new version, implementing PTP_SYS_OFFSET_PRECISE using
the one shot way.

>
> If there is problem with the system time being adjusted during PTM,
> then that needs solving in any case!

The new series uses shorter cycles, is able to restart the PTM dialogs
if an error is detected (the clock adjustment in the end causes the NIC
to report a PTM timeout), so things are working better.

>
> Thanks,
> Richard


Cheers,
-- 
Vinicius
