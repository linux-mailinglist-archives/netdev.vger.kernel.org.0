Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37AE5EB19D
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 21:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiIZTu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 15:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbiIZTu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 15:50:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCFA1CFE1
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 12:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC7B0B80DFA
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 19:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9BE26C43142;
        Mon, 26 Sep 2022 19:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664221817;
        bh=Fqitdjy+n+nmoOxyxM4FcPtygIQAMJEGi9v2k/po4vI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sOb5RxYqY393Xxb2v8S+EmUJu85HF2TAF44jw5KyVl4kxgypvI5g3B/e5qNmB1sJD
         qy8Hd7EoSod6+JcabzxcLSf9yC2A7O1IBpTvz/O0FJ14dQtbc+QF4CCWpiXD4PlNYU
         mzpeC/mbUADL5BMHrGLoypk0JPNO8H15Kv0TZPRxMJJtD8n4dC48hAQmjMaVpZJvbI
         SPkZYkYu3NN8EijgOJBYyRW4oKWzp9yJvOdBqYK06LnN6eHYOvc4XvX8ML0xNlQZXp
         pOLHzibLwWDaW2v3kUSTq+dTgH/idD8oowLO1HMOimLqiR27IvIzXYRK1W0HkQo2yy
         2GTt/dFqnsBjg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F311E21EC7;
        Mon, 26 Sep 2022 19:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: vertexcom: mse102x: Silence no spi_device_id
 warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166422181751.25918.8801231675209346207.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Sep 2022 19:50:17 +0000
References: <20220922065717.1448498-1-weiyongjun@huaweicloud.com>
In-Reply-To: <20220922065717.1448498-1-weiyongjun@huaweicloud.com>
To:     Wei Yongjun <weiyongjun@huaweicloud.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, stefan.wahren@i2se.com, weiyongjun1@huawei.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 22 Sep 2022 06:57:17 +0000 you wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> SPI devices use the spi_device_id for module autoloading even on
> systems using device tree, after commit 5fa6863ba692 ("spi: Check
> we have a spi_device_id for each DT compatible"), kernel warns as
> follows since the spi_device_id is missing:
> 
> [...]

Here is the summary with links:
  - [net-next] net: vertexcom: mse102x: Silence no spi_device_id warnings
    https://git.kernel.org/netdev/net-next/c/1bba1998bfd7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


