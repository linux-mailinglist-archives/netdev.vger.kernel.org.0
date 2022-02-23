Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923B44C0ADB
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 05:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbiBWEQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 23:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiBWEPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 23:15:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2F44091E
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 20:15:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF5CDB81E7A
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 04:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A241C340E7;
        Wed, 23 Feb 2022 04:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645589719;
        bh=+BciX6m7Je9XCtGfOBhhm+pciSBR6V+ACfuibyfe65w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tMOlr9w9wUJmJcyB1AYGVYYLKujSlhlUSw0iKnAigmerdUg6t6H28sdzxIHS0N57v
         cItl8AgW4D3IY4S1gP316l5bjvHZIQQZbvFJnTxAuMcrM7qKISFiQEIov+S+t3Rwjk
         D52YXs+rXnqZ5GwfwXvb9L865B4YwwP7iJM91mRx0FyUnvpGPFBEK9X2vtynRUw0d0
         MDpc/EqLvKQ8utvqR0PiDy3q4zPIRaZtc6bJqGlAEuA96iXfX8kOtAQKT/onhUUM0n
         K4RvZzOtkcnUvjaADwhw3fPinlptGYjAaayZrPL+5YdmSqMvwVjjhASNHicwD9OotO
         lE40ep4xV6bPw==
Date:   Tue, 22 Feb 2022 20:15:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, elver@google.com, edumazet@google.com
Subject: Re: [PATCH net-next 0/2] tcp: take care of another syzbot issue
Message-ID: <20220222201518.37122ca8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <164558941044.26093.15086204600598443366.git-patchwork-notify@kernel.org>
References: <20220222032113.4005821-1-eric.dumazet@gmail.com>
        <164558941044.26093.15086204600598443366.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Feb 2022 04:10:10 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
>   - [net-next,2/2] net: preserve skb_end_offset() in skb_unclone_keeptruesize()
>     (no matching commit)

I dropped the extra new lines around the body of
skb_unclone_keeptruesize()
