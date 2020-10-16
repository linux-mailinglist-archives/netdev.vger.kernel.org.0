Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85110290D50
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 23:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411362AbgJPVcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 17:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411354AbgJPVcF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 17:32:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 643E9216C4;
        Fri, 16 Oct 2020 21:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602883925;
        bh=sONpstJsGgC+AA1Ry+CXKRFgauKStQSxfQ1R0eaWOt4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SbPF+VDu/jBRH1m5MvpW9XhPZ4Sa4ZpSiRvUJwIZT+/uH5hm6FRU8AUj3DsSqg8Nq
         fVwUzH43wH/cqVEaNmVp20VhEHP+Q/hHTSjLrezRwYqsGbls5JOVhk1W1YrPkxO+gA
         RpR9RF4f+4rz82e5zxOhNf0iDrz76/S7H82AXP/Q=
Date:   Fri, 16 Oct 2020 14:32:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Ian Rogers <irogers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Toke =?UTF-8?B?SMO4aWxhbmQt?= =?UTF-8?B?SsO4cmdlbnNlblw=?=" 
        <toke@redhat.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Alexandre Cassen <acassen@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 1/2] tools/include: Update if_link.h and netlink.h
Message-ID: <20201016143201.0c12c03b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201016142348.0000452b@intel.com>
References: <20201015223119.1712121-1-irogers@google.com>
        <20201016142348.0000452b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Oct 2020 14:23:48 -0700 Jesse Brandeburg wrote:
> > These are tested to be the latest as part of the tools/lib/bpf build.  
> 
> But you didn't mention why you're making these changes, and you're
> removing a lot of comments without explaining why/where there might be
> a replacement or why the comments are useless. I now see that you're
> adding actual kdoc which is good, except for the part where
> you don't put kdoc on all the structures.

Note that he's just syncing the uAPI headers to tools/

The source of the change is here:

78a3ea555713 ("net: remove comments on struct rtnl_link_stats")
0db0c34cfbc9 ("net: tighten the definition of interface statistics")
