Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF2D20E962
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 01:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgF2Xa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 19:30:58 -0400
Received: from mga05.intel.com ([192.55.52.43]:16658 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbgF2Xaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 19:30:55 -0400
IronPort-SDR: In1kYoj0X1IMIwmjoJHotw82x+j92ORtScUpEZh9LkVZtSA91zSLX7+MvDhTJbpb/Z74Dp2uwh
 lIXo6HMfjU2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="230949129"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="230949129"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 16:30:55 -0700
IronPort-SDR: r/ff1793eafJ9LROp5+kT5PF/pGdsiWunYjKScHkVyQfo5g54Vgr11H7bIlA3Tf0nLIhfDss5r
 zSYHA/erhmaQ==
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="454377136"
Received: from jlbliss-mobl.amr.corp.intel.com ([10.255.231.136])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 16:30:54 -0700
Date:   Mon, 29 Jun 2020 16:30:54 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@jlbliss-mobl.amr.corp.intel.com
To:     Davide Caratti <dcaratti@redhat.com>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: Re: [PATCH net-next 5/6] mptcp: __mptcp_tcp_fallback() returns a
 struct sock
In-Reply-To: <f4474c22d50669fa3702224677fd2c2541b83ca9.1593461586.git.dcaratti@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2006291630390.11066@jlbliss-mobl.amr.corp.intel.com>
References: <cover.1593461586.git.dcaratti@redhat.com> <f4474c22d50669fa3702224677fd2c2541b83ca9.1593461586.git.dcaratti@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020, Davide Caratti wrote:

> From: Paolo Abeni <pabeni@redhat.com>
>
> Currently __mptcp_tcp_fallback() always return NULL
> on incoming connections, because MPTCP does not create
> the additional socket for the first subflow.
> Since the previous commit no __mptcp_tcp_fallback()
> caller needs a struct socket, so let __mptcp_tcp_fallback()
> return the first subflow sock and cope correctly even with
> incoming connections.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
> net/mptcp/protocol.c | 22 ++++++++++------------
> 1 file changed, 10 insertions(+), 12 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
