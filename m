Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8092520E960
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 01:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgF2Xah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 19:30:37 -0400
Received: from mga18.intel.com ([134.134.136.126]:53018 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726749AbgF2Xah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 19:30:37 -0400
IronPort-SDR: yoYtH44qjf+IZ1vMpec4cF0XimTHaDB5J0IKpW2yhymkQeEJkXH6S5O8S24dhQOhwIyM3BDguA
 xONkeULnwYqw==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="133540913"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="133540913"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 16:30:37 -0700
IronPort-SDR: OMy4otyg43q9GjDEsocpPFEh/h1TkYRc5wmi8ibHnnUMFvWopepaj3KHyI+MLyNMBCW8+WoUFd
 quJqItQroh1g==
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="454377063"
Received: from jlbliss-mobl.amr.corp.intel.com ([10.255.231.136])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 16:30:37 -0700
Date:   Mon, 29 Jun 2020 16:30:37 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@jlbliss-mobl.amr.corp.intel.com
To:     Davide Caratti <dcaratti@redhat.com>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: Re: [PATCH net-next 4/6] mptcp: create first subflow at msk creation
 time
In-Reply-To: <ce0a43c723147d86dec5ea47f86fa877bf5371b7.1593461586.git.dcaratti@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2006291630190.11066@jlbliss-mobl.amr.corp.intel.com>
References: <cover.1593461586.git.dcaratti@redhat.com> <ce0a43c723147d86dec5ea47f86fa877bf5371b7.1593461586.git.dcaratti@redhat.com>
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
> This cleans the code a bit and makes the behavior more consistent.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
> net/mptcp/protocol.c | 53 +++++++++++++++++---------------------------
> 1 file changed, 20 insertions(+), 33 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
