Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B792182D2
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 10:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgGHIso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 04:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgGHIsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 04:48:43 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C00C08C5DC;
        Wed,  8 Jul 2020 01:48:43 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id u25so26422993lfm.1;
        Wed, 08 Jul 2020 01:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=JEdvc9/856Brx/sBJ8Yam9emFnm/wF/Hn2AcTak3ns0=;
        b=rnvJQ/F8yY5c5p7JR9DqPQybweabq5ZZ0x8RO0cpWyic1yTrJ1NssYrkg0hVz13Y/O
         oNjICdRK/+Y/rVb+h0oLZSa6kz0eBQ32h+qe2PuGVsdFvvp57SJ1Vuh44zTUhlnphkEt
         gBuwyxc3KLxaFd79SgN/+kmMeDqpO0qEiPzJMFaivfCvsYVD+9d7GW0RR+uQ5jiCNFZd
         ysop0BwKUkbE+Rr7bYg3UUsvpEzWl9gABaYqelmbkw0Sk6y5vcHzlpBmJ/xQqHONtNkC
         sZXSNYeqVhZFEr+mjnCjnlke6G+AXEBjgytlNBAZvsg8IZicvVhoMRPlMTQaHZQLwHG2
         i4Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=JEdvc9/856Brx/sBJ8Yam9emFnm/wF/Hn2AcTak3ns0=;
        b=cR5CRhaXttk/9MVCFgVaX33F7uE+/9VxOGLrgwH/gKFFY/pTejPfln0foqmDkHlVL4
         UD6v/k8dFG7U3+PmBoGFAoP/vPr8Z+SNGOP4U1FwqOedu9o9y5YVzt9d32Jbvt4NBZev
         XmiTtDzKm5eRbZuV9z05ByVh1I4yyry4bxrSnyiNyILUWij6AGe96SMlQkg5TjZUHlIb
         9QbjRq+RVFTwG0UsFO+j6+JlL8BWkR/Yvfn/T28AMdtlVMUHtyiOBo7lVfAqZLi1rodv
         cuUdi5sexQeXM3KlNOgYuWViwroJJC0TkUOLrY9gHGz9KMlKSZwP2A5joZkwgFjuFxgz
         UhJg==
X-Gm-Message-State: AOAM532tdRrfnWnR5h/KeKckiGTZa6pF9Ed/iTt/2VD4u+uGMMffOPDY
        kI0FEfzqDdPuWf1CTblOcJY=
X-Google-Smtp-Source: ABdhPJzsaTUJ/3P+9MRxfwbKU9eGeKrNZmSJcRae09Q9ycb3vCviRFLC7WfW0HS+4qxjWT8qcFGj0g==
X-Received: by 2002:a19:8b8a:: with SMTP id n132mr35131491lfd.45.1594198121573;
        Wed, 08 Jul 2020 01:48:41 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id t4sm750545ljg.11.2020.07.08.01.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 01:48:40 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [EXT] [PATCH  4/5] net: fec: get rid of redundant code in
 fec_ptp_set()
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200706142616.25192-5-sorganov@gmail.com>
        <AM6PR0402MB3607DE03C3333B9E4C8D3309FF660@AM6PR0402MB3607.eurprd04.prod.outlook.com>
        <87tuyj8jxx.fsf@osv.gnss.ru>
        <AM6PR0402MB36074EB7107ACF728134FEB0FF670@AM6PR0402MB3607.eurprd04.prod.outlook.com>
Date:   Wed, 08 Jul 2020 11:48:30 +0300
In-Reply-To: <AM6PR0402MB36074EB7107ACF728134FEB0FF670@AM6PR0402MB3607.eurprd04.prod.outlook.com>
        (Andy Duan's message of "Wed, 8 Jul 2020 05:34:35 +0000")
Message-ID: <87y2nue6jl.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andy Duan <fugang.duan@nxp.com> writes:

> From: Sergey Organov <sorganov@gmail.com> Sent: Tuesday, July 7, 2020 10:43 PM
>> Andy Duan <fugang.duan@nxp.com> writes:
>> 
>> > From: Sergey Organov <sorganov@gmail.com> Sent: Monday, July 6, 2020
>> 10:26 PM
>> >> Code of the form "if(x) x = 0" replaced with "x = 0".
>> >>
>> >> Code of the form "if(x == a) x = a" removed.
>> >>
>> >> Signed-off-by: Sergey Organov <sorganov@gmail.com>
>> >> ---
>> >>  drivers/net/ethernet/freescale/fec_ptp.c | 4 +---
>> >>  1 file changed, 1 insertion(+), 3 deletions(-)
>> >>
>> >> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c
>> >> b/drivers/net/ethernet/freescale/fec_ptp.c
>> >> index e455343..4152cae 100644
>> >> --- a/drivers/net/ethernet/freescale/fec_ptp.c
>> >> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
>> >> @@ -485,9 +485,7 @@ int fec_ptp_set(struct net_device *ndev, struct
>> ifreq
>> >> *ifr)
>> >>
>> >>         switch (config.rx_filter) {
>> >>         case HWTSTAMP_FILTER_NONE:
>> >> -               if (fep->hwts_rx_en)
>> >> -                       fep->hwts_rx_en = 0;
>> >> -               config.rx_filter = HWTSTAMP_FILTER_NONE;
>> > The line should keep according your commit log.
>> 
>> You mean I should fix commit log like this:
>> 
>> Code of the form "switch(x) case a: x = a; break" removed.
>> 
>> ?
> Like this:
>
> case HWTSTAMP_FILTER_NONE:
> 	fep->hwts_rx_en = 0;
> 	config.rx_filter = HWTSTAMP_FILTER_NONE;

This last line is redundant, as it's part of the switch that reads:

switch (config.rx_filter) {
 case HWTSTAMP_FILTER_NONE: config.rx_filter = HWTSTAMP_FILTER_NONE;

that effectively reduces to:

if(x == a) x = a;

that is a no-op (provided 'x' is a usual memory reference),
and that is exactly what I've described in the commit log.

What do I miss?

Thanks,
-- Sergey
