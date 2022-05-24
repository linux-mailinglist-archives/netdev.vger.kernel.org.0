Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99575533017
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 20:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240077AbiEXSJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 14:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbiEXSJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 14:09:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD9A6B016;
        Tue, 24 May 2022 11:09:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1E81B81A7A;
        Tue, 24 May 2022 18:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A46C34100;
        Tue, 24 May 2022 18:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653415749;
        bh=vWqEFZl3B4zvV9bFWqMm2SiFRvtsnc3w5Umh3YVfJy8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XevVXPQFwp2H17jcVEhtFnpLTpiZYEbA6JPf4pvq1bC/kji9TTumfNzMn8wOF0A2y
         VGQ3MR6oNAgmxG+KCh4tbQT4n7uZ996ott19VPEtWJfLjJsTUKGDepnR2Nqc/ANTOB
         Mngit0rX9Mv68cMcav25thigczHhJoEJmhGKuiV9nmtw8E8SgAcl/dwg8cseBwpWnV
         HxHzbw6mGg9EbbIT3F+3yh/RQVnorjz+WBPWpRyjERbeEOkJAbt/YvCQkX21tShaL1
         FMiv0Ho5mXphfvlpppKANknZVgtRNH3ZM7H4UWkTTXWxLi2y6nyZpa4bUCzAEp5VoA
         l6S82sL0WkRNA==
Date:   Tue, 24 May 2022 11:09:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Bartschies <thomas.bartschies@cvk.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.17 08/12] net: af_key: check encryption module
 availability consistency
Message-ID: <20220524110908.7a237987@kernel.org>
In-Reply-To: <20220524155929.826793-8-sashal@kernel.org>
References: <20220524155929.826793-1-sashal@kernel.org>
        <20220524155929.826793-8-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 May 2022 11:59:22 -0400 Sasha Levin wrote:
> From: Thomas Bartschies <thomas.bartschies@cvk.de>
> 
> [ Upstream commit 015c44d7bff3f44d569716117becd570c179ca32 ]
> 
> Since the recent introduction supporting the SM3 and SM4 hash algos for IPsec, the kernel
> produces invalid pfkey acquire messages, when these encryption modules are disabled. This
> happens because the availability of the algos wasn't checked in all necessary functions.
> This patch adds these checks.
> 
> Signed-off-by: Thomas Bartschies <thomas.bartschies@cvk.de>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I don't see anyone else complaining yet so let me step up.

Please drop this, it's getting reverted.
