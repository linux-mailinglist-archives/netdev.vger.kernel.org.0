Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FD62A37EB
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 01:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgKCAfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 19:35:20 -0500
Received: from mga17.intel.com ([192.55.52.151]:32854 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727329AbgKCAfT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 19:35:19 -0500
IronPort-SDR: ApV2Ig73aZCA6kpJ+j2ROfnLBEydwZSerZ6617XometgqNp9LA5pgJhjVHVwKWRwrXAptUkB1w
 g5816yVa8u5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="148831321"
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="148831321"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 16:35:19 -0800
IronPort-SDR: ddqBAuv6mamppuWCxGcGEJOEYV0UVJnOwIt28KLhj9j6mlY0hLx2J5L5Et4pUSNfoY3gAP1h5J
 SbQpxNJamqHw==
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="305875840"
Received: from hshedbal-mobl2.amr.corp.intel.com ([10.255.229.198])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 16:35:18 -0800
Date:   Mon, 2 Nov 2020 16:35:18 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     netdev@vger.kernel.org, Geliang Tang <geliangtang@gmail.com>,
        mptcp@lists.01.org, davem@davemloft.net,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 5/6] mptcp: add a new sysctl add_addr_timeout
In-Reply-To: <20201102153359.29c546f1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Message-ID: <49dec7ac-934a-2fe6-70ef-71f7b3ed2f@linux.intel.com>
References: <20201030224506.108377-1-mathew.j.martineau@linux.intel.com> <20201030224506.108377-6-mathew.j.martineau@linux.intel.com> <20201102153359.29c546f1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Nov 2020, Jakub Kicinski wrote:

> On Fri, 30 Oct 2020 15:45:05 -0700 Mat Martineau wrote:
>> From: Geliang Tang <geliangtang@gmail.com>
>>
>> This patch added a new sysctl, named add_addr_timeout, to control the
>> timeout value (in seconds) of the ADD_ADDR retransmission.
>
> Please document the new sysctl.
>

Thanks Jakub. I will add a patch to document this new sysctl and the 
existing 'enabled' sysctl for MPTCP.

--
Mat Martineau
Intel
