Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFC73698A8
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 19:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243329AbhDWRus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 13:50:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232238AbhDWRur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 13:50:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 08ADB61450;
        Fri, 23 Apr 2021 17:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619200210;
        bh=6tAMPT6U7vKDFMJ3zsAzO85HvaYLb2FqgAjzqx/Kd6o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JlQOD1wiLsnVytuI0wOc3kYtF2VLpZtC6wIa+G1OBWl8xXRbnEZhm/VS3AqDQlPXu
         5LDwHN4JBy50TdqH61lbHAYAYJ3x5BCGTs2rmnq1KVe6kdSFAKO0keLoFOGtQ8Q/Ll
         ImSG+oCxYhetXpDiNF3oitFbLNPIgI2qUxGHEbwiL8BOWjL9vo2YnqXesw7DPZgR6u
         3JQk2zMO2v9Srg9eF9F48IovuCcOIOgWO+g48ZcMwVO5TDeMNtYBHFTE9LD1ZZbTKD
         FjQklKb+ZftdYIJKNcyZxr/RlWxi4s3yuUVNdxg6Eus9rWAZyhi6p4lIWHTTGsvt0u
         iAdUgV3auEJvw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 00E6C60A52;
        Fri, 23 Apr 2021 17:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] uapi: add missing virtio related headers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161920020999.5159.7025343456047982357.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Apr 2021 17:50:09 +0000
References: <20210423174011.11309-1-stephen@networkplumber.org>
In-Reply-To: <20210423174011.11309-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, parav@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (refs/heads/main):

On Fri, 23 Apr 2021 10:40:11 -0700 you wrote:
> The build of iproute2 relies on having correct copy of santized
> kernel headers. The vdpa utility introduced a dependency on
> the vdpa related headers, but these headers were not present
> in iproute2 repo.
> 
> Fixes: c2ecc82b9d4c ("vdpa: Add vdpa tool")
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> 
> [...]

Here is the summary with links:
  - [iproute2] uapi: add missing virtio related headers
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=b5a6ed9cc9fc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


