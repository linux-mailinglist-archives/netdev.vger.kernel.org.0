Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA114EA8FD
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 10:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbiC2IL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 04:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiC2ILy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 04:11:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CD921C
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 01:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AC6961585
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 08:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3973C340ED;
        Tue, 29 Mar 2022 08:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648541411;
        bh=bFSVhu30c9b1vmimtffMtnmpyHlAlWD3EY5mbJTkcNM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p3YkxHGhJpVD0kq+1a7oHBvb5h9MKqmKPiHasvpG59PNH9LdEAyPF+OIYAfiEHOBh
         urvjvC+oVQBrfjSUlN/z7w2lcFv6SnkAqynPeQEKD7t3qMaSbKXKrx5VA/Ic6jQYWO
         hS1tYFQ0DqBq0etlP2DnaZtajRiVNnINELmRgrLcqkDRoXHxv7TKPaRwffxL33ItDT
         Igo785QxOqw4DnC9MiqiNr3ceY5qzmPxkxN+c2xAHVeVkeO7ZolhKj5Uj53S9SpKEp
         g7RT8NoY5ujvICSNTDcxl50zuw9ol/6zZ9qyiO6FYscbkGFQ7E+HH5NUMjdBG5EyAu
         TZd6PFyheQJPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7702F03848;
        Tue, 29 Mar 2022 08:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] openvswitch: Fixed nd target mask field in the flow dump.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164854141087.9717.16731647759253990005.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Mar 2022 08:10:10 +0000
References: <20220328054148.3057-1-martinvarghesenokia@gmail.com>
In-Reply-To: <20220328054148.3057-1-martinvarghesenokia@gmail.com>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        martin.varghese@nokia.com
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

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 28 Mar 2022 11:11:48 +0530 you wrote:
> From: Martin Varghese <martin.varghese@nokia.com>
> 
> IPv6 nd target mask was not getting populated in flow dump.
> 
> In the function __ovs_nla_put_key the icmp code mask field was checked
> instead of icmp code key field to classify the flow as neighbour discovery.
> 
> [...]

Here is the summary with links:
  - [net] openvswitch: Fixed nd target mask field in the flow dump.
    https://git.kernel.org/netdev/net/c/f19c44452b58

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


