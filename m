Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59284852F2
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 13:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbiAEMkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 07:40:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43474 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234272AbiAEMkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 07:40:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE7FA61670;
        Wed,  5 Jan 2022 12:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 495CFC36AF3;
        Wed,  5 Jan 2022 12:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641386416;
        bh=85EgKSnkxr2c1immt9do3f1sURp0SJC6V/uNQ5SIVJg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l3xA/fgXftfzuLba+7hRFiFrsbmTPQAzVOho6qEebiRj5Y/iDGd5ws/sboQ/OtC/y
         WxsS8iBct3eZY6mwwlmjqA96h0bPzRjhtN1TtrP+M1sVrIL+APw8Xs3tbpO3s0K+rU
         56zgPrh1nvX1ACPLdUbnRzQf+uVL8qCH8BJR5uGN0I3zUATcWX+BLQZf8Kublo6MH6
         y9T9QXt+Hl2mZmXoHeCcuvCQdf/DRQRqGpJ7UAmcxMnrd4MUodWaOj4/BwfGOgT0mn
         s3E/J29LU3hhWQE0M/v4PFvhTlIMog7D1RnSKg4adGfCxl7Ws7iruAIz8hGkTsf+hu
         GZxxSLw+7HOGw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30AA3F7940C;
        Wed,  5 Jan 2022 12:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf/selftests: Fix namespace mount setup in tc_redirect
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164138641619.6231.12315835333755803519.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 12:40:16 +0000
References: <20220104121030.138216-1-jolsa@kernel.org>
In-Reply-To: <20220104121030.138216-1-jolsa@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        joamaki@gmail.com, haliu@redhat.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue,  4 Jan 2022 13:10:30 +0100 you wrote:
> The tc_redirect umounts /sys in the new namespace, which can be
> mounted as shared and cause global umount. The lazy umount also
> takes down mounted trees under /sys like debugfs, which won't be
> available after sysfs mounts again and could cause fails in other
> tests.
> 
>   # cat /proc/self/mountinfo | grep debugfs
>   34 23 0:7 / /sys/kernel/debug rw,nosuid,nodev,noexec,relatime shared:14 - debugfs debugfs rw
>   # cat /proc/self/mountinfo | grep sysfs
>   23 86 0:22 / /sys rw,nosuid,nodev,noexec,relatime shared:2 - sysfs sysfs rw
>   # mount | grep debugfs
>   debugfs on /sys/kernel/debug type debugfs (rw,nosuid,nodev,noexec,relatime)
> 
> [...]

Here is the summary with links:
  - bpf/selftests: Fix namespace mount setup in tc_redirect
    https://git.kernel.org/bpf/bpf-next/c/5e22dd186267

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


