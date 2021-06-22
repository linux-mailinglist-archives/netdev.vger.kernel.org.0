Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17033B0D18
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbhFVSmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:42:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230146AbhFVSmW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 14:42:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8BA516128C;
        Tue, 22 Jun 2021 18:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624387206;
        bh=qw91iE0jZ/x2Ymg8H9qTCVqUd9ZGBkvtbseOaXsKCa0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c2IJPV3wWj2hGH3OlDUcgFTNFfGki2IAU3b89QwHQXThE4yy76Zu3fYJ6zgj7A1cy
         dsiJIcgDbtxzGrEAIVPBhVyJnwI8giFCsQ7SeXq3+kV2Fbk/AcP9epBekh9wCQHdM8
         1YD1iYw2Nq5rxxT3TC6b+Gs03Z/Pc6Ak1oedNBRBiLpbajevLugLkejMtTgptfeGmB
         NzUWhg7NGtfVfBdt9p8Omi4otT062cpt/WJx2k+HRwuJVVgMDcGkG1rFR1DV3YjT7b
         WbhLp2rvIhfX6OivvKUGbr1xQicsuHOn3xT1GL4wso+1wqB9d0A4LTNDfwtzj0xAHc
         Z7pZYobtWQmNw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7DC58609FF;
        Tue, 22 Jun 2021 18:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net-next 00/14] sctp: implement RFC8899: Packetization Layer
 Path MTU Discovery for SCTP transport
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162438720650.29926.6241107476929251289.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 18:40:06 +0000
References: <cover.1624384990.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1624384990.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 22 Jun 2021 14:04:46 -0400 you wrote:
> Overview(From RFC8899):
> 
>   In contrast to PMTUD, Packetization Layer Path MTU Discovery
>   (PLPMTUD) [RFC4821] introduces a method that does not rely upon
>   reception and validation of PTB messages.  It is therefore more
>   robust than Classical PMTUD.  This has become the recommended
>   approach for implementing discovery of the PMTU [BCP145].
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net-next,01/14] sctp: add pad chunk and its make function and event table
    https://git.kernel.org/netdev/net-next/c/745a32117b5a
  - [PATCHv2,net-next,02/14] sctp: add probe_interval in sysctl and sock/asoc/transport
    https://git.kernel.org/netdev/net-next/c/d1e462a7a5f3
  - [PATCHv2,net-next,03/14] sctp: add SCTP_PLPMTUD_PROBE_INTERVAL sockopt for sock/asoc/transport
    https://git.kernel.org/netdev/net-next/c/3190b649b4d9
  - [PATCHv2,net-next,04/14] sctp: add the constants/variables and states and some APIs for transport
    https://git.kernel.org/netdev/net-next/c/d9e2e410ae30
  - [PATCHv2,net-next,05/14] sctp: add the probe timer in transport for PLPMTUD
    https://git.kernel.org/netdev/net-next/c/92548ec2f1f9
  - [PATCHv2,net-next,06/14] sctp: do the basic send and recv for PLPMTUD probe
    https://git.kernel.org/netdev/net-next/c/fe59379b9ab7
  - [PATCHv2,net-next,07/14] sctp: do state transition when PROBE_COUNT == MAX_PROBES on HB send path
    https://git.kernel.org/netdev/net-next/c/1dc68c194571
  - [PATCHv2,net-next,08/14] sctp: do state transition when a probe succeeds on HB ACK recv path
    https://git.kernel.org/netdev/net-next/c/b87641aff9e7
  - [PATCHv2,net-next,09/14] sctp: do state transition when receiving an icmp TOOBIG packet
    https://git.kernel.org/netdev/net-next/c/836964083177
  - [PATCHv2,net-next,10/14] sctp: enable PLPMTUD when the transport is ready
    https://git.kernel.org/netdev/net-next/c/7307e4fa4d29
  - [PATCHv2,net-next,11/14] sctp: remove the unessessary hold for idev in sctp_v6_err
    https://git.kernel.org/netdev/net-next/c/237a6a2e318c
  - [PATCHv2,net-next,12/14] sctp: extract sctp_v6_err_handle function from sctp_v6_err
    https://git.kernel.org/netdev/net-next/c/f6549bd37b92
  - [PATCHv2,net-next,13/14] sctp: extract sctp_v4_err_handle function from sctp_v4_err
    https://git.kernel.org/netdev/net-next/c/d83060759a65
  - [PATCHv2,net-next,14/14] sctp: process sctp over udp icmp err on sctp side
    https://git.kernel.org/netdev/net-next/c/9e47df005cab

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


