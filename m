Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212BB67A8CC
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbjAYCcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjAYCcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:32:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383234FCD2;
        Tue, 24 Jan 2023 18:32:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9E5761426;
        Wed, 25 Jan 2023 02:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A0DC433D2;
        Wed, 25 Jan 2023 02:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674613932;
        bh=f+2CFHZZc0a9JyAgM8ZSso1pkkcBn5OW93bruAAbCNY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OaxZk/ahbKBZVGlDGaherjADRJWa+Uv+1aW5nhrgfWJeW5Awdy9nUffxjeHVS/34T
         gua+YF1gzvt75N06gSWDp85r7OW6srb39sINFRKGMCfgSJY1mk0UaVywZp6S2FCA4T
         Y/owkMH3E00X1/TUQdzPxPW93I/r4+0HLJzy8bCrUojMl+gkMQI0vMhK1nzNrgnp0R
         e3cYzPUeh9l1mX4Vr4Zerb+uvqsQgtIYri6H8IqiY52SwHRXho9GxC9/BwPiWR54fZ
         D2P6QcsBGTcdsAmYHk34IaTWpJBDUOygaPYfeJm4NCTiYOkhu6H25upUUnOGwbG/9a
         UD6KDsUyOl0sg==
Date:   Tue, 24 Jan 2023 18:32:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>,
        Pietro Borrello <borrello@diag.uniroma1.it>
Subject: Re: [PATCH net] sctp: fail if no bound addresses can be used for a
 given scope
Message-ID: <20230124183211.14b73da5@kernel.org>
In-Reply-To: <Y9CUPsuuYgdr/g+s@t14s.localdomain>
References: <9fcd182f1099f86c6661f3717f63712ddd1c676c.1674496737.git.marcelo.leitner@gmail.com>
        <20230124181416.6218adb7@kernel.org>
        <Y9CUPsuuYgdr/g+s@t14s.localdomain>
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

On Tue, 24 Jan 2023 23:30:22 -0300 Marcelo Ricardo Leitner wrote:
> Lost in Narnia again, I suppose. :)

:D

> Ok, I had forgot it, but now checking, it predates git.
> What should I have used in this case again please? Perhaps just:
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Yup, just slap the initial commit ID on it. Let me add when applying.
