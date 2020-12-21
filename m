Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A3A2DFFDC
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 19:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgLUSeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 13:34:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgLUSeZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 13:34:25 -0500
Date:   Mon, 21 Dec 2020 10:33:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608575624;
        bh=Dtt7yMNifQ5yKw84JKxmXnlxVVM7//EwO7k2WiUNITk=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=UsP8ea21lBkAdHRtHInZZWWhB30a4VGlgIE+InIW2cQKyOVeD0LGQJkwZ7fG5Hf2p
         mu+TUhKz/GJXrxQZjmpOKZN4wHAr5Xze36Z68VvwxNS6NiFKSsoPdYpxKdPAVN1K2q
         9oikGoYZkhFjugKV56y1l9hLO3A/sTNgf39e1jVgNGecAtAJ7Zz8+adGKXdo01sJxH
         r/XSHFzJF8pSErotKhzVHixApTuv8zwH6eFm9c1i4bzRpE+epX+S1aEykbYQdI8IJu
         RZtXXnPSLyHiLmufl6wePNDeU2vkAay/32i4rlQw2gyvnqJpQjeic3OT5I8AbAqBi4
         Y+19ovvrrXogg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net] docs: netdev-FAQ: add missing underlines to
 questions
Message-ID: <20201221103343.632e2205@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87zh28op7r.fsf@tarshish>
References: <ccd6e8b9f1d87b683a0759e8954d03310cb0c09f.1608052699.git.baruch@tkos.co.il>
        <20201217103517.6ac75a97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87zh28op7r.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Dec 2020 10:29:12 +0200 Baruch Siach wrote:
> > I think this and the following fixes should be folded into a single
> > line (unless it's possible in RST for header to span multiple lines):
> >
> > I sent a patch and I'm wondering what happened to it - how can I tell whether it got merged?
> > --------------------------------------------------------------------------------------------
> >
> > To be honest I think we can also drop the Q: and A: prefixes now that
> > we're using RST.
> >
> > And perhaps we can add an index of questions at the beginning of the
> > the file?  
> 
> Sphinx creates side bar index of the questions in the HTML version. See
> 
>   https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html
> 
> Other formats provide other index methods.

Interesting. It doesn't render the questions in that bar when I build
locally with make htmldocs. But I see it on kernel.org, so I guess
that's what matters most.
