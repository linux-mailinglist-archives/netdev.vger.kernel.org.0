Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D6535200B
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbhDATlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:41:16 -0400
Received: from mga04.intel.com ([192.55.52.120]:61652 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233786AbhDATlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 15:41:15 -0400
IronPort-SDR: 6yTlt+6KfYGA2nhXp3tI1+vWNythoKC1jwBGuXOiDXOb7ksfAEUmUwbt+EWl9PIb6GDMH+Hk6f
 fUiqrdR2VqiA==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="190088112"
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="190088112"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 12:41:14 -0700
IronPort-SDR: Bo0ikWOsGrvVdiPkUeHU8bpG83V28+DG+2wPCYQ6dZv5nhUtM9eWM2ngvf0YDEnXLemflGbORE
 0JCer0ulJ4/Q==
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="419338437"
Received: from jmurunue-mobl2.amr.corp.intel.com ([10.251.11.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 12:41:12 -0700
Date:   Thu, 1 Apr 2021 12:41:10 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net 2/2] mptcp: revert "mptcp: provide subflow aware
 release function"
In-Reply-To: <ad4571485ca31026738cf57d67d68d681997a012.1617295578.git.pabeni@redhat.com>
Message-ID: <e5ceaf-ce5c-6979-fb7-9283a1fa266c@linux.intel.com>
References: <cover.1617295578.git.pabeni@redhat.com> <ad4571485ca31026738cf57d67d68d681997a012.1617295578.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Apr 2021, Paolo Abeni wrote:

> This change reverts commit ad98dd37051e ("mptcp: provide subflow aware
> release function"). The latter introduced a deadlock spotted by
> syzkaller and is not needed anymore after the previous commit.
>
> Fixes: ad98dd37051e ("mptcp: provide subflow aware release function")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 55 ++------------------------------------------
> 1 file changed, 2 insertions(+), 53 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
