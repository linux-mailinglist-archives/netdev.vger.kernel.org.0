Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235FC2B6D4E
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 19:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgKQS1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 13:27:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:34700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbgKQS1Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 13:27:24 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD3C42222E;
        Tue, 17 Nov 2020 18:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605637644;
        bh=XoB/GL3SDYfmCrX8LR/Z72B2KpAhnqguEgUXNbE0dYM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eyh1V7vPuFr2VJi2MdRt9qmP3AWBjaQ3wvHyzh0YtRhCGNEJvYTPFaloHGYWhRWWm
         AYoOoNYOAvkayqNR6WEoy81uXvY4VJDLksHmGyHDthvfQXoldAk3WXnSXyCNHBvlYL
         4pDAN7matYC+idmUU0e9tRkQXLjnE2PUIOcbYmT0=
Date:   Tue, 17 Nov 2020 10:27:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 0/3] net: dsa: tag_dsa: Unify regular and
 ethertype DSA taggers
Message-ID: <20201117102722.33765ba7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201114234558.31203-1-tobias@waldekranz.com>
References: <20201114234558.31203-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Nov 2020 00:45:55 +0100 Tobias Waldekranz wrote:
> The first patch ports tag_edsa.c's handling of IGMP/MLD traps to
> tag_dsa.c. That way, we start from two logically equivalent taggers
> that are then merged. The second commit does the heavy lifting of
> actually fusing tag_dsa.c and tag_edsa.c. The final one just follows
> up with some clean up of existing comments.

Applied, thanks everyone!
