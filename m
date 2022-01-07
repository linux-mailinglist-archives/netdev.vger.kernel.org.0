Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEF3487ABF
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 17:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348372AbiAGQve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 11:51:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34580 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348379AbiAGQvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 11:51:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 330EDB8265C
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 16:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EE7C36AEB;
        Fri,  7 Jan 2022 16:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641574288;
        bh=b1uN7lb7EJrtgoaY50WTQB/TCZCy/AQhhJC5rjcst4g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A/wmqPWfJ+ZKcLCxW8J1KKOv4yrVmWrmqifMMPzKQ47fbWqgsPWZgN4kiJ2zjgBOd
         J2bqkb4ZIh/ibDTM9xWf+jW8H5KcMXVCvci/vnAal6LFDU9thCrEccwJLwwjmWYmAJ
         NbQBMlZQbB+IKjUg08pdbRedCKxCfbGYn+KUrwNWXJTcictspCtIr14lgP8eMls78v
         EUimS/lkbtm/9QrM7FK+Nhn3++7Bmw5n8KEcozXykvCTwV7EIJh5DgNbVZiq0J7LDi
         b4HJr+5NK6YbpCQi3SA8I7HevlJ0z3TMhgO1khgvAGKryrI5lNbItSKHRhLgWnnBS5
         z1Jwc+ZLw2vUA==
Date:   Fri, 7 Jan 2022 08:51:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next] ptp: don't include ptp_clock_kernel.h in spi.h
Message-ID: <20220107085127.6cfaed55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <Ydhj3QP2VxXIWfZq@sirena.org.uk>
References: <20220107155645.806985-1-kuba@kernel.org>
        <Ydhj3QP2VxXIWfZq@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jan 2022 16:01:33 +0000 Mark Brown wrote:
> On Fri, Jan 07, 2022 at 07:56:45AM -0800, Jakub Kicinski wrote:
> > Commit b42faeee718c ("spi: Add a PTP system timestamp
> > to the transfer structure") added an include of ptp_clock_kernel.h
> > to spi.h for struct ptp_system_timestamp but a forward declaration
> > is enough. Let's use that to limit the number of objects we have
> > to rebuild every time we touch networking headers.  
> 
> Nack, this is a purely SPI patch and should go via SPI (and you've not
> even bothered to fix the subject line).  

Hold off unnecessary comments. If you want me to change something just
tell me rather than making vague references to following "the style for
the subsystem".

> It's already in my queue with that fixed.

What does it mean that it's in "your queue" is, it does not appear in
any branch of
ttps://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git/
Will this patch make 5.17?
