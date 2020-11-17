Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5822B58FE
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 06:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgKQFAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 00:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:53608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgKQFAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 00:00:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605589205;
        bh=OH+93C9nOlhWqajka8dPqOVrxhVunFlU9VN4JxKVaUg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TUC6XF6zgNHDBNvb+ovn4eCBkO32mzktoU5luCzBHNAmTnShNL6iQC/STs51IUKQi
         cR7bksGJ4x6pVE1QfdaVBvQ9+zgILOF6GHV4ct6BOZ4Hf6BIeDXPMIGsTxzw4meU0n
         Wc367av9uQ2f6HwXh4jPN1Z6iE071cxTN9YKYQBE=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] libbpf: bpf__find_by_name[_kind] should use
 btf__get_nr_types()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160558920529.2852.9814496937693880554.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Nov 2020 05:00:05 +0000
References: <1605437195-2175-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1605437195-2175-1-git-send-email-alan.maguire@oracle.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Sun, 15 Nov 2020 10:46:35 +0000 you wrote:
> When operating on split BTF, btf__find_by_name[_kind] will not
> iterate over all types since they use btf->nr_types to show
> the number of types to iterate over.  For split BTF this is
> the number of types _on top of base BTF_, so it will
> underestimate the number of types to iterate over, especially
> for vmlinux + module BTF, where the latter is much smaller.
> 
> [...]

Here is the summary with links:
  - [bpf-next] libbpf: bpf__find_by_name[_kind] should use btf__get_nr_types()
    https://git.kernel.org/bpf/bpf-next/c/de91e631bdc7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


