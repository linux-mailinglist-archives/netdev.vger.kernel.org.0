Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26352A87B2
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731867AbgKEUFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKEUFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:05:06 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F92DC0613CF;
        Thu,  5 Nov 2020 12:05:06 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id t18so1323858plo.0;
        Thu, 05 Nov 2020 12:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=seMETD+A0muyA/mqytcvGqhJO4LEpEn0huI9QAUp6i8=;
        b=lQGBVRxreZ2HL1YK7S/KtNHaL6hNDaZW6v2xBDn0Go4RcZCmJfgyyvj9X93ifBZMd/
         DKtcKaPoPcaMdNPP4iak5uVgkbj/sRxVt/vuqY/WPg7gjIdt6UiecV+9SaXp4j8b6i/h
         5IA/8DB4Swijl1UPH2xK8LBZas81eZwQIaAczAaHyRcXjYECzHgmdQD7A61N4DESlMMf
         vPfx5VCX0alnNBnEavDlS+Qggp7QcW4Z+tdtnSii3MGImxv71fTxDTCGHHKcuons+G/r
         toULyUA7KsARE+JT8AzsGrtqJhEDYon05wt9f0as6Yr9JH94s85I5bxHjMNgMEbQ4RYB
         bZDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=seMETD+A0muyA/mqytcvGqhJO4LEpEn0huI9QAUp6i8=;
        b=cF8ECjuAwAnvGlqGQ1mudtwS+zByDdA5KtRhWylaQFCsycWXBb4B9MfwmFcKCCM2uV
         LFehvgX/KK3NnarQvD8gE1CelHmQLVWM6MA/qQeT4CL+xspY3fBdwoz+uUpvfdBoPnWT
         X57w4EfEmYDIF8s9dxYZFDSIkEsFrahXOewzrFgAGcW1L1RtGmfPeU+p4TokpsEObQ08
         tXFqmVwgrljI1+yoU3rO0qq73GJ+xyg/MKd6rK+u67BIehLLlfL67cmUt8W60XeBHhBp
         uUTRp2yTIUKjiqiTWTuWz7mLFsl4UB7guiOnWY2p78CJO5eFNxAjhQXKsL+YiZCqwNzQ
         7WYQ==
X-Gm-Message-State: AOAM532KXnOGV5/KIgdxJrIwpjTSOiTI9pcBL4q+B4mp45R49+NrpBA0
        mcu1N0O03NZnP3uaE9PW+pLZC6dopPPCATwjMoyzJ02aAag=
X-Google-Smtp-Source: ABdhPJxhghQNiw0cuy94y+ex3onkHcYO9/7luHpEjoWg1Jp58maCMqTHVk0/YG4rcht2nUbuPNMKRPM7FfTEqW9F4Dc=
X-Received: by 2002:a17:902:82c8:b029:d6:b42f:ce7a with SMTP id
 u8-20020a17090282c8b02900d6b42fce7amr3604586plz.23.1604606706032; Thu, 05 Nov
 2020 12:05:06 -0800 (PST)
MIME-Version: 1.0
References: <20201105073434.429307-1-xie.he.0141@gmail.com> <CAK8P3a2bk9ZpoEvmhDpSv8ByyO-LevmF-W4Or_6RPRtV6gTQ1w@mail.gmail.com>
In-Reply-To: <CAK8P3a2bk9ZpoEvmhDpSv8ByyO-LevmF-W4Or_6RPRtV6gTQ1w@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 5 Nov 2020 12:04:55 -0800
Message-ID: <CAJht_EPP_otbU226Ub5mC_OZPXO4h0O2-URkpsrMBFovcdDHWQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: x25_asy: Delete the x25_asy driver
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Martin Schiller <ms@dev.tdt.de>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        Linux X25 <linux-x25@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 7:07 AM Arnd Bergmann <arnd@kernel.org> wrote:
>
> Adding Martin Schiller and Andrew Hendry, plus the linux-x25 mailing
> list to Cc.

The linux-x25 mail list has stopped working for a long time.

> When I last looked at the wan drivers, I think I concluded
> that this should still be kept around, but I do not remember why.

I think we only decided that X.25 as a whole was still needed. We
didn't decide that this particular driver was necessary.

> Since you did the bugfix mentioned above, do you have an idea
> when it could have last worked? I see it was originally merged in
> linux-2.3.21, and Stephen Hemminger did a cleanup for
> linux-2.6.0-rc3 that he apparently tested but also said "Not sure
> if anyone ever uses this.".

I think this driver never worked. Looking at the original code in
Linux 2.1.31, it already has the problems I fixed in commit
8fdcabeac398.

I guess when people (or bots) say they "tested", they have not
necessarily used this driver to actually try transporting data. They
may just have tested open/close, etc. to confirm that the particular
problem/issue they saw had been fixed.
