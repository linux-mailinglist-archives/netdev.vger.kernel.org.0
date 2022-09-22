Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A57C5E58B0
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 04:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiIVCkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 22:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiIVCkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 22:40:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669D69AFCE;
        Wed, 21 Sep 2022 19:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE707B833F5;
        Thu, 22 Sep 2022 02:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E763C433C1;
        Thu, 22 Sep 2022 02:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663814415;
        bh=pCK1mKDA5rYstwX51BC9V1ecQPoxBA7MiLn9jkmCr1k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DDVCEtjVptOwmPBu6/Ukvxv51vnZZHGDe/OGkS/4E30wHPp/PIQyU/72F/M7CADr1
         TM+sn+O/k43+YyH3Drcur2x1Vlt4V/9rbBncyBcTO5GvUT3hm8ZfEkZ/0iJbK0Ab0V
         LjcCRNZMXYDt5naiU+9b06Jsa748qEl+BNKYCGsaC5a+RLD1KIIq3U2Suplipd6msz
         CwK7nS+m3h89Cu1xf34pMOExK3TyhL0rTOg5DIyseGPoiCD9pfVJrlOOMH64AlnfAE
         Kf9PjE7KIzAFTUYq3dYIz1X17ezanNNy0yriIX2fJyZ60v9ENT8K6IUI6ruuejjuGQ
         bzXe+B7xxLKVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A22BE4D03D;
        Thu, 22 Sep 2022 02:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 bpf-next 0/3] Introduce bpf_ct_set_nat_info kfunc helper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166381441549.2980.4403940314525769490.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 02:40:15 +0000
References: <cover.1663778601.git.lorenzo@kernel.org>
In-Reply-To: <cover.1663778601.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Wed, 21 Sep 2022 18:48:24 +0200 you wrote:
> Introduce bpf_ct_set_nat_info kfunc helper in order to set source and
> destination nat addresses/ports in a new allocated ct entry not inserted
> in the connection tracking table yet.
> Introduce support for per-parameter trusted args.
> 
> Changes since v2:
> - use int instead of a pointer for port in bpf_ct_set_nat_info signature
> - modify KF_TRUSTED_ARGS definition in order to referenced pointer constraint
>   just for PTR_TO_BTF_ID
> - drop patch 2/4
> 
> [...]

Here is the summary with links:
  - [v3,bpf-next,1/3] bpf: Tweak definition of KF_TRUSTED_ARGS
    https://git.kernel.org/bpf/bpf-next/c/eed807f62610
  - [v3,bpf-next,2/3] net: netfilter: add bpf_ct_set_nat_info kfunc helper
    https://git.kernel.org/bpf/bpf-next/c/0fabd2aa199f
  - [v3,bpf-next,3/3] selftests/bpf: add tests for bpf_ct_set_nat_info kfunc
    https://git.kernel.org/bpf/bpf-next/c/b06b45e82b59

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


