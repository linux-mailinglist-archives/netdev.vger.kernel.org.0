Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7573720BB74
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 23:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgFZVZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 17:25:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:36568 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbgFZVZt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 17:25:49 -0400
IronPort-SDR: pkmWPxNVdVGeoAQfvJkuI+KTKqYwfIv/JW5wnbnBI55yOvTaYxHlGWEelKlFrH7cD2P3NkxuvJ
 IiE9ysMdbujw==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="146993055"
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="146993055"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 14:25:49 -0700
IronPort-SDR: JBlz71SDOy33zOMR+MAthFVGmiyc+D+uul4dhdfwqjSF9ziignioV83oSEihQ6kvRp23kPv3nf
 YAanjpDS2UmQ==
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="280271487"
Received: from redsall-mobl2.amr.corp.intel.com ([10.254.108.22])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 14:25:48 -0700
Date:   Fri, 26 Jun 2020 14:25:48 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@redsall-mobl2.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [MPTCP] [PATCH net-next v2 3/4] mptcp: move crypto test to
 KUNIT
In-Reply-To: <cc66fb0363b7e454cbc4d3d70d1216e7c242908c.1593192442.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2006261425220.66996@redsall-mobl2.amr.corp.intel.com>
References: <cover.1593192442.git.pabeni@redhat.com> <cc66fb0363b7e454cbc4d3d70d1216e7c242908c.1593192442.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jun 2020, Paolo Abeni wrote:

> currently MPTCP uses a custom hook to executed unit tests at
> boot time. Let's use the KUNIT framework instead.
> Additionally move the relevant code to a separate file and
> export the function needed by the test when self-tests
> are build as a module.
>
> Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/Kconfig       | 20 ++++++++----
> net/mptcp/Makefile      |  3 ++
> net/mptcp/crypto.c      | 63 ++----------------------------------
> net/mptcp/crypto_test.c | 72 +++++++++++++++++++++++++++++++++++++++++
> 4 files changed, 91 insertions(+), 67 deletions(-)
> create mode 100644 net/mptcp/crypto_test.c

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
