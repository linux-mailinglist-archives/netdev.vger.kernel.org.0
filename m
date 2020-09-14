Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308E826944F
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgINSDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:03:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:40348 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgINSDW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 14:03:22 -0400
IronPort-SDR: qK2Jqg9BN1JPD62/2WV2Zsn2vtbl5ITqFgEyUX46YoA4/TufXmkkSG0OruoDgMx2sxLDIaU+Qu
 ER80uS8VErig==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="159176442"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="159176442"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:03:05 -0700
IronPort-SDR: eZV3Javv5g7rvetK7nS0fsYjXnhV+J7svPtV/gvvb+5YPOxg1lE7yb+4kHq9fyjtC7EgHUzDRh
 oIdM7B995LiQ==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="450979799"
Received: from ningale-mobl.amr.corp.intel.com ([10.255.229.30])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:03:05 -0700
Date:   Mon, 14 Sep 2020 11:03:03 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@ningale-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: Re: [MPTCP] [PATCH net-next v2 02/13] mptcp: set data_ready status
 bit in subflow_check_data_avail()
In-Reply-To: <10b65904849e08dfccab8da33219d2081341f581.1599854632.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2009141102090.57764@ningale-mobl.amr.corp.intel.com>
References: <cover.1599854632.git.pabeni@redhat.com> <10b65904849e08dfccab8da33219d2081341f581.1599854632.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020, Paolo Abeni wrote:

> This simplify mptcp_subflow_data_available() and will
> made follow-up patches simpler.
>
> Additionally remove the unneeded checks on subflow copied_seq:
> we always whole skbs out of subflows.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/subflow.c | 19 ++++++++-----------
> 1 file changed, 8 insertions(+), 11 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
