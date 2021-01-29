Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391083083E8
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 03:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhA2Cux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 21:50:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:59836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229757AbhA2Cuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 21:50:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 00D2D64DFF;
        Fri, 29 Jan 2021 02:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611888611;
        bh=GSBIUy6ft31GoV66BlL6xFa2Mr7SbEYA4cOaci+6NG4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=saPP+8UyEgnPEFS0e8WeHD2keF+KMNgrERL97mT5UuNYpIqEfnhyp/l3j7PUhg86+
         KzdqvOywINVptI29/LF29GgoNTPJouFja7OyiYDAQoKGdhlc+K7KvOyEzBL68wIZVL
         Z+YG0oJE0yCXQgI/1RsRUMHadhV+NVNE580gb/QdkX6ruVHH6g+rNufF7vVhb2LR2R
         xB+UkEkhn2jWUic8dob0OtrZbKyMXwbdB2Jco1pCADU/nWId1V20qpfQTE/8C+sphZ
         oJ6v63J6KD5o8+meCQ8s2vihWOznx2JLyWgjbtQcDchUL/5fXmSlm0JGFl5+g5v2Cb
         ox/2EkopQbn8g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E6F276530E;
        Fri, 29 Jan 2021 02:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] lan743x: fix endianness when accessing descriptors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161188861094.22252.8608162483413934450.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jan 2021 02:50:10 +0000
References: <20210128044859.280219-1-rtgbnm@gmail.com>
In-Reply-To: <20210128044859.280219-1-rtgbnm@gmail.com>
To:     Alexey Denisov <rtgbnm@gmail.com>
Cc:     bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 28 Jan 2021 09:48:59 +0500 you wrote:
> TX/RX descriptor ring fields are always little-endian, but conversion
> wasn't performed for big-endian CPUs, so the driver failed to work.
> 
> This patch makes the driver work on big-endian CPUs. It was tested and
> confirmed to work on NXP P1010 processor (PowerPC).
> 
> Signed-off-by: Alexey Denisov <rtgbnm@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v2] lan743x: fix endianness when accessing descriptors
    https://git.kernel.org/netdev/net-next/c/462512824f90

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


