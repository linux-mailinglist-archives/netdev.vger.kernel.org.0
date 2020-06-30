Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025E020FAE4
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 19:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390499AbgF3RjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 13:39:23 -0400
Received: from mga05.intel.com ([192.55.52.43]:49435 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390480AbgF3RjW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 13:39:22 -0400
IronPort-SDR: NUkpxRcbK4eJyWr1d+QoxqFICnBSeOP2Y+UX94tPtYfc7O5Ta1aAOez/NmkNH15cvR9XAYmfUq
 5v8sD9u7Aftg==
X-IronPort-AV: E=McAfee;i="6000,8403,9668"; a="231195932"
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="scan'208";a="231195932"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2020 10:39:22 -0700
IronPort-SDR: L6EId5qT51KGH5GFqnQ/979P1WLnmyPf0ZcB0YH6cJ9izbwcBgQ0Igv6z/g7Xo4nWh93NfLgIj
 V7OurEywGuAQ==
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="scan'208";a="277498854"
Received: from ptcotton-mobl1.amr.corp.intel.com ([10.254.108.236])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2020 10:39:21 -0700
Date:   Tue, 30 Jun 2020 10:39:20 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@ptcotton-mobl1.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] mptcp: do nonce initialization at subflow
 creation time
In-Reply-To: <cc811b8707d488492fb8e33ed651aab456de6f72.1593527763.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2006301034001.27064@ptcotton-mobl1.amr.corp.intel.com>
References: <cc811b8707d488492fb8e33ed651aab456de6f72.1593527763.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, 30 Jun 2020, Paolo Abeni wrote:

> This clean-up the code a bit, reduces the number of
> used hooks and indirect call requested, and allow
> better error reporting from __mptcp_subflow_connect()
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/subflow.c | 54 +++++++++++++++++----------------------------
> 1 file changed, 20 insertions(+), 34 deletions(-)
>

Thanks Paolo, cleanup looks good and it's nice to not rely on the 
rebuild_header hook for this initialization.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
