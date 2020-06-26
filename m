Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CAC20BB7E
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 23:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgFZV0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 17:26:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:8663 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbgFZV0J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 17:26:09 -0400
IronPort-SDR: yjE8vfYSm/dp6eFvYMrFoJW5q8ZwUiYBc7HB5eLVDNksfqnhcXvbfCoIVptL/zMHtFnZ1tqFkR
 cWf463cJznhg==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="210553935"
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="210553935"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 14:26:08 -0700
IronPort-SDR: vauLZPmOcjcrFHxL+P/XBr7blt1+zbNPFPAoNG8OvIM7EQXnMxFhr/8qMo0hrW9rXgVj7aICN3
 8weCyU8iw6eQ==
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="280271592"
Received: from redsall-mobl2.amr.corp.intel.com ([10.254.108.22])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 14:26:08 -0700
Date:   Fri, 26 Jun 2020 14:26:08 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@redsall-mobl2.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [MPTCP] [PATCH net-next v2 4/4] mptcp: introduce token KUNIT
 self-tests
In-Reply-To: <592538b2c28ee849ff94d9cfc8f7f6dbc5adae5d.1593192442.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2006261425520.66996@redsall-mobl2.amr.corp.intel.com>
References: <cover.1593192442.git.pabeni@redhat.com> <592538b2c28ee849ff94d9cfc8f7f6dbc5adae5d.1593192442.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 26 Jun 2020, Paolo Abeni wrote:

> Unit tests for the internal MPTCP token APIs, using KUNIT
>
> v1 -> v2:
> - use the correct RCU annotation when initializing icsk ulp
> - fix a few checkpatch issues
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/Kconfig      |   2 +-
> net/mptcp/Makefile     |   3 +-
> net/mptcp/token.c      |   9 +++
> net/mptcp/token_test.c | 140 +++++++++++++++++++++++++++++++++++++++++
> 4 files changed, 152 insertions(+), 2 deletions(-)
> create mode 100644 net/mptcp/token_test.c

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
