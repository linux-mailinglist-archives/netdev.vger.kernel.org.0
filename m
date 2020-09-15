Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3189226AA0D
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 18:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbgIOQqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 12:46:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbgIOQpR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 12:45:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D581D206B5;
        Tue, 15 Sep 2020 16:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600188259;
        bh=FF43z/S/NBT/IavELpr4EbShbFHrGJYWhIZciCWTM4k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jsj+OybbbMQaU6E6iDJkIcWOjHtilUEXDqeY1AQt06AsFFGkqwpAkVu84kxmG+Cu9
         ggw0lTqfn6NIyagisJA2ckytBQVu135QwD3HdWKrP/tffhTq//SokQkwzz59YKSdjh
         wyPd8vvlesrkvV0iCixPBAXzHNq7qmyggUpE7CJk=
Date:   Tue, 15 Sep 2020 09:44:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for
 Octeontx2
Message-ID: <20200915094417.077331cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CALHRZupiMFJXb6_Abd6qbyZJzjdpMCy_t+DWQs7zU9cXtuhWGA@mail.gmail.com>
References: <1599117498-30145-1-git-send-email-sundeep.lkml@gmail.com>
        <20200903121803.75fb0ade@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR18MB3298899BF15F266144EE8760C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
        <20200904083709.GF2997@nanopsycho.orion>
        <BY5PR18MB3298EB53D2F869D64D7F534DC62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
        <20200904121126.GI2997@nanopsycho.orion>
        <BY5PR18MB3298C4C84704BCE864133C33C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
        <20200904133753.77ce6bc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALHRZuoa8crCaOAkEqyBq1DnmVqUgpv_jzQboMNZcU_3R4RGvg@mail.gmail.com>
        <CALHRZuo9w=NJ4B6hw4afhoY21rAbqxBTZnLKN4+A=q21wNPPjQ@mail.gmail.com>
        <20200915091212.3b857f80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALHRZupiMFJXb6_Abd6qbyZJzjdpMCy_t+DWQs7zU9cXtuhWGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Sep 2020 22:06:45 +0530 sundeep subbaraya wrote:
> On Tue, Sep 15, 2020 at 9:42 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 15 Sep 2020 21:22:21 +0530 sundeep subbaraya wrote:  
> > > > > Make use of the standard devlink tracepoint wherever applicable, and you
> > > > > can keep your extra ones if you want (as long as Jiri don't object).  
> > > >
> > > > Sure and noted. I have tried to use devlink tracepoints and since it
> > > > could not fit our purpose I used these.  
> > >
> > > Can you please comment.  
> >
> > Comment on what? Restate what I already said? Add the standard
> > tracepoint, you can add extra ones where needed.  
> 
> We did look at using the devlink tracepoint for our purpose and found
> it not suitable for our current requirement.
> As and when we want to add new tracepoints we will keep this in mind
> to see if we can use the devlink one.
> 
> So was just checking if Jiri is okay with this.

Please make sure you adjust the To: field of the email to the person
you're asking your question.
