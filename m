Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944F7437F11
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 22:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbhJVUF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 16:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234043AbhJVUF1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 16:05:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 438586103E;
        Fri, 22 Oct 2021 20:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634932989;
        bh=4+NjBqbDdmVRj6KAol82Rhnjdk6s05OpTgM9HKDvd0k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Bo0Z3tsdXfRHyWl7cr5ST78gEHbFo9ZOPhvPsmhZoI7vWDJ6zNvEMArDGwAsdsd77
         zd3mFJ1fTs62JZ9kd9vMZeMcCgvV98kq77tdPo/Qd2XkA9VYJRNHnszNKLC97Owutt
         b2OssetqGGIOoNNlNUsv/6W1kfO+f/Q7NuffHTsypFUfMe57pimNEfp9Dg9Ie/9agU
         nJpp9yxDiRqNqOVKVFXlzO5lLzJrE07NI5Xq9g7EmGqgaLbIk4gQNsiS1Pjqbwn1DM
         3xwbudcLoiDRU5yO0wMlHeK98zZwDrUdxPgS1hbkxkSaGsTKvVago4rvB9v7cNa5m7
         6xlAoKimUYHXQ==
Date:   Fri, 22 Oct 2021 13:03:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2021-10-21
Message-ID: <20211022130308.43487b40@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5e093d1aa26f0b442dd37c293ae57fcc837e448a.camel@sipsolutions.net>
References: <20211021154351.134297-1-johannes@sipsolutions.net>
        <163493100739.20489.10617693347363757800.git-patchwork-notify@kernel.org>
        <5e093d1aa26f0b442dd37c293ae57fcc837e448a.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Oct 2021 21:36:44 +0200 Johannes Berg wrote:
> On Fri, 2021-10-22 at 19:30 +0000, patchwork-bot+netdevbpf@kernel.org
> wrote:
> > This pull request was applied to netdev/net.git (master)
> > by Jakub Kicinski <kuba@kernel.org>:  
> 
> Thanks.
> 
> I have a patch or two that are for -next but depend on this, any chance
> of pulling net into net-next some time, perhaps after it goes to Linus?

You missed the previous PR by like 15 min :( 

Next one on Thursday, I think. Good enough?
