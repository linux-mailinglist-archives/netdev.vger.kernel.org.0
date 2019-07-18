Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A65926D17E
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 18:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbfGRQGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 12:06:47 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37372 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfGRQGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 12:06:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id f17so26241606wme.2
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 09:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sVd2rWwZ9F06zhbzH6mCdgYiM8uN3X2Mi6wWMROw2Kg=;
        b=yuf/VI0AhTJUpgtuM8PcHhx4BpMQxHZvwWge2TTcTV3ZkQuZxn/2/I9oibQYFuQ8CC
         ynYyE70L1RUkZtzApgy/jMw3SLAzvLiQw+/FKRCtaYlCemjXGSu7Nl05BG/EHHdsJekm
         kh235IAFmXPoImGoEByRyLRQxIis4BinO0WoCv8WbBiRTyRJ2BV+zOgQWgB7dEhzxj7J
         93IcCANLQnzBh9dnuoERvPvHXLg5/O44SmPybYAnsdWWg+8QbuBwKC/oP1Oi1fb85lhC
         lXGUMg9vn5u3NhegBd4El3gf8eZzK0Q2X7m0WwwC0FVPfSf1ZQm13L2SDrJ1XA+ZrYuL
         KSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sVd2rWwZ9F06zhbzH6mCdgYiM8uN3X2Mi6wWMROw2Kg=;
        b=To0+DvWdkK/xmcjb9Fg4G/tyCC3uYd8Ic5gqDUgcDuf6S/9S+vkeSzdPj+aJkdHymQ
         kgVGHnQZu6Myw93PVdHCQcFnPEdyXkZMcnDex30jQ+HE96p2NQs7aZw9YWOWJxkDlSLs
         z4j/TEE7YTwoMNKYMlwUPTFtkParH51edF50vcxK9pAChDgP5dd/QYGpJoGIyCs+V6hd
         3rfj3CkowJEk5cyYOe2WTHAqRZU+0a/QW6F/7NumvUcUkphgW8FO7ziMnQ0CisRNd5BA
         bFo6n/IUffvWfQWcQxdS+LfpAD/rFhq5be5j9V7rfCK7HLIzbH9gBatBmt6vhnyKvmEy
         CNuQ==
X-Gm-Message-State: APjAAAUJaW32NNmIh1JhyeM4X0vTqu2l3QckLdzpxNWQUNnMDAoyMU/J
        6Y5E8WFQegmOH+xHZ3KAT+bpx75mJsM55MY5OfGwVw==
X-Google-Smtp-Source: APXvYqzsb4j+jmW+egxaHAo3Vi5dAnyyHO1+geMuOpHfAqSBT4s9STCE7ViYk6GRoil8fe4+7ffIBlSZPGyFKg4VcMM=
X-Received: by 2002:a05:600c:20c1:: with SMTP id y1mr44573238wmm.10.1563466005339;
 Thu, 18 Jul 2019 09:06:45 -0700 (PDT)
MIME-Version: 1.0
References: <1563460710-28454-1-git-send-email-ilias.apalodimas@linaro.org> <CAJe_ZhdFBUWQwf+OcDX_0_wYTpTqHJvqJi2QE3CP+8rwXCLjMw@mail.gmail.com>
In-Reply-To: <CAJe_ZhdFBUWQwf+OcDX_0_wYTpTqHJvqJi2QE3CP+8rwXCLjMw@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 18 Jul 2019 18:06:34 +0200
Message-ID: <CAKv+Gu_k3unwP0Ma_mQ7s+h=V2-LUyyc93VK601hJkqeu+e=jQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: update netsec driver
To:     Jassi Brar <jaswinder.singh@linaro.org>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Jul 2019 at 16:52, Jassi Brar <jaswinder.singh@linaro.org> wrote:
>
> On Thu, 18 Jul 2019 at 09:38, Ilias Apalodimas
> <ilias.apalodimas@linaro.org> wrote:
> >
> > Add myself to maintainers since i provided the XDP and page_pool
> > implementation
> >
> Yes, please.
>
> Acked-by: Jassi Brar <jaswinder.singh@linaro.org>
>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
