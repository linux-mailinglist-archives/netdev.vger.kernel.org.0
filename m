Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925DB52D9C0
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 18:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241699AbiESQEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 12:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241696AbiESQEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 12:04:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5534B57141;
        Thu, 19 May 2022 09:04:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAFACB82565;
        Thu, 19 May 2022 16:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54514C385AA;
        Thu, 19 May 2022 16:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652976286;
        bh=iPDR8ilYnB0nQ/+DloDpPTckk5aU+JgBRjXXuvvCOU0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ioKmLWqYWb5T4vQheOFYhBXmeEfT+D6wbQq3/nX/En3LMbTIWAosJc85cz9G4GQvS
         xQmGyO989l0y4aikRzsSXtDeTRL7rggut2MgygnQwZ4xhvzzKihn9xU5AoQEcOmf7D
         /qEz3nXbTylufHiDgmxOlFEDDHS/Y0sROWTwyMgyLc6lNTG5zhkf6WLbZH/RJon5ou
         nknb+Kx4JA4RQhwqTVHomgPKE3gqOkWdc4Gmoslr9umlzb0OUXsoTvUcyOF+re0yqM
         anz/v92KdCmrKZ1cYwwUFL5AJv7ydS9PVW862h86Qi59Bml5BUEnATwJXRYBZQ1l3o
         oEQXxdARH5dSg==
Date:   Thu, 19 May 2022 09:04:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Carlos Fernandez <carlos.fernandez@technica-engineering.de>
Cc:     Carlos Fernandez <carlos.escuin@gmail.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] Retrieve MACSec-XPN attributes before offloading
Message-ID: <20220519090444.3cd14244@kernel.org>
In-Reply-To: <AM9PR08MB678803198E0EA09F9AD1AA7DDBD09@AM9PR08MB6788.eurprd08.prod.outlook.com>
References: <20220518085745.7022-1-carlos.fernandez@technica-engineering.de>
        <20220518090151.7601-1-carlos.fernandez@technica-engineering.de>
        <20220518092326.52183e77@kernel.org>
        <AM9PR08MB678803198E0EA09F9AD1AA7DDBD09@AM9PR08MB6788.eurprd08.prod.outlook.com>
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

On Thu, 19 May 2022 07:43:43 +0000 Carlos Fernandez wrote:
> Where should I rebase it? Thanks.

Oh, not where - on what. Check out the master branch of this tree:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/

git cherry-pick the patch on top of it, resolve the conflicts if any,
make sure it still works, git format-patch, git send-email..
