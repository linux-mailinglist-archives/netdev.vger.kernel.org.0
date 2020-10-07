Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50466286944
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 22:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgJGUkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 16:40:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727776AbgJGUkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 16:40:03 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602103203;
        bh=8s8R6knd8iw0vbPQHHUgrq+oBfhjrVXloCxr8xjoYDs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HjBZb0ADijOEi+Dn32rLunm7InuYuLabkG7+6gI2QECtdSPRbVqBTEBBpLZxOHFyB
         Btx7aD2aQaS2zcD6Xpkq03Y9QolSEjpIJ1ebwx0nXLFD7NVWznx5v/IJcu73kOm+Ob
         bEyNBKRK1nslcSe+vH1XYVGE0wZ/0ixwtLb6XjDk=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] libbpf: fix compatibility problem in
 xsk_socket__create
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160210320307.20743.18344305972350266676.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Oct 2020 20:40:03 +0000
References: <1602070946-11154-1-git-send-email-magnus.karlsson@gmail.com>
In-Reply-To: <1602070946-11154-1-git-send-email-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        ciara.loftus@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed,  7 Oct 2020 13:42:26 +0200 you wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix a compatibility problem when the old XDP_SHARED_UMEM mode is used
> together with the xsk_socket__create() call. In the old XDP_SHARED_UMEM
> mode, only sharing of the same device and queue id was allowed, and in
> this mode, the fill ring and completion ring were shared between the
> AF_XDP sockets. Therefore, it was perfectly fine to call the
> xsk_socket__create() API for each socket and not use the new
> xsk_socket__create_shared() API. This behavior was ruined by the
> commit introducing XDP_SHARED_UMEM support between different devices
> and/or queue ids. This patch restores the ability to use
> xsk_socket__create in these circumstances so that backward
> compatibility is not broken.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] libbpf: fix compatibility problem in xsk_socket__create
    https://git.kernel.org/bpf/bpf-next/c/80348d8867c6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


