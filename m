Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A353B341788
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 09:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbhCSIb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 04:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234226AbhCSIa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 04:30:58 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E0EC06174A;
        Fri, 19 Mar 2021 01:30:57 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id v24-20020a9d69d80000b02901b9aec33371so7788000oto.2;
        Fri, 19 Mar 2021 01:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aOBAOoUYVUuaQ/ANg0jzaMHaepXG3KDq4pE4MIvdG8o=;
        b=ehKcIFpqcFvs6rmBGhhYLOmTa156yRI+RgCEmgIEkZfjrNkBsB7Su31mJPBIbzGPVA
         iroPBc8wT7bt0wZcHbLRDyK4q6LtniOz0X3MB0C6sAiW4xQ06OTTyPgzfWFTcHurActw
         rtAncV4a5KU1YpT5hEVwxgiFF0F4KmnMO/MNv5aUvkZu7YTrd8Q293NxvSlLyVN4rSEA
         Zo+qsNIBemsj8hOvm/OAu38NzxqQ+5uOzcKSfG5nvB5DQMHBOidYiS9CK9g8uW25CyLw
         trLjhuXGM9dGCkiDZmNhzOgsOicmkrsPXS6M0hHa38odvX4EqT0xcDVgylz6mT/TjgmD
         HFZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aOBAOoUYVUuaQ/ANg0jzaMHaepXG3KDq4pE4MIvdG8o=;
        b=LZ+CPysagYdivnAOXHdJGJyFy0WtoZ+k9UQnMNu4wBh5VMQo9fQh8nqV/jgM/MFscL
         Mg5+y/z8Chzu8bvITH0zE8iNUavRd9tX15pFtJUNwWizj6m6vxmxxD1v28e1xqaTY14I
         +XIdSZVGNAnKt3x34CGFPzScsmquWBO2iRV019TZiqzkpgZbNBc7f5uwaSBjd6MrN8tr
         /LaM/wJ33MFzdKhFaTvDr9umgbv2nQyy560taVGVuoDLtoVNiMrhIG2u6S27liWE6PtX
         d71G5284HKwcsBcMjzoH6tbnUkqdOT4Zb63XZDqVE3R+gyOMpS/dy8uaR9XRyFi2f4Ya
         /CGQ==
X-Gm-Message-State: AOAM531akDnfeUJXXvtfCZHfIoxxfgpSLsRSox5eM69rRE1xx3i6ocRG
        a7hbc+Fa0GBb3ohZfOcZSW70tID9Y/ND3dFNTUA=
X-Google-Smtp-Source: ABdhPJxk8oR3tZuE0wVizpmB2OZnYufj91eZnehno59lNg/ie7ktVZyajwutrf5ekj5wc59CR8jJZnhWvSE50F+P5cA=
X-Received: by 2002:a9d:12a7:: with SMTP id g36mr190938otg.304.1616142657379;
 Fri, 19 Mar 2021 01:30:57 -0700 (PDT)
MIME-Version: 1.0
References: <87tupl30kl.fsf@igel.home> <04a7e801-9a55-c926-34ad-3a7665077a4e@microchip.com>
 <87o8fhoieu.fsf@igel.home>
In-Reply-To: <87o8fhoieu.fsf@igel.home>
From:   Yixun Lan <yixun.lan@gmail.com>
Date:   Fri, 19 Mar 2021 08:28:06 +0000
Message-ID: <CALecT5gY1GK774TXyM+zA3J9Q8O90UKMs3bvRk13yg9_+cFO3Q@mail.gmail.com>
Subject: Re: macb broken on HiFive Unleashed
To:     Andreas Schwab <schwab@linux-m68k.org>
Cc:     Claudiu.Beznea@microchip.com, linux-riscv@lists.infradead.org,
        ckeepax@opensource.cirrus.com, andrew@lunn.ch, w@1wt.eu,
        Nicolas.Ferre@microchip.com, daniel@0x0f.com,
        alexandre.belloni@bootlin.com, pthombar@cadence.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI Andreas:

On Wed, Mar 17, 2021 at 4:27 PM Andreas Schwab <schwab@linux-m68k.org> wrote:
>
> It turned out to be a broken clock driver.
>

what's the exact root cause? and any solution?
seems I face the same issue, upgrade kernel to 5.11, then eth0 fail to bring up

Yixun Lan
