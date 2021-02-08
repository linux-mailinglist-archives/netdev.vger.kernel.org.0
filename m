Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772AE313CD4
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 19:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbhBHSKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 13:10:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235435AbhBHSGT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 13:06:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF08964E37;
        Mon,  8 Feb 2021 18:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807469;
        bh=2Omi58tsxQZBEa5HkDAgeInYsygbftc+VgCHiwLCKPg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Be+4Mgs4FBwhFixpXHiKlPdqHAYAnZQ0BZ9oRXNZ/NRDvi2BflgNzHb+wN5VtzGlv
         47jAZDt8DbU5ff/0ONtUD//AvdQKYpbQhPKq7iZWHMkdpwujL1A8A2tkYGsTg29n0t
         FodtgXWXm62iX07QzXfmlQcoWiQm5GwnhAKHM3PhEAP2b9ZFzZHr4PICI6FoWU97Ts
         0zonAOu1sjjVxk40DXEzYqTrdWKWcHMYzJVhtFi2ssH0GalglJFJZnsNffSIy3LXiC
         9yhfV8l08mYK/JYA9r13TLPiBsXwuNcAD//Up/ChoUt1ty5tNrOiikC/QQViUimu59
         4d7gSkDEdzSLg==
Date:   Mon, 8 Feb 2021 10:04:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, davem@davemloft.net,
        rppt@kernel.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH] drivers: net: ethernet: sun: Fix couple of spells in
 the file sunhme.c
Message-ID: <20210208100427.4708e1e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4134afc4-31d6-1b49-9b73-195a6d559953@gmail.com>
References: <20210205124741.1397457-1-unixbhaskar@gmail.com>
        <4134afc4-31d6-1b49-9b73-195a6d559953@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Feb 2021 15:00:01 +0000 Edward Cree wrote:
> On 05/02/2021 12:47, Bhaskar Chowdhury wrote:
> > 
> > 
> > s/fuck/mess/
> > s/fucking/soooo/
> > 
> > Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>  
> 
> Right or wrong, these are not "spelling fixes".
> Please do not misrepresent your patch in your Subject: line.
> (Also, subsystem prefix should probably just be "net: sunhme:".)

I think Steven already explained on the printf patch that the "obscene"
language rules apply to new code only, so I marked this as Rejected
silently.
