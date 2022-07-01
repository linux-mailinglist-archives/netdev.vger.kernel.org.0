Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F2756295B
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 05:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbiGADFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 23:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiGADFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 23:05:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AB122508;
        Thu, 30 Jun 2022 20:05:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60F0662198;
        Fri,  1 Jul 2022 03:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F737C34115;
        Fri,  1 Jul 2022 03:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656644699;
        bh=i3hgOZOxSxqlECP9IZ9Mlbbt3+nMSlh2ktv5N+3PSIo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e/ID69iDvBt0Jy1fw7kCci79zjX6y9efR33rb0FzFI3qu/HKesNLZhnTPema7ibEs
         A9sia4X9ipyOEIpPH45FP/WtqiGOleeA1CgEAGQxAZncBuqMpd7ZSgJETpK0oCPrgi
         ONjUYP0ecB/T0DuSb5lP52Q1o5oLUs/YRcl+yQvAQvYIY/X3ElCxHVvLX8X/9hoRiv
         +rq5WffZ94Y6euz407xBI5L600YrZw5Chccm2uw04xAtO71XETQfzXsch6/3n08Oip
         SL1epYB4S4MgQH23N04c1Da2/wHPwNPFUN80fHGPQV4LS/IPoiwWqrQ5M4ZLH+7/5E
         EzQH4I/anZbFQ==
Date:   Thu, 30 Jun 2022 20:04:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     qiangqing.zhang@nxp.com, davem@davemloft.ne, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethernet/freescale:fix repeated words in comments
Message-ID: <20220630200458.707053ab@kernel.org>
In-Reply-To: <20220629124656.55575-1-yuanjilin@cdjrlc.com>
References: <20220629124656.55575-1-yuanjilin@cdjrlc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jun 2022 20:46:56 +0800 Jilin Yuan wrote:
> -		/* Write the next next compare(not the next according the spec)
> +		/* Write the next compare(not the next according the spec)

This one may be on purpose, given the clarification in the brackets.
