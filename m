Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569AE6137B8
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 14:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbiJaNUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 09:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJaNUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 09:20:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2A165BF
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 06:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8149B8168C
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 13:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63C69C43470;
        Mon, 31 Oct 2022 13:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667222415;
        bh=ZlAkKq9Lkt+JUfnp7o6kaxwqy1prlhM/ml0lYn+RTzA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ItAjaC3ZM1U1VrdltssLuadbSbN5KrkqUcHx+pZf/yBkML4LvnQnbgYG3bP1Mfxjs
         Rq1pMxoye5mLqIp7DD1O5sj6xsoPfur+u/DvNMaF4rO9satzhga7IVDzBRvdfBMZpP
         CgNSopwKQiEZa/QEtluSBiPVBrXk4Jr7uZ9z0QH/ww2GCQAKRnMMCE/ZHlO0+RzlSi
         qbbNIoBSVGH5Yas0pnUSxxePVn+W9018cYNwO+RpM2HpMMSVJY8gLKxqpkJMqdQnxw
         NDjAGl7CivLydett/Y2FpKZtUyGPkcxE0QKWbm4LpzSCcOPm4e411wNebtorXKMYQw
         a44YAKNUrJ5RA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4A25DE50D71;
        Mon, 31 Oct 2022 13:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 iproute2-next] taprio: support dumping and setting per-tc
 max SDU
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166722241529.20019.17797587305869019835.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Oct 2022 13:20:15 +0000
References: <20221028115053.3831884-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221028115053.3831884-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        stephen@networkplumber.org, vinicius.gomes@intel.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Fri, 28 Oct 2022 14:50:53 +0300 you wrote:
> The 802.1Q queueMaxSDU table is technically implemented in Linux as
> the TCA_TAPRIO_TC_ENTRY_MAX_SDU attribute of the TCA_TAPRIO_ATTR_TC_ENTRY
> nest. Multiple TCA_TAPRIO_ATTR_TC_ENTRY nests may appear in the netlink
> message, one per traffic class. Other configuration items that are per
> traffic class are also supposed to go there.
> 
> This is done for future extensibility of the netlink interface (I have
> the feeling that the struct tc_mqprio_qopt passed through
> TCA_TAPRIO_ATTR_PRIOMAP is not exactly extensible, which kind of defeats
> the purpose of using netlink). But otherwise, the max-sdu is parsed from
> the user, and printed, just like any other fixed-size 16 element array.
> 
> [...]

Here is the summary with links:
  - [v3,iproute2-next] taprio: support dumping and setting per-tc max SDU
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=b10a6509c195

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


