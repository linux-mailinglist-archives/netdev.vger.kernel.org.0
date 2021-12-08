Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5107D46CAC0
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 03:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239061AbhLHCWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 21:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235106AbhLHCWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 21:22:38 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DF8C061746
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 18:19:07 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id 15so910971ilq.2
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 18:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=egauge.net; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :organization:user-agent:mime-version:content-transfer-encoding;
        bh=r+WvBmZpS0dwMmf0DqvGpLxh7nbMO6CLLW18P2NNE9w=;
        b=YbXcK3PL90cxzRUAgazB7/ojV4aWjHBPd43EFmoKOLAEVrelKo6Qvp/YgkpNOvzQOP
         W9ftiXyet8eI6Axv2qE7oCZv2APaphv3otsV+BF+g8fQr6fPqLG0TRch3W3OsTJLJtiY
         B0nt/AgS3RreLW2ZZS+jPdyC6za4G+SyQEeQb6scaSoQVlM16QiUFhmQiRvTSHoYI4bR
         ITLfBFl/ZgBpmkDOVLY6fuxK53/aEaK2hc2OJi/kvDF/bp3NmxO7Mrq77bkc3TC5x1fZ
         BjSKrdMJCg8vuK0u8+by6AGOD8mXgd/jvMRtetBRyrZlqWdlWdPlKTNevo73gE2EN6r7
         EvlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=r+WvBmZpS0dwMmf0DqvGpLxh7nbMO6CLLW18P2NNE9w=;
        b=o9gp/jDacwnx4dA09Ju0oDM/KzwedS/cLlG5B34ftlOvakCVUZcaCSAP2elirm9NAm
         E3UPi92zYATOTCX1pFdFd3W9nTkRudnQiqKgWhY+Z2HL+Q3CwURF93ZMTOHGetwMuPyG
         RIhRZdbdK7WtuV0N1JskEw8eu4UOCFPgs60PhU2XbUb3cRTPG9b17+jBUdyKzrKgFPvm
         ZaSSf0cPP1Rip2hBQoJMjQi7TNCSa7mqtoBqyOjL6Qj5jdUFU9/fq7l4uEpcdr2cPMRR
         Vqv4HmsYzIU40un2k3DwwxA5pZ62uar1emec+vMqdejy2M1+c+b3+NriUcgeBdOFt3DP
         Llgw==
X-Gm-Message-State: AOAM532b3xJauw3zBzgaPBe+um6cq7EN+okTgHGvAMbXiMslowYjY0Hg
        3/7n6HgbAqOju3K4JodD7dms
X-Google-Smtp-Source: ABdhPJxrGMMmzBgFck0ZVIBYgJkKyLzNMZXkfRw9YcDo7Qq+p6xvwogBPjRvN1CyCWrX69eSNnrbuw==
X-Received: by 2002:a05:6e02:20c9:: with SMTP id 9mr2950559ilq.245.1638929946606;
        Tue, 07 Dec 2021 18:19:06 -0800 (PST)
Received: from ?IPv6:2601:281:8300:4e0:2ba9:697d:eeec:13b? ([2601:281:8300:4e0:2ba9:697d:eeec:13b])
        by smtp.gmail.com with ESMTPSA id s20sm983283iog.25.2021.12.07.18.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 18:19:06 -0800 (PST)
Message-ID: <6da1f2cc0ffc2c0106412c5aff52700edd183c6d.camel@egauge.net>
Subject: Re: [PATCH 2/2] wilc1000: Fix missing newline in error message
From:   David Mosberger-Tang <davidm@egauge.net>
To:     Joe Perches <joe@perches.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 07 Dec 2021 19:19:05 -0700
In-Reply-To: <5b44cebddcda765942aa118d25740a074137d0f8.camel@perches.com>
References: <20211206232709.3192856-1-davidm@egauge.net>
         <20211206232709.3192856-3-davidm@egauge.net>
         <4687b01640eaaba01b3db455a7951a534572ee31.camel@perches.com>
         <00d44cb3-3b38-7bb6-474f-c819c2403b6a@egauge.net>
         <5b44cebddcda765942aa118d25740a074137d0f8.camel@perches.com>
Organization: eGauge Systems LLC
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-12-07 at 16:23 -0800, Joe Perches wrote:
> On Tue, 2021-12-07 at 15:58 -0700, David Mosberger-Tang wrote:
> > On 12/6/21 6:33 PM, Joe Perches wrote:
> > 
> > > On Mon, 2021-12-06 at 23:27 +0000, David Mosberger-Tang wrote:
> > > > Add missing newline in pr_err() message.
> > > []
> > > > diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
> > > []
> > > > @@ -27,7 +27,7 @@ static irqreturn_t isr_uh_routine(int irq, void *user_data)
> > > >   	struct wilc *wilc = user_data;
> > > >   
> > > >   	if (wilc->close) {
> > > > -		pr_err("Can't handle UH interrupt");
> > > > +		pr_err("Can't handle UH interrupt\n");
> > > Ideally this would use wiphy_<level>:
> > > 
> > > 		wiphy_err(wilc->wiphy, "Can't handle UH interrupt\n");
> > 
> > Sure, but that's orthogonal to this bug fix.
> 
> Of course.
> 
> >  I do have a "cleanups" 
> > branch with various cleanups of this sort.  I'll look into fixing pr_*() 
> > calls in the cleanups branch (there are several of them, unsurprisingly).
> 
> netdev_<level> -> wiphy_<level> conversions too where feasible please.

OK, I made a note for that, too, thanks.

  --david


