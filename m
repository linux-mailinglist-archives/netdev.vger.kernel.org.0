Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD9F3146AB
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 03:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhBIC5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 21:57:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229824AbhBIC5X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 21:57:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3278964E0B;
        Tue,  9 Feb 2021 02:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612839402;
        bh=uMYIAbC+VgGR2pGD5Ys5jNFLw2hFkPR6W1SjvPRQrS8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DdH8AnkYFZd2Ao8jazUqfVq2nH9ffTlMPu2+zlQ8WuGNFY1gCiRhIMi6jObZJ+iE+
         PDHh44qgEIhoM1paP/GwCzd7qvMdC47lOEOmE1Ud112q1uj3P4DY8BTrO+1E6TyEtk
         lFWEi6W6SrTiW3fVWwWZyZn6dhFxYWteHLqxhiqixAojbwW1PSKVuT0LTFEgxXDRH8
         12ca8qtqO3xtaS98V/1mE+1O5zKlX95VmZ/jsMa4PMyb823zfZzjpM5BW9WtVjy/j6
         1mueENZ14lcIBSY8BOywBELSknzdyKYyWmoQe54bZzALq+nczOWj0eAwhhxOOBxkNS
         GK5x2v/hh6U0Q==
Date:   Mon, 8 Feb 2021 18:56:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, dsahern@kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net-next 7/8] mld: convert ip6_sf_socklist to list
 macros
Message-ID: <20210208185641.70ef6444@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8e1d588c-e9a4-04d2-62c3-138d5af21a32@gmail.com>
References: <20210208175820.5690-1-ap420073@gmail.com>
        <8633a76b-84c1-44c1-f532-ce66c1502b5c@gmail.com>
        <CAMArcTVdhDZ-4yETx1mGnULfKU5uGdAKsLbXKSBi-ZmVMHbvfQ@mail.gmail.com>
        <8e1d588c-e9a4-04d2-62c3-138d5af21a32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Feb 2021 19:18:40 -0700 David Ahern wrote:
> On 2/8/21 7:05 PM, Taehee Yoo wrote:
> > Thanks, I understand why the arrays have been using.
> > I will send a v2 patch, which contains only the necessary changes.  
> 
> please send v2 as a patch series and not 8 individual patches + cover
> letter.

And if you use git send email please use --thread and
--no-chain-reply-to, so that the patches are all "in response" 
to the cover letter.
