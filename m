Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F982C11C0
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 18:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbgKWRTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 12:19:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbgKWRTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 12:19:08 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3BA220728;
        Mon, 23 Nov 2020 17:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606151947;
        bh=Gmh7elWNDKpRb/DixRNbUEZYdY6lZHaWjAsm5Hdvxvg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bVicIzV0NtRO0Kozq0GKrVAvMoVt8l7JDfNhw0xNdDRqk3lPwNPns/pJQiKplIqID
         i+5pQ/boFejurO0FoiyK/UbAz1FNYgBtWlXi4AdlNyZoeDdLOX752SMRVOOh21Pz7V
         ei7N0eh3beoUfuztZhFHOd7jZvgbYBrTNTfMMGfQ=
Date:   Mon, 23 Nov 2020 09:19:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rong Chen <rong.a.chen@intel.com>
Cc:     kernel test robot <lkp@intel.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        netdev@vger.kernel.org
Subject: Re: [kbuild-all] Re: [net-next,v2,4/5] seg6: add support for the
 SRv6 End.DT4 behavior
Message-ID: <20201123091906.5856d985@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9242894f-b831-067a-48d8-2f235963dedb@intel.com>
References: <20201107153139.3552-5-andrea.mayer@uniroma2.it>
        <202011131747.puABQV5A-lkp@intel.com>
        <20201113085730.5f3c850a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9242894f-b831-067a-48d8-2f235963dedb@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 09:13:49 +0800 Rong Chen wrote:
> Sorry for the inconvenience, we have optimized the build bot to avoid 
> this situation.

Great to hear, thank you!
