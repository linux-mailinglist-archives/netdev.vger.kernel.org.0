Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACB4520A2E
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 02:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbiEJAeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 20:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbiEJAeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 20:34:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3485293B7D;
        Mon,  9 May 2022 17:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 817356121A;
        Tue, 10 May 2022 00:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8E3AC385C6;
        Tue, 10 May 2022 00:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652142613;
        bh=WyBakIUkIAywk82xhsV3Fr/rEfbkEHmgckPXLA/PXqk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ORKeUAAFNW0zU/XoLMyLfeE3ccA2zsVA+MY/7bKZ66XavL+FCScS0v/DDBY6O2rE1
         +9EgQ0ZwmLG9nTV/wpUsab9vtP9VOmk+1HIKyXq18K+Fi/y3uo4njEuuOl7kwC+MAd
         ME2JGdbHsKHkWiP9e8jeL/+YnpKfCYRvIOqsp/oWtV6cqLyN8Mol+tOvYPtWDUG4zK
         Mjun9q00FsYv+SfZKVgUyvGDdXdxGVhQnrBolXlPizF958sTitF/OyBhsPvRg8S2z5
         tTmPsEjajoz4GCumlfl+aXkXa1YslpPHkvarKZpYlGLRY4Yhty6+FvvA2jwry1xviX
         3gZc3l091MgWQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ABF55F03928;
        Tue, 10 May 2022 00:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/2] bpftool: fix feature output when helper probes
 fail
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165214261369.23610.5282615298374087059.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 00:30:13 +0000
References: <20220504161356.3497972-1-milan@mdaverde.com>
In-Reply-To: <20220504161356.3497972-1-milan@mdaverde.com>
To:     Milan Landaverde <milan@mdaverde.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        quentin@isovalent.com, paul@isovalent.com,
        niklas.soderlund@corigine.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Wed,  4 May 2022 12:13:30 -0400 you wrote:
> Currently in bpftool's feature probe, we incorrectly tell the user that
> all of the helper functions are supported for program types where helper
> probing fails or is explicitly unsupported[1]:
> 
> $ bpftool feature probe
> ...
> eBPF helpers supported for program type tracing:
> 	- bpf_map_lookup_elem
> 	- bpf_map_update_elem
> 	- bpf_map_delete_elem
> 	...
> 	- bpf_redirect_neigh
> 	- bpf_check_mtu
> 	- bpf_sys_bpf
> 	- bpf_sys_close
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/2] bpftool: adjust for error codes from libbpf probes
    https://git.kernel.org/bpf/bpf-next/c/6d9f63b9df5e
  - [bpf-next,2/2] bpftool: output message if no helpers found in feature probing
    https://git.kernel.org/bpf/bpf-next/c/b06a92a18d46

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


