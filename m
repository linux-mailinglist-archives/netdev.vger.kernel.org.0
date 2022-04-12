Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6EE54FE2DF
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351146AbiDLNmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356213AbiDLNmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:42:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8882B3CFFD
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 671BAB81DA6
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 13:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD17BC385A1;
        Tue, 12 Apr 2022 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649770811;
        bh=lnsPiMK2LHfrggLzp7yKzUo+yfAApKGkmqktoHGP+qA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mc/FN0VAki2yGRYKITEijselpdWOI1BauZJazdeoU4JL9dzCk5oLBQ6QFx87YKv/A
         C6l+bZYyon7wBFg8O6yJHEvtmmpN3fXwO2F0ZAM3MNmHrAzsRmJ0kr4K7PA2nJ35Wl
         UDh4IzUkjOVjN0c0nFm+ojaHpTzoHmiAtEhDMsll08/2KDX4SdJYv3OkhhDujWRXDM
         nL+hLW9g4DERSiVMYIZIJsGIidwqQmDYmasZnQocMKQh9oCjIn1l7ix/0hcMGoT5os
         6JgOVjjaTcVU2Pz6yb2Z3SF1H32rCYUvKdy84bxjUIjMLI5KhHYMldhxvsD3lQJnSY
         vciZDqromQbzQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C0517E85D15;
        Tue, 12 Apr 2022 13:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] page_pool: Add recycle stats to
 page_pool_put_page_bulk
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164977081178.10572.6302484640806460134.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 13:40:11 +0000
References: <3712178b51c007cfaed910ea80e68f00c916b1fa.1649685634.git.lorenzo@kernel.org>
In-Reply-To: <3712178b51c007cfaed910ea80e68f00c916b1fa.1649685634.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        ilias.apalodimas@linaro.org, jbrouer@redhat.com, jdamato@fastly.com
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

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 11 Apr 2022 16:05:26 +0200 you wrote:
> Add missing recycle stats to page_pool_put_page_bulk routine.
> 
> Reviewed-by: Joe Damato <jdamato@fastly.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v1:
> - rebase on net-next
> 
> [...]

Here is the summary with links:
  - [v2,net-next] page_pool: Add recycle stats to page_pool_put_page_bulk
    https://git.kernel.org/netdev/net-next/c/590032a4d213

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


