Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9EA3755EC
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 16:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbhEFOvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 10:51:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234759AbhEFOvJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 10:51:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 08A7661177;
        Thu,  6 May 2021 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620312610;
        bh=ye/s2oyuCMWuG8ceCnCSykwLYdyjlf+Bx41yaSsDgXQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b6XQooDjxXAfM5SQ/SWzAwpTH4ZdzG/m8n5D9UkLtG2InBPCAu5JpnjuJ4CUwsfcA
         umocPM/RYzVbBl4rjAQo6W3MnitPEeh5IOKIzXv/HjxK8WZiFXE57ZpUPGbj1goycv
         6K7J/d/MDxLC9G3yZcFjQWb8PfuLAaRF2+12+sod/iHb0t5fYTtq07JDi/5bp8586B
         zM+xZtx+GeL02AYvjlPxTSh6md6W4FA5h4fdhUFRrCer91EZ3MNnplLM0fmKU/uAUB
         e19Ve7bl6nLfnVtiLUA7XKPLYFwy63HgrrhkJn0XnPDckRbOtDVgLJC3DBam0UwtDx
         V1P9tABX2lTPg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F1B0060982;
        Thu,  6 May 2021 14:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] tc: q_ets: drop dead code from argument parsing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162031260998.15077.2780875998395041358.git-patchwork-notify@kernel.org>
Date:   Thu, 06 May 2021 14:50:09 +0000
References: <a98f8ff492c5be9f06a6ad6522371230c5721ee7.1619887263.git.aclaudi@redhat.com>
In-Reply-To: <a98f8ff492c5be9f06a6ad6522371230c5721ee7.1619887263.git.aclaudi@redhat.com>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (refs/heads/main):

On Sat,  1 May 2021 18:44:35 +0200 you wrote:
> Checking for nbands to be at least 1 at this point is useless. Indeed:
> - ets requires "bands", "quanta" or "strict" to be specified
> - if "bands" is specified, nbands cannot be negative, see parse_nbands()
> - if "strict" is specified, nstrict cannot be negative, see
>   parse_nbands()
> - if "quantum" is specified, nquanta cannot be negative, see
>   parse_quantum()
> - if "bands" is not specified, nbands is set to nstrict+nquanta
> - the previous if statement takes care of the case when none of them are
>   specified and nbands is 0, terminating execution.
> 
> [...]

Here is the summary with links:
  - [iproute2] tc: q_ets: drop dead code from argument parsing
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=a2f1f66075c8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


