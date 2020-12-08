Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602DD2D20DF
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 03:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbgLHCeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 21:34:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:38700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgLHCeP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 21:34:15 -0500
Date:   Mon, 7 Dec 2020 18:33:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607394814;
        bh=L1inc/gdZ9IcX+sWcTGuhNwxVCQ2Pxbuyoll3ANSwtQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=WnGVW2Jh2ePCQ8C5IRBinhJWB2l+YMKfT586aH0gTvbm+RJOz3SiQTYwMH+Jnup1b
         MQPeVQH4GXH+Wd29KbFGs6jM+V5Ukba9wotewG67E/sP8ZcRrQhLcOd0v0DtrY3wFz
         GxKBCuS+2kBTh14IWx7UQ3Kz6gfIX7F8eAW/5FJyqz9fiGHO0SsJ56qg87O0R1jiEB
         0K2h+7G8Ivp31j+BvZaNacFYw2hptZojgR616yYbOI7grOUYtrqMItp8XtZWqoHhmF
         cI6obONCwbVo85Fq2/HeMqF/O44mmo9EAJHv5pvzuDAJbK9bva9bx3xzQwVg/5KdEY
         ICYuGuoDLFmVA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>
Subject: Re: pull request (net): ipsec 2020-12-07
Message-ID: <20201207183333.07a991d4@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201207093937.2874932-1-steffen.klassert@secunet.com>
References: <20201207093937.2874932-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Dec 2020 10:39:33 +0100 Steffen Klassert wrote:
> 1) Sysbot reported fixes for the new 64/32 bit compat layer.
>    From Dmitry Safonov.
> 
> 2) Fix a memory leak in xfrm_user_policy that was introduced
>    by adding the 64/32 bit compat layer. From Yu Kuai.

Pulled, thank you!
