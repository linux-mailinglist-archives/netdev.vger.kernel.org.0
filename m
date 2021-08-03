Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DBC3DF45C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 20:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238709AbhHCSLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 14:11:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:4762 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237196AbhHCSLe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 14:11:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="213783412"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="213783412"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 11:11:17 -0700
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="585071020"
Received: from takbas-mobl.amr.corp.intel.com ([10.212.253.160])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 11:11:16 -0700
Date:   Tue, 3 Aug 2021 11:11:16 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     netdev@vger.kernel.org, Geliang Tang <geliangtang@gmail.com>,
        davem@davemloft.net, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: Re: [PATCH net] mptcp: drop unused rcu member in
 mptcp_pm_addr_entry
In-Reply-To: <20210803082152.259d9c2a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <7ef8acba-2ecc-37ec-165d-ba32b3f3fde@linux.intel.com>
References: <20210802231914.54709-1-mathew.j.martineau@linux.intel.com> <20210803082152.259d9c2a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Aug 2021, Jakub Kicinski wrote:

> On Mon,  2 Aug 2021 16:19:14 -0700 Mat Martineau wrote:
>> From: Geliang Tang <geliangtang@gmail.com>
>>
>> kfree_rcu() had been removed from pm_netlink.c, so this rcu field in
>> struct mptcp_pm_addr_entry became useless. Let's drop it.
>>
>> Fixes: 1729cf186d8a ("mptcp: create the listening socket for new port")
>> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
>> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
>
> This just removes a superfluous member, right? So could as well be
> applied to net-next?
>

Hi Jakub -

Yes, it's just a superfluous member.

It seemed like a -net candidate, as it was addressing a mistake in a 
previous commit (rather than a feature or refactor) and does affect memory 
usage - and I was trying to be mindful of the stable tree process. But the 
patch will apply cleanly to either net or net-next, so you could apply to 
net-next if the fix is not significant enough.

I'll tune my net-vs-net-next threshold based on the tree I see it applied 
to :)

Thanks!

--
Mat Martineau
Intel
