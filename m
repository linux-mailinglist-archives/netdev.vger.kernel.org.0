Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40CEDCBC06
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 15:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388714AbfJDNlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 09:41:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388270AbfJDNlU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 09:41:20 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CE0E87F75E;
        Fri,  4 Oct 2019 13:41:20 +0000 (UTC)
Received: from carbon (ovpn-200-24.brq.redhat.com [10.40.200.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EEFE410018FF;
        Fri,  4 Oct 2019 13:41:13 +0000 (UTC)
Date:   Fri, 4 Oct 2019 15:41:12 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, brouer@redhat.com
Subject: Re: [v4 1/4] samples: pktgen: make variable consistent with option
Message-ID: <20191004154112.7dda5cff@carbon>
In-Reply-To: <CAEKGpzj9WGepw4LPJeFhbtONYJyvLcO_ChnMRrEB5-BVTfKqMQ@mail.gmail.com>
References: <20191004013301.8686-1-danieltimlee@gmail.com>
        <20191004145153.6192fb09@carbon>
        <CAEKGpzj9WGepw4LPJeFhbtONYJyvLcO_ChnMRrEB5-BVTfKqMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Fri, 04 Oct 2019 13:41:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Oct 2019 22:28:26 +0900
"Daniel T. Lee" <danieltimlee@gmail.com> wrote:

> On Fri, Oct 4, 2019 at 9:52 PM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> >
> >
> > On Fri,  4 Oct 2019 10:32:58 +0900 "Daniel T. Lee" <danieltimlee@gmail.com> wrote:
> >  
> > > [...]  
> >  
> 
> Thanks for the review!
> 
> > A general comment, you forgot a cover letter for your patchset.
> >  
> 
> At first, I thought the size of the patchset (the feature to enhance)
> was small so
> I didn't include it with intent, but now it gets bigger and it seems
> necessary for cover letter.
> 
> When the next version is needed, I'll include it.
> 
> > And also forgot the "PATCH" part of subj. but patchwork still found it:
> > https://patchwork.ozlabs.org/project/netdev/list/?series=134102&state=2a
> >  
> 
> I'm not sure I'm following.
> Are you saying that the word "PATCH" should be included in prefix?
>     $ git format-patch --subject-prefix="PATCH,v5"
> like this?

I would say "[PATCH net-next v5]" as you should also say which kernel
tree, in this case net-next.

All the rules are documented here:
 https://www.kernel.org/doc/html/latest/process/index.html
 https://www.kernel.org/doc/html/latest/process/submitting-patches.html

This netdev list have it's own extra rules:
 https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
