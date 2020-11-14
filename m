Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CC02B2ADF
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 03:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgKNCuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 21:50:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbgKNCuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 21:50:07 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605322207;
        bh=TYtdey9e5EexETrySNAOBowxN2js1hrDAgbFqAFr3d0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sTyS0R3awuOaTGjrzHSNSdElaLqXgTmkvkUtWu5Gx/JPCMODesZ4SvVqIWJdd9BRG
         mXl9cLepqNbUePfXjfNMfj64Xia+ETZ1JJwI2I4YlAkQFWSGW+Qifxt4GqEEWGKCU9
         NPxY6KbfMDvMYwMP0dKoRa4ynP0VoarygyWW2Xs8=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v5 00/11] Add a tool for configuration of DCB
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160532220741.3458.7568898274264290438.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Nov 2020 02:50:07 +0000
References: <cover.1605218735.git.me@pmachata.org>
In-Reply-To: <cover.1605218735.git.me@pmachata.org>
To:     Petr Machata <me@pmachata.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, john.fastabend@gmail.com,
        jiri@nvidia.com, idosch@nvidia.com, kuba@kernel.org,
        mrv@mojatatu.com, leon@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (refs/heads/main):

On Thu, 12 Nov 2020 23:24:37 +0100 you wrote:
> The Linux DCB interface allows configuration of a broad range of
> hardware-specific attributes, such as TC scheduling, flow control, per-port
> buffer configuration, TC rate, etc.
> 
> Currently a common libre tool for configuration of DCB is OpenLLDP. This
> suite contains a daemon that uses Linux DCB interface to configure HW
> according to the DCB TLVs exchanged over an interface. The daemon can also
> be controlled by a client, through which the user can adjust and view the
> configuration. The downside of using OpenLLDP is that it is somewhat
> heavyweight and difficult to use in scripts, and does not support
> extensions such as buffer and rate commands.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v5,01/11] Unify batch processing across tools
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=1d9a81b8c9f3
  - [iproute2-next,v5,02/11] lib: Add parse_one_of(), parse_on_off()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=82604d28525a
  - [iproute2-next,v5,03/11] lib: json_print: Add print_on_off()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=9091ff0251f8
  - [iproute2-next,v5,04/11] lib: Extract from devlink/mnlg a helper, mnlu_socket_open()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=72858c7b77d0
  - [iproute2-next,v5,05/11] lib: Extract from devlink/mnlg a helper, mnlu_msg_prepare()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=dd78dfc7be69
  - [iproute2-next,v5,06/11] lib: Extract from devlink/mnlg a helper, mnlu_socket_recv_run()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=6dd778e83789
  - [iproute2-next,v5,07/11] lib: Extract from iplink_vlan a helper to parse key:value arrays
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=28e663ee65b5
  - [iproute2-next,v5,08/11] lib: parse_mapping: Update argc, argv on error
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=bc3523ae7013
  - [iproute2-next,v5,09/11] lib: parse_mapping: Recognize a keyword "all"
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=66a2d7148713
  - [iproute2-next,v5,10/11] Add skeleton of a new tool, dcb
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=67033d1c1c8a
  - [iproute2-next,v5,11/11] dcb: Add a subtool for the DCB ETS object
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=ef15b07601ea

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


