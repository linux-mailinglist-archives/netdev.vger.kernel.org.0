Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17B9413DF8B
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgAPQEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:04:37 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:35820 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726552AbgAPQEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 11:04:37 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1is7dL-0006Ui-4a; Thu, 16 Jan 2020 17:04:35 +0100
Date:   Thu, 16 Jan 2020 17:04:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netlink: make getters tolerate NULL nla arg
Message-ID: <20200116160435.GT795@breakpoint.cc>
References: <20200116145522.28803-1-fw@strlen.de>
 <87eevzsa2m.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87eevzsa2m.fsf@toke.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> Florian Westphal <fw@strlen.de> writes:
> 
> > One recurring bug pattern triggered by syzbot is NULL dereference in
> > netlink code paths due to a missing "tb[NL_ARG_FOO] != NULL" test.
> >
> > At least some of these missing checks would not have crashed the kernel if
> > the various nla_get_XXX helpers would return 0 in case of missing arg.
> 
> Won't this risk just papering over the issue and lead to subtly wrong
> behaviour instead? At least a crash is somewhat visible :)

How?  Its no different than tb[X] being set with a 0 value.
