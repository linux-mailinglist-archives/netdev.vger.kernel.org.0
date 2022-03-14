Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9774D8BDD
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243947AbiCNSiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243935AbiCNSiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:38:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028923EAB9;
        Mon, 14 Mar 2022 11:37:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BAF361047;
        Mon, 14 Mar 2022 18:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E71C340EE;
        Mon, 14 Mar 2022 18:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647283059;
        bh=i6hvK1nf9olXwiDwD/gZEUKxvHwF73M0NcmxSWvScJY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=laHtWw2WqjrzPsuCxXzsBT4vmD/SA4bgDRrl75odsdw+d3PcR80r//4DtPhRGFupp
         3JxZkCXTwOIFY6IoEkefsJwNPCvETforLkxE3PpieScjPVzeN7AykZfGwbm7g2C594
         OdKYvnD+hZrqclQz///J+Z/zzDxe+f2TFveoYFhCPCEvxo5WcOnwu0s05I5NfLsEn/
         wZTUNjJJ47vuKYyQbPT61efjBr7yLPp8MNcaZl+1p0AJtmKJei+hx+UFTid8GQT7TY
         iOSmVOMtooKJS5lpAGErMJA9o3VAM9oPhHYofYqH0iT5zGla67xl5HZVAdF1j80PM5
         mIRvXZ0HjtIuA==
Date:   Mon, 14 Mar 2022 11:37:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2022-03-11
Message-ID: <20220314113738.640ea10b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87sfrkwg1q.fsf@tynnyri.adurom.net>
References: <20220311124029.213470-1-johannes@sipsolutions.net>
        <164703362988.31502.5602906395973712308.git-patchwork-notify@kernel.org>
        <20220311170625.4a3a626b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220311170833.34d44c24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87sfrkwg1q.fsf@tynnyri.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 20:21:53 +0200 Kalle Valo wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> 
> > On Fri, 11 Mar 2022 17:06:25 -0800 Jakub Kicinski wrote:  
> >> Seems to break clang build.  
> >
> > No, sorry just some new warnings with W=1, I think.  
> 
> I have not installed clang yet. You don't happen to have the warnings
> stored someplace? I checked the patchwork tests and didn't see anything
> there.

Yeah.. patchwork build thing can't resolve conflicts. I wish there was
a way to attach a resolution to the PR so that the bot can use it :S

I was guessing what happened based on the result of the first thing
that got built after wireless-next was pulled but that thing itself
didn't build, hence my confusion. 

I say - don't worry about it. The non-W=1 build is clean which is what
matters the most.
