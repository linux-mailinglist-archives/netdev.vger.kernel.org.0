Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7231FEE25
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 10:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728937AbgFRIzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 04:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728746AbgFRIzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 04:55:43 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00263C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 01:55:41 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b16so2463407pfi.13
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 01:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bD+k/71u8ehtJTB/BfPHQSZXrBCbz3j42tBcsHer+pc=;
        b=XIoxWHiq6wFH2Q4rKPjZbpDTtMZUUxXaqOIOfCZc46/aabF3E+FLUQc2JP+DFmNg3Z
         Io04YnjNr3iIYoMsgpwcYbm3HWzTnyaQR8asCJTUmZq05R2nDZZ/cjYreN1csbYQeMwx
         IqDgU7EpjpDytHFWxPjZNW2LHSvLSx47Y8tILYBSyTev7/b71tl2kLgYgBeEHuQUUp+0
         nEFbD1NFHIW66S0o9fqRDWL0DZCOt5WkXszK3fDptKYRf9DCos8fHA72AHJfVQA7AaKZ
         4kNdnYOfwXwHIyaYn/xO2D4xBeuO1Y+neyApEzfEGNN1OrS7TJovSH8UQzH1rfRmyD46
         Xllw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bD+k/71u8ehtJTB/BfPHQSZXrBCbz3j42tBcsHer+pc=;
        b=htCAJBq5qj85Pn6xMqO1gFtF4cgFt1hxiHy2JeXnD31iAED9qGOOLmMDAqT3C43D0b
         2DIswPFPhoFShYNWjGOamlYSk7CoDe2JYjXsp01kyMKkpnl4CXwyc+Rje77j+Q8cjQOY
         6O/T7Rbqj1Kxy1sOSM66B0NXYPeXDg/Rs7x9M8JJGOiq1yqVnlPeWkLjfrUQwTSzUXmI
         nRiXXbXXOEV8rWQ0JGaSrEF8eYdj/tkzByJEDSXKuk+eitRZ80Vq3zG855u1dzilpM3u
         govCArCoIOJn+P5FI+RC4rJH7WP5EhbkO0Z9Ck5jNG/5q85shgMBU9Wts99Y8PgHE9Lc
         HEoQ==
X-Gm-Message-State: AOAM5322cRktBcFdqOeQvdmnG+WyxXQTkDYXSGxlzRD1f7WZUs9z8nUq
        P2TOVhDKFs76vMW7NpdYcSz5
X-Google-Smtp-Source: ABdhPJwpBS38djhjYupgYTEAVkCqPNakXAMmYdvNAvb8uT0GZ4JqP+WK/Ds5JalxsgdaNkXTKlaIBw==
X-Received: by 2002:a62:37c1:: with SMTP id e184mr2628635pfa.238.1592470541355;
        Thu, 18 Jun 2020 01:55:41 -0700 (PDT)
Received: from mani ([103.59.133.81])
        by smtp.gmail.com with ESMTPSA id j12sm2273422pfd.21.2020.06.18.01.55.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Jun 2020 01:55:40 -0700 (PDT)
Date:   Thu, 18 Jun 2020 14:25:33 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     wg@grandegger.com, kernel@martin.sperl.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Add Microchip MCP25XXFD CAN driver
Message-ID: <20200618085533.GA26093@mani>
References: <20200610074442.10808-1-manivannan.sadhasivam@linaro.org>
 <fbbca009-3c53-6aa9-94ed-7e9e337c31a4@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbbca009-3c53-6aa9-94ed-7e9e337c31a4@pengutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 0611, Marc Kleine-Budde wrote:
> On 6/10/20 9:44 AM, Manivannan Sadhasivam wrote:
> > Hello,
> > 
> > This series adds CAN network driver support for Microchip MCP25XXFD CAN
> > Controller with MCP2517FD as the target controller version. This series is
> > mostly inspired (or taken) from the previous iterations posted by Martin Sperl.
> > I've trimmed down the parts which are not necessary for the initial version
> > to ease review. Still the series is relatively huge but I hope to get some
> > reviews (post -rcX ofc!).
> > 
> > Link to the origial series posted by Martin:
> > https://www.spinics.net/lists/devicetree/msg284462.html
> > 
> > I've not changed the functionality much but done some considerable amount of
> > cleanups and also preserved the authorship of Martin for all the patches he has
> > posted earlier. This series has been tested on 96Boards RB3 platform by myself
> > and Martin has tested the previous version on Rpi3 with external MCP2517FD
> > controller.
> 
> I initially started looking at Martin's driver and it was not using several
> modern CAN driver infrastructures. I then posted some cleanup patches but Martin
> was not working on the driver any more. Then I decided to rewrite the driver,
> that is the one I'm hoping to mainline soon.
> 

So how should we proceed from here? It is okay for me to work on adding some
features and also fixing the issues you've reported so far. But I want to reach
a consensus before moving forward.

If you think that it makes sense to go with your set of patches, then I need an
estimate on when you'll post the first revision.

> Can you give it a try?
> 
> https://github.com/marckleinebudde/linux/commits/v5.6-rpi/mcp25xxfd-20200607-41
> 

Sure thing. Will do.

Thanks,
Mani

> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
