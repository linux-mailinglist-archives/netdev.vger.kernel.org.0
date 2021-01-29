Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63317308FBC
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 23:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbhA2WAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 17:00:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231169AbhA2WAX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 17:00:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21EAA64DDB;
        Fri, 29 Jan 2021 21:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611957582;
        bh=0j11Cgvmw3GG+q8FzBsXNI6iSzH/wZUiiLmtxJFhm6s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fj6bihvQapas73a9ghI13lfzb/4LRXXuO7hUviGV7Q+4Wu1zbFSews0jGj27xzeUV
         I9jquBvyCQgof/cBoBqfuuMETcGw1vgAr6j7/9LGSWRSWnVPd7AXWJoFnRN0gkULit
         Y9wOrjZWUpnBMBwhfdKoMLn9wIDzuT9Ek0D7qgeJaMCnHHo088kX8qG3c4Krh8TurQ
         e/8axvILUyWz9O6bclUHs9fdmyK0kMPBXz2cHiXy+xBgFHsapjbMiPzxNtW9ULaWih
         BPALN7QO6RWIGqKRCkTfbqSTvEbIvkBKHIXMUGJl9z7Ixm5222MUuMqL73FZGmqtq3
         s93qOWPYpsP0A==
Date:   Fri, 29 Jan 2021 13:59:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2021-01-29
Message-ID: <20210129135941.16e55d3f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129001556.6648-1-daniel@iogearbox.net>
References: <20210129001556.6648-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 01:15:56 +0100 Daniel Borkmann wrote:
> 1) Fix two copy_{from,to}_user() warn_on_once splats for BPF cgroup getsockopt
>    infra when user space is trying to race against optlen, from Loris Reiff.
> 
> 2) Fix a missing fput() in BPF inode storage map update helper, from Pan Bian.
> 
> 3) Fix a build error on unresolved symbols on disabled networking / keys LSM
>    hooks, from Mikko Ylinen.
> 
> 4) Fix preload BPF prog build when the output directory from make points to a
>    relative path, from Quentin Monnet.

Pulled, thanks! 

I keep forgetting that pw bot ignores BPF PRs for some reason.
