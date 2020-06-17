Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34AA41FD42C
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgFQSN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:13:27 -0400
Received: from mga04.intel.com ([192.55.52.120]:44229 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgFQSNY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 14:13:24 -0400
IronPort-SDR: QElvJtrigecWuoAZAl5E1p9C5+BZOx8UbrI+w/Hvod0gVv2/Lby392xSIkVG4KWJWH9fVehnoi
 yGwoMUbxyZJw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 11:13:23 -0700
IronPort-SDR: hRQTzk2CIaJmqpMpIrcppylAXyZj+pmaZl0WeSVMjs7d61eRSMfwhXdK8EKkOgoaRJ5RSM/td9
 zsyan//T72mQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,523,1583222400"; 
   d="scan'208";a="476943896"
Received: from unknown (HELO [10.254.109.153]) ([10.254.109.153])
  by fmsmga005.fm.intel.com with ESMTP; 17 Jun 2020 11:13:22 -0700
Date:   Wed, 17 Jun 2020 11:13:22 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mjmartin-mac01.local
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: Re: [MPTCP] [PATCH net 1/2] mptcp: cache msk on MP_JOIN init_req
In-Reply-To: <3213f22a1fa85217032ba3de482f2209c63f2870.1592388398.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.22.394.2006171112280.1663@mjmartin-mac01.local>
References: <cover.1592388398.git.pabeni@redhat.com> <3213f22a1fa85217032ba3de482f2209c63f2870.1592388398.git.pabeni@redhat.com>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020, Paolo Abeni wrote:

> The msk ownership is transferred to the child socket at
> 3rd ack time, so that we avoid more lookups later. If the
> request does not reach the 3rd ack, the MSK reference is
> dropped at request sock release time.
>
> As a side effect, fallback is now tracked by a NULL msk
> reference instead of zeroed 'mp_join' field. This will
> simplify the next patch.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.h |  1 +
> net/mptcp/subflow.c  | 39 +++++++++++++++++----------------------
> 2 files changed, 18 insertions(+), 22 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
