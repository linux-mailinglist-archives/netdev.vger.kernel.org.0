Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A1928FA26
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 22:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392291AbgJOUdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 16:33:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392286AbgJOUdI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 16:33:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73303206C1;
        Thu, 15 Oct 2020 20:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602793988;
        bh=/9qjaPflKD6f1sKRQmV+MIAZM/mRa3bf8LcSJYXFqAs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F+ilX2pVccgEXWPU68OtTBpitOQsuE0f8u/Z0kOce3MffoOsEzrN/ml56X06KkK5m
         zFpCyXJHWEi5SHaZ1Gfs6FE/IW3JnJY03yl3hPC5nBvNrQXF4msXcIKuGadQd5r3K3
         2t/F55tr9c3tA8qYTZXPEAkHy2FA1PSWq5re3n6Y=
Date:   Thu, 15 Oct 2020 13:33:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2020-10-15
Message-ID: <20201015133305.30cf9b9f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015191552.12435-1-daniel@iogearbox.net>
References: <20201015191552.12435-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 21:15:52 +0200 Daniel Borkmann wrote:
> The main changes are:
> 
> 1) Fix register equivalence tracking in verifier, from Alexei Starovoitov.
> 
> 2) Fix sockmap error path to not call bpf_prog_put() with NULL, from Alex Dewar.
> 
> 3) Fix sockmap to add locking annotations to iterator, from Lorenz Bauer.
> 
> 4) Fix tcp_hdr_options test to use loopback address, from Martin KaFai Lau.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Pulled, thanks!
