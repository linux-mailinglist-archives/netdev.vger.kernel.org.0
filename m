Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB37E30FD8B
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 21:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239889AbhBDUAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 15:00:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:32912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239891AbhBDT7S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 14:59:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A98364F38;
        Thu,  4 Feb 2021 19:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612468717;
        bh=u+6crpBq8Oq+sKoX2+GL7qm2xUVPXcP6Fd0cRAAhjTo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=thG8nnM8kWSZZ6YCcjlM1YxV5z+hcu7V9AGSlulpk7hYJKGuIrjzmYEtlHqawB0h3
         o/P7rGZ3RmEI0AWse9EqKBt6/vfUpn2fwXxSUhn/OcUMsuGNaZy6JeFd2ZheAADfhu
         RpDfDNtfFjysfU3i7icFO1e2bi4yFj9W9wSHpjkd7XpJLVMHEqLaxGtHz+WIaw3NUM
         E/ipcTqPNAtP7/B0y2YXRX4uesSZOkYDiLe1NpngL4Nt2fSnrBlu9xnstj0LgKnDXK
         6qWXDD3Nc9LWvoz+lOKJmrlzCKyUxgydqbQs8ol9Bysrz2iFufwHbIOvIjKEucUqPL
         9VFXUupaVB29Q==
Date:   Thu, 4 Feb 2021 11:58:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     Simon Wunderlich <sw@simonwunderlich.de>, davem@davemloft.net,
        netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 2/4] batman-adv: Update copyright years for 2021
Message-ID: <20210204115836.4f66e1c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3636307.aAJz7UTs6F@ripper>
References: <20210202174037.7081-1-sw@simonwunderlich.de>
        <20210202174037.7081-3-sw@simonwunderlich.de>
        <20210203163506.4b4dbff0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3636307.aAJz7UTs6F@ripper>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 04 Feb 2021 08:54:33 +0100 Sven Eckelmann wrote:
> On Thursday, 4 February 2021 01:35:06 CET Jakub Kicinski wrote:
> [...]
> > Is this how copyright works? I'm not a layer, but I thought it was
> > supposed to reflect changes done to given file in a given year.  
> 
> <irony>Because we all know that the first thing a person is doing when 
> submitting a change is to update the copyright year.</irony>
> 
> So we have either the option to:
> 
> * not update it at all (as in many kernel sources)
> * don't have it listed explicitly (as seen in other kernel sources)
> * update it once a year
> 
> I personally like to have a simple solution so I don't have to deal with this 
> kind of details while doing interesting things. The current "solution"
> was to handle the copyright notices year for the whole project as one entity - 
> once per year and then ignore it for the rest of the year.

Back when I was working for a vendor I had a script which used git to
find files touched in current year and then a bit of sed to update the
dates. Instead of running your current script every Jan, you can run
that one every Dec.

> And I would also prefer not to start a discussion about the differences 
> between the inalienable German Urheberrecht, pre 1989 anglo-american 
> copyright, post 1989 anglo american copyright and other copyright like laws.

No need, we can depend on common sense. I hope you understand that a
pull request which updates 8 lines of code, mostly comments, and then
contains a version bump + 57 lines of copyright bumps is very likely 
to give people a pause, right?

If you strongly prefer the current model please add appropriate commit
messages justifying it and repost. Right now patch 1 and 2 have none.
