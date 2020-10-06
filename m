Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88839285505
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 01:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgJFX67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 19:58:59 -0400
Received: from mga05.intel.com ([192.55.52.43]:53810 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgJFX67 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 19:58:59 -0400
IronPort-SDR: ALfrJARycIsDbaN9DDfpGc1/PTbWmdrgxeSKzIw4Dr2xc0/WAeqCfuKB3ygo2XS9bs9jkjD2Fe
 P0nxdtjTBF0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="249464916"
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="249464916"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 16:58:59 -0700
IronPort-SDR: JQQYqgCPv27v802EUKsGovbkTlGzTbXF5/SorUOtdafAdjhdOVvgJMFiq3YSKp75RHsiHaFEyx
 PAYGLHAJPxPw==
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="311488137"
Received: from ccarpent-mobl.amr.corp.intel.com ([10.255.229.108])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 16:58:58 -0700
Date:   Tue, 6 Oct 2020 16:58:58 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@ccarpent-mobl.amr.corp.intel.com
To:     Davide Caratti <dcaratti@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        mptcp@lists.01.org, Christoph Paasch <cpaasch@apple.com>,
        pabeni@redhat.com, Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH net] net: mptcp: make DACK4/DACK8 usage consistent among
 all subflows
In-Reply-To: <70c96303d6d9931aae1b1028aed016d807df0e20.1602001119.git.dcaratti@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2010061656560.22542@ccarpent-mobl.amr.corp.intel.com>
References: <70c96303d6d9931aae1b1028aed016d807df0e20.1602001119.git.dcaratti@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1433231232-1602028738=:22542"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1433231232-1602028738=:22542
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 6 Oct 2020, Davide Caratti wrote:

> using packetdrill it's possible to observe the same MPTCP DSN being acked
> by different subflows with DACK4 and DACK8. This is in contrast with what
> specified in RFC8684 §3.3.2: if an MPTCP endpoint transmits a 64-bit wide
> DSN, it MUST be acknowledged with a 64-bit wide DACK. Fix 'use_64bit_ack'
> variable to make it a property of MPTCP sockets, not TCP subflows.
>
> Fixes: a0c1d0eafd1e ("mptcp: Use 32-bit DATA_ACK when possible")
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
> net/mptcp/options.c  | 2 +-
> net/mptcp/protocol.h | 2 +-
> net/mptcp/subflow.c  | 3 +--
> 3 files changed, 3 insertions(+), 4 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
--0-1433231232-1602028738=:22542--
