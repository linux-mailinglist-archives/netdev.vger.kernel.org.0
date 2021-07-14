Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227AC3C7D2A
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 06:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhGNELJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 00:11:09 -0400
Received: from smtprelay0056.hostedemail.com ([216.40.44.56]:36960 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229451AbhGNELJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 00:11:09 -0400
Received: from omf18.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 5156118258223;
        Wed, 14 Jul 2021 04:08:17 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf18.hostedemail.com (Postfix) with ESMTPA id 16C702EBFA4;
        Wed, 14 Jul 2021 04:08:15 +0000 (UTC)
Message-ID: <f3d58a9a27e255ba5b05f8f043ef649fb74fe993.camel@perches.com>
Subject: Re: [PATCH] replace for loop with array initializer
From:   Joe Perches <joe@perches.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Salah Triki <salah.triki@gmail.com>
Cc:     kevin.curtis@farsite.co.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 13 Jul 2021 21:08:14 -0700
In-Reply-To: <20210712130520.748b6e3a@hermes.local>
References: <20210712192450.GA1153790@pc>
         <20210712130520.748b6e3a@hermes.local>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 16C702EBFA4
X-Spam-Status: No, score=0.20
X-Stat-Signature: f7fd9mmpf7d194zskk53um3aksqzp933
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+XPDY2tWmCWMtyRpn6nk7x2rSb+9Qgjw8=
X-HE-Tag: 1626235695-65390
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-07-12 at 13:05 -0700, Stephen Hemminger wrote:
> On Mon, 12 Jul 2021 20:24:50 +0100 Salah Triki <salah.triki@gmail.com> wrote:
> > diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
[]
> > +static struct fst_card_info *fst_card_array[FST_MAX_CARDS] = { [0 ... FST_MAX_CARDS-1] = NULL };
> 
> Why bother, the default initialization in C is 0 (ie. NULL).
> In fact, checkpatch should complain about useless array initialization for this.

I'll look out for your patch to checkpatch.


