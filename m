Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8EF2C34F7
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 00:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389769AbgKXXtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 18:49:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728749AbgKXXtG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 18:49:06 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16FA42100A;
        Tue, 24 Nov 2020 23:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606261746;
        bh=UOVjsou1NphjeKLK7OSCErMOgnbH953scN8q24eTPyQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wtrND54xp4J5NS8JQxIuumSPUvsXL4Eqlvr2g6OQMunUB/FUHwatgHDYQp7Y++/ob
         umRua8Z62dCAye0fwBBnkzFBwcX8fM7Ln0k3ob4nbUrru0bhbQdGgf8HwmQV4o9zj0
         k2n/rqtCj1pBnYOCD5Nuj0c5XhkGyfAR5kZTG0yc=
Date:   Tue, 24 Nov 2020 15:49:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Subject: Re: [net-next v3 0/8] seg6: add support for SRv6 End.DT4/DT6
 behavior
Message-ID: <20201124154904.0699f4c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201123182857.4640-1-andrea.mayer@uniroma2.it>
References: <20201123182857.4640-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 19:28:48 +0100 Andrea Mayer wrote:
> - Patch 1 is needed to solve a pre-existing issue with tunneled packets
>   when a sniffer is attached;
> 
> - Patch 2 improves the management of the seg6local attributes used by the
>   SRv6 behaviors;
> 
> - Patch 3 adds support for optional attributes in SRv6 behaviors;
> 
> - Patch 4 introduces two callbacks used for customizing the
>   creation/destruction of a SRv6 behavior;
> 
> - Patch 5 is the core patch that adds support for the SRv6 End.DT4
>   behavior;
> 
> - Patch 6 introduces the VRF support for SRv6 End.DT6 behavior;
> 
> - Patch 7 adds the selftest for SRv6 End.DT4 behavior;
> 
> - Patch 8 adds the selftest for SRv6 End.DT6 (VRF mode) behavior;
> 
> - Patch 9 adds the vrftable attribute for End.DT4/DT6 behaviors in iproute2.

LGTM! Please address the nit and repost without the iproute2 patch.
Mixing the iproute2 patch in has confused patchwork:

https://patchwork.kernel.org/project/netdevbpf/list/?series=389667&state=*

Note how it thinks that the iproute2 patch is part of the kernel
series. This build bot-y thing is pretty new. I'll add a suggestion 
to our process documentation not to mix patches.

> I would like to thank David Ahern for his support during the development of
> this patchset.

Should I take this to mean that David has review the code off-list?

