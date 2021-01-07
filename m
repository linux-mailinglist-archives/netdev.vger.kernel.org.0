Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69472ED53E
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbhAGROe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:14:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:52534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727673AbhAGROd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 12:14:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 371D222C9F;
        Thu,  7 Jan 2021 17:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610039633;
        bh=ZVeD39col6jONCCqdvgtIVCmR0m41a3iw2QJUE5Geso=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P3EsmxxZDZh+F/f5tlaofaJqMd5SBB6Zzx4Df/sO7K6IHNHmcW8nV6biybCNuPije
         phTg+dzw1zVcV5q/coL0nQTMcPoiAqBamR8K80XNlXKtYVPLkDsCki0KvVKrv2JcUw
         vV2G0R5N/lHvKIqiJdB8otQbbpRiDK8uOXnGtZ5I/1P1iPsUoZMxJqUpUjJ+IsUEtP
         iCGswzpdvUle21jW7H1NM1sJEf2egDy7U67pJfRlnRmgrkumx93nobtiruHy9g4QMx
         Lu5cn2+Yr8MO7qpOXgRe82PONDK1FmXrIQLxsv9+OLdkAyCbrXamQ5tzAfBTh3bHIh
         Wna+832kPIoSQ==
Date:   Thu, 7 Jan 2021 09:13:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2] tc: flower: fix json output with mpls lse
Message-ID: <20210107091352.610abd6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210107164856.GC17363@linux.home>
References: <1ef12e7d378d5b1dad4f056a2225d5ae9d5326cb.1608330201.git.gnault@redhat.com>
        <20210107164856.GC17363@linux.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jan 2021 17:48:56 +0100 Guillaume Nault wrote:
> On Fri, Dec 18, 2020 at 11:25:32PM +0100, Guillaume Nault wrote:
> > The json output of the TCA_FLOWER_KEY_MPLS_OPTS attribute was invalid.
> > 
> > Example:
> > 
> >   $ tc filter add dev eth0 ingress protocol mpls_uc flower mpls \
> >       lse depth 1 label 100                                     \
> >       lse depth 2 label 200
> > 
> >   $ tc -json filter show dev eth0 ingress
> >     ...{"eth_type":"8847",
> >         "  mpls":["    lse":["depth":1,"label":100],
> >                   "    lse":["depth":2,"label":200]]}...  
> 
> Is there any problem with this patch?
> It's archived in patchwork, but still in state "new". Therefore I guess
> it was dropped before being considered for review.

Erm, that's weird. I think Alexei mentioned that auto-archiving is
turned on in the new netdevbpf patchwork instance. My guess is it got
auto archived :S

Here is the list of all patches that are Archived as New:

https://patchwork.kernel.org/project/netdevbpf/list/?state=1&archive=true

Should any of these have been reviewed?

