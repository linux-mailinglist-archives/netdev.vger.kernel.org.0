Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9ADC4CEE1B
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 23:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbiCFWNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 17:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiCFWNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 17:13:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E23F2612A
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 14:12:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC13160FA8
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 22:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6380C340EC;
        Sun,  6 Mar 2022 22:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646604732;
        bh=Vg4dg+rtnXwPXxFzIQ41Fx4epBxcehS/Bu7Z4cIzmXA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fOuQOc40xppJhSkTOioF4U7Q6Dn2jMdyVnE7XKLORst016QJcqwbwdfM9q8/oz+m7
         H9s1szundRyDYNkOYGu4gxiWDkYhA3HLtaefkrE1PcLMkf5tflDIpCORqctHFaaDnJ
         f9pXcyQQvNRiMa8FRE1HmfcwotzLNx6nr4qYAecI=
Date:   Sun, 6 Mar 2022 23:12:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH net-next 02/10] staging: Use netif_rx().
Message-ID: <YiUxuBxop3AtLmnw@kroah.com>
References: <20220306215753.3156276-1-bigeasy@linutronix.de>
 <20220306215753.3156276-3-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220306215753.3156276-3-bigeasy@linutronix.de>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 06, 2022 at 10:57:45PM +0100, Sebastian Andrzej Siewior wrote:
> Since commit
>    baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any context.")
> 
> the function netif_rx() can be used in preemptible/thread context as
> well as in interrupt context.
> 
> Use netif_rx().
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-staging@lists.linux.dev
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/staging/gdm724x/gdm_lte.c      | 2 +-
>  drivers/staging/wlan-ng/p80211netdev.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
