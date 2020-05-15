Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7780A1D58AD
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 20:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgEOSJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 14:09:46 -0400
Received: from mga18.intel.com ([134.134.136.126]:30727 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgEOSJq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 14:09:46 -0400
IronPort-SDR: oLzWMffZTKxca0Z5FZGmv1+eoT7TEr3EHeQowSz6GpiZL3AYOwd08xDUO6urVzBwg6jA+tTg7b
 rxD/3ZH+VicA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 11:09:46 -0700
IronPort-SDR: 6o641+LipBSl5vNkzoAhx6D040kH9XO6xD2wYSK4aVlXxaCC405vQ1O3qlYTvatw4MRGLYxA4i
 7T4sjJxfB1Hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,396,1583222400"; 
   d="scan'208";a="298514225"
Received: from rasanche-mobl.amr.corp.intel.com ([10.255.228.159])
  by fmsmga002.fm.intel.com with ESMTP; 15 May 2020 11:09:45 -0700
Date:   Fri, 15 May 2020 11:09:45 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@rasanche-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org
Subject: Re: [PATCH net-next v2 2/3] inet_connection_sock: factor out destroy
 helper.
In-Reply-To: <9cb1cf2e8b9dc89510ab38c938e2ba102b207d2f.1589558049.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.22.394.2005151109100.36555@rasanche-mobl.amr.corp.intel.com>
References: <cover.1589558049.git.pabeni@redhat.com> <9cb1cf2e8b9dc89510ab38c938e2ba102b207d2f.1589558049.git.pabeni@redhat.com>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 15 May 2020, Paolo Abeni wrote:

> Move the steps to prepare an inet_connection_sock for
> forced disposal inside a separate helper. No functional
> changes inteded, this will just simplify the next patch.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Reviewed-by: Christoph Paasch <cpaasch@apple.com>
> ---
> include/net/inet_connection_sock.h | 8 ++++++++
> net/ipv4/inet_connection_sock.c    | 6 +-----
> 2 files changed, 9 insertions(+), 5 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
