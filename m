Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1EC50C4EE
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiDVX2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 19:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiDVX03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 19:26:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EBC939E2
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 16:02:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EA59B83309
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 23:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D71C385A4;
        Fri, 22 Apr 2022 23:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650668549;
        bh=nHfWXSZbsZP/gTWlRedXUyzXAc4owJyuVwLhv31nT/k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ONZ6fo4Z+1UUu0SRPXBskoaRitvLR7RISjh7gWHUQ0hlOmcOPr4g1VZ+z7RsdJRxo
         ntmfHlmkGolpN1tbEIXa7IjzdoNJxrqkrD/bUUkzhWfpZBebBtnVl+rrTuO8VImaCX
         Rr4vXJTBh5F7Yz5R1bjIUG+oHXHnwAWM5AltDk20VZkI8NzIIPghjVcAmJX75+74kZ
         D98IS8ukPf7iOb0hkM5b2D8uOts6EC8s/nhHPp7/wW+0Omv6m5UbF1Re5CFGxnWTvS
         OSZkFZ1KV59pLm5UOWOQgBwgDqrgJyHbdZQNGrV+f+eyrpWHZS6JFs+1gdJ735I2wQ
         BzgbqcECSKz1w==
Date:   Fri, 22 Apr 2022 16:02:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net 0/2] wireguard patches for 5.18-rc4
Message-ID: <20220422160228.46f9fe2f@kernel.org>
In-Reply-To: <20220421134805.279118-1-Jason@zx2c4.com>
References: <20220421134805.279118-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Apr 2022 15:48:03 +0200 Jason A. Donenfeld wrote:
> Hi Davekub,

YES :D

> Here are two small wireguard fixes for 5.18-rc4:

Missed the PR, sadly. Paolo was handling it and he's on EU time.
