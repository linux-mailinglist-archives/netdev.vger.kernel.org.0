Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13E323380B
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 19:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbgG3R6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 13:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728473AbgG3R6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 13:58:46 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F010C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 10:58:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1k1CpH-00036X-V6; Thu, 30 Jul 2020 19:58:44 +0200
Date:   Thu, 30 Jul 2020 19:58:43 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev <netdev@vger.kernel.org>,
        mathew.j.martineau@linux.intel.com,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 05/10] tcp: pass want_cookie down to req_init
 function
Message-ID: <20200730175843.GD5271@breakpoint.cc>
References: <20200730171529.22582-1-fw@strlen.de>
 <20200730171529.22582-6-fw@strlen.de>
 <CANn89iKK1Fk7q8dM-s-Pt74D_s7J5UCwA-dTUMbimpEuXj2PSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKK1Fk7q8dM-s-Pt74D_s7J5UCwA-dTUMbimpEuXj2PSQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> wrote:
> On Thu, Jul 30, 2020 at 10:15 AM Florian Westphal <fw@strlen.de> wrote:
> >
> > In MPTCP case, we want to know if we should store a new token id or if we
> > should try best-effort only (cookie case).
> >
> > This allows the MPTCP core to detect when it should elide the storage
> > of the generated MPTCP token.
> >
> 
> It seems you add later another patch, introducing cookie_tcp_reqsk_alloc()
> 
> We could rename req->cookie_ts  bit to req->syncookie  in order to not
> change function signatures.

Ok, I will update patch #1 to do a rename instead of removing cookie_ts
bit.  I will keep the change in output path to check synack_type instead
of cookie_ts.
