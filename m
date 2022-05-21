Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B6152F7A3
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 04:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354350AbiEUCkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 22:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiEUCkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 22:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198A318FF17;
        Fri, 20 May 2022 19:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6010A61E96;
        Sat, 21 May 2022 02:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9C3DC34100;
        Sat, 21 May 2022 02:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653100812;
        bh=Z66O7rrQMaC4hvVN0LSHrtN8tmpUIUMqge8osG6UzEQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H7f5QkZTrSHwWycJH9ickpZdrntgoWeYsMBea6lDVoGwq7G7faCGRmHrTf3Ikdlg0
         bvlwaC2fqxlYGBsSFzGosKSzdZ42FZ9+SrGa06rJWpz5GJjkNw6k8dE6JnUYUNl3Sj
         hGGBh+1sBzqIx0JtKBXdkXV1xw+/37xMEdpkHgm9TwdZO1VDhsPbOAmsW7addRyaNQ
         0Ew5n5Mv2BKeqkqqKHbnxif5CdIYZmeKWcMxn2PxU9z9OE5S4y4ww9aadwFO1Ed6B8
         gfjD3BEX9/rYqZF0UVQpq7Wkad0b85Yxy0751p/y8coFRR4wKyC6xA4E9tNZs1qjqo
         W7rGFBxSh3lCQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8D207F0389D;
        Sat, 21 May 2022 02:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v5 00/17] Introduce eBPF support for HID devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165310081257.14672.16026665563860628107.git-patchwork-notify@kernel.org>
Date:   Sat, 21 May 2022 02:40:12 +0000
References: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
In-Reply-To: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     gregkh@linuxfoundation.org, jikos@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, shuah@kernel.org, davemarchevsky@fb.com,
        joe@cilium.io, corbet@lwn.net, tero.kristo@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 18 May 2022 22:59:07 +0200 you wrote:
> Hi,
> 
> And here comes the v5 of the HID-BPF series.
> 
> I managed to achive the same functionalities than v3 this time.
> Handling per-device BPF program was "interesting" to say the least,
> but I don't know if we can have a generic BPF way of handling such
> situation.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v5,01/17] bpf/btf: also allow kfunc in tracing and syscall programs
    https://git.kernel.org/bpf/bpf-next/c/979497674e63
  - [bpf-next,v5,02/17] bpf/verifier: allow kfunc to return an allocated mem
    (no matching commit)
  - [bpf-next,v5,03/17] bpf: prepare for more bpf syscall to be used from kernel and user space.
    (no matching commit)
  - [bpf-next,v5,04/17] libbpf: add map_get_fd_by_id and map_delete_elem in light skeleton
    (no matching commit)
  - [bpf-next,v5,05/17] HID: core: store the unique system identifier in hid_device
    (no matching commit)
  - [bpf-next,v5,06/17] HID: export hid_report_type to uapi
    (no matching commit)
  - [bpf-next,v5,07/17] HID: initial BPF implementation
    (no matching commit)
  - [bpf-next,v5,08/17] selftests/bpf: add tests for the HID-bpf initial implementation
    (no matching commit)
  - [bpf-next,v5,09/17] HID: bpf: allocate data memory for device_event BPF programs
    (no matching commit)
  - [bpf-next,v5,10/17] selftests/bpf/hid: add test to change the report size
    (no matching commit)
  - [bpf-next,v5,11/17] HID: bpf: introduce hid_hw_request()
    (no matching commit)
  - [bpf-next,v5,12/17] selftests/bpf: add tests for bpf_hid_hw_request
    (no matching commit)
  - [bpf-next,v5,13/17] HID: bpf: allow to change the report descriptor
    (no matching commit)
  - [bpf-next,v5,14/17] selftests/bpf: add report descriptor fixup tests
    (no matching commit)
  - [bpf-next,v5,15/17] samples/bpf: add new hid_mouse example
    (no matching commit)
  - [bpf-next,v5,16/17] selftests/bpf: Add a test for BPF_F_INSERT_HEAD
    (no matching commit)
  - [bpf-next,v5,17/17] Documentation: add HID-BPF docs
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


