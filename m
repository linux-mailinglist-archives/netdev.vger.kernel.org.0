Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A258C3DF24A
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbhHCQPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbhHCQPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:15:34 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC69C061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 09:15:20 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id e19so37180422ejs.9
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 09:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=3egl3tcFSK+8LCnm5+Q/2C4EP0wLkWqUr3gqzaDZJSQ=;
        b=PXALqmegNFgqrzPrLO42ygl3/L3Crk1ZKymOY2il3LuwW9aiGUPtfuAy5pRHV86T9L
         Q76cCdGhH6SU+e/5sHAxXuIJxmyfq13ckSbBS+ecNnTGwO3edT2PQ4Qy1Jf2YpcLiCl6
         UYvU25y9Qo1XCtSqShCG/QWQtuLALMJc2fV5w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=3egl3tcFSK+8LCnm5+Q/2C4EP0wLkWqUr3gqzaDZJSQ=;
        b=W7gk5gGHk9XGYmlKg/9X6XXjIPqTRiCIduY7S/gxiRip/Kfi3dMFskv/it0aErXoEZ
         +hlgY31tUlWL3gKs11DDDJQ3GEwGpwQZmsX20rutK1M/W8dY7a79JKnsOYFDa9uPj0H/
         ETWWoctvKfCdWfEf+H9xR8lSVyPJiRRUuYdb+R+eJk0LXhXBCA1PRq4vl8PdfimfLlHv
         yKYWTmDwkguJFpTcSpZWsBNF7gx+JYNuu3DKMykzYl3BXJDbGgMrZtt0B0y980zlNz47
         CvowexCTJDWEqEcaGaoBx1Bb2TMpPzRW7ZUZRTO/Mu3PW/6OfaLwLqEiRuc30YYVYHfO
         8y+w==
X-Gm-Message-State: AOAM5308blzJiIYxEukd6L4+/YrIhLk2+VZSso9RXOtPVnn9k08Y8AwM
        raBIx5tT54U53jeIAzgNqO1Ycw==
X-Google-Smtp-Source: ABdhPJyE0JY8H44cT/uTcyqPK3NJjU26kfTSX9gQgwQSmQLMO43rxLFF4XWlknGg+kQ1MFJ57YyhKw==
X-Received: by 2002:a17:906:5911:: with SMTP id h17mr13082046ejq.440.1628007319466;
        Tue, 03 Aug 2021 09:15:19 -0700 (PDT)
Received: from carbon ([94.26.108.4])
        by smtp.gmail.com with ESMTPSA id x12sm5676688edv.96.2021.08.03.09.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:15:19 -0700 (PDT)
Date:   Tue, 3 Aug 2021 19:15:17 +0300
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, Petko Manolov <petkan@nucleusys.com>
Subject: Re: [PATCH net 1/2] net: usb: pegasus: Check the return value of
 get_geristers() and friends;
Message-ID: <YQlrlclZrODbtNS0@carbon>
Mail-Followup-To: Pavel Skripkin <paskripkin@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, Petko Manolov <petkan@nucleusys.com>
References: <20210803150317.5325-1-petko.manolov@konsulko.com>
 <20210803150317.5325-2-petko.manolov@konsulko.com>
 <eeb03520-f57a-1c78-fe84-0b72edea371f@gmail.com>
 <YQlkh54HdqQYZenw@carbon>
 <58f9122f-3ad3-9d6b-7ae3-5d5a83f19334@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58f9122f-3ad3-9d6b-7ae3-5d5a83f19334@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21-08-03 18:46:36, Pavel Skripkin wrote:
> On 8/3/21 6:45 PM, Petko Manolov wrote:
> > On 21-08-03 18:28:55, Pavel Skripkin wrote:
> > > On 8/3/21 6:03 PM, Petko Manolov wrote:
> > > > From: Petko Manolov <petkan@nucleusys.com>
> > > > > Certain call sites of get_geristers() did not do proper error
> > > handling.  This
> > > > could be a problem as get_geristers() typically return the data via pointer to a
> > > > buffer.  If an error occured the code is carelessly manipulating the wrong data.
> > > > > Signed-off-by: Petko Manolov <petkan@nucleusys.com>
> > > 
> > > Hi, Petko!
> > > 
> > > This patch looks good to me, but I found few small mistakes
> > 
> > Yeah, the patch was never compiled.  Sorry about it.  v2 is coming up.
> > 
> 
> BTW: should this also go to stable with Fixes: 1da177e4c3f4
> ("Linux-2.6.12-rc2")?

Yeah, i think so.  Apparently the issues this patch fixes have not manifested
themselves very frequently.  Either that or nobody is using this driver now. :)

Anyway, the bugs are real and fixes going to the stable series is well
justified.  Thanks a bunch for the review.


cheers,
Petko
