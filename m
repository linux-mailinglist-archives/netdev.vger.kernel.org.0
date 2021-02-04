Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDEC030EC55
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 07:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbhBDGKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 01:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbhBDGKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 01:10:39 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA000C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 22:09:58 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id l14so1252679qvp.2
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 22:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YPdACSGVn/+K4TckXXfbeqBNVhAV71NfhwdLzyKPLg8=;
        b=JOBGAd7CN3ijboIaPw+MEKuanyrxBA8X1snw0iOb7zKqPAb3UyH4vRPM1LnjFqwdgS
         3pi4jlABrp6WtVgaYADgwXCgz59Ea/x0yJf6CMSOqbgZKhWDD31pGWPYHNEi84d6HcWJ
         MqHGQM75ckuP7dSILwSOst3XZLfrKMWVScKEQehYsVZuzvrfPD4z5f7hX9CodIKSdNA9
         LywDhoia7p5yLEuPH+ZhdLlLJK6XGrcVBb3x2/j6nm8vmExkcjomaEowFaPLinerRsEL
         sdUQSZ5aaUhSqXFiwAw2VowFGt97pD2GHCjNpODqK0k9MA4se0rYY/wEQ0UT61llhGSu
         CsRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YPdACSGVn/+K4TckXXfbeqBNVhAV71NfhwdLzyKPLg8=;
        b=BhOFGIpkxdY7r6U7ac8oMjZmwXnfJBBRkVaaHXacYMGhB3yHPXfGqEXhImSIdWx2fn
         f3M6VL2P812ExDC4pl4Kw4y8S9HXQ+kZt2sHKIyvrJdJo/j1CUmQ7569C98OneZqGliL
         rnwviWeTd2bgLhU3+PTMUq2AtnGAHGX1ivBNckMLx22kaI+EnhkxKmvmrDbozi6+YQiO
         Nf6UkKgW3kq34p1SH8OOwSYr9eQAUtAFHpzavmnPemRy4DN0xR1VjCtmeVvEzHCAGVEk
         hZAr/zKDbPXBWuSrJmECYqrYeNQA2nz2hwWC6/M73tPp3Qr8DS/msmt/ZsInzN1/tJSX
         WRfg==
X-Gm-Message-State: AOAM533RKTQ/B68WZIWNr5uYu9m/M4LzKpv2EN2x9F5fHIjg19lHo4W2
        Vrs61KrMYCY8SUk5H7MxXhmeq/Y7y2AQMAwb7eFU/3HN1XlUYw==
X-Google-Smtp-Source: ABdhPJwOrP53s+nVadM6jr0DRT1+cA24pJygP1uNoT0UbkaIb1l7w9LDv8fR+v66e2MYcqAV+RBQtnbvpLK+DzZhHeE=
X-Received: by 2002:a0c:bf12:: with SMTP id m18mr6366018qvi.40.1612418998010;
 Wed, 03 Feb 2021 22:09:58 -0800 (PST)
MIME-Version: 1.0
References: <20210202065159.227049-1-jonas@norrbonn.se>
In-Reply-To: <20210202065159.227049-1-jonas@norrbonn.se>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Wed, 3 Feb 2021 22:09:47 -0800
Message-ID: <CAOrHB_DH4Zh_yLTKf5dbPvD2aZoGTamkX2tZmF15Rh+qpXGL5g@mail.gmail.com>
Subject: Re: [PATCH net-next 0/7] GTP
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     Harald Welte <laforge@gnumonks.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 10:53 PM Jonas Bonn <jonas@norrbonn.se> wrote:
>
> There's ongoing work in this driver to provide support for IPv6, GRO,
> GSO, and "collect metadata" mode operation.  In order to facilitate this
> work going forward, this short series accumulates already ACK:ed patches
> that are ready for the next merge window.
>
> All of these patches should be uncontroversial at this point, including
> the first one in the series that reverts a recently added change to
> introduce "collect metadata" mode.  As that patch produces 'broken'
> packets when common GTP headers are in place, it seems better to revert
> it and rethink things a bit before inclusion.
>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
