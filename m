Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97BD596775
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 04:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238186AbiHQCgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 22:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238055AbiHQCgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 22:36:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1041073937;
        Tue, 16 Aug 2022 19:36:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D24161484;
        Wed, 17 Aug 2022 02:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F09C433C1;
        Wed, 17 Aug 2022 02:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660703799;
        bh=rC6nEgbK0M0wRDxyTi7pIfC7J1t7mM91s18n4Tr2kdU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oJdARAMALbRbkSIWY6pARxQ6ZvJBXB6UP2pyxEziKTuxEKAHKy/M7cNHo4PjSWF6c
         71MXHFWxQl4c3kpY+gnAOk1YIigU3BBOzDZVPNN/32k6YsW1gGSSPYzWAkE/4fWTVw
         ChV8wt2tyq0ReBFObynm0aoGCTt1Z+C/LxDun/Dta1f/gLkbUdN9O3hRDC5EKpuozi
         E+T5hiGO9VGDA6Lw6JiBYdr/mdszZ+lzDbmehLmMX+fjdx+m6Z+uw3OST/koXhfg0h
         R3VfhvQTnhN5kRbTBP2E4J/y7rJedKoIe1iMNpNamJtCteK4ufZUlgbyxY36FycNbB
         6vcECDvwx4hpA==
Date:   Tue, 16 Aug 2022 19:36:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     paulus@samba.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ppp: fix repeated words in comments
Message-ID: <20220816193638.31791cb1@kernel.org>
In-Reply-To: <20220814092255.53629-1-yuanjilin@cdjrlc.com>
References: <20220814092255.53629-1-yuanjilin@cdjrlc.com>
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

On Sun, 14 Aug 2022 17:22:55 +0800 Jilin Yuan wrote:
>  	 * This ensures that we have returned from any calls into the
> -	 * the channel's start_xmit or ioctl routine before we proceed.
> +	 * channel's start_xmit or ioctl routine before we proceed.

It's better to remove the 'the' at the end of the line.
Generally accepted typography rules are that the articles 
(a, an, the) should not be followed by a line break.
