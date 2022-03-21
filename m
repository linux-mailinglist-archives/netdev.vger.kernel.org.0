Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874574E1F08
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 03:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344171AbiCUCbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 22:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344168AbiCUCbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 22:31:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4336757B12;
        Sun, 20 Mar 2022 19:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7192B81062;
        Mon, 21 Mar 2022 02:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 816A8C340EE;
        Mon, 21 Mar 2022 02:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647829810;
        bh=kM4pAdRUerTimRuR7pRzFlmQ8d7hQ17c7SQgBjafwmc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IDkC6YEFBZYRjCxnDaEUdK9j7OkIgrTtG4lW2orET3v+cvZR7OkLeWYaMVlXAxyem
         zutqYR40ZnVdGjclS+R+hQZ0UuP3VgxCD3iIpytKbCs5OblqqkzkdhFMXMVKW5GQtn
         XS+Hh6c64UYdldrhaYEJk/Krl+d+Dob6u/8oIDVE9U2obSKb5XefyXow6AeLLc6GKf
         mrAJJkP2Hyrszdr6DUuT8QhvtUGrdBTXJkAn8ZzMeRPYHgXPlhPRg6LTRcmFPZQ4DQ
         IO0G3oG9zki1nmQC/u23LFYFzFFl1dQEosfNFnDduVwxHf1CWIB7GiApDVylZ/mITj
         JO5QcS8/pHu5w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 633BCF03846;
        Mon, 21 Mar 2022 02:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 1/2] bpf: Adjust BPF stack helper functions to accommodate
 skip > 0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164782981040.13314.15450443324560487136.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 02:30:10 +0000
References: <20220314182042.71025-1-namhyung@kernel.org>
In-Reply-To: <20220314182042.71025-1-namhyung@kernel.org>
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, acme@kernel.org,
        peterz@infradead.org, eugene.loh@oracle.com, haoluo@google.com
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 14 Mar 2022 11:20:41 -0700 you wrote:
> Let's say that the caller has storage for num_elem stack frames.  Then,
> the BPF stack helper functions walk the stack for only num_elem frames.
> This means that if skip > 0, one keeps only 'num_elem - skip' frames.
> 
> This is because it sets init_nr in the perf_callchain_entry to the end
> of the buffer to save num_elem entries only.  I believe it was because
> the perf callchain code unwound the stack frames until it reached the
> global max size (sysctl_perf_event_max_stack).
> 
> [...]

Here is the summary with links:
  - [v3,1/2] bpf: Adjust BPF stack helper functions to accommodate skip > 0
    https://git.kernel.org/bpf/bpf-next/c/ee2a098851bf
  - [v3,2/2] bpf/selftests: Test skipping stacktrace
    https://git.kernel.org/bpf/bpf-next/c/e1cc1f39981b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


