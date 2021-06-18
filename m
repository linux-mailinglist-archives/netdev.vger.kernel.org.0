Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9373AD0B2
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 18:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbhFRQsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 12:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235740AbhFRQsD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 12:48:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4FB96127C;
        Fri, 18 Jun 2021 16:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624034753;
        bh=ZTtwHmqh0rQ3M2ho9c60I0q0eOzXiN2NKnpGl1n9jAs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R/HYr50FfFMgL8AT6+8hLyRxD/ZSJ4S2xb12SBGX3bFOa3uWO/saYDhlnVh86HZZi
         OPDTpRuYv/2ZQouGk4fRnlCJgkL18zxi+4aIaD64YAzf49WelDhz2fEAbY0JRP/RbJ
         VR1FI2PTAT6TbjogpFjK/WPi7QxmCYgwALtjhSbyhztW+Tjo7JUPS5dSdcGLjDT5A1
         w5OHX7Fe1IquhO1WW9ds+tBjdvFYugD7ejgElqSQwxbbOUSkwwTVmZzxfTyxYEvOV8
         s/Hgm/YM5MQ5/pN9z0oud2vd0ZPIKafP7cIaWCVfDbFVRZCpOjBzgT0HD4Wi/v2DQ0
         4WeLullrbJTJg==
Date:   Fri, 18 Jun 2021 18:45:45 +0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        David Hildenbrand <david@redhat.com>, Greg KH <greg@kroah.com>,
        Christoph Lameter <cl@gentwo.de>,
        Theodore Ts'o <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, netdev <netdev@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
Message-ID: <20210618184545.33ea3d47@coco.lan>
In-Reply-To: <20210618155829.GD4920@sirena.org.uk>
References: <b32c8672-06ee-bf68-7963-10aeabc0596c@redhat.com>
        <5038827c-463f-232d-4dec-da56c71089bd@metux.net>
        <20210610182318.jrxe3avfhkqq7xqn@nitro.local>
        <YMJcdbRaQYAgI9ER@pendragon.ideasonboard.com>
        <20210610152633.7e4a7304@oasis.local.home>
        <37e8d1a5-7c32-8e77-bb05-f851c87a1004@linuxfoundation.org>
        <YMyjryXiAfKgS6BY@pendragon.ideasonboard.com>
        <cd7ffbe516255c30faab7a3ee3ee48f32e9aa797.camel@HansenPartnership.com>
        <CAMuHMdVcNfDvpPXHSkdL3VuLXCX5m=M_AQF-P8ZajSdXt8NdQg@mail.gmail.com>
        <20210618103214.0df292ec@oasis.local.home>
        <20210618155829.GD4920@sirena.org.uk>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, 18 Jun 2021 16:58:29 +0100
Mark Brown <broonie@kernel.org> escreveu:

> On Fri, Jun 18, 2021 at 10:32:14AM -0400, Steven Rostedt wrote:
> > On Fri, 18 Jun 2021 16:28:02 +0200
> > Geert Uytterhoeven <geert@linux-m68k.org> wrote:  
> 
> > > What about letting people use the personal mic they're already
> > > carrying, i.e. a phone?  
> 
> > Interesting idea.  
> 
> > I wonder how well that would work in practice. Are all phones good
> > enough to prevent echo?  
> 
> Unless you get the latency for the WebRTC<->in room speaker down lower
> than I'd expect it to be I'd expect echo cancellation to have fun,
> though beam forming might reject a lot of in room noise including that -
> higher end modern phones are astonishingly good at this stuff.  I'd not
> trust it to work reliably for all attendees though, it's the sort of
> thing where you'll get lots of per device variation.

The local audience should be listening to the in-room audio, in order
to avoid echo. Also, all local mics should be muted, if someone is 
speaking from a remote location. 

Yet, echo is unavoidable if a remote participant is speaking while 
listening to the audio without headphones. If this ever happens, I
guess the moderator should cut the remote audio and ask the remote
participant to lower their speakers or use a headphone.


Thanks,
Mauro
