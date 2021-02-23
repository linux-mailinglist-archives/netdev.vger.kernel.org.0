Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87284323226
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 21:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbhBWUbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 15:31:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233534AbhBWUbg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 15:31:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80D2864DE8;
        Tue, 23 Feb 2021 20:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614112256;
        bh=zv1pBULb175f+7lCB54xQsmpuLu/Xrnd8ZnnugR62T4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GFPlvdXPazzzn8CHQqmO+1S6pm8EdK3OYXLMG/wldUzBu6ZYooSo9r19RdrC1OmgY
         4Ej3Zm2ckAYx3cBCazZ5BlMtz6wDTgMc7pQp28nFPcbqaO6/Lv2iKSY+5rJUHJ+ubT
         vi1hUFSHcbBJDOSrO35aA8Nmf+mUlFXu4+Jd57U5ibln7Isywv+f8adRZ/6yaVxM30
         N+MR0iIGrAl4T35/YHr/Ycq7gN0LownEbW+Qs69AiheCzWkVgisbHltu2unAsD4egj
         Dly6t2OaCAw6Eo3oa6mixmhHrN2tuV+YYDUeEm3lo9v5qX4wLQQ2Ub3d2X790J9AjN
         ToLJdXTeh8Lng==
Date:   Tue, 23 Feb 2021 12:30:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     andy.shevchenko@gmail.com, davem@davemloft.net, axboe@kernel.dk,
        herbert@gondor.apana.org.au, viro@zeniv.linux.org.uk,
        dong.menglong@zte.com.cn, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next] net: socket: use BIT() for MSG_*
Message-ID: <20210223123052.1b27aad1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210217065427.122943-1-dong.menglong@zte.com.cn>
References: <20210217065427.122943-1-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Feb 2021 14:54:27 +0800 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> The bit mask for MSG_* seems a little confused here. Replace it
> with BIT() to make it clear to understand.
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>

# Form letter - net-next is closed

We have already sent the networking pull request for 5.12 and therefore
net-next is closed for new drivers, features, code refactoring and
optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after 5.12-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
