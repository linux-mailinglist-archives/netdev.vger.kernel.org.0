Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33945A1E75
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 04:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240244AbiHZCA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 22:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiHZCAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 22:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6100B792D5;
        Thu, 25 Aug 2022 19:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0ED41B82F67;
        Fri, 26 Aug 2022 02:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8FFA0C433D6;
        Fri, 26 Aug 2022 02:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661479214;
        bh=SuxfnH1J9bBwDaPQn24zrh7Rtn1UTyoTanq1mS1gv4U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R6/CfEf+1XxED41xU0xdlbCWTuf606iTef8eXp2xmLfpsTEevrLtsn50u8YaRQ2NJ
         YyYhsnW6EYnK5nV4ognDRVT0qSIOXYPIXIYWz8wNXsijVAGrdS+4QwHpyrK2ITlS0L
         3l1Gc01ykhGtKaW/4biOqs1oJzVQv5dCCDCjJvw+8V47CXWEpB8m4bHwc/+0hoNWRo
         442mpfytLC2gHxugVBnLQQktvidJmiDzKSkzY07anPu0pZjNwcMrQuGJnACgOEOgyn
         OL3hux+99ourHecgj3lpLYNeyZfn2gtsfr/fRtiTagX0+H7w8ix5f4/P+3YfLLqN14
         UM/oaN8326uVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 720A5C4166E;
        Fri, 26 Aug 2022 02:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v9 00/23] Introduce eBPF support for HID devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166147921446.22284.3135870790322146375.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Aug 2022 02:00:14 +0000
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
In-Reply-To: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     gregkh@linuxfoundation.org, jikos@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, memxor@gmail.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org,
        davemarchevsky@fb.com, joe@cilium.io, corbet@lwn.net,
        tero.kristo@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-doc@vger.kernel.org
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

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Wed, 24 Aug 2022 15:40:30 +0200 you wrote:
> Hi,
> 
> here comes the v9 of the HID-BPF series.
> 
> Again, for a full explanation of HID-BPF, please refer to the last patch
> in this series (23/23).
> 
> [...]

Here is the summary with links:
  - [bpf-next,v9,01/23] bpf/verifier: allow all functions to read user provided context
    (no matching commit)
  - [bpf-next,v9,02/23] bpf/verifier: do not clear meta in check_mem_size
    (no matching commit)
  - [bpf-next,v9,03/23] selftests/bpf: add test for accessing ctx from syscall program type
    (no matching commit)
  - [bpf-next,v9,04/23] bpf/verifier: allow kfunc to return an allocated mem
    (no matching commit)
  - [bpf-next,v9,05/23] selftests/bpf: Add tests for kfunc returning a memory pointer
    (no matching commit)
  - [bpf-next,v9,06/23] bpf: prepare for more bpf syscall to be used from kernel and user space.
    https://git.kernel.org/bpf/bpf-next/c/b88df6979682
  - [bpf-next,v9,07/23] libbpf: add map_get_fd_by_id and map_delete_elem in light skeleton
    https://git.kernel.org/bpf/bpf-next/c/343949e10798
  - [bpf-next,v9,08/23] HID: core: store the unique system identifier in hid_device
    (no matching commit)
  - [bpf-next,v9,09/23] HID: export hid_report_type to uapi
    (no matching commit)
  - [bpf-next,v9,10/23] HID: convert defines of HID class requests into a proper enum
    (no matching commit)
  - [bpf-next,v9,11/23] HID: Kconfig: split HID support and hid-core compilation
    (no matching commit)
  - [bpf-next,v9,12/23] HID: initial BPF implementation
    (no matching commit)
  - [bpf-next,v9,13/23] selftests/bpf: add tests for the HID-bpf initial implementation
    (no matching commit)
  - [bpf-next,v9,14/23] HID: bpf: allocate data memory for device_event BPF programs
    (no matching commit)
  - [bpf-next,v9,15/23] selftests/bpf/hid: add test to change the report size
    (no matching commit)
  - [bpf-next,v9,16/23] HID: bpf: introduce hid_hw_request()
    (no matching commit)
  - [bpf-next,v9,17/23] selftests/bpf: add tests for bpf_hid_hw_request
    (no matching commit)
  - [bpf-next,v9,18/23] HID: bpf: allow to change the report descriptor
    (no matching commit)
  - [bpf-next,v9,19/23] selftests/bpf: add report descriptor fixup tests
    (no matching commit)
  - [bpf-next,v9,20/23] selftests/bpf: Add a test for BPF_F_INSERT_HEAD
    (no matching commit)
  - [bpf-next,v9,21/23] samples/bpf: add new hid_mouse example
    (no matching commit)
  - [bpf-next,v9,22/23] HID: bpf: add Surface Dial example
    (no matching commit)
  - [bpf-next,v9,23/23] Documentation: add HID-BPF docs
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


