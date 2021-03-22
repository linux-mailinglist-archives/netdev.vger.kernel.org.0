Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4970434512D
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhCVUvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbhCVUvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 16:51:23 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AC6C061574;
        Mon, 22 Mar 2021 13:51:21 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id r17-20020a4acb110000b02901b657f28cdcso4430429ooq.6;
        Mon, 22 Mar 2021 13:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yM/6S6FViE7IpToxGYmVsIhNe3gv17YedRrLGkVh5iM=;
        b=dakTJAIFUC5lWRKJ4WNCzoxcD8nuusxO0ZPD7ezRk0/ETCqga2jW4+w0XKxyjCBPiN
         jqWI87gYljQV8OHOTiwQXhF6I+V2JGs6979WY8TclxFuxKXZuzKR1y0OxD4UkYGvAoor
         bZAH0VLgiQGc+Q33AMfjSMtApEbQubnRsq3myM/PI2LDRSdrPqZp3dFBB5s3bsyaT8Xn
         uO5qYtTKiWDKhPvDP1QGFvGzm1LorVRfxqCmNQd6DVGfKqatN2nPG944Bs2Bd490KsD6
         BqESeYIoHfPjXOwbMu7VcTIzQEuOafVK0TnSoOXdwvgXY3Atfsi0R6l/NlhKMtZM3Xse
         JDyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yM/6S6FViE7IpToxGYmVsIhNe3gv17YedRrLGkVh5iM=;
        b=VGytosfkTP0W4WvHIZl0SgO6cA1nT/RimjqTGZcmhDRv8lI+tmOFvABx0Wi41UtnEG
         ZR0H6hi6xGgmZC1mjhF23Vrl6pZD7YXopv7QCGj5yWpAuZRZZFmtEHfLRP/hIOELv0SY
         Roh+wCKMVewBMQAKwqgIilI63DGOJluBNJqnlWwu4d0cHT4JTBvum0PZDtLOVSDSYH/Z
         8g8aBm6BP4eYy+LleykyyH9UwzBs927OTmlZ8azotIjOY+RuqatuyuD4IDgM96mER+Cf
         TjsYqOxJIzUUYpYycjyhRktc8wIM6MWere9pxKzOlypgokHIzWMv/kwrvvyzsY9IUBuo
         3k4Q==
X-Gm-Message-State: AOAM531MnpP6vEfwVXpViIStxjG8pdVgnpeKAENJkPTlanZlQFez+7HC
        1yzwzVA3s+cvzYQf3Hb3mbzvKO+Vf2qT7AInaWfVUwmTiA==
X-Google-Smtp-Source: ABdhPJxfDqZznIfEqJoPvRZgE9GrpR69RJyCbfAlvZ6GCegAdfd9P6ANUWByDsxOPDNAfVKpbaV65S4EY2OnnPJusxM=
X-Received: by 2002:a4a:d0ce:: with SMTP id u14mr1047919oor.36.1616446280734;
 Mon, 22 Mar 2021 13:51:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210322202650.45776-1-george.mccollister@gmail.com> <20210322204633.ptvwd2jinybnxcje@skbuf>
In-Reply-To: <20210322204633.ptvwd2jinybnxcje@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 22 Mar 2021 15:51:08 -0500
Message-ID: <CAFSKS=NRMMz5u9qjFmhrxZMCVpa2ZP1jTJ5o+eUA6H2B2aotOg@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: don't assign an error value to tag_ops
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 3:46 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Mon, Mar 22, 2021 at 03:26:50PM -0500, George McCollister wrote:
> > Use a temporary variable to hold the return value from
> > dsa_tag_driver_get() instead of assigning it to dst->tag_ops. Leaving
> > an error value in dst->tag_ops can result in deferencing an invalid
> > pointer when a deferred switch configuration happens later.
> >
> > Fixes: 357f203bb3b5 ("net: dsa: keep a copy of the tagging protocol in the DSA switch tree")
> >
> > Signed-off-by: George McCollister <george.mccollister@gmail.com>
> > ---
>
> Who dereferences the invalid pointer? dsa_tree_free I guess?

I saw it occur just above on the following line the next time
dsa_port_parse_cpu() is called:
if (dst->tag_ops->proto != tag_protocol) {

-George
