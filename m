Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61BE2F3D70
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390552AbhALVjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:39:52 -0500
Received: from mga05.intel.com ([192.55.52.43]:21993 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731887AbhALVjl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 16:39:41 -0500
IronPort-SDR: REpkfa12IORMbCPSNgJ1NsstY5/D+5nl696hRMgPktfVKNRbcYt1VEq1h7DW35nl7Rgoq+FmJX
 jXVYpG4lUEag==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="262895553"
X-IronPort-AV: E=Sophos;i="5.79,342,1602572400"; 
   d="scan'208";a="262895553"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 13:37:51 -0800
IronPort-SDR: F3sqL9GPNjpjoaFs6MYJm8AqjGn5nJkskWAO9De0wcqq2zikesgRYh5rS+9n8YXBOsQiyCvAoN
 +m+qKszlcBkw==
X-IronPort-AV: E=Sophos;i="5.79,342,1602572400"; 
   d="scan'208";a="397502790"
Received: from smakanda-mobl1.gar.corp.intel.com ([10.254.115.163])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 13:37:50 -0800
Date:   Tue, 12 Jan 2021 13:37:48 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [MPTCP] [PATCH net 1/2] mptcp: more strict state checking for
 acks
In-Reply-To: <5566ba1c4409a652440d84ff49b99e58ca998a0e.1610471474.git.pabeni@redhat.com>
Message-ID: <cf5db42-8431-da6f-422-da51da18a119@linux.intel.com>
References: <cover.1610471474.git.pabeni@redhat.com> <5566ba1c4409a652440d84ff49b99e58ca998a0e.1610471474.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021, Paolo Abeni wrote:

> Syzkaller found a way to trigger division by zero
> in mptcp_subflow_cleanup_rbuf().
>
> The current checks implemented into tcp_can_send_ack()
> are too week, let's be more accurate.
>
> Reported-by: Christoph Paasch <cpaasch@apple.com>
> Fixes: ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling")
> Fixes: fd8976790a6c ("mptcp: be careful on MPTCP-level ack.")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
