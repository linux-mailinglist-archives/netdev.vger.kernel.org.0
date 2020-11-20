Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A648F2BAC2F
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 15:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgKTOuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 09:50:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:42512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbgKTOuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 09:50:51 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605883851;
        bh=I8qoVdLoV3RCtFxcMMvZbKxbI3FHQKH3QgfYqKibbFw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bhtfQDpZjwSMO0pP0/Q/F8n0QYcvg0Y9TKLy74vyUoPUo/eh9f5HDowHVw1TMRpUT
         oNxDnioZgDy+JEAEKBvtYs6e0JE4IpsQP59748UNOWduRl/PeQ3QjuvxTJ+0It80a9
         gPmrd05RGfSPoNfBKVkeCpQtFdq2/GDd9E+ZwGec=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V3] MAINTAINERS: Update XDP and AF_XDP entries
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160588385107.16958.5965341756003029840.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Nov 2020 14:50:51 +0000
References: <160586238944.2808432.4401269290440394008.stgit@firesoul>
In-Reply-To: <160586238944.2808432.4401269290440394008.stgit@firesoul>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        borkmann@iogearbox.net, alexei.starovoitov@gmail.com,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, joe@perches.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Fri, 20 Nov 2020 09:53:09 +0100 you wrote:
> Getting too many false positive matches with current use
> of the content regex K: and file regex N: patterns.
> 
> This patch drops file match N: and makes K: more restricted.
> Some more normal F: file wildcards are added.
> 
> Notice that AF_XDP forgot to some F: files that is also
> updated in this patch.
> 
> [...]

Here is the summary with links:
  - [net-next,V3] MAINTAINERS: Update XDP and AF_XDP entries
    https://git.kernel.org/bpf/bpf/c/6200d5c38313

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


