Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9D2282502
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 17:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgJCPP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 11:15:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgJCPP2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Oct 2020 11:15:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D12CE206DD;
        Sat,  3 Oct 2020 15:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601738128;
        bh=9t6as+urdRJ6MzZpbpcJfqNvZlzwAubnCZY1DXiZKyw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YrQSf4bnATjgRDyhXdxGQJ+0xt3CZqI+0wAiWgjXW1PTAWkze5YCPDs/NA9pZWGMu
         IXMySVC7WbF5N0cKnnSavPdK5uSZro1dLvjdHyMHMQ6j8OJW0z47m/7e9buO+2WNoR
         Y1BgBgSa73QdazmlGvROQ+80ijHmyCZTD8VMi0ZM=
Date:   Sat, 3 Oct 2020 08:15:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v3 0/5] genetlink per-op policy export
Message-ID: <20201003081526.0992c2a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201003084446.59042-1-johannes@sipsolutions.net>
References: <20201003084446.59042-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  3 Oct 2020 10:44:41 +0200 Johannes Berg wrote:
> Here's a respin, now including Jakub's patch last so that it will
> do the right thing from the start.
> 
> The first patch remains the same, of course; the others have mostly
> some rebasing going on, except for the actual export patch (patch 4)
> which is adjusted per Jakub's review comments about exporting the
> policy only if it's actually used for do/dump.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
