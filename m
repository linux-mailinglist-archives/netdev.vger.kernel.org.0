Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5348DC8C53
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 17:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbfJBPIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 11:08:20 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37222 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbfJBPIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 11:08:20 -0400
Received: by mail-oi1-f195.google.com with SMTP id i16so17936552oie.4;
        Wed, 02 Oct 2019 08:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YmSfdMBXuUuD115PJSXFrkPyMi20h5DIGdK6TZuxENs=;
        b=klSOlgL/Pni96RCEFMJVNWvhyv1WFwpKQdSWoxOCalLMRp2s7Yexbnqh5Ap8Rp2Q0U
         cETfzIh6g4ueWH6Qrg93J2mGmWMp0oeOUokcH7aokt6v9t2fL4PtEeek/R5eLTxlOo8W
         UNJeuCgd2BgiNGVncG2oA435x7kMKO+ninzk+cEKXpR069FEpvqlsX9YEvFDxHM5W94E
         1hrTL/EPjLZf21cZ30yt+ACqXcm+fH8Y0se5dU+jL2VOzrJU3cCZNFqN1xihD4WP+vlq
         IQgbFSpQ5iLEzXV5fzc4xc9Lo5M2ErUJAmJLvD+OLN+VbNvaWuxPIIr9Ak4ZTrCIA8a6
         bHpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YmSfdMBXuUuD115PJSXFrkPyMi20h5DIGdK6TZuxENs=;
        b=q79Bwm3wXQUEaSBRyhsHiSZEyypxp+qoeArJmDEkI+EwFvlNL5AHOQd76+WCtqbRFP
         azkpGebM62ortN7RukoeaY6GuJfxSR1KsWd/dO7S4DveveGVDZch7GJsAa6YzsGGTldG
         MRtEWfrBNJjpHDbut8yuJtDfR5/l4vgcTuIeoM8cogH8MBNdayWm18gBxzjIRau4p8oF
         0E5WL5nTgdPvQ6RbvfqNfc7okAOVCDEjZ9bi7wqqkSfuzyX0VheB3pqOFUswumqJW98r
         9h1mOAoFJ5vfuzZW5hzHgwV+0xwg1/wuS5wM3Cqex6nK5jUzLDqv8CaVHT5/KwijtVoO
         s2CA==
X-Gm-Message-State: APjAAAUSQFNninI7vsOMmY17xMzikUeISMXaC/DuiY4hN2YzsBBn1R50
        O5TneZWWpWbKeatArelfLGoV99LTqx+ggbPm6Kk=
X-Google-Smtp-Source: APXvYqwNaFTClKjVAM3TyZuAuQBGaHB29cIE5MhlZUY+u7sByDZbV4Dc3NFaiMLWVunUTnWHxGWS7GioW77WWL9fHDM=
X-Received: by 2002:aca:b902:: with SMTP id j2mr3049364oif.169.1570028899370;
 Wed, 02 Oct 2019 08:08:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190918183552.28959-1-TheSven73@gmail.com> <20190918183552.28959-5-TheSven73@gmail.com>
 <20190930140714.GC2280096@kroah.com>
In-Reply-To: <20190930140714.GC2280096@kroah.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Wed, 2 Oct 2019 11:08:08 -0400
Message-ID: <CAGngYiWu=LVr06YSZ4WuN+QCfz4k2JJmqOYQ=sZWSUEu+gJq5Q@mail.gmail.com>
Subject: Re: [PATCH v1 4/5] staging: fieldbus core: add support for FL-NET devices
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Enrico Weigelt <lkml@metux.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "J. Kiszka" <jan.kiszka@siemens.com>,
        Frank Iwanitz <friw@hms-networks.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 10:09 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Sep 18, 2019 at 02:35:51PM -0400, Sven Van Asbroeck wrote:
> > Add the FL-NET device type to the fieldbus core.
>
> What does this mean?
>
> You add an unspecified enumerated type and suddenly new hardware starts
> working?  That feels really wrong to me...
>

This just empowers fieldbus devices to id themselves as 'flnet' when they
register with the core:

priv->fbdev.fieldbus_type = FIELDBUS_DEV_TYPE_FLNET;
...
err = fieldbus_dev_register(&priv->fbdev);

The core exports this as a sysfs property, so that userspace has a
standardized way of determining the fieldbus type when looking at the
fieldbus dev's sysfs dir.

Yes the commit message is too confusing. I'll write a better one if/when I
repost flnet support. Might be a while because you indicated "no new h/w
support while still in staging".
