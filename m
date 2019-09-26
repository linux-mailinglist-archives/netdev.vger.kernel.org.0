Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A207BF8CE
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 20:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbfIZSGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 14:06:11 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46834 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727934AbfIZSGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 14:06:10 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iDY9Z-00055X-Hk; Thu, 26 Sep 2019 20:06:09 +0200
Date:   Thu, 26 Sep 2019 20:06:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, paulb@mellanox.com,
        vladbu@mellanox.com
Subject: Re: [PATCH net] sk_buff: drop all skb extensions on free and skb
 scrubbing
Message-ID: <20190926180609.GB9938@breakpoint.cc>
References: <20190926141840.31952-1-fw@strlen.de>
 <76c10ba7-5fc8-e9e8-769f-fc4d5cada7a2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76c10ba7-5fc8-e9e8-769f-fc4d5cada7a2@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > +static inline void skb_ext_reset(struct sk_buff *skb)
> > +{
> > +	if (skb->active_extensions) {
> 
> This deserves an unlikely(skb->active_extensions) hint here ?

unlikely() isn't used in the other helpers (e.g. skb_ext_{put,del,copy}
either, should I add it there too?
