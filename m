Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086633F7F56
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 02:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbhHZAg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 20:36:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234589AbhHZAgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 20:36:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9D5761053;
        Thu, 26 Aug 2021 00:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629938138;
        bh=koghVnaubabP+D9Quos5WDi3pGtrqWdYTMW0UNejqjM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HnAmMbc8iVwnc88mETvM36p5tZ9GYlR42sscKBoBp7dpRqvzGMPv3TWDoMR8s2HSf
         wRPlMl1Pv3+j3Ie7VJ24ez5DJ57ute4yrkyq54Izq8t2rOyuJdBFPBEdSMuPkL5NW2
         TP7PozfROzN4srJU3ysLFlFO77BJizx3EQd4/kOUnbl3sbpuNHl/4TekWNt4jCKhqb
         q3q2O85we/onG2YDfQZ9KkZnjAA9qKcvf3t0Z+KuQ58e7NP3UzfcYfc2/YS3zgxN6B
         +Rgpa1I0m6AfFUCihXLjiDXfqGe+gxAr63pbCGLJvoNZljOuqhc8nWQRTKOWe4QxP4
         VaVVhaldw4FNg==
Date:   Wed, 25 Aug 2021 17:35:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     michael.chan@broadcom.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] bnxt: count discards due to memory
 allocation errors
Message-ID: <20210825173537.19351263@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210826002257.yffn4cf2dtyr23q3@skbuf>
References: <20210825231830.2748915-1-kuba@kernel.org>
        <20210825231830.2748915-4-kuba@kernel.org>
        <20210826002257.yffn4cf2dtyr23q3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Aug 2021 03:22:57 +0300 Vladimir Oltean wrote:
> 'Could you consider adding "driver" stats under RTM_GETSTATS,
> or a similar new structured interface over ethtool?
> 
> Looks like the statistic in question has pretty clear semantics,
> and may be more broadly useful.'

It's commonly reported per ring, I need for make a home for these 
first by adding that damn netlink queue API. It's my next project.

I can drop the ethtool stat from this patch if you have a strong
preference.
