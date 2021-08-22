Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C60D3F3E40
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 09:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhHVHPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 03:15:36 -0400
Received: from smtprelay0037.hostedemail.com ([216.40.44.37]:51066 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229934AbhHVHPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 03:15:36 -0400
Received: from omf02.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 3553D18037BD8;
        Sun, 22 Aug 2021 07:14:54 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf02.hostedemail.com (Postfix) with ESMTPA id 09A5F1D42F4;
        Sun, 22 Aug 2021 07:14:52 +0000 (UTC)
Message-ID: <2e0bea3524268f96a39506b3e5ea9f738c6aab27.camel@perches.com>
Subject: Re: [PATCH v1 1/1] ray_cs: use %*ph to print small buffer
From:   Joe Perches <joe@perches.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Sun, 22 Aug 2021 00:14:51 -0700
In-Reply-To: <877dgerrqw.fsf@codeaurora.org>
References: <20210712142943.23981-1-andriy.shevchenko@linux.intel.com>
         <20210821171432.B996DC4360C@smtp.codeaurora.org>
         <293b9231af8b36bb9a24a11c689d33c7e89c3c4e.camel@perches.com>
         <877dgerrqw.fsf@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 09A5F1D42F4
X-Stat-Signature: ybkgy97sw4z5qypncs8n4fbpy78rcu97
X-Spam-Status: No, score=-1.59
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+yJGoCh/tebKAdOx3pd0yDij8KagAZkmo=
X-HE-Tag: 1629616492-286889
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2021-08-22 at 08:08 +0300, Kalle Valo wrote:
> Joe Perches <joe@perches.com> writes:
> 
> > On Sat, 2021-08-21 at 17:14 +0000, Kalle Valo wrote:
> > > Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> > > 
> > > > Use %*ph format to print small buffer as hex string.
> > > > 
> > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > 
> > > Patch applied to wireless-drivers-next.git, thanks.
> > > 
> > > 502213fd8fca ray_cs: use %*ph to print small buffer
> > > 
> > 
> > There's one more of these in the same file but it's in an #ifdef 0 block...
> 
> I would rather remove the whole ifdef 0 block, patches welcome.
> 

It'd probably take you about 20 seconds if you do it yourself.

$ git grep -P -n '^\s*#\s*if\s+0\b' drivers/net/wireless/ray_cs.c
drivers/net/wireless/ray_cs.c:637:#if 0
drivers/net/wireless/ray_cs.c:2281:#if 0
drivers/net/wireless/ray_cs.c:2341:#if 0

Rather a bit more time if you want to do the whole kernel...

$ git grep -P -n '^\s*#\s*if\s+0\b' | wc -l
1558



