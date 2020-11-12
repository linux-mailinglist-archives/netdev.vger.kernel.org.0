Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF2A2B09FF
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgKLQbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:31:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbgKLQbt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 11:31:49 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7414720B80;
        Thu, 12 Nov 2020 16:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605198708;
        bh=8AAKaDUnWO2jiDCb3yy9I9GOzwRfrMIuvuh6Bmv7C8s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ig64Y7JYq8CaEcNJ8gohUOckN7Tc5wiYzmgMwQS5jOyBNk6eqqgf8AIPkq7Kzje75
         yxC9zqgYCvpL/tOX52zv4mc9LgBWcDM9weZJK6mbuxsPEnb3yzDR43FT8SFtweGHNi
         bCYb1E7KsRR+xNqajovuwQaoB/QipE4BttWh0RJ4=
Date:   Thu, 12 Nov 2020 08:31:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next RFC] MAINTAINERS: Add Martin Schiller as a
 maintainer for the X.25 stack
Message-ID: <20201112083147.186e0750@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJht_EOU+=nwJ5qqPHozqqvUn9dkrN37WnPk6p3hxdJDhHTAHA@mail.gmail.com>
References: <20201111213608.27846-1-xie.he.0141@gmail.com>
        <7baa879ed48465e7af27d4cbbe41c3e6@dev.tdt.de>
        <CAJht_EOU+=nwJ5qqPHozqqvUn9dkrN37WnPk6p3hxdJDhHTAHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 00:14:55 -0800 Xie He wrote:
> On Wed, Nov 11, 2020 at 11:06 PM Martin Schiller <ms@dev.tdt.de> wrote:
> > But I still think it is important that we either repair or delete the
> > linux-x25 mailing list. The current state that the messages are going
> > into nirvana is very unpleasant.  
> 
> Yes, I agree.
> 
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> sent an email to
> <postmaster@vger.kernel.org> for this issue on Aug 9th, 2020, but got
> no reply.
> 
> Maybe we need to ask Jakub or David for help.

Please resend, Aug 9th is around the time Dave had to step away so the
email probably got lost in transition.
