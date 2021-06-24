Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835813B2724
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 08:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhFXGJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 02:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbhFXGJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 02:09:31 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B688EC061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 23:07:12 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id c84so3096677wme.5
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 23:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sTi4UDWojTVu1dnCO5B8yjBIysDsKkKbkZQOG8tJeMg=;
        b=XPvKK6RrkXchKmYdJ6VlAiNsoZYRUBR4NJjPV0JjkKUzza47D/wl03GiYQEMeiH+Zh
         KANkZVgxwbOMgrQ/YvPQz1WYBpwtFgT93ig66z4zPFOGIX9+NOy8adO6HU6uby4W86aI
         NiXM8TkT8tZRLtQt+4NHbPnIN2/dAD6VQDNwoIZihZPfbM4U++OJgfyth0WtVLgL7aZa
         RlgaKrS0FDwaXx4nyP7K432eUImIp5Q4SdXEH5TQE/3uU57Ge365nGzu0VKjfZaZZXIh
         dEvnOS2Z3AdyoBwXwC8ICBE6BXaW8nH3ok+w5pQIh+A6r8xwgQi4ELjTQcWuMp7gU/Ve
         4vwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sTi4UDWojTVu1dnCO5B8yjBIysDsKkKbkZQOG8tJeMg=;
        b=I2+orpE7B5cU84Mnk+RPGPbMEDFh3DAigLvSWIGD/lHpOir+Xv7GdYm8jxb8XXeXbA
         gHFtO2woIVCuATh0kHuhH4p1/EHNBERHSD1mAU36L781SJd+gKzuh759kEUzRMrgw5qV
         UbT/pszLzCvqocVCD3m4adTWKFupPrGv5Mj3wReDs8U0Yc5UwV2zrO9eZcmci6g+5eGo
         BHibblfzUjpJ0OU01VzlU3y1OhuG5a5TOmPc7Lh3j3gZA6qxvL27m5lp2TnKWnm1xkLg
         viJYDG5PgY7hGYxk8/SoLRo0oCQbrlBTpWv0PWeOdtxw8Ybm8EzSd/X/5mRB597JIzFu
         KVPQ==
X-Gm-Message-State: AOAM530LQ2rxp0u//jsr5PMgs8NgdYVJQJjWb6uqI2VVU1Rz11Sfn4TA
        Vy3RkEYKVYgCfRj0E9+LejwA9HfMKBKu8o5j7NM=
X-Google-Smtp-Source: ABdhPJz1BAdf86jKfRvcyAwYdF53IpP6UEcvbgigG3dyxocVdWdjTQXy3p1O0MypZG47BzvONHhtBBCaIlW2Epz3b2I=
X-Received: by 2002:a05:600c:3b8b:: with SMTP id n11mr2172855wms.159.1624514831314;
 Wed, 23 Jun 2021 23:07:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210624041316.567622-1-sukadev@linux.ibm.com> <20210624041316.567622-2-sukadev@linux.ibm.com>
In-Reply-To: <20210624041316.567622-2-sukadev@linux.ibm.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Thu, 24 Jun 2021 01:07:00 -0500
Message-ID: <CAOhMmr7RbBNF8BbRbf3hEdD0cj9OjihuuKmXJogSz=8ewtGWog@mail.gmail.com>
Subject: Re: [PATCH net 1/7] Revert "ibmvnic: simplify reset_long_term_buff function"
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Brian King <brking@linux.ibm.com>,
        Cristobal Forno <cforno12@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 11:16 PM Sukadev Bhattiprolu
<sukadev@linux.ibm.com> wrote:
>
> This reverts commit 1c7d45e7b2c29080bf6c8cd0e213cc3cbb62a054.
>
> We tried to optimize the number of hcalls we send and skipped sending
> the REQUEST_MAP calls for some maps. However during resets, we need to
> resend all the maps to the VIOS since the VIOS does not remember the
> old values. In fact we may have failed over to a new VIOS which will
> not have any of the mappings.
>
> When we send packets with map ids the VIOS does not know about, it
> triggers a FATAL reset. While the client does recover from the FATAL
> error reset, we are seeing a large number of such resets. Handling
> FATAL resets is lot more unnecessary work than issuing a few more
> hcalls so revert the commit and resend the maps to the VIOS.
>

This was not an issue when the original optimization code was committed.
VIOS changes over time and it is proprietary code, so people don't really know
what it changes every time. If you believe the verbose hcall is really
necessary,
you'd better document that in the function/source code. This patch may
be reverted again
some time later when the verbose calling isn't needed.
