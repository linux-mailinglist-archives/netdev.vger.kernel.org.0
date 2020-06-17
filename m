Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F021FD42E
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgFQSOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:14:31 -0400
Received: from mga03.intel.com ([134.134.136.65]:40811 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727017AbgFQSOb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 14:14:31 -0400
IronPort-SDR: +EfUVD1r5DFxjfITfpjcIjH70v0I+ra6Lrt+v555PlFdSv6GydfCMPBkc30axmzrcslUfSNuFX
 ZSWyEVQpUtWA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 11:14:30 -0700
IronPort-SDR: U6V53XQvCVt5x47K2QyEWAQRtARrdCQo2ZqnhcZ60yQq16obFNoLnJmll3rX2yaaotjhdXy+1U
 WwZeXXaI9Tdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,523,1583222400"; 
   d="scan'208";a="299387172"
Received: from unknown (HELO [10.254.109.153]) ([10.254.109.153])
  by fmsmga004.fm.intel.com with ESMTP; 17 Jun 2020 11:14:28 -0700
Date:   Wed, 17 Jun 2020 11:14:28 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mjmartin-mac01.local
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: Re: [MPTCP] [PATCH net 2/2] mptcp: drop MP_JOIN request sock on syn
 cookies
In-Reply-To: <3aff0acec0b89a55fdae02194036f34be56b545c.1592388398.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.22.394.2006171113260.1663@mjmartin-mac01.local>
References: <cover.1592388398.git.pabeni@redhat.com> <3aff0acec0b89a55fdae02194036f34be56b545c.1592388398.git.pabeni@redhat.com>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020, Paolo Abeni wrote:

> Currently any MPTCP socket using syn cookies will fallback to
> TCP at 3rd ack time. In case of MP_JOIN requests, the RFC mandate
> closing the child and sockets, but the existing error paths
> do not handle the syncookie scenario correctly.
>
> Address the issue always forcing the child shutdown in case of
> MP_JOIN fallback.
>
> Fixes: ae2dd7164943 ("mptcp: handle tcp fallback when using syn cookies")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/subflow.c | 18 ++++++++++--------
> 1 file changed, 10 insertions(+), 8 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
