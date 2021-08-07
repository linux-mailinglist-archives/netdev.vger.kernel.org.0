Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66343E3581
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 15:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbhHGNWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 09:22:15 -0400
Received: from smtprelay0066.hostedemail.com ([216.40.44.66]:37604 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232181AbhHGNWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 09:22:14 -0400
Received: from omf02.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id DA0A91802203A;
        Sat,  7 Aug 2021 13:21:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf02.hostedemail.com (Postfix) with ESMTPA id F100C1D42F5;
        Sat,  7 Aug 2021 13:21:54 +0000 (UTC)
Message-ID: <0b52c87bb939fe45c1cf07fe9c3409e927138046.camel@perches.com>
Subject: Re: [PATCH] atm: horizon: Fix spelling mistakes in TX comment
From:   Joe Perches <joe@perches.com>
To:     Jun Miao <jun.miao@windriver.com>, 3chas3@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 07 Aug 2021 06:21:53 -0700
In-Reply-To: <20210807124903.1237510-1-jun.miao@windriver.com>
References: <20210807124903.1237510-1-jun.miao@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: F100C1D42F5
X-Spam-Status: No, score=0.11
X-Stat-Signature: xa3pkcrguuujaerdidd13utzegda99m8
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1947+D92hpECD2REcbo0UEsQCSWWwcspLk=
X-HE-Tag: 1628342514-354626
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-08-07 at 20:49 +0800, Jun Miao wrote:
> It's "mustn't", not "musn't", meaning "shall not".
> Let's fix that.

Perhaps more useful to change to 'must not' for the
non-native speaker.
 
> diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
[]
> @@ -2167,10 +2167,10 @@ static int hrz_open (struct atm_vcc *atm_vcc)
>    
> 
>    // Part of the job is done by atm_pcr_goal which gives us a PCR
>    // specification which says: EITHER grab the maximum available PCR
> -  // (and perhaps a lower bound which we musn't pass), OR grab this
> +  // (and perhaps a lower bound which we mustn't pass), OR grab this
>    // amount, rounding down if you have to (and perhaps a lower bound
> -  // which we musn't pass) OR grab this amount, rounding up if you
> -  // have to (and perhaps an upper bound which we musn't pass). If any
> +  // which we mustn't pass) OR grab this amount, rounding up if you
> +  // have to (and perhaps an upper bound which we mustn't pass). If any
>    // bounds ARE passed we fail. Note that rounding is only rounding to
>    // match device limitations, we do not round down to satisfy
>    // bandwidth availability even if this would not violate any given


