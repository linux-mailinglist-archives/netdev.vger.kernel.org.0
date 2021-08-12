Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43EF3EA69D
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 16:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238070AbhHLObx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 10:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbhHLObw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 10:31:52 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE5AC061756;
        Thu, 12 Aug 2021 07:31:26 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mEBjs-0007tz-Pr; Thu, 12 Aug 2021 16:31:20 +0200
Date:   Thu, 12 Aug 2021 16:31:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Kangmin Park <l4stpr0gr4m@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: remove duplicate code
Message-ID: <20210812143120.GD607@breakpoint.cc>
References: <20210807062106.2563-1-l4stpr0gr4m@gmail.com>
 <CAKW4uUx=cOu46E0QCdmg1Jq3WJ3w6ROo6oKZaXA=g6gdhdiDdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKW4uUx=cOu46E0QCdmg1Jq3WJ3w6ROo6oKZaXA=g6gdhdiDdg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kangmin Park <l4stpr0gr4m@gmail.com> wrote:
> I checked the Changes Requested state in patchwork.
> But I have not received any review mails.

I did not see any either.

> I wonder if there is any problem.

I don't think its worth doing, the 'extra' check avoids the
need for two additional function arguments (and those are not free
either).
