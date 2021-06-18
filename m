Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B543ACF42
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 17:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbhFRPiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 11:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235536AbhFRPiu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 11:38:50 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D26B610A2;
        Fri, 18 Jun 2021 15:36:39 +0000 (UTC)
Date:   Fri, 18 Jun 2021 11:36:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        David Hildenbrand <david@redhat.com>, Greg KH <greg@kroah.com>,
        Christoph Lameter <cl@gentwo.de>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, netdev <netdev@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
Message-ID: <20210618113637.5890bbcf@oasis.local.home>
In-Reply-To: <20210618113452.7ab0033e@oasis.local.home>
References: <5038827c-463f-232d-4dec-da56c71089bd@metux.net>
        <20210610182318.jrxe3avfhkqq7xqn@nitro.local>
        <YMJcdbRaQYAgI9ER@pendragon.ideasonboard.com>
        <20210610152633.7e4a7304@oasis.local.home>
        <37e8d1a5-7c32-8e77-bb05-f851c87a1004@linuxfoundation.org>
        <YMyjryXiAfKgS6BY@pendragon.ideasonboard.com>
        <cd7ffbe516255c30faab7a3ee3ee48f32e9aa797.camel@HansenPartnership.com>
        <CAMuHMdVcNfDvpPXHSkdL3VuLXCX5m=M_AQF-P8ZajSdXt8NdQg@mail.gmail.com>
        <20210618103214.0df292ec@oasis.local.home>
        <CAMuHMdWK4NPzanF68TMVuihLFdRzxhs0EkbZdaA=BUkZo-k6QQ@mail.gmail.com>
        <YMy4UjWH565ElFtZ@casper.infradead.org>
        <CAMuHMdWqUkfe7kdBO+eQdXHzhpygH=TivOBNqQJujyqP=wM5cw@mail.gmail.com>
        <20210618113452.7ab0033e@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Jun 2021 11:34:52 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> How many times have you been in a conference where the normal mic and
> speaker caused a nasty feedback loop?
> 
> I'm not sure how well phone mics and room speakers will work.

BTW, Don't take these criticisms as a rejection of your idea. I
actually like the idea. But to implement it, we need to go through all
the scenarios that will likely go wrong, if we want it to work.

-- Steve
