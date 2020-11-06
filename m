Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22BE2A9146
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 09:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgKFI25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 03:28:57 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:35903 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbgKFI25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 03:28:57 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UEPEfCA_1604651334;
Received: from IT-FVFX43SYHV2H.local(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0UEPEfCA_1604651334)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 Nov 2020 16:28:54 +0800
Subject: Re: [PATCH] net/dsa: remove unused macros to tame gcc warning
To:     Joe Perches <joe@perches.com>, andrew@lunn.ch
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1604641050-6004-1-git-send-email-alex.shi@linux.alibaba.com>
 <71dc38c1646980840fb83d82fc588501af72e05f.camel@perches.com>
From:   Alex Shi <alex.shi@linux.alibaba.com>
Message-ID: <8e0fac45-9107-cdfe-de9e-ccf3abd416a4@linux.alibaba.com>
Date:   Fri, 6 Nov 2020 16:28:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <71dc38c1646980840fb83d82fc588501af72e05f.camel@perches.com>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



ÔÚ 2020/11/6 ÏÂÎç2:36, Joe Perches Ð´µÀ:
> On Fri, 2020-11-06 at 13:37 +0800, Alex Shi wrote:
>> There are some macros unused, they causes much gcc warnings. Let's
>> remove them to tame gcc.
> 
> I believe these to be essentially poor warnings.
> 
> Aren't these warnings generated only when adding  W=2 to the make
> command line?
> 
> Perhaps it's better to move the warning to level 3
> ---
> diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
> index 95e4cdb94fe9..5c3c220ddb32 100644
> --- a/scripts/Makefile.extrawarn
> +++ b/scripts/Makefile.extrawarn
> @@ -68,7 +68,6 @@ KBUILD_CFLAGS += $(call cc-option, -Wlogical-op)
>  KBUILD_CFLAGS += -Wmissing-field-initializers
>  KBUILD_CFLAGS += -Wtype-limits
>  KBUILD_CFLAGS += $(call cc-option, -Wmaybe-uninitialized)
> -KBUILD_CFLAGS += $(call cc-option, -Wunused-macros)

This changed too much, and impact others. May not good. :)

Thanks
Alex
>  
>  KBUILD_CPPFLAGS += -DKBUILD_EXTRA_WARN2
>  
> @@ -89,6 +88,7 @@ KBUILD_CFLAGS += -Wredundant-decls
>  KBUILD_CFLAGS += -Wsign-compare
>  KBUILD_CFLAGS += -Wswitch-default
>  KBUILD_CFLAGS += $(call cc-option, -Wpacked-bitfield-compat)
> +KBUILD_CFLAGS += $(call cc-option, -Wunused-macros)
>  
>  KBUILD_CPPFLAGS += -DKBUILD_EXTRA_WARN3
>  
> 
