Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39BA4707FD
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 19:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245002AbhLJSEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 13:04:13 -0500
Received: from mga12.intel.com ([192.55.52.136]:54156 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235392AbhLJSEM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 13:04:12 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="218425838"
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="218425838"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 10:00:36 -0800
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="544054225"
Received: from dmales-mobl.amr.corp.intel.com ([10.251.4.94])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 10:00:36 -0800
Date:   Fri, 10 Dec 2021 10:00:35 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>, cgel.zte@gmail.com,
        davem@davemloft.net, shuah@kernel.org, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ye Guojin <ye.guojin@zte.com.cn>,
        ZealRobot <zealci@zte.com.cn>
Subject: Re: [PATCH] selftests: mptcp: remove duplicate include in
 mptcp_inq.c
In-Reply-To: <20211210075701.06bfced2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <7041cc47-3728-c033-bc97-49d86a1938b9@linux.intel.com>
References: <20211210071424.425773-1-ye.guojin@zte.com.cn> <ab84ca1f-0f43-d50c-c272-81f64ee31ce8@tessares.net> <20211210065437.27c8fe23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20211210065644.192f5159@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b6c19c9c-de6c-225c-5899-789dfd8e7ae8@tessares.net> <20211210075701.06bfced2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Dec 2021, Jakub Kicinski wrote:

> On Fri, 10 Dec 2021 16:36:06 +0100 Matthieu Baerts wrote:
>>> Actually, I take that back, let's hear from Mat, he may want to take
>>> the patch via his tree.
>>
>> We "rebase" our tree on top of net-next every night. I think for such
>> small patches with no behaviour change and sent directly to netdev ML,
>> it is probably best to apply them directly. I can check with Mat if it
>> is an issue if you prefer.
>
> Please do, I'm happy to apply the patch but Mat usually prefers to take
> things thru MPTCP tree.
>

Jakub -

It is ok with me if you apply this now, for the reasons Matthieu cited.

The usual division of labor between Matthieu and I as MPTCP co-maintainers 
usually has me upstreaming the patches to netdev, but I do trust 
Matthieu's judgement on sending out Reviewed-by tags and advising direct 
appliction to the netdev trees! Also, much like you & David, having offset 
timezones can be helpful.

Also appreciate your awareness of the normal patch flow for MPTCP, and 
that you're checking that we're all on the same page.


>> I would have applied it in our MPTCP tree if we were sending PR, not to
>> bother you for such patches but I guess it is best not to have us
>> sending this patch a second time later :)
>>
>> BTW, if you prefer us sending PR over batches of patches, please tell us!
>
> Small preference for patches. It's good to have the code on the ML for
> everyone to look at and mixed PR + patches are a tiny bit more clicking
> for me.
>

Good to know.


Thanks!

--
Mat Martineau
Intel
