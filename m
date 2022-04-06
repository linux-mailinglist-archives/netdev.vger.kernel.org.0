Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8D44F6A01
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 21:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiDFTen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 15:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiDFTeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 15:34:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49824216F8A;
        Wed,  6 Apr 2022 10:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD704B824E3;
        Wed,  6 Apr 2022 17:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63CC3C385A6;
        Wed,  6 Apr 2022 17:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649265612;
        bh=bCQGB0u5v44OC+IqUjXAgcJRjdQnsHHjN1iUEPhYK8k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W7oTstl4G4acgRkxfXpf0qPEpX1eA6h4/2al+5RPktvFKLYKWJv9fHUVmdWxXy8cX
         1ccVNKAViOjrQm/9AAl+hyt6izIYx5x9YeW+puQNVqpBtnxbbkE+79qSAQ+/8zU9Us
         UdI8T0Bv3bawFuypMECm8+6woESICJO1VS2H0RvpTgNKAaU9MVLOWxhQFljkzZxwaP
         sSRSNdDtbixoWKr1fqU3fkda7yWPfRChm2iz4aP+WTweQ/edJTrXe3b43RmfbS8cnx
         DANWj0hgxCYfiDhm0ZtLnF95WSaux6x24yG3YTuvKbkUMqDbde4vzXap37CoObL6LP
         xgFS2FpYDBKow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 481E5E8DBDD;
        Wed,  6 Apr 2022 17:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf/selftests: use bpf_num_possible_cpus() in
 per-cpu map allocations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164926561229.23950.7869141234456390467.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 17:20:12 +0000
References: <20220406085408.339336-1-asavkov@redhat.com>
In-Reply-To: <20220406085408.339336-1-asavkov@redhat.com>
To:     Artem Savkov <asavkov@redhat.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Andrii Nakryiko <andrii@kernel.org>:

On Wed,  6 Apr 2022 10:54:08 +0200 you wrote:
> bpf_map_value_size() uses num_possible_cpus() to determine map size, but
> some of the tests only allocate enough memory for online cpus. This
> results in out-of-bound writes in userspace during bpf(BPF_MAP_LOOKUP_ELEM)
> syscalls in cases when number of online cpus is lower than the number of
> possible cpus. Fix by switching from get_nprocs_conf() to
> bpf_num_possible_cpus() when determining the number of processors in
> these tests (test_progs/netcnt and test_cgroup_storage).
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf/selftests: use bpf_num_possible_cpus() in per-cpu map allocations
    https://git.kernel.org/bpf/bpf-next/c/ebaf24c589d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


