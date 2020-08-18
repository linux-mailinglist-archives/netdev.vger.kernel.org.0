Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CA4248234
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 11:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgHRJua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 05:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgHRJu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 05:50:28 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDFEC061343
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 02:50:28 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a5so17641339wrm.6
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 02:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=KDn/L/KgtGjfXOwvFM3d0ycolsRtvWGhY+IU39u+X2I=;
        b=sfBZhgvdUnGznJEo+Fcb9wMuFjWPXc+9UyK5W7mn6ZVikBjC9pqwkoJi5IafZR0gkl
         vgL1ZKVd5RDfHNTuPkY3RFpg7AUtf3pNQi3J0mZpOMUC4qmcxHW5XLiUcOdGEllDSyLf
         s/Eq4wUgkxMzpcZ5VGQfC2USDRS28oFOKG4naOfGrXD2liqaJDkHhTjmQJfK7qYw/0x1
         kH3nYgWp/zwaj2VKMDJPyxYcCnAWU/+gx0CeriL/zJ3TjEDFYabY86wIKDQDVhaveEEm
         pGmuCMyTVATxmjOk3r+EzalELAUljZdQEdjZ+hDwTuOdd6565PXAA36XbpmoOqNP0gOx
         tSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KDn/L/KgtGjfXOwvFM3d0ycolsRtvWGhY+IU39u+X2I=;
        b=Zt66xM9JY357g1q8k/F5xp2BE0964YQuZr+aJjtqaGBnYhj6ygEOyyY/I/qv70njm9
         va1qu/Q5hQ7krevF+p4p5m7i6zi0+MeSACUdjhP2jnF5pJIBVP7lKFsIqBjwinJYdYRm
         466gNxrRZKDQ9iGbVwFJFbq7PWSHvZEe0rIOW589/d7XwIhHRGhXF4VbToMh58Il/kMo
         XSJtjjyUM0rpviLWT4Wy/kDdBS9TD00UscX78/aXwbb818/eQG0izm1HBGV/cQ0VOGAj
         0w4/E3QQPNO12LVfSvTB3W8JyqNx1FYy8sv3uolXLupL1nobWA3Ee5nKKx4bHNJkhXc5
         /20w==
X-Gm-Message-State: AOAM530O9YSXj0N1MjzXJ5sXEgve0BxZUEJhgFxvdKLuQ+pXm+pOSkZ+
        NqxYspksKjJ2l48iBKwaGYi9PQ==
X-Google-Smtp-Source: ABdhPJz1F0Shr79zg0ZgvQ3EF447qJ/7AgvM1fwOZGThYbUCe++2sCbkQwJc4VdZGNq+dmjgy0daFQ==
X-Received: by 2002:a5d:6348:: with SMTP id b8mr19151821wrw.362.1597744226614;
        Tue, 18 Aug 2020 02:50:26 -0700 (PDT)
Received: from dell ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id h10sm33963387wro.57.2020.08.18.02.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 02:50:25 -0700 (PDT)
Date:   Tue, 18 Aug 2020 10:50:24 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Christian Lamparter <chunkeey@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        Christian Lamparter <chunkeey@googlemail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 08/30] net: wireless: ath: carl9170: Mark 'ar9170_qmap'
 as __maybe_unused
Message-ID: <20200818095024.GZ4354@dell>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
 <20200814113933.1903438-9-lee.jones@linaro.org>
 <7ef231f2-e6d3-904f-dc3a-7ef82beda6ef@gmail.com>
 <9776eb47-6b83-a891-f057-dd34d14ea16e@rasmusvillemoes.dk>
 <87eeo5mnr0.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87eeo5mnr0.fsf@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Aug 2020, Kalle Valo wrote:

> Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:
> 
> > On 14/08/2020 17.14, Christian Lamparter wrote:
> >> On 2020-08-14 13:39, Lee Jones wrote:
> >>> 'ar9170_qmap' is used in some source files which include carl9170.h,
> >>> but not all of them.  Mark it as __maybe_unused to show that this is
> >>> not only okay, it's expected.
> >>>
> >>> Fixes the following W=1 kernel build warning(s)
> >> 
> >> Is this W=1 really a "must" requirement? I find it strange having
> >> __maybe_unused in header files as this "suggests" that the
> >> definition is redundant.
> >
> > In this case it seems one could replace the table lookup with a
> >
> > static inline u8 ar9170_qmap(u8 idx) { return 3 - idx; }
> >
> > gcc doesn't warn about unused static inline functions (or one would have
> > a million warnings to deal with). Just my $0.02.
> 
> Yeah, this is much better.
> 
> And I think that static variables should not even be in the header
> files. Doesn't it mean that there's a local copy of the variable
> everytime the .h file is included? Sure, in this case the overhead is
> small (4 bytes per include) but still it's wrong.

It happens a lot.

As I stated before, the 2 viable options are to a) move it into the
source files; ensuring code duplication, unnecessary maintenance
burden and probably disparity over time, or b) create (or locate if
there is one already) a special header file which is only to be
included by the users.

The later option gets really complicated if there are a variety of
tables which are included by any given number of source file
permutations.

The accepted answer in all of the other subsystems I've worked with so
far, is to use __maybe_unused.  It's simple, non-intrusive and doesn't
rely on any functional changes.

> Having a static inline
> function would solve that problem as well the compiler warning.

This time yes, but it's a hack that will only work with simple,
linear data.  Try doing that with some of the other, more complicated
tables, like mwifiex_sdio_sd8*.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
