Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1689778E88
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 16:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbfG2O6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 10:58:35 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35484 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfG2O6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 10:58:35 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so53746397wmg.0
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 07:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=xafcHcyJE/uJgYYzvOJdNS4lEtSAMsbPqiZjxyKfzTQ=;
        b=Nhs9KVi+VjmEtAOk0uGZL8bg0+KA0iMhT/xqmvMAVyLdUO0U5DrRtPxcf3DTFQSXAt
         pb4o5Bf1bHCWqA0s9JQF3YVmlfNKKcNU5XMSDlpYhcFfrzNHaeq4yqAtQdsOsac9rV+A
         MYlFWIU0AUaYTsYdCcqwBPqibj+vZOuI0kvxKeu+jazwKesbCfZ9HO55OvuVQnZvDiuL
         CFwb5NJ2clMGf/w2R0yfah5pMkajia4t3i5bpF7kEYcQamIzqpQDpyPVpFJMaW4iYinm
         RJJSEOJ+s645SOWReoXYoS/HyKthQD5yX21jfK7q5b4k1Cvm9Oxz6yekU2Uc/PwJlBhD
         Kj5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=xafcHcyJE/uJgYYzvOJdNS4lEtSAMsbPqiZjxyKfzTQ=;
        b=QaIixvDKCUEopUr/sX5VuQ95Wjp/sin7UTHQk40mrJqQVRqUnEMeIq6H7q2jiXOG4v
         lgDiT1F3TSdjApiMEqOCF/9OgzYxeLy3gUadhw5Kl3CsSvTbjSjMZVDgpjQppJpimnOD
         6nJAfAOoi/BPhboCJnDCjaZLO47DrqttiAqwL0S1ANd0Kqb88RsJCm1HopruNY2p4gDY
         6AkFusBnv4c91bPviWYrZa1ZxNpRCYgg6k1ZiICSV07LOcX/XX6jYgQP1oeVAZ/ySA6m
         R9m5b+TyKolO8NHzLLw8iEC8lAKEonSl3Uc7wsYISWwEkOypfw5uh6Yhq7lnrKGtsPNG
         sZrQ==
X-Gm-Message-State: APjAAAXqSalto/bHQHHxAGqNvTH1JzVspYBBNyuBjQLcH1lmQDtTw1El
        GHMZ/oF3OMBVD9DL5EuQjDWRjD8HQryWjG8QQWc=
X-Google-Smtp-Source: APXvYqwgHhC5qh4Q+14Zuf7ENNs/LdTjAYv3mATUMLHO4f1t6Hl1LF9qABtbra+V71Etc0+pT52CdPQFGBRuAt0RovE=
X-Received: by 2002:a1c:3cc4:: with SMTP id j187mr95517944wma.36.1564412313479;
 Mon, 29 Jul 2019 07:58:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190725193511.64274-1-andriy.shevchenko@linux.intel.com>
 <20190725193511.64274-11-andriy.shevchenko@linux.intel.com>
 <20190726.142346.407773857500139523.davem@davemloft.net> <20190729094047.GH9224@smile.fi.intel.com>
In-Reply-To: <20190729094047.GH9224@smile.fi.intel.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 29 Jul 2019 16:58:22 +0200
Message-ID: <CA+icZUW5H+9VJvxViYYEDCJ-mLa-xudqYScjZFJ8eA6200YZmg@mail.gmail.com>
Subject: Re: [PATCH v3 11/14] NFC: nxp-nci: Remove unused macro pr_fmt()
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     David Miller <davem@davemloft.net>,
        clement.perrochaud@effinnov.com, charles.gorand@effinnov.com,
        netdev@vger.kernel.org, Sedat Dilek <sedat.dilek@credativ.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 12:38 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Fri, Jul 26, 2019 at 02:23:46PM -0700, David Miller wrote:
> > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Date: Thu, 25 Jul 2019 22:35:08 +0300
> >
> > > The macro had never been used.
> > >
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> >  ...
> > > @@ -12,8 +12,6 @@
> > >   * Copyright (C) 2012  Intel Corporation. All rights reserved.
> > >   */
> > >
> > > -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >
> > If there are any kernel log messages generated, which is the case in
> > this file, this is used.
>
> AFAICS no, it's not.
> All nfc_*() macros are built on top of dev_*() ones for which pr_fmt() is no-op.
> If we would like to have it in that way, we rather should use dev_fmt().
>
>
> > Also, please resubmit this series with a proper header posting containing
> > a high level description of what this patch series does, how it is doing it,
> > and why it is doing it that way.  Also include a changelog.
>
> Will do.
>
> Thank you for review!
>

Can you send out the latest series as v5?
I got some new? patches from you, but a bit confused now.

- Sedat -
