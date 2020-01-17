Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9D4140822
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 11:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgAQKj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 05:39:59 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45450 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbgAQKj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 05:39:59 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1isP2j-0007ey-Q8; Fri, 17 Jan 2020 11:39:57 +0100
Date:   Fri, 17 Jan 2020 11:39:57 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netlink: make getters tolerate NULL nla arg
Message-ID: <20200117103957.GV795@breakpoint.cc>
References: <20200116145522.28803-1-fw@strlen.de>
 <87eevzsa2m.fsf@toke.dk>
 <20200116160435.GT795@breakpoint.cc>
 <8736cfs73w.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8736cfs73w.fsf@toke.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> And that the crashes at least shine a light on
> them forcing people to consider whether that is indeed the case?
>
> (IDK if that's actually the case, I'm asking :))

All I was saying is that if the getters were more tolerant a few crash
bugs could have been avoided.
