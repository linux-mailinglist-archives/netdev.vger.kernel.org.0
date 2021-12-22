Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA67047D856
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 21:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbhLVUiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 15:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhLVUiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 15:38:50 -0500
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E14C061574;
        Wed, 22 Dec 2021 12:38:50 -0800 (PST)
Received: by mail-vk1-xa35.google.com with SMTP id j10so1989516vkk.12;
        Wed, 22 Dec 2021 12:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m0KHFHynG/Cv5zTmabkUB5fH/sivVPFmBLyvsRt42No=;
        b=Ybjbj0UO1bMSxVm24s+VgWqgDQVInB1dFf7a72G3NQHBi25DaAocVC2JDtmy8lX1VZ
         CNzW22BLdboUkKJk3oIWctUtHYs4zCdzf4mxBRIi1KSpBwypt7ojpL/aFQCve5wFT2u4
         2iWjQRZpa1eZndK3lyMDvHIR/KKO9NfAL9k1clSdEySqA9S7T9ADRKZ2mrPUqEMBnQC3
         0aoBPMp32YhNhsYXyQwdeO81D40noGhm192M3etGVF6VU0tqE0OdYkdNyzlo9xKSdNJo
         x6wCL7SWtafoBjBGTFX9YgD5M2VXBIUC0Ra8FeKgWbMQV7dZGAtuLaSFK4NalLBMXuvL
         dNjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m0KHFHynG/Cv5zTmabkUB5fH/sivVPFmBLyvsRt42No=;
        b=w5HTJyNX1idKBUjPw1aSo3rjdcylE18gmq52PvEk0Br7/joUfQfnqXSmAhm85+59hS
         dvOdbjG8ZyGNKf+TdHBdi4T/35vVHnPx0WoDxEQMACFQLtOOmfzqkc9jc+uF3EXSge3l
         mYte2dtsCFx1/39mDdEWvfiOXusvKKOvz+LeGLLezUMzApbmAh3IoqmxKF+q8rzKfg6D
         TtM2NncuUEm8dRfb5wN/S8En8OW5ZIMmArcUsO7gdB2tPEgIHxX7EW+kF3kXSVpt8Woq
         Npf0q5EycjhJszIdUYsWXTZ/PpvzofVaBLzudxTg7JYJ/6P5EGjqjU58XYtTf0lRJaEb
         BF9g==
X-Gm-Message-State: AOAM530OMt8ir50mWJmkdaehAigS5MqVjzGvhjI9a9gFr19YlAumalm6
        Vm3Pd7BW7eMaTj/3g0TLjOihP5q3Fn39YKn9+6g=
X-Google-Smtp-Source: ABdhPJyhRZ7yQ+kQtC7Eai0wKzixB4C3bCIj6QEUj7+m+Z8K3puQJOAO5xu+EJmR31kQtsDZBXp42BINhE0czYeEILc=
X-Received: by 2002:a05:6122:912:: with SMTP id j18mr1710393vka.41.1640205529214;
 Wed, 22 Dec 2021 12:38:49 -0800 (PST)
MIME-Version: 1.0
References: <20211222163256.66270-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20211222163256.66270-1-andriy.shevchenko@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 22 Dec 2021 23:38:44 +0300
Message-ID: <CAHNKnsS_1fQh1UL-VX0kXfDp_umMtfSnDwJXWxiBXFdyrK1pYA@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] wwan: Replace kernel.h with the necessary inclusions
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 22, 2021 at 7:32 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> When kernel.h is used in the headers it adds a lot into dependency hell,
> especially when there are circular dependencies are involved.
>
> Replace kernel.h inclusion with the list of what is really being used.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Subject and description do not cover cleanup of includes besides the
kernel.h. But that does not seem like a big issue, so:

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
