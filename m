Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111E567F5D0
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 08:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbjA1Hzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 02:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjA1Hzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 02:55:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8590333455;
        Fri, 27 Jan 2023 23:55:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28A78B81222;
        Sat, 28 Jan 2023 07:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C9AC433D2;
        Sat, 28 Jan 2023 07:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674892538;
        bh=rkOGxqS6JWEbGTvB5xcRGou0RuWwwqwNrM56UiBtJwc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LOHc4kZ6kuY3uJpUfzLMKac+h2Wvr15cpGFujFa9z5inhOii48xw0tckDBA50YW0K
         ReHTYW7O97vqjRtiXeTHyz2jmtB4Po/PRhvYiWI0D1ZqNQZ0X9hqtzz+2SNwQVK9aF
         6pAzCDPi087xuMvzX7B7IJHX1yQaM6VcS3+tJkQQ3VO3ZCK6ePR9aoM6gW+NLNdWaI
         4ivLnaj1deSC5cIA9+4uRF7ImMCjoP7jF5mRH7SVazCLTzxjCEa4BcYHdKGjx7QrDy
         jW6llpq/jN8R8gdJeCUYXKBipU44IuLMMOVL5stv7AQ3XezJT1SW93y9gWzIqu9dlT
         k0XPqkz0Xh8yw==
Date:   Fri, 27 Jan 2023 23:55:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2023-01-28
Message-ID: <20230127235535.684cae41@kernel.org>
In-Reply-To: <167489221874.30137.5005634055300425754.git-patchwork-notify@kernel.org>
References: <20230128004827.21371-1-daniel@iogearbox.net>
        <167489221874.30137.5005634055300425754.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Jan 2023 07:50:18 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> Here is the summary with links:
>   - pull-request: bpf-next 2023-01-28
>     https://git.kernel.org/netdev/net/c/0548c5f26a0f

The bot's still matching on wrong PRs. I'll push this one shortly.
