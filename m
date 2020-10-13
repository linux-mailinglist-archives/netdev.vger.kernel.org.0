Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9027F28C782
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 05:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbgJMDRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 23:17:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727831AbgJMDRV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 23:17:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E38A521BE5;
        Tue, 13 Oct 2020 00:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602550214;
        bh=/d8dx7lega327MMuoeqrohYtIk698Ma9UEbO0fqEwJY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ae7HtKnPAhI4xegvVFEIztfzWX9G0xGhkBs0YChDIjPe2yy/v2ksW0NTCCNTl0xvY
         gCnn5vIa/QP2gd2z9Nxw6n093YmhKBVNH3vbFXym6x94bS9LJi0CxHHEFXrqSCqx/U
         TcfRUR42xSPvjINU1RCnmNE+eWq4XPH8/1NFl3cM=
Date:   Mon, 12 Oct 2020 17:50:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: pull-request: bpf-next 2020-10-12
Message-ID: <20201012175012.74dd237a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201012205522.27023-1-alexei.starovoitov@gmail.com>
References: <20201012205522.27023-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 13:55:22 -0700 Alexei Starovoitov wrote:
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 62 non-merge commits during the last 10 day(s) which contain
> a total of 73 files changed, 4339 insertions(+), 772 deletions(-).
> 
> The main changes are:
> 
> 1) The BPF verifier improvements to track register allocation pattern, from Alexei and Yonghong.
> 
> 2) libbpf relocation support for different size load/store, from Andrii.
> 
> 3) bpf_redirect_peer() helper and support for inner map array with different max_entries, from Daniel.
> 
> 4) BPF support for per-cpu variables, form Hao.
> 
> 5) sockmap improvements, from John.

Pulled, thanks!
