Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FF426945C
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgINSG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:06:29 -0400
Received: from mga12.intel.com ([192.55.52.136]:4453 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbgINSGW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 14:06:22 -0400
IronPort-SDR: KeW53TFRn8ilZo3FDMkyIcXFIfUIDqIa9pm3Wuv9Hix8FM+Rqdaa6cyC70vXphsnIKoBGGVHTC
 WbcmhcOkFm1w==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="138640741"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="138640741"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:06:19 -0700
IronPort-SDR: Z7NR3oLYjUp3PbNqNzmCglvaSqLMFFgTTkB3JnBosGzEBTRXbjQKKNRq2bpw+LcrHY4S3zc5Fd
 0JqcIaOQIbTA==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="507232846"
Received: from ningale-mobl.amr.corp.intel.com ([10.255.229.30])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:06:19 -0700
Date:   Mon, 14 Sep 2020 11:06:18 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@ningale-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: Re: [PATCH net-next v2 05/13] mptcp: introduce and use
 mptcp_try_coalesce()
In-Reply-To: <39b392036de70a64726b19e7bb851a53ec90f134.1599854632.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2009141105320.57764@ningale-mobl.amr.corp.intel.com>
References: <cover.1599854632.git.pabeni@redhat.com> <39b392036de70a64726b19e7bb851a53ec90f134.1599854632.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020, Paolo Abeni wrote:

> Factor-out existing code, will be re-used by the
> next patch.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 31 +++++++++++++++++++------------
> 1 file changed, 19 insertions(+), 12 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
