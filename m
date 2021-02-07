Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBC631276F
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 21:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhBGUtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 15:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhBGUts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 15:49:48 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C89CC06174A;
        Sun,  7 Feb 2021 12:49:08 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id f26so686272oog.5;
        Sun, 07 Feb 2021 12:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sSvbOW54waddHlMmHk+sFkmyHix23TmLcnM7y2A/d8I=;
        b=LA6YLElXMaqp0jFV/7KO/I0jQqKSsx/NJ1XhHnzmHHSIMMfzhgPJOoeakP2EpIMZ72
         TaIj3OmbLpIHtYYSc6+5gFXko6ZrJga6q5LnSe1pBCt0l9z3/9AMt/sfU7l9/I4p+6KN
         yzFCjRpHttYrogJJ7+Tx20ecikRvMZRrzZfsuAGJbzCJtLUK8nNEvMUj10TPCrZAZdr0
         RIkRngw+p00DWwUmVCfz55JlbNUK+/AXm+AT9xlyd5FFXTF1kvuDgxjssHN2irj8BcrT
         rDmFP31f889j5NSr7kgu8WqSQ4ssb2EafW7Jou7Y9aUQ3HJfO23mzhwuIlmfmY7mpMjb
         qjNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sSvbOW54waddHlMmHk+sFkmyHix23TmLcnM7y2A/d8I=;
        b=q+mh/ccDPXdXwGjKg1e9hxQwOu5AiZwkcnuHHb0tc9U2Kp1V0VM5exlyr9gwzcYsrs
         /bBASH2P9195KUCeyjgkIpj9ABhOABRIaRLM/9iDN6bV62RGsWBIVVwqsuI1nBz2QQ/n
         oo9AOD3JQFBfcAXsWj5WTOtplO4/p+eUPalxqEPXJb5y0pI88U7d8UqohZJLgKrPUnLp
         9bY4KMcmD0cUVsAvHAhlAXynkz9be/Lon+/z1SH48lJgCsrPCDUVCW6lasVUcqkSgn18
         C7U/mKR27D9X2JrVyDITBP6WRG+YSZA4YN0UtXL5xg4/HIly1b+jPgloKR5aiMzNXZ99
         kyaQ==
X-Gm-Message-State: AOAM532D2CNZWrFQLRV0BSwyDcQ1c+RWvLbr+1jJTYAyUaWqObq6v5ge
        HXbQfokloiWSDjFpxkHGiWoK+Hn9jCrn2WucylAEn+Wmjpc=
X-Google-Smtp-Source: ABdhPJyt3WFnZgNV/Kk6xy8KWtBIbKHC/hJntFKCavDqwxMY6H+VJb++zDr31PtAdckubrTN/kMc1VptGFdVBHqQfg4=
X-Received: by 2002:a4a:2a5e:: with SMTP id x30mr3357476oox.4.1612730947842;
 Sun, 07 Feb 2021 12:49:07 -0800 (PST)
MIME-Version: 1.0
References: <20210206000146.616465-1-enbyamy@gmail.com> <20210206120751.30e175a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210206120751.30e175a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Amy Parker <enbyamy@gmail.com>
Date:   Sun, 7 Feb 2021 12:48:57 -0800
Message-ID: <CAE1WUT7T8C6XSgAAqTcmK5Syy16Hi90VSLfspZyeMO8T3Jmaqw@mail.gmail.com>
Subject: Re: [PATCH 0/3] drivers/net/ethernet/amd: Follow style guide
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, Andrew Morton <akpm@linux-foundation.org>,
        rppt@kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 6, 2021 at 12:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  5 Feb 2021 16:01:43 -0800 Amy Parker wrote:
> > This patchset updates atarilance.c and sun3lance.c to follow the kernel
> > style guide. Each patch tackles a different issue in the style guide.
>
> These are very, very old drivers, nobody worked on them for a decade.
> What's your motivation for making these changes?

I've just been trying to make patches to clean up code to follow the
style guide. These files had a lot of violations.
