Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C656C360551
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbhDOJLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:11:24 -0400
Received: from honk.sigxcpu.org ([24.134.29.49]:60382 "EHLO honk.sigxcpu.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhDOJLY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 05:11:24 -0400
Received: from localhost (localhost [127.0.0.1])
        by honk.sigxcpu.org (Postfix) with ESMTP id E4307FB03;
        Thu, 15 Apr 2021 11:10:59 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at honk.sigxcpu.org
Received: from honk.sigxcpu.org ([127.0.0.1])
        by localhost (honk.sigxcpu.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6JjsF-OgtLbd; Thu, 15 Apr 2021 11:10:58 +0200 (CEST)
Date:   Thu, 15 Apr 2021 11:10:57 +0200
From:   Guido =?iso-8859-1?Q?G=FCnther?= <agx@sigxcpu.org>
To:     Chris Talbot <chris@talbothome.com>
Cc:     ofono@ofono.org, netdev@vger.kernel.org,
        debian-on-mobile-maintainers@alioth-lists.debian.net,
        librem-5-dev@lists.community.puri.sm, 982250@bugs.debian.org,
        985893@bugs.debian.org
Subject: Re: [Debian-on-mobile-maintainers] Forking on MMSD
Message-ID: <YHgDIeSPFNm6YWC+@bogon.m.sigxcpu.org>
References: <051ae8ae27f5288d64ec6ef2bd9f77c06b829b52.camel@talbothome.com>
 <634e0debea558b90af2cebfc99518071f1d630e9.camel@talbothome.com>
 <YHc0wV9wjT3WhfYW@bogon.m.sigxcpu.org>
 <d29aaa8b01d1342f9c51e1c68ea3870f6e7158f8.camel@talbothome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d29aaa8b01d1342f9c51e1c68ea3870f6e7158f8.camel@talbothome.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chris,
On Wed, Apr 14, 2021 at 02:46:30PM -0400, Chris Talbot wrote:
> Hello,
> 
> On Wed, 2021-04-14 at 20:30 +0200, Guido Günther wrote:
> > Hi,
> > On Wed, Apr 14, 2021 at 02:21:04PM -0400, Chris Talbot wrote:
> > > Hello All,
> > > 
> > > In talking to the Debian Developer Mr. Federico Ceratto, since I
> > > have
> > > been unable to get a hold of the Ofono Maintainers, the best course
> > > of
> > > action for packaging mmsd into Debian is to simply fork the project
> > > and
> > > submit my version upstream for packaging in Debian. My repository
> > > is
> > > here: https://source.puri.sm/kop316/mmsd/
> > > 
> > > I am sending this so the relavent parties are aware of this, and to
> > > indicate that I no longer intend on trying to get a hold of
> > > upstream
> > > mmsd to try and submit patches.
> > > 
> > > For the Purism Employees, I am additionally asking for permission
> > > to
> > > keep hosting mmsd on https://source.puri.sm/ . I have been
> > > extremely
> > > appreciative in using it and I am happy to keep it there, but I
> > > want to
> > > be neighboorly and ask if it is okay for me to keep it there. If it
> > > is
> > > not, I completely understand and I am fine with moving it to a new
> > > host.
> > 
> > Keeping your ofono version on source.puri.sm is certainly welcome!
> > Cheers,
> >  -- Guido
> > 
> > > 
> > > If you have any questions, comments, or concern, please reach out
> > > to
> > > me.
> > > 
> > > -- 
> > > Respectfully,
> > > Chris Talbot
> > > 
> > > 
> > > _______________________________________________
> > > Debian-on-mobile-maintainers mailing list
> > > Debian-on-mobile-maintainers@alioth-lists.debian.net
> > > https://alioth-lists.debian.net/cgi-bin/mailman/listinfo/debian-on-mobile-maintainers
> > > 
> Thank you for allowing me to keep hosting it there.

Great. If you really want to maintain a fork i'd consider renaming to
make that obvious (e.g. mm-mmsd) to avoid confusion within distros.

> Since it is now a fork, I added Mr. Ceratto, Mr. Farraris (a-wai), and
> Mr. Clayton Craft (craftyguy, a pmOS developer) as maintainers. Is
> there a wish for a Purism maintainer to be added as well?
I think sadiq and devrtz were the ones most involved so far but i think
working via MRs is fine since that allows to establish a workflow.

Cheers,
 -- Guido


> Respectfully,
> Chris Talbot
> 
