Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127A82955AC
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 02:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894397AbgJVAfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 20:35:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:16282 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2894365AbgJVAfh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 20:35:37 -0400
IronPort-SDR: Z96nolHquJt+S2ugVl0DMRaplL7mwjSII1AO3QF1S70R4BbJiquB2wFaIsBOAzzyOxbS1AV7OV
 xxDU6MY1Lbrw==
X-IronPort-AV: E=McAfee;i="6000,8403,9781"; a="155235788"
X-IronPort-AV: E=Sophos;i="5.77,402,1596524400"; 
   d="scan'208";a="155235788"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 17:35:33 -0700
IronPort-SDR: dcrW/PklZpa5W4OuQQhLF1CXm3OVpPhcqDNGffaJxrTm5mTXXEo54ubqP90mTa4sadX3xQvWHt
 HXPVSpMyEWfQ==
X-IronPort-AV: E=Sophos;i="5.77,402,1596524400"; 
   d="scan'208";a="533737216"
Received: from djthomps-mobl1.amr.corp.intel.com ([10.251.6.165])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 17:35:33 -0700
Date:   Wed, 21 Oct 2020 17:35:32 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] selftests: mptcp: depends on built-in IPv6
In-Reply-To: <20201021155549.933731-1-matthieu.baerts@tessares.net>
Message-ID: <1d28e7da-3fce-b064-a159-662f53e5a3b@linux.intel.com>
References: <20201021155549.933731-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Oct 2020, Matthieu Baerts wrote:

> Recently, CONFIG_MPTCP_IPV6 no longer selects CONFIG_IPV6. As a
> consequence, if CONFIG_MPTCP_IPV6=y is added to the kconfig, it will no
> longer ensure CONFIG_IPV6=y. If it is not enabled, CONFIG_MPTCP_IPV6
> will stay disabled and selftests will fail.
>
> We also need CONFIG_IPV6 to be built-in. For more details, please see
> commit 0ed37ac586c0 ("mptcp: depends on IPV6 but not as a module").
>
> Note that 'make kselftest-merge' will take all 'config' files found in
> 'tools/testsing/selftests'. Because some of them already set
> CONFIG_IPV6=y, MPTCP selftests were still passing. But they will fail if
> MPTCP selftests are launched manually after having executed this command
> to prepare the kernel config:
>
>  ./scripts/kconfig/merge_config.sh -m .config \
>      ./tools/testing/selftests/net/mptcp/config
>
> Fixes: 010b430d5df5 ("mptcp: MPTCP_IPV6 should depend on IPV6 instead of selecting it")
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> ---
> tools/testing/selftests/net/mptcp/config | 1 +
> 1 file changed, 1 insertion(+)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
