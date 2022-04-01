Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E7B4EFC04
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 23:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241162AbiDAVME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 17:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235065AbiDAVMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 17:12:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B50E2BB3A;
        Fri,  1 Apr 2022 14:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E93361A25;
        Fri,  1 Apr 2022 21:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89F97C340F3;
        Fri,  1 Apr 2022 21:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648847412;
        bh=PWmstzi8XMYG/I55YQAy62GTNOEhQvabhLA50LlROm4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XkAuEgtGoBXc3/njTCsvVGOOZRG7CdvBwr1gLs8uMgt+NowygPBrGB4ClhThwSPGM
         wYhE60VMZjfXJEZg0iaIZwOKe+BSyc2nbukgcOfy5VIq2hCZbEpvrP7yI6fL2WDwqW
         DYefkBTkI/fiyiaNTH4pz21yTUsfLMeR0IzE0ntnYgtfZMRFDapN8cXSGM0mU5kY4/
         HACkO1TShgnLEvp0ZSpWGRhPsLL3Oc1dfmnk5k0vB4mowZ4JxTni5+lDNbYgMlTqOn
         rTFrkm/RZftKS2QjFRJ+WhULXFmaHqGoMJo8u/gHQn7wwyEnuUMUOFk97rLkHeRW3r
         Yh7dAdLz72SqA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 601DBF03849;
        Fri,  1 Apr 2022 21:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: test_offload.py: skip base maps without names
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164884741238.23098.562719647853095370.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Apr 2022 21:10:12 +0000
References: <20220329081100.9705-1-ykaliuta@redhat.com>
In-Reply-To: <20220329081100.9705-1-ykaliuta@redhat.com>
To:     Yauheni Kaliuta <ykaliuta@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, jolsa@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 29 Mar 2022 11:11:00 +0300 you wrote:
> The test fails:
> 
>   # ./test_offload.py
>   ...
>   Test bpftool bound info reporting (own ns)...
>   FAIL: 3 BPF maps loaded, expected 2
>     File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 1177, in <module>
>       check_dev_info(False, "")
>     File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 645, in check_dev_info
>       maps = bpftool_map_list(expected=2, ns=ns)
>     File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 190, in bpftool_map_list
>       fail(True, "%d BPF maps loaded, expected %d" %
>     File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 86, in fail
>       tb = "".join(traceback.extract_stack().format())
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: test_offload.py: skip base maps without names
    https://git.kernel.org/bpf/bpf-next/c/891663ace74c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


