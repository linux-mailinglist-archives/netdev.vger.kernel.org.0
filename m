Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B08E31C17B
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 19:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhBOS1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 13:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbhBOS0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 13:26:55 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FEFC061756;
        Mon, 15 Feb 2021 10:26:14 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id b145so4662897pfb.4;
        Mon, 15 Feb 2021 10:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xOUAe/T2MGoHA6DdbGUuxRC8W/GLeCH9tH82IEaXibA=;
        b=NRfbNk4LtP/BhuVLIRF0AwcZBnfk6PgPCHFMkziFVQfi6W4mb3nGXKUqD0DU/o7JF3
         edl8QzDQ/2ff0uaafpNQm/qq4YQ/fnZK2pPgEcnpw+VnJ7xz4jbtXF5/P5NU0mpcCUUf
         O5G3eBMqwqCYzxa9dIQ3xv3DzZqI1PY/VL24rjiNP2H2SphK+lf1oBhNhrTW39OA34yp
         Qymk/4sq7RXj1KTaz4zCbWWIUC7juJrHL+EEjMedNer4u2k3/jadkxI70JzMbR01M9n0
         IpXm+DjbnPkTkATeEGVrKIFf5dXVDOQyhCeDyYk00dsWUIy6ELnZAKf6+qt2ocmBO9Ye
         gv5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xOUAe/T2MGoHA6DdbGUuxRC8W/GLeCH9tH82IEaXibA=;
        b=bL6UPsWXLaB8YZXw3E4lV36CsifaMFDjITmsrbYFr+ncJm+yrgLeAPl8HUBN9v6+Il
         rdN6YDVlCQWPKQ8Tou1nKZRVxnDgrs6t93dOXO6uLQKJi8YLcJbyEB41KS89NC26HRVl
         PsuMTiMgvobj6QUp4+edl7QC7skubuVCgcSEZUlGCeHQanp6O+ArLDk1Wy07mkLoLTdK
         Vl05WRdxqObYZH/dTo5/tmxbNU8HoMIJ9E+E/Yqyo2WHSh4Vl6M9JTOfaciojyoF4Anb
         BCA5aiFeFOuB/JlgkYkLrf/YVE0H86Xj6570rw1VUhdqR3eRJFQ/LFrbbbpkZwsfestA
         +8Eg==
X-Gm-Message-State: AOAM533LP/cv6jk9HL+lro3sBmi3R6JQnAkdz2CZRyIRnCqiS5irW1Db
        zShYyBLUOjIxIdGD44E514Mxx6NBU9UtGoWSMYM=
X-Google-Smtp-Source: ABdhPJyfvT5Scb5kBdmlrRTQ9J5ttgCmI5xFzvME98Q3rXiKvB9CeiDOcjVpRs51w99dDVX/D/822WjIWkHdg+DRQXo=
X-Received: by 2002:a05:6a00:854:b029:1b7:6233:c5f with SMTP id
 q20-20020a056a000854b02901b762330c5fmr16623029pfk.73.1613413574363; Mon, 15
 Feb 2021 10:26:14 -0800 (PST)
MIME-Version: 1.0
References: <CAHp75VecgvsDqRwmyJZb8z0n4XAUjEStrVmXDZ9-knud7_eO3A@mail.gmail.com>
 <CALeDE9PkZnrZ=cXKB16+oZ0=O=3XSYqsgXi9TKeuWT7KqXrdNQ@mail.gmail.com>
In-Reply-To: <CALeDE9PkZnrZ=cXKB16+oZ0=O=3XSYqsgXi9TKeuWT7KqXrdNQ@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 15 Feb 2021 20:25:58 +0200
Message-ID: <CAHp75VedCFYFr7DAkhV+ZZKqtmff+CDKrR=e2ccz=hW8qcV+uw@mail.gmail.com>
Subject: Re: commit 0f0aefd733f7 to linux-firmware effectively broke all of
 the setups with old kernels
To:     Peter Robinson <pbrobinson@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Josh Boyer <jwboyer@kernel.org>, Ferry Toth <fntoth@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 8:03 PM Peter Robinson <pbrobinson@gmail.com> wrote:
>
> > Seems the commit 0f0aefd733f7 to linux-firmware effectively broke all
> > of the setups with the old kernels. Firmware name is an ABI (!) and
> > replacing it like this will definitely break systems with older
> > kernels. Linux firmware package likely, but unfortunately, should
> > carry on both versions as long as it's needed. Alternative solution is
> > to provide the links during installation.
>
> It does provide the links using the copy-firmware.sh and the details in WHENCE.
>
> The alternative is to leave firmwares in place with CVEs.

Good, thanks, I haven't looked into that script.


-- 
With Best Regards,
Andy Shevchenko
