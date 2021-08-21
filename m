Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282F53F3C4F
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 21:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhHUTje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 15:39:34 -0400
Received: from smtprelay0219.hostedemail.com ([216.40.44.219]:37438 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229484AbhHUTjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 15:39:33 -0400
Received: from omf15.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 4A6F3837F24A;
        Sat, 21 Aug 2021 19:38:53 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf15.hostedemail.com (Postfix) with ESMTPA id 0E0ACC4190;
        Sat, 21 Aug 2021 19:38:51 +0000 (UTC)
Message-ID: <293b9231af8b36bb9a24a11c689d33c7e89c3c4e.camel@perches.com>
Subject: Re: [PATCH v1 1/1] ray_cs: use %*ph to print small buffer
From:   Joe Perches <joe@perches.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Sat, 21 Aug 2021 12:38:49 -0700
In-Reply-To: <20210821171432.B996DC4360C@smtp.codeaurora.org>
References: <20210712142943.23981-1-andriy.shevchenko@linux.intel.com>
         <20210821171432.B996DC4360C@smtp.codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 0E0ACC4190
X-Spam-Status: No, score=-1.48
X-Stat-Signature: p3cihmthp6xep5gyb15h48yio8xswn9z
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX184milWoUGuNOSSPU8ary2jK00LMOvrdE0=
X-HE-Tag: 1629574731-433881
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-08-21 at 17:14 +0000, Kalle Valo wrote:
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> 
> > Use %*ph format to print small buffer as hex string.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Patch applied to wireless-drivers-next.git, thanks.
> 
> 502213fd8fca ray_cs: use %*ph to print small buffer
> 

There's one more of these in the same file but it's in an #ifdef 0 block...
---
 drivers/net/wireless/ray_cs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 590bd974d94f4..849216fbb8363 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2284,9 +2284,9 @@ static void untranslate(ray_dev_t *local, struct sk_buff *skb, int len)
 			       DUMP_PREFIX_NONE, 16, 1,
 			       skb->data, 64, true);
 		printk(KERN_DEBUG
-		       "type = %08x, xsap = %02x%02x%02x, org = %02x02x02x\n",
+		       "type = %08x, xsap = %02x%02x%02x, org = %3phN\n",
 		       ntohs(type), psnap->dsap, psnap->ssap, psnap->ctrl,
-		       psnap->org[0], psnap->org[1], psnap->org[2]);
+		       psnap->org);
 		printk(KERN_DEBUG "untranslate skb->data = %p\n", skb->data);
 	}
 #endif


