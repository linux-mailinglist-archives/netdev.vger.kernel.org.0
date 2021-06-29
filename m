Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F163B7800
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 20:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbhF2Smf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 14:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234971AbhF2Smc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 14:42:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9A2E861DE3;
        Tue, 29 Jun 2021 18:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624992004;
        bh=cP9TLArBKodoLnZJfWXBfheIhahVLjfuirshopZJZi8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XjJtbZKzaOvs8ZMkl3VaTGI4yG8oeKQo7vjxLsmVgIUw6Xp72JquSgOKOctnXSI4W
         0hjtXl0gxCRYKCH+x8ZjbmZ0fgjSCMAGbwNXHEizKPMTOA6KLTr7+j4ubv1MRysY7M
         u6c7RwV/+U7fTeXkqW0oBssRyyOwt9wrhJrue8dyGG9oSQc85zX1ApPJS5Pm7tMEef
         251Aj7qn5CEGIvCukWtIl7Y6jGC3xHg2YkGbUqWLCgg+Ciq4Llyr5eGZHy6lV8CVjW
         jGYgGLSIlYjfccY2/HlKfXaNV/J6hU95xB4ycwWrRaz3sksor35/HCqSJsJgJ1j14n
         elZ2XKn+OH39w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8EEA0609A3;
        Tue, 29 Jun 2021 18:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ptp: Set lookup cookie when creating a PTP PPS source.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162499200458.24074.14722653174447239621.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Jun 2021 18:40:04 +0000
References: <20210628182533.2930715-1-jonathan.lemon@gmail.com>
In-Reply-To: <20210628182533.2930715-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 28 Jun 2021 11:25:33 -0700 you wrote:
> When creating a PTP device, the configuration block allows
> creation of an associated PPS device.  However, there isn't
> any way to associate the two devices after creation.
> 
> Set the PPS cookie, so pps_lookup_dev(ptp) performs correctly.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> 
> [...]

Here is the summary with links:
  - ptp: Set lookup cookie when creating a PTP PPS source.
    https://git.kernel.org/netdev/net-next/c/8602e40fc813

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


