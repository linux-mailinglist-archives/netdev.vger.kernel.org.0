Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E41158250F
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 20:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730155AbfHESv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 14:51:56 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46843 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727830AbfHESvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 14:51:55 -0400
Received: by mail-lj1-f194.google.com with SMTP id v24so80300130ljg.13;
        Mon, 05 Aug 2019 11:51:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BNhKN5SY5q1+Mh+bjmt4HOn1FwJMHHMXbbFzHulQuBA=;
        b=J00fOI+onR1tDus4oV9oV+TGNef7Wbxv2OUhyeBP/5n/uDg5jfa2XaS8vNCNExDq11
         xtvgTgVIE5+BknKwkzsmJtM/xXcFtME8MH4VZhq4luA/Bgu3Yoj7Ar+yp8ur6qQuMWcJ
         x8/S8ai2Tfzwcux76+M9OLFVVAflOJhban5+NeISkw04jGeMmZNOx63Bvo1/M9iZwjla
         DN0B9Iyn32WkD5PLUeLiuRhgSEI9rkGMXyRTq2/YUb7ZbOc4Cds+lTuFaTzLkmiwAVEJ
         JUBrB5W6EsVpgohkTNIJtEGA0VQNzVOEi45HBvJkhmVk/nHzsl3wMjdjpFCNfWgQtEgL
         mNMw==
X-Gm-Message-State: APjAAAWkAREiasQowWDCLHDIVAU18iLgfCT2sOVzUMdZPnhpl2s9/ZJH
        LhCVWljS3Ddl/NbpdMfTmSdsteDPEMY=
X-Google-Smtp-Source: APXvYqwc17/1KeX288W1OqU+7d4hrTFRFzgI9iUVlO18mUkLwlGYmb+rjuzCyiLl7coC9aG5rCLADQ==
X-Received: by 2002:a05:651c:87:: with SMTP id 7mr69620380ljq.184.1565031113348;
        Mon, 05 Aug 2019 11:51:53 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id k23sm13999254ljg.90.2019.08.05.11.51.52
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 11:51:52 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id m8so46556110lji.7;
        Mon, 05 Aug 2019 11:51:52 -0700 (PDT)
X-Received: by 2002:a2e:9b4a:: with SMTP id o10mr22932480ljj.137.1565031112745;
 Mon, 05 Aug 2019 11:51:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190802202323.27117-1-thbonotto@gmail.com> <20190805145020.GE1974@kadam>
In-Reply-To: <20190805145020.GE1974@kadam>
From:   Helen Koike <helen@koikeco.de>
Date:   Mon, 5 Aug 2019 15:51:41 -0300
X-Gmail-Original-Message-ID: <CAPW4XYb-KycdZjfb7y786+3VJhfxhj-9qs7DCr3Kyc8o3kUysw@mail.gmail.com>
Message-ID: <CAPW4XYb-KycdZjfb7y786+3VJhfxhj-9qs7DCr3Kyc8o3kUysw@mail.gmail.com>
Subject: Re: [Lkcamp] [PATCH] staging: isdn: remove unnecessary parentheses
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Thiago Bonotto <thbonotto@gmail.com>, devel@driverdev.osuosl.org,
        Karsten Keil <isdn@linux-pingi.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, lkcamp@lists.libreplanetbr.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Aug 5, 2019 at 11:51 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> This driver is obselete so we're just keeping it around for a couple
> kernel releases and then deleting it.  We're not taking cleanups for it.

I'm sorry, it was me who suggested Thiago to make this change
as his first contribution, I didn't see the TODO file.

Thiago, it would be great if you could send a patch to another staging driver
to get starting and to learn how the kernel development cycle works.
Feel free to ping me or the lkcamp group if you want some pointers/guidance.

Thanks both for your contribution.
Helen

>
> regards,
> dan carpenter
>
>
> _______________________________________________
> Lkcamp mailing list
> Lkcamp@lists.libreplanetbr.org
> https://lists.libreplanetbr.org/mailman/listinfo/lkcamp
