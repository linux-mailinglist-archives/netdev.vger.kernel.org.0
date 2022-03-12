Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3876D4D6B9A
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 02:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiCLBJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 20:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiCLBJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 20:09:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387C040A3F;
        Fri, 11 Mar 2022 17:08:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0E800CE2986;
        Sat, 12 Mar 2022 01:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD624C340E9;
        Sat, 12 Mar 2022 01:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647047315;
        bh=U/onqElJLVCJgmOdHzEApWa2fLZ6/41EGE/qkLVwDIY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oVWxPeY10MihDc5dQDd10a3b+aUm+22we0PVP+mSLZDy/E+sKx62XwfAhbObSfl0C
         /fOtzaRANS82elm/44PmU0pbDUWzTyK1laCFdsI3WIoq9eqmp0BBRDwlvu8pHXB051
         VD6dTRqVQf3Hh2XXCePg1OFmBlZSoMnAgzq9MzAYYanRB+Q/Uuj9a2e12Q+Ob8SRuY
         Mz9RAEw5mqKZDUpoW0vPrdqDqvVO7A3AeQunK0DTkJgiXt+xPI8w9rnYKxhZxpQsgR
         rwTqolsmVeD7YWJ+fQ4SwAkrbbsax1eRfCwWm+QMk7BveKXH2S7+yA4QnLafxF5HW1
         UI3lFmG2rd4wQ==
Date:   Fri, 11 Mar 2022 17:08:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2022-03-11
Message-ID: <20220311170833.34d44c24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220311170625.4a3a626b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220311124029.213470-1-johannes@sipsolutions.net>
        <164703362988.31502.5602906395973712308.git-patchwork-notify@kernel.org>
        <20220311170625.4a3a626b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 17:06:25 -0800 Jakub Kicinski wrote:
> Seems to break clang build.

No, sorry just some new warnings with W=1, I think.
