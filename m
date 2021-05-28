Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7399E39489D
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 00:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhE1WVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 18:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhE1WVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 18:21:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F254A6135C;
        Fri, 28 May 2021 22:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622240405;
        bh=zAvNqNKd+HmueNXzQhflCrLEld4y1TB20N5Z13TFwNo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ajjPzdnD6zwLsplkDNm2ebIATCEud+G/wcH1JcPHwuGrUBjH8Ndd8JNERBKpL5EjQ
         HrVRGClV9ati1Lnku1bkWU0ER6Je46Ju/Qt4N/sWYWOtdj1KFC3J4mljzFtMF/dUUW
         dFCC83iqwFoD75DjoaN1j/REqZpDkD+Uo/Q/aIVDYDOjOM3yeC+68dW516B1n+75xg
         b3Wjp7o+11VFvlvoRyzN8u8/eiDlCfa/tuVX8cTrTPPSjJOBcbGu4tKurFU2y+v4wk
         gTPB/Inx+iTDRUJiaz+XCueNRvC0tPdaUkOEEZlfs1+ufmUmqvQ0Klw+FeKsk4VZxE
         HjhCaUpxnrduA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E70B160A39;
        Fri, 28 May 2021 22:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 01/12] nfc: fdp: correct kerneldoc for structure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162224040494.21156.3377097979911349255.git-patchwork-notify@kernel.org>
Date:   Fri, 28 May 2021 22:20:04 +0000
References: <20210528124200.79655-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20210528124200.79655-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 28 May 2021 08:41:49 -0400 you wrote:
> Since structure comments are not kerneldoc, remove the double ** to fix
> W=1 warnings:
> 
>     warning: This comment starts with '/**', but isn't a kernel-doc comment.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> 
> [...]

Here is the summary with links:
  - [01/12] nfc: fdp: correct kerneldoc for structure
    https://git.kernel.org/netdev/net-next/c/cd4375d621aa
  - [02/12] nfc: fdp: drop ACPI_PTR from device ID table
    https://git.kernel.org/netdev/net-next/c/466e1c889c71
  - [03/12] nfc: port100: correct kerneldoc for structure
    https://git.kernel.org/netdev/net-next/c/a548bee9ffe8
  - [04/12] nfc: pn533: drop of_match_ptr from device ID table
    https://git.kernel.org/netdev/net-next/c/a70bbbe387d0
  - [05/12] nfc: mrvl: mark OF device ID tables as maybe unused
    https://git.kernel.org/netdev/net-next/c/26f20ff5e207
  - [06/12] nfc: mrvl: skip impossible NCI_MAX_PAYLOAD_SIZE check
    https://git.kernel.org/netdev/net-next/c/41a6bf50ee04
  - [07/12] nfc: pn533: mark OF device ID tables as maybe unused
    https://git.kernel.org/netdev/net-next/c/b3a790d43749
  - [08/12] nfc: s3fwrn5: mark OF device ID tables as maybe unused
    https://git.kernel.org/netdev/net-next/c/5edc94265e19
  - [09/12] nfc: pn544: mark ACPI and OF device ID tables as maybe unused
    https://git.kernel.org/netdev/net-next/c/aa1405772fe1
  - [10/12] nfc: st-nci: mark ACPI and OF device ID tables as maybe unused
    https://git.kernel.org/netdev/net-next/c/255fcc7b7166
  - [11/12] nfc: st21nfca: mark ACPI and OF device ID tables as maybe unused
    https://git.kernel.org/netdev/net-next/c/806278023492
  - [12/12] nfc: st95hf: mark ACPI and OF device ID tables as maybe unused
    https://git.kernel.org/netdev/net-next/c/1ab4fe09977e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


