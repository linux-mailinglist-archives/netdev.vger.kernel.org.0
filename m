Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACE082512
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 20:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbfHESw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 14:52:57 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41988 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfHESw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 14:52:56 -0400
Received: by mail-lf1-f66.google.com with SMTP id s19so58850923lfb.9;
        Mon, 05 Aug 2019 11:52:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tjeoZJSeJkKftPMhGTbICIt4Paaa37S6NJ3KXecwDeY=;
        b=fvTemu1MFvP3e3MNKI2Pbrf/wHX6q46nVKg2ocsEKct+hxK7sIF9rnoGKcqFrPVDTM
         VLqJ2qnYHZXXj8nt2uZ/0VdrOJZv32zzb3jLOfkfiSYoez0riQTYLWcj2YioqbkexiuO
         UYj7pDObX0bvq4tOOF7tu47ytdNawbEIwgl87EsaCt8RIn6f+MQpk0M7oKgHySEF3xkN
         YEmJIDIhPPD00fOHg7jz6jRLhVlkULOYmBD90AifoPzetFWPefgV9bufc2Tr//X+HF51
         mnjQ5xvoI+NtG18LsCy1PKiTppZj6Tl40aQMTWdeqtqgGuZ1JJHw7G36SUP9aTj+U16p
         4WVA==
X-Gm-Message-State: APjAAAXeQBrS3L8EaTpgQeRGi8sf1TNDZEgbdxj0WUME71fGdGktwy2r
        9vzq2l7AV/I+2uRu1vuwfFqxUcGvtUA=
X-Google-Smtp-Source: APXvYqzTljTOe2UuvkTqGvSOMSBz0h17PiloDwVWeaMUgvL8fo5qazYZQnEjG630THUuUjnC7BG+Sg==
X-Received: by 2002:a19:110:: with SMTP id 16mr7698001lfb.63.1565031174224;
        Mon, 05 Aug 2019 11:52:54 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id z23sm15124608lfq.77.2019.08.05.11.52.53
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 11:52:53 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id r9so80152710ljg.5;
        Mon, 05 Aug 2019 11:52:53 -0700 (PDT)
X-Received: by 2002:a2e:2c14:: with SMTP id s20mr17515926ljs.54.1565031173071;
 Mon, 05 Aug 2019 11:52:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190802195017.27845-1-ricardo6142@gmail.com> <20190802145448.0bcd5374@hermes.lan>
In-Reply-To: <20190802145448.0bcd5374@hermes.lan>
From:   Helen Koike <helen@koikeco.de>
Date:   Mon, 5 Aug 2019 15:52:42 -0300
X-Gmail-Original-Message-ID: <CAPW4XYYUQGungxgvDq5G7zhT3M+N75WrR1HoOFesMtU2hYK2dA@mail.gmail.com>
Message-ID: <CAPW4XYYUQGungxgvDq5G7zhT3M+N75WrR1HoOFesMtU2hYK2dA@mail.gmail.com>
Subject: Re: [Lkcamp] [PATCH] isdn: hysdn: fix code style error from checkpatch
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Ricardo Bruno Lopes da Silva <ricardo6142@gmail.com>,
        devel@driverdev.osuosl.org, Karsten Keil <isdn@linux-pingi.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, lkcamp@lists.libreplanetbr.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Aug 2, 2019 at 6:55 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri,  2 Aug 2019 19:50:17 +0000
> Ricardo Bruno Lopes da Silva <ricardo6142@gmail.com> wrote:
>
> > Fix error bellow from checkpatch.
> >
> > WARNING: Block comments use * on subsequent lines
> > +/***********************************************************
> > +
> >
> > Signed-off-by: Ricardo Bruno Lopes da Silva <ricardo6142@gmail.com>
>
> Read the TODO, these drivers are scheduled for removal, so changes
> are not helpful at this time.

I'm sorry, it was me who suggested Ricardo to make this change
as his first contribution, I didn't see the TODO file.

Ricardo, it would be great if you could send a patch to another staging driver
to get starting and to learn how the kernel development cycle works.
Feel free to ping me or the lkcamp group if you want some pointers/guidance.

Thanks both for your contribution.
Helen

>
> _______________________________________________
> Lkcamp mailing list
> Lkcamp@lists.libreplanetbr.org
> https://lists.libreplanetbr.org/mailman/listinfo/lkcamp
