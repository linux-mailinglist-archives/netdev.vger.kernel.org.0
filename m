Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F9739DB5E
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 13:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhFGLcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 07:32:54 -0400
Received: from mail-ot1-f46.google.com ([209.85.210.46]:34348 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbhFGLcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 07:32:52 -0400
Received: by mail-ot1-f46.google.com with SMTP id v27-20020a056830091bb02903cd67d40070so13265100ott.1;
        Mon, 07 Jun 2021 04:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ouJCJpb+cVjhmk8j2qfxiU2PiYqfLkfly1jYgo8fmy4=;
        b=l3tb4Ti3/ESiVNC9be61igb7NBBFLs9+KwCCmS9OlfdmYt9uey00TQd3qX11GWioZN
         1+ht04CVQrf0UM6VxgqDaPTArSmodK3BYXWL0udJ10T612ebj1W+0ybZrwUKDjsQuhz9
         aWq1IA6ZVklOffOiHORlXUO69XDw1ADiZSo4idLvQ6h12ToQK4a3jHvnbUEDNlOV7+01
         LHmOyaDW05UPY+c5NgwRVD0iUH0Ay+szsy6qGJttnnxPj4TS8L4kte71gGZfk7PUgjGH
         YTpNlsQaMR01+gfrJZDGC4WLAe6ZtK5ULr1ZXOXZv/AUuicjXaRdIFWza8lUe7VY4EFm
         7eVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ouJCJpb+cVjhmk8j2qfxiU2PiYqfLkfly1jYgo8fmy4=;
        b=aM5TMckYUCdvIQkaaYY2ShCdAcHNr+zPR5bcRQZqLxhc/zrVp8IapuT2yB1wYwkiNi
         NOaJR6m15hGMPEpRHpjhBwqgbjZKu0vBAOMM0pDWfZxPKE7dRG/vSkWs4jALDnt8KO3k
         uRKBT0VVR0DRLDc1QsmcT3pWBXut/pE53U9SxBvDihy12EHP61OyN0hqGuQZJQQ81TNv
         sx4fIhbqPt0T2OSLzTn4bAmuYTbxh8SRCv6JzPEnh6DhxULRI/GYw/8qTDlm/9JCu4Of
         C1UG0LVdhEraSAgUjTSyfaLf7G4wgEK8Xtg9jH7cw7fsb5f/8qi4UoBH0JTH2Jyo859I
         9CIw==
X-Gm-Message-State: AOAM530L6+tJbirNqSXsA7DVqe79lpwzGgsKkI3alap4vcJERoTiV89Q
        dJn9drjUwLe0D9LYKtaICZU=
X-Google-Smtp-Source: ABdhPJwfGgFpT8BfA9ywyPV9GozhTIyRKAxRs5/zwSlum7MqzjvC9UecMC6ghRBNcLEBwvai1toqHQ==
X-Received: by 2002:a9d:560a:: with SMTP id e10mr13685889oti.353.1623065392393;
        Mon, 07 Jun 2021 04:29:52 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l9sm2105274oou.43.2021.06.07.04.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 04:29:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 7 Jun 2021 04:29:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-watchdog@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] watchdog: Remove MV64x60 watchdog driver
Message-ID: <20210607112950.GB314533@roeck-us.net>
References: <9c2952bcfaec3b1789909eaa36bbce2afbfab7ab.1616085654.git.christophe.leroy@csgroup.eu>
 <31d702e5-22d1-1766-76dd-e24860e5b1a4@roeck-us.net>
 <87im3hk3t2.fsf@mpe.ellerman.id.au>
 <e2a33fc1-f519-653d-9230-b06506b961c5@roeck-us.net>
 <87czsyfo01.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czsyfo01.fsf@mpe.ellerman.id.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 11:43:26AM +1000, Michael Ellerman wrote:
> Guenter Roeck <linux@roeck-us.net> writes:
> > On 5/17/21 4:17 AM, Michael Ellerman wrote:
> >> Guenter Roeck <linux@roeck-us.net> writes:
> >>> On 3/18/21 10:25 AM, Christophe Leroy wrote:
> >>>> Commit 92c8c16f3457 ("powerpc/embedded6xx: Remove C2K board support")
> >>>> removed the last selector of CONFIG_MV64X60.
> >>>>
> >>>> Therefore CONFIG_MV64X60_WDT cannot be selected anymore and
> >>>> can be removed.
> >>>>
> >>>> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> >>>
> >>> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> >>>
> >>>> ---
> >>>>   drivers/watchdog/Kconfig       |   4 -
> >>>>   drivers/watchdog/Makefile      |   1 -
> >>>>   drivers/watchdog/mv64x60_wdt.c | 324 ---------------------------------
> >>>>   include/linux/mv643xx.h        |   8 -
> >>>>   4 files changed, 337 deletions(-)
> >>>>   delete mode 100644 drivers/watchdog/mv64x60_wdt.c
> >> 
> >> I assumed this would go via the watchdog tree, but seems like I
> >> misinterpreted.
> >> 
> >
> > Wim didn't send a pull request this time around.
> >
> > Guenter
> >
> >> Should I take this via the powerpc tree for v5.14 ?
> 
> I still don't see this in the watchdog tree, should I take it?
> 
It is in my personal watchdog-next tree, but afaics Wim hasn't picked any
of it up yet. Wim ?

Thanks,
Guenter
