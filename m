Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 727C76F951
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 08:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfGVGHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 02:07:49 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54894 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfGVGHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 02:07:49 -0400
Received: by mail-wm1-f68.google.com with SMTP id p74so33831374wme.4;
        Sun, 21 Jul 2019 23:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Qyf4qXRMS1midgw/1TAz5WQhu/fgbPVXI6Nn/GIQkdg=;
        b=TosEpE2RwM6xynQVH59rTr9w9S0/ihm0TPsc+QyVe82pkKrhUd2qpQCMPapT2JemTf
         1+c6SKKsF6cOgmau/etNT9wqQ5WQwRRMvSwCrsbpjgKSR4GjjtEiArDUC2Tg9ntQnGSF
         bhBv5pZr+wNzd8zopRUpcYQhlyrOldsj1W9XR+5MYRJ65+py9hfIwQpOBUHl3hEGsteG
         l0fW27tha+BMNGUHNjL80tZCrSxR2y80ZlGW9tICIBzDK0LiCvY72EBk8/syRGUQLv0k
         QRp7j7JIuW+hfmJuoGTsUBmQtw0NRvvC5kQvHmE3QCkSh5yyMlVFoI0PRKT6WW7U9SWy
         FAXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Qyf4qXRMS1midgw/1TAz5WQhu/fgbPVXI6Nn/GIQkdg=;
        b=kaYu5AI3J/CqZIT356nl6LgITi3yvStEU++EDplBqOR8T5Sk/TgYQ1i4VfgUWyb60N
         ZtSY1xe2PXuUp2jnBPyGbpxufiM1s6hJULNr/WqzEoVsZl+pa0u5pbBYst7ESnTegU2l
         Zrhx330fbDSIRjVWqgLsmOpO/PVAxVQTd8ef2ktkisnA+Ra/p9Ayv50YZmkN57KpGSby
         E06dDUb85HP9RqtsuPsmLaQBvWEkMF2t6QSwM3DUxzJNB0QFcspC3+vJDTRwDcQIZXep
         DVrN58ZRqJCvlTKPs5lQwD6tCMSjQmdinpE4nNPY25oROLwQssW50iWmucgR+VDSGEXQ
         yTRw==
X-Gm-Message-State: APjAAAVgQWYG/Yax66t0zvOP1KDr6WNqsBBE4Ok1G1THrocJh0LqntYs
        pKUp583SS1S+zE13WE0W3tHTDoM=
X-Google-Smtp-Source: APXvYqzkN5t2jA3UAitmn1U2UclvW56UUzolPPcT8VfbawNp0cG6iXggnIsCpjCzfKxJ/JlHwq0tnw==
X-Received: by 2002:a7b:c104:: with SMTP id w4mr64077505wmi.42.1563775667215;
        Sun, 21 Jul 2019 23:07:47 -0700 (PDT)
Received: from avx2 ([46.53.250.207])
        by smtp.gmail.com with ESMTPSA id e7sm36158149wmd.0.2019.07.21.23.07.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 23:07:46 -0700 (PDT)
Date:   Mon, 22 Jul 2019 09:07:44 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, axboe@kernel.dk, kvalo@codeaurora.org,
        john.johansen@canonical.com, linux-arch@vger.kernel.org
Subject: Re: [PATCH] unaligned: delete 1-byte accessors
Message-ID: <20190722060744.GA24253@avx2>
References: <20190721215253.GA18177@avx2>
 <1563750513.2898.4.camel@HansenPartnership.com>
 <20190722052244.GA4235@avx2>
 <1563774526.3223.2.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1563774526.3223.2.camel@HansenPartnership.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 22, 2019 at 02:48:46PM +0900, James Bottomley wrote:
> On Mon, 2019-07-22 at 08:22 +0300, Alexey Dobriyan wrote:
> > On Mon, Jul 22, 2019 at 08:08:33AM +0900, James Bottomley wrote:
> > > On Mon, 2019-07-22 at 00:52 +0300, Alexey Dobriyan wrote:
> > > > Each and every 1-byte access is aligned!
> > > 
> > > The design idea of this is for parsing descriptors.  We simply
> > > chunk up the describing structure using get_unaligned for
> > > everything.  The reason is because a lot of these structures come
> > > with reserved areas which we may make use of later.  If we're using
> > > get_unaligned for everything we can simply change a u8 to a u16 in
> > > the structure absorbing the reserved padding.  With your change now
> > > I'd have to chase down every byte access and replace it with
> > > get_unaligned instead of simply changing the structure.
> > > 
> > > What's the significant advantage of this change that compensates
> > > for the problems the above causes?
> > 
> > HW descriptors have fixed endianness, you're supposed to use
> > get_unaligned_be32() and friends.
> 
> Not if this is an internal descriptor format, which is what this is
> mostly used for.

Maybe, but developer is supposed to look at all struct member usages
while changing types, right?

> > For that matter, drivers/scsi/ has exactly 2 get_unaligned() calls
> > one of which can be changed to get_unaligned_be32().
> 
> You haven't answered the "what is the benefit of this change" question.
>  I mean sure we can do it, but it won't make anything more efficient
> and it does help with the descriptor format to treat every structure
> field the same.

The benefit is less code, come on.

Another benefit is that typoing

	get_unaligned((u16*)p)

for
	get_unaligned((u8*)p)

will get detected.
