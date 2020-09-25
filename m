Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEA3277CDC
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgIYA05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:26:57 -0400
Received: from mga06.intel.com ([134.134.136.31]:59580 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbgIYA05 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 20:26:57 -0400
IronPort-SDR: UdCjtAWSNYrYaIC3KKN4+AfRB50fGQRpeJgzFqvFA+CyzpHkUOx9pmClor+tKfCTsGiU9Qfd2j
 Bl55R5i7VP+Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="222980834"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="222980834"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:26:57 -0700
IronPort-SDR: LQYdaM5WZxHALZW8OHF6fh0+zwQwA26kj+LJctiFPpb1Nht3ZI40Oa/SWMzlXRzsv9Wsojler5
 +UzkstrcidXQ==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="455590823"
Received: from mmahler-mobl1.amr.corp.intel.com ([10.254.96.152])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:26:57 -0700
Date:   Thu, 24 Sep 2020 17:26:56 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mmahler-mobl1.amr.corp.intel.com
To:     Geliang Tang <geliangtang@gmail.com>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [MPTCP][PATCH net-next 16/16] mptcp: retransmit ADD_ADDR when
 timeout
In-Reply-To: <8d5db133c22f03ed112b13fdc2a36ed4168295d8.1600853093.git.geliangtang@gmail.com>
Message-ID: <alpine.OSX.2.23.453.2009241726360.62831@mmahler-mobl1.amr.corp.intel.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <8d5db133c22f03ed112b13fdc2a36ed4168295d8.1600853093.git.geliangtang@gmail.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020, Geliang Tang wrote:

> This patch implemented the retransmition of ADD_ADDR when no ADD_ADDR echo
> is received. It added a timer with the announced address. When timeout
> occurs, ADD_ADDR will be retransmitted.
>
> Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
> net/mptcp/options.c    |   1 +
> net/mptcp/pm_netlink.c | 109 ++++++++++++++++++++++++++++++++++-------
> net/mptcp/protocol.h   |   3 ++
> 3 files changed, 96 insertions(+), 17 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
