Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1333F286C96
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 04:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbgJHCKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 22:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgJHCKE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 22:10:04 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602123003;
        bh=USK1Ahqjbl0Zr3Ppq072vnqM2Mf0BbRXyUcPQ2AfsrI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N5sUkK7r3gOsZmdtmqY8nSysi2Ke6xX4HWPC+XLOjN81iR9eyAtWsAtRoLrZnzwPJ
         AOxTrzFMX9DuFtWrWHhg4O5FKa+6fWqiilGriMKgjlIZvMQNrMxpimi+9q9OtNGXCz
         Wz5c3cYCzplt5DGUlRiDw5fd5T6I5mOARfVKsR4A=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 bpf-next 0/4] libbpf: auto-resize relocatable LOAD/STORE
 instructions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160212300339.17640.11889080811959975451.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Oct 2020 02:10:03 +0000
References: <20201008001025.292064-1-andrii@kernel.org>
In-Reply-To: <20201008001025.292064-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com, luka.perkov@sartura.hr,
        tony.ambardar@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 7 Oct 2020 17:10:20 -0700 you wrote:
> Patch set implements logic in libbpf to auto-adjust memory size (1-, 2-, 4-,
> 8-bytes) of load/store (LD/ST/STX) instructions which have BPF CO-RE field
> offset relocation associated with it. In practice this means transparent
> handling of 32-bit kernels, both pointer and unsigned integers. Signed
> integers are not relocatable with zero-extending loads/stores, so libbpf
> poisons them and generates a warning. If/when BPF gets support for
> sign-extending loads/stores, it would be possible to automatically relocate
> them as well.
> 
> [...]

Here is the summary with links:
  - [v3,bpf-next,1/4] libbpf: skip CO-RE relocations for not loaded BPF programs
    https://git.kernel.org/bpf/bpf-next/c/47f7cf6325f7
  - [v3,bpf-next,2/4] libbpf: support safe subset of load/store instruction resizing with CO-RE
    https://git.kernel.org/bpf/bpf-next/c/a66345bcbdf0
  - [v3,bpf-next,3/4] libbpf: allow specifying both ELF and raw BTF for CO-RE BTF override
    https://git.kernel.org/bpf/bpf-next/c/2b7d88c2b582
  - [v3,bpf-next,4/4] selftests/bpf: validate libbpf's auto-sizing of LD/ST/STX instructions
    https://git.kernel.org/bpf/bpf-next/c/888d83b961f6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


