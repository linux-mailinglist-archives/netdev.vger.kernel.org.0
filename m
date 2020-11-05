Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871F02A83DA
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 17:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731659AbgKEQqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 11:46:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731403AbgKEQqg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 11:46:36 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81B8F20735;
        Thu,  5 Nov 2020 16:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604594795;
        bh=gbpX7j3/qxMPhXWZdCoUI8WiySna3a9/SLpa9nqyFkE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nq83UtgIc+dWWxYsp5qbroCqdR1skTfxkTXfKevjW6wb7QBkctYtoAjGv8j4owOhY
         niF5bYM6lCynYwrpAYVZEI8nrifr1dEHOMsI+F9+fajxKrNFLyOyu+O5sbYVEZ5fHQ
         5cQNbp3zhXrUgSSt8EAfqxtcMxg8c2EjqrKIT3xg=
Date:   Thu, 5 Nov 2020 08:46:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Vlad Buslov <vlad@buslov.dev>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next v2] net: sched: implement action-specific terse
 dump
Message-ID: <20201105084633.38ed9653@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAM_iQpUn2v94cUeE9MmK2__Hsf+rumq-cRNrnRN2iyUn1M1hug@mail.gmail.com>
References: <20201102201243.287486-1-vlad@buslov.dev>
        <20201104163916.4cf9b2dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAM_iQpUn2v94cUeE9MmK2__Hsf+rumq-cRNrnRN2iyUn1M1hug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Nov 2020 22:34:27 -0800 Cong Wang wrote:
> On Wed, Nov 4, 2020 at 4:39 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon,  2 Nov 2020 22:12:43 +0200 Vlad Buslov wrote:  
> > > Allow user to request action terse dump with new flag value
> > > TCA_FLAG_TERSE_DUMP. Only output essential action info in terse dump (kind,
> > > stats, index and cookie, if set by the user when creating the action). This
> > > is different from filter terse dump where index is excluded (filter can be
> > > identified by its own handle).
> > >
> > > Move tcf_action_dump_terse() function to the beginning of source file in
> > > order to call it from tcf_dump_walker().
> > >
> > > Signed-off-by: Vlad Buslov <vlad@buslov.dev>
> > > Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>  
> >
> > Jiri, Cong, can I get an ack?
> >
> > The previous terse dump made sense because it fulfilled the need of
> > an important user (OvS). IDK if this is as clear-cut, and I haven't
> > followed the iproute2 thread closely enough, so please weigh in.  
> 
> Like I said in the previous discussion, I am not a fan of terse dump,
> but before we have a better solution here, using this flag is probably
> the best we have on the table, so at least for a temporary solution:
> 
> Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied, thanks!
