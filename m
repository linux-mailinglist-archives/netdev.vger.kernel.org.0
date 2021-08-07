Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D505B3E3666
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 19:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhHGRBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 13:01:11 -0400
Received: from smtprelay0173.hostedemail.com ([216.40.44.173]:37650 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229622AbhHGRA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 13:00:56 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave07.hostedemail.com (Postfix) with ESMTP id 0E8E4180D0F8A;
        Sat,  7 Aug 2021 17:00:17 +0000 (UTC)
Received: from omf05.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 377F219478;
        Sat,  7 Aug 2021 16:58:16 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf05.hostedemail.com (Postfix) with ESMTPA id 494B0B2794;
        Sat,  7 Aug 2021 16:58:15 +0000 (UTC)
Message-ID: <7afa073ece002f84f4f2c28b3ac3032ded94bf43.camel@perches.com>
Subject: Re: [V2][PATCH] atm: horizon: Fix spelling mistakes in TX comment
From:   Joe Perches <joe@perches.com>
To:     Jun Miao <jun.miao@windriver.com>, 3chas3@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 07 Aug 2021 09:58:14 -0700
In-Reply-To: <20210807153830.1293760-1-jun.miao@windriver.com>
References: <20210807153830.1293760-1-jun.miao@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.11
X-Stat-Signature: bsrdfkk7u7f9wndwikex4j4but6fbxem
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 494B0B2794
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18CJGDPYaoC+RPaCCYosPaoxTfRnMIQ484=
X-HE-Tag: 1628355495-985621
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-08-07 at 23:38 +0800, Jun Miao wrote:
> It's "must not", not "musn't", meaning "shall not".
> Let's fix that.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Jun Miao <jun.miao@windriver.com>
> ---
>  drivers/atm/horizon.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
> index 4f2951cbe69c..9ee494bc5c51 100644
> --- a/drivers/atm/horizon.c
> +++ b/drivers/atm/horizon.c
> @@ -2167,10 +2167,10 @@ static int hrz_open (struct atm_vcc *atm_vcc)
>    
> 
>    // Part of the job is done by atm_pcr_goal which gives us a PCR
>    // specification which says: EITHER grab the maximum available PCR
> -  // (and perhaps a lower bound which we musn't pass), OR grab this
> +  // (and perhaps a lower bound which we mustn't pass), OR grab this

I meant to suggest you change the patch to use "must not" not
the commit message.

>    // amount, rounding down if you have to (and perhaps a lower bound
> -  // which we musn't pass) OR grab this amount, rounding up if you
> -  // have to (and perhaps an upper bound which we musn't pass). If any
> +  // which we mustn't pass) OR grab this amount, rounding up if you
> +  // have to (and perhaps an upper bound which we mustn't pass). If any
>    // bounds ARE passed we fail. Note that rounding is only rounding to
>    // match device limitations, we do not round down to satisfy
>    // bandwidth availability even if this would not violate any given


