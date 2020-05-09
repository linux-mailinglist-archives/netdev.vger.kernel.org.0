Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760441CBC46
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 04:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbgEICCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 22:02:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbgEICCC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 22:02:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DB2F218AC;
        Sat,  9 May 2020 02:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588989721;
        bh=f/75jpsP75sjutxWnSb2ta93FS25SZJI24n5u0R/Hwo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OxYM9s0/Sovqg/a/zGKHNblkI5aGfCETtGMRHmi8ehNWqF0wI2uJrYEAWQudc3++m
         U2l9UfC6p0ttKTzw4a+81vwBShlaQMqq21qLEbeo4oWwfVG+S5OxQ3pDABA0m42nVH
         1uEeFLdYFuBI7IK54sobpQpvgvgQiJ8h+V5NWvAo=
Date:   Fri, 8 May 2020 19:02:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2020-05-09
Message-ID: <20200508190200.5cec6d40@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200508230527.24382-1-daniel@iogearbox.net>
References: <20200508230527.24382-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  9 May 2020 01:05:27 +0200 Daniel Borkmann wrote:
> Hi David,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 4 non-merge commits during the last 9 day(s) which contain
> a total of 4 files changed, 11 insertions(+), 6 deletions(-).
> 
> The main changes are:
> 
> 1) Fix msg_pop_data() helper incorrectly setting an sge length in some
>    cases as well as fixing bpf_tcp_ingress() wrongly accounting bytes
>    in sg.size, from John Fastabend.
> 
> 2) Fix to return an -EFAULT error when copy_to_user() of the value
>    fails in map_lookup_and_delete_elem(), from Wei Yongjun.
> 
> 3) Fix sk_psock refcnt leak in tcp_bpf_recvmsg(), from Xiyu Yang.

Pulled, thank you!
