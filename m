Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC5E3978F9
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 19:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbhFARXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 13:23:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:41397 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231918AbhFARXd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 13:23:33 -0400
IronPort-SDR: BX1/bpMnqcXPx/1YEe/bx+GcCRDMhkQNQ3AUHCeX6ptwu/9Z2khOnb4yKgMs6Sccwf/+ez8HR9
 m4AJHcRNqhUA==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="224868193"
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="224868193"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 10:21:51 -0700
IronPort-SDR: mUUFdZakwdUrX2r0uqMC+u9+ApcxRj1SgJ/AHj9HMjTWXE/+g8MHFyaTFckOt6Zg5X+X8GknYX
 KQhreUlkGVtA==
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="479366127"
Received: from ipiacent-mobl1.amr.corp.intel.com ([10.209.119.149])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 10:21:51 -0700
Date:   Tue, 1 Jun 2021 10:21:50 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     netdev@vger.kernel.org, davem@davemloft.net,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: Re: [PATCH net-next 0/7] mptcp: Miscellaneous cleanup
In-Reply-To: <20210528140719.0e18900f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Message-ID: <2832722e-2697-3563-c16f-422d8c743f8d@linux.intel.com>
References: <20210527235430.183465-1-mathew.j.martineau@linux.intel.com> <20210528140719.0e18900f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021, Jakub Kicinski wrote:

> On Thu, 27 May 2021 16:54:23 -0700 Mat Martineau wrote:
>> Here are some cleanup patches we've collected in the MPTCP tree.
>>
>> Patches 1-4 do some general tidying.
>>
>> Patch 5 adds an explicit check at netlink command parsing time to
>> require a port number when the 'signal' flag is set, to catch the error
>> earlier.
>>
>> Patches 6 & 7 fix up the MPTCP 'enabled' sysctl, enforcing it as a
>> boolean value, and ensuring that the !CONFIG_SYSCTL build still works
>> after the boolean change.
>
> Pulled, thanks!
>
> Would you mind making sure that all maintainers and authors of commits
> pointed to by Fixes tags are always CCed? I assume that those folks
> usually see the patches on mptcp@ ML before they hit netdev but I'd
> rather not have to assume..

No problem at all, I will add get_maintainers.pl to my checklist and add 
Cc: tags to future patch sets.

--
Mat Martineau
Intel
