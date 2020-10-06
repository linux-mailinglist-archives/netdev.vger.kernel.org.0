Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C942851B9
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 20:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgJFSkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 14:40:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbgJFSkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 14:40:04 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602009603;
        bh=IvQjVIfH5DIF1Fmqf9y3gxCvit8dsCG7mjBBuxGwlX8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kd+qO0cgY5QR2Rft2AgJQw0Z6bSFRoN0gs2Eh7VE1MwQRimTjk06qZUXMQISQTwsT
         khRNsg/01gl4yYr2d0ZeEp9iwrNz2KFL+PnyxkuUxGmxgmjt7ox/PegEK9FisDoWqB
         w2NJRjBNAw8HICLHRbZqR+ed+uKheCbSbNEIZhPQ=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 bpf 0/3] Fix pining maps after reuse map fd
From:   patchwork-bot+bpf@kernel.org
Message-Id: <160200960357.8676.14578405115856230926.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Oct 2020 18:40:03 +0000
References: <20201006021345.3817033-1-liuhangbin@gmail.com>
In-Reply-To: <20201006021345.3817033-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org, toke@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Tue,  6 Oct 2020 10:13:42 +0800 you wrote:
> When a user reuse map fd after creating a map manually and set the
> pin_path, then load the object via libbpf. bpf_object__create_maps()
> will skip pinning map if map fd exist. Fix it by add moving bpf creation
> to else condition and go on checking map pin_path after that.
> 
> v3:
> for selftest: use CHECK() for bpf_object__open_file() and close map fd on error
> 
> [...]

Here is the summary with links:
  - [PATCHv3,1/3] libbpf: close map fd if init map slots failed
    https://git.kernel.org/bpf/bpf-next/c/a0f2b7acb4b1
  - [PATCHv3,2/3] libbpf: check if pin_path was set even map fd exist
    https://git.kernel.org/bpf/bpf-next/c/2c193d32caee
  - [PATCHv3,3/3] selftest/bpf: test pinning map with reused map fd
    https://git.kernel.org/bpf/bpf-next/c/44c4aa2bd151

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


