Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACE02F890E
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 00:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbhAOXAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 18:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:33310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbhAOXAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 18:00:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6591A2399A;
        Fri, 15 Jan 2021 23:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610751608;
        bh=RuxI0+5o+iF8ELYoih7lRTU/CZKmOIoEc5ZL2ZswYjI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C2i6wcPIUOSxDA240gv7CVN1x1bbDwvGhBsUZ8z3I6gbETbPmLhOTqbYaFlj1/ZMt
         r0obPA5rAYIF7I4sBucQP7fETZYPgNrRL0k4HuW0wyuIYMXMwTPcGY7HiRQtpbz3Dc
         4ht+fJLHpjheFkdmCbdJo2akI81ID/eo+AioU5ExV/aX0PBF4uIhDo79Ozvh4nUzhM
         0VQaNjrM7+dOqmT1S/ynQF0JyUNw+Yg2sNpTseRGq5QWfNnPrEJdCbuvNIGxV6dM4L
         BMmplvy3tXS3NJ4ifKiYkXjAqjbL2SWBERPk1IPnCw4X09ZvN2OTk/xbbGMKWEkaHi
         InAQI9MvrLKmA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 5CCB1605AB;
        Fri, 15 Jan 2021 23:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] MAINTAINERS: update my email address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161075160837.22495.5230649397692870926.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jan 2021 23:00:08 +0000
References: <20210115104337.7751-1-bjorn.topel@gmail.com>
In-Reply-To: <20210115104337.7751-1-bjorn.topel@gmail.com>
To:     =?utf-8?b?QmrDtnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, bjorn@kernel.org,
        linux-riscv@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Fri, 15 Jan 2021 11:43:37 +0100 you wrote:
> From: Björn Töpel <bjorn@kernel.org>
> 
> My Intel email will stop working in a not too distant future. Move my
> MAINTAINERS entries to my kernel.org address.
> 
> Signed-off-by: Björn Töpel <bjorn@kernel.org>
> 
> [...]

Here is the summary with links:
  - [bpf] MAINTAINERS: update my email address
    https://git.kernel.org/bpf/bpf/c/235ecd36c7a9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


