Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727692F577D
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbhANCAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729502AbhAMXh4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 18:37:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 618FD23382;
        Wed, 13 Jan 2021 23:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610580951;
        bh=kMN6bwNTKDjqwa/biS+hHVcNGvnlUMvax+6x4CKq7lo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KUL66VS067jPClBcEqJte4CVSlKrLS7Q5b/IAuTIq6ZxbfGKRUzNU5rBsrucVapRq
         lrfgwxfdQ8RXvCsS4MyNMIMQWjciis5LTsnZe5izXCJuQkIDBnAVh7TNnINknjWt89
         7Fz84nXOpVKobDu6eZBb8bZiitjidKVlP58p5KXolnGXFkW1qccqwrbUQJz+e8AAdv
         x1i96GIezukb3fKomr/xOemZ93QG9eX3Kgiak10GZ83jgfQoHl+rFXo+vSSZqtKaud
         X1xXe2mcl0Zkte1DmmxqRAzywXXenIVUmLts8IDAjGHlGGkR/hQFkeQMUUQwdBVdvD
         4krdffU4NjV3w==
Date:   Wed, 13 Jan 2021 15:35:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Yingjie Wang" <wangyingjie55@126.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sunil Goutham <sgoutham@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Linu Cherian <lcherian@marvell.com>
Subject: Re: [PATCH v2] af/rvu_cgx: Fix missing check bugs in rvu_cgx.c
Message-ID: <20210113153550.7b059d2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <355954d9.5264.176fbee1ed6.Coremail.wangyingjie55@126.com>
References: <1610417389-9051-1-git-send-email-wangyingjie55@126.com>
        <20210112181328.091f7cfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <355954d9.5264.176fbee1ed6.Coremail.wangyingjie55@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 21:27:35 +0800 (CST) Yingjie Wang wrote:
> Thanks for your reply.  I commit this change on linux-next/stable
> branch, and I use "git log --pretty=fixes" command to get the Fixes
> tag. I want to know if I need to make a change on any other branch
> and commit it?

For networking fixes net/master would be best, but my comment
wasn't about the tree, but about which commit is quoted in the Fixes
tag.

Maybe the maintainers will help us identify the right fixes tag.
CCing them now. Please make sure to always CC maintainers
(scripts/get_maintainer.pl should help you).

Marvell folks, FWIW this is the thread in the archive for context:
https://lore.kernel.org/lkml/1610417389-9051-1-git-send-email-wangyingjie55@126.com/
